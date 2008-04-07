Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYDGVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYDGVsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYDGVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:48:07 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:1125 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYDGVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:48:06 -0400
Date: Mon, 7 Apr 2008 23:44:34 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Message-ID: <20080407214434.GA5296@mailshack.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA6478.1070301@sgi.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Mon, 07 Apr 2008 23:47:35 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.130; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 11:14:16AM -0700, Mike Travis wrote:
> Alexander van Heukelum wrote:
> > On Fri, Apr 04, 2008 at 06:30:15PM -0700, Mike Travis wrote:
> >>   * Increase stack size for the kernel bootloader decompressor.  This is
> >>     needed to boot a kernel with NR_CPUS = 4096.  I tested with 8k stack
> >>     size but that wasn't sufficient.
> >>
> >> Based on:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >>     +   x86/latest          .../x86/linux-2.6-x86.git
> >>     +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
> >>
> >> Signed-off-by: Mike Travis <travis@sgi.com>
> >> ---
> >>  arch/x86/boot/compressed/head_64.S |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> --- linux-2.6.25-rc5.orig/arch/x86/boot/compressed/head_64.S
> >> +++ linux-2.6.25-rc5/arch/x86/boot/compressed/head_64.S
> >> @@ -314,5 +314,5 @@ gdt_end:
> >>  /* Stack for uncompression */
> >>  	.balign 4
> >>  user_stack:
> >> -	.fill 4096,4,0
> >> +	.fill 16384,4,0
> > --------------^^^ * ^
> > 
> > Changed from 16K to 64K. I wonder what is using so much space on
> > this stack?
> > 
> >>  user_stack_end:
> >>
> >> -- 
> 
> Hi,
> 
> That is a good question.  It's pretty difficult to debug at that early
> stage (any ideas are certainly welcome!).  It's mostly hit and miss (and
> handy access to the reset button ;-)  I could do some further research
> but since it's "throwaway" memory (at least I think it is), then I didn't
> think it important to pursue.

It's certainly not important enough to put much time in. I tried
MAXSMP on top of just Ingo's -x86 with qemu, though, but it wouldn't
crash. I set the stack size to 16 bytes, and it still booted happily
(of course there is still about 11 kilobytes of inflate code which
is then overwritten by stack use).

I did see that the malloc space that the inflate code is using is
taken from _after_ the end of the bss. I don't see how this is
protected from being used/overwritten. Changing the stack size changes
the memory layout a bit... maybe you were so unlucky to create a
vmlinux image that was just barely smaller than some threshold and
increasing the stack size made the decompression/relocation area be
located somewhere else?

Test patch follows.

Greetings,
	Alexander

> Thanks,
> Mike

diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
index bb3c483..c858e30 100644
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ b/arch/x86/boot/compressed/vmlinux_32.lds
@@ -39,5 +39,6 @@ SECTIONS
 		*(.bss.*)
 		*(COMMON)
 		_end = . ;
+		_real_end = . + 0x4000;
 	}
 }
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index 7e5c720..9bef3cd 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -44,5 +44,6 @@ SECTIONS
 		pgtable = . ;
 		. = . + 4096 * 6;
 		_heap = .;
+		_heap_end = . + 0x7000;
 	}
 }

