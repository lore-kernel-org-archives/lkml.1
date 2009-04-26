Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZDZJHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZDZJHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZDZJHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:07:07 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37015 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZDZJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:07:05 -0400
Date: Sun, 26 Apr 2009 11:09:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20090426090906.GA27809@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org> <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:10:38PM -0400, Tim Abbott wrote:
> On Fri, 24 Apr 2009, Sam Ravnborg wrote:
> 
> > This patch touches far too many files.
> > We should try to work out a method so we are in better control
> > of the section names, so renaming in the end is a simple patch
> > touching only a few files.
> 
> OK, I'm now planning to implement this approach.
> 
> > > -.section .text.head, "ax"
> > > +.section .text..head, "ax"
> > 
> > Use __HEAD (from include/linux/init.h)
> > Same goes for all other uses of .text.head.
> 
> I notice that __HEAD uses .head.text, while some architectures use 
> .text.head.  It looks like this is just an inconsistency across 
> architectures that will be removed as a consequence of this cleanup work 
> (no architecture uses both .head.text and .text.head).
Correct - this is implied by the introduction of __HEAD.
For users of the old naming schme (like i386) you need to adjust the
linker script too.

> One challenge with this approach is that many linker scripts use these 
> section names in more complex ways than just squashing HEAD_TEXT at the 
> start of the text section.  For example, the the linker scripts for x86 
> and ia64 have code like:
> 
>   .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
>         _text = .;                      /* Text and read-only data */
>         *(.text.head)
>   } :text = 0x9090
> 
> which can't user either the __HEAD macro (which is the full .section line) 
> or the HEAD_TEXT macro (which is the *(.head.text)).

The simple way to deal wi8th this is to accept some duplication of naming
in order to keep readability.
So I suggest you to use:

  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
        _text = .;                      /* Text and read-only data */
        HEAD_TEXT
  } :text = 0x9090

We need to be carefull about keeping some sort of readability
of these linker macro files.

I was not specific in my last mail about this - but I assume you have
understood that the naming ".head.text" was selected so it is compatible
wiht -ffunction-sections. In other words no need for any ugly ".." here.

We should try to be as consistent as possible across architectures here
so it is better to toach a few additiona files rather than adding macros
and the like to accept there sub-optimal section naming.

	Sam
