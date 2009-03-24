Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZCXH0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZCXH0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZCXH0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:26:36 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43623 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbZCXH0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:26:36 -0400
Date: Tue, 24 Mar 2009 03:23:39 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <20090324170700.6029f6ce.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0903240210410.21037@vinegar-pot.mit.edu>
References: <1237872525-31014-1-git-send-email-tabbott@mit.edu> <20090324170700.6029f6ce.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Stephen Rothwell wrote:

> On Tue, 24 Mar 2009 01:28:41 -0400 Tim Abbott <tabbott@MIT.EDU> wrote:
> >
> > I'd like to see this patch series merged for 2.6.30.  It applies on
> > top of your current master (aka v2.6.29).  Patch 1/4 would benefit
> > from special treatment during the merge window, since it makes many
> > small changes in lots of files, and thus is likely to conflict with
> > other changes; the other patches are fairly small.
> 
> Indeed.  I just did a merge of your changes with next-20090323 and it
> conflicted with changes in 10 files across 4 architectures.  There has
> been work on several areas that you are changing here (some of which will
> make your life easier - like the percpu changes).  

Yeah, unfortunately, because people are always modifying the kernel's 
"magic" sections, a version of the patch that applies to master will 
basically always conflict with something in linux-next (at least, this has 
been my experience updating it during the 2.6.29 release cycle).  As Rusty 
Russell said last month about this patch, there's no good time for this 
kind of change.

I'm happy to rebase this patch again to merge it late in the merge window 
if that makes life easier for others.  Merge conflicts with this patch are 
hard to avoid but fairly easy to resolve -- you just replace .data.foo 
with .data..foo (etc.).

> I suspect that at least some of patch 1/4 could have bee split out and 
> sent to the appropriate maintainers.

Because the change is actually renaming sections, it needs to be made on 
all the architectures at the same time as changes are made to the 
architecture-independent code.  So, changes in, say, include/linux/init.h:

-#define __nosavedata __section(.data.nosave)
+#define __nosavedata __section(.data..nosave)

must be synchronized with, say, arch/arm/kernel/vmlinux.lds.S:

                . = ALIGN(4096);
                __nosave_begin = .;
-               *(.data.nosave)
+               *(.data..nosave)

So, while it might have been useful to split out and send individual 
per-architecture patches to arch maintainers for review, that would not 
avoid the need to merge it as a single giant patch.

	-Tim Abbott
