Return-Path: <linux-kernel-owner+w=401wt.eu-S1423190AbXD3MN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423190AbXD3MN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423193AbXD3MN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:13:59 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40255 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423190AbXD3MN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:13:58 -0400
Date: Mon, 30 Apr 2007 14:13:52 +0200 (MEST)
Message-Id: <200704301213.l3UCDqgN018906@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: juergen127@kreuzholzen.de, linux-kernel@vger.kernel.org
Subject: Re: Geode-GX1 processor in 2.6.21
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 12:51:05 +0200, Juergen Beisert wrote:
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> 
> If this register is 0x00 before, it is still 0x00 after this line. If I change 
> the line into this:
> 
> 	ccr2 = getCx86(CX86_CCR2);
> 	ccr2 |= 0x88;
> 	setCx86(CX86_CCR2, ccr2);
> 
> register ccr2 is 0x88 after the setCx86 call and the power saving feature is 
> active (and BTW: the TSC is useless then, because it also stops when the CPU 
> runs into a HLT instruction).
> 
> setCx86 and getCx86 are macros defined in include/asm-i386/processor.h:
> 
> #define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
> 
> #define setCx86(reg, data) do { \
>          outb((reg), 0x22); \
>          outb((data), 0x23); \
> } while (0)
> 
> Maybe the compiler does the wrong thing if someone uses these macros in the 
> same instruction?

The compiler is fine, it's the setCx86() macro that is utter crap
because it fails to behave like a function by not evaluating its
arguments before performing its outb() statements.

Converting them to static inlines would be the best solution. Something like

static inline u8 getCx86(unsigned int reg)
{
	outb(reg, 0x22);
	return inb(0x23);
}

static inline void setCx86(unsigned int reg, u8 data)
{
	outb(reg, 0x22);
	outb(data, 0x23);
}

ought to work.

/Mikael
