Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZIDOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZIDOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZIDOTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:19:52 -0400
Received: from mxo44.mail.genotec.ch ([82.195.224.44]:50654 "EHLO
	mxo44.mail.genotec.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbZIDOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:19:51 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 10:19:50 EDT
Date: Fri, 4 Sep 2009 16:05:16 +0200
From: Marc Andre Tanner <mat@brain-dump.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-embedded@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] printk: provide a filtering macro for printk
Message-ID: <20090904140516.GA6524@debbook.brain-dump.org>
References: <1251844269-12394-1-git-send-email-mat@brain-dump.org>
 <1251844269-12394-8-git-send-email-mat@brain-dump.org>
 <4A9DAD2B.3080909@am.sony.com>
 <BD79186B4FD85F4B8E60E381CAEE190901C55CD3@mi8nycmail19.Mi8.com>
 <20090902130943.GE2736@debbook.brain-dump.org>
 <4A9EA5C9.3010900@am.sony.com>
 <BD79186B4FD85F4B8E60E381CAEE190901C55DE5@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901C55DE5@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-GIC-MailScanner-Outbound: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 02:22:52PM -0400, H Hartley Sweeten wrote:
> On Wednesday, September 02, 2009 10:05 AM, Tim Bird wrote:
> > Marc Andre Tanner wrote:
> >> On Tue, Sep 01, 2009 at 07:32:25PM -0400, H Hartley Sweeten wrote:
> >>> On Tuesday, September 01, 2009 4:24 PM, Tim Bird wrote:
> >>>> Some places in the kernel break the message into pieces, like so:
> >>>>
> >>>> printk(KERN_ERR, "Error: first part ");
> >>>> ...
> >>>> printk(" more info for error.\n");
> >>> Technically, shouldn't the second part of the message actually be:
> >>>
> >>> printk(KERN_CONT " more info for error.\n");
> >>>
> >>> Maybe some mechanism could be created to handle the continued message
> >>> if they have the KERN_CONT?
> >> 
> >> Yes it's true that KERN_CONT isn't handled correctly, but I don't see a way
> >> to change that.
> >> 
> >>>> These parts would not be handled consistently under certain
> >>>> conditions.
> >>>>
> >>>> It would be confusing to see only part of the message,
> >>>> but I don't know how often this construct is used.  
> >> 
> >> $ grep -R KERN_CONT linux-2.6 | wc -l
> >> 373
> >> 
> >>>> Maybe
> >>>> another mechanism is needed to ensure that continuation
> >>>> printk lines have the same log level as their start strings.
> >> 
> >> I currently don't see a way to achieve this with the CPP.
> >
> > If it's that few, then maybe it's OK to actually change
> > the code for those printk statements. (Heck, these locations
> > were all changed in the last 2 years anyway.)
> > 
> > I'm just brainstorming here, but how about changing them from:
> >   printk(KERN_INFO "foo");
> >   printk(KERN_CONT "bar\n");
> > to:
> >   printk(KERN_INFO "foo");
> >   printk_cont(KERN_INFO "bar\n");
> 
> Unfortunately not all the continued printk statements in the kernel are
> properly tagged with KERN_CONT (or pr_cont, etc.).

Yes and a quick search revealed that there are actually quite a lot of
those untagged messages.

As I needed some distraction from some other work I played around a bit
more with a solution which wouldn't require to change existing kernel
code. It uses a variable which would have to be available in every
function to store the loglevel of messages which are split over multiple
printk calls. Here is what I came up with so far:

#define PRINTK_IS_LINE(fmt) (					\
	((const char*)(fmt))[sizeof((fmt)) - 2] == '\n'		\
)

#define PRINTK_LEVEL(fmt) (					\
	(((const char *)(fmt))[0] == '<' &&			\
	 ((const char *)(fmt))[1] >= '0' &&			\
	 ((const char *)(fmt))[1] <= '9'			\
	) ? ((const char *)(fmt))[1] - '0' : 4			\
)

#define printk(fmt, ...) ({ 								\
	int __printk_ret = 0;								\
	int __printk_level = __printk_cont_level;					\
											\
	if (__builtin_constant_p((fmt)) && ((fmt))) {					\
		/* check if we are dealing with a line ending */			\
		if (PRINTK_IS_LINE((fmt))) {						\
			/* check if it was a whole line */				\
			if (__printk_cont_level == -1)					\
				__printk_level = PRINTK_LEVEL((fmt));			\
			__printk_cont_level = -1;					\
		} else if (__printk_cont_level == -1) /* first part of a line? */	\
			__printk_level = __printk_cont_level = PRINTK_LEVEL((fmt));	\
	}										\
											\
	if (!__builtin_constant_p((fmt)) || __printk_level <= CONFIG_PRINTK_VERBOSITY)	\
		__printk_ret = printk((fmt), ##__VA_ARGS__); 				\
											\
	__printk_ret;									\
})

Apart from the fact that it's getting uglier it obviously depends on
the availability of __printk_cont_level (which would get compiled out,
at least I hope so) in every function. 

So

void demo() {
	...
}

would have to become:

void demo() {
	int __printk_cont_level = -1;
	...	
}

I don't know whether this is possible at all through some kind of gcc
magic. There is also the problem of introducing warnings when 
__prink_cont_level isn't used in a function but I guess this could be
dealt with some __attribute__ setting.

Anyway just wanted to share the results of a brainstorming session.

Marc 

-- 
 Marc Andre Tanner >< http://www.brain-dump.org/ >< GPG key: CF7D56C0
