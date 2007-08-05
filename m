Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbXHEPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbXHEPpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXHEPpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:45:04 -0400
Received: from 1wt.eu ([62.212.114.60]:1173 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbXHEPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:45:03 -0400
Date: Sun, 5 Aug 2007 17:43:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: Axel Reinhold <axel@freakout.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070805154337.GA4716@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708050856.l758u4ou031651@bongo.freakout.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 10:56:04AM +0200, Axel Reinhold wrote:
> i found a bug in linux-2.4.35.
> 
> the bug produces a crashing kernel when compiled
> with gcc >=4.2.0 and VIA C3 optimized -march=c3
> (CONFIG_MCYRIXIII=y)
> 
> this issue was first discussed on the gcc bugzilla:
>  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=32264
> 
> and tracked down to the include/asm-i386/hw_irq.h
> module with the help of the gcc guys:
> 
> (pluto at agmk dot net) wrote:
> >yup, i see something new :)
> >
> >please look at line 12137 of i8259.i:
> >
> >__attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...
> >
> >as you can see there is a semicolon after call_do_IRQ(void)
> >and following asm statement isn't treated as a function body.
> >in this way -O1 -f{no-}unit-at-a-time accidentally produces
> >different code. it's not a gcc bug.
> >
> >linux-2.4.35/include/asm-i386/hw_irq.h
> >contains these evil macros.
> 
> is there a chance to fix this?
> these macros a far beyond my capabilities to fix.

Axel,

I've reproduced it and posted the following explanation to GCC's
bugzilla ; I think I can provide you with a simple fix very soon.

Cheers,
Willy

----

Reproduced with trivial code. The reason is very simple : The asm code
is emitted in the .data section, because due to the -fno-unit-at-a-time
argument, the "interrupts" array is declared first and sets the current
section to .data.

Interestingly, adding __attribute__ ((section(".text"))) before the
function declaration does not change anything. But adding ".section .text\n"
in the asm statement fixes it.

In fact, -fno-unit-at-a-time does not work on this code under gcc-4.2.1,
while it works with gcc-4.1.1. However, using the recommended
-fno-toplevel-reorder argument fixes the problem. Also, if the "dummy"
array below is declared before the asm statement, then even gcc-4.1.1
emits the code in the .data section.

In all cases, removing -fno-unit-at-a-time produces good code. I still
suspect that because the behaviour is different between 4.1 and 4.2, it
might be a regression in 4.2, but since its replacement works, I'm not
sure it's worth investigating further. I'll work on a fix for linux-2.4.

Trivial example below :

/* the following code may go to .data if compiled with gcc >= 4.1 and
 * -fno-unit-at-a-time
 */
void common_interrupt(void);
__asm__( "\n"
         ".align 4,0x90""\n"
         "common_interrupt:\n\t"
         "cld\n\t"
);

/* If dummy is not initialized, the code above goes into .text.
 * If dummy is initialized to zero, the code above goes into .bss
 * If dummy is initialized to non-zero, the code goes into .data
 * If dummy is declared before the code above, then it goes to .data
 * whatever the compiler.
 */
int dummy[1] = { 1 };

