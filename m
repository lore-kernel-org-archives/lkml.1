Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYB0Fpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYB0Fpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYB0FpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:45:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYB0FpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:45:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=RMkh7lh3eVzkLYiuZVQ2cg/ktgdKpPGeGDoRf5DDE0wGZA+uV3s6p1/itAmKukADm
	NfNl0wb3qCTc0ParbxknA==
Date: Tue, 26 Feb 2008 21:44:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline
 __attribute__((format (printf,x,y) to statement expression macros
In-Reply-To: <20080227041316.GA23188@parisc-linux.org>
Message-ID: <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost> <20080227041316.GA23188@parisc-linux.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Matthew Wilcox wrote:

> On Tue, Feb 26, 2008 at 08:02:27PM -0800, Joe Perches wrote:
> > Converting inline __attribute__((format (printf,x,y) functions
> > to macros or statement expressions produces smaller objects
> > 
> > before:
> > $ size vmlinux
> >    text    data     bss     dec     hex filename
> > 4716770  474560  618496 5809826  58a6a2 vmlinux
> > after:
> > $ size vmlinux
> >    text    data     bss     dec     hex filename
> > 4716706  474560  618496 5809762  58a662 vmlinux
> 
> > -static inline void __attribute__((format(printf, 1, 2)))
> > -__simple_attr_check_format(const char *fmt, ...)
> > -{
> > -	/* don't do anything, just let the compiler check the arguments; */
> > -}
> > +/* don't do anything, just let the compiler check the arguments; */
> > +
> > +#define __simple_attr_check_format(fmt, args...) \
> > +	do { if (0) printk(fmt, ##args); } while (0)
> 
> That's very interesting.  It's only 64 bytes, but still, it's not
> supposed to have any different effect.  Could you distill a test case
> for the GCC folks and file it in their bugzilla?
> 

I'm not seeing any change in text size with allyesconfig after applying 
this patch with latest git:

   text	   data	    bss	    dec	    hex	filename
32696210	5021759	6735572	44453541	2a64ea5	vmlinux.before
32696210	5021759	6735572	44453541	2a64ea5	vmlinux.after

Joe, what version of gcc are you using?

		David
