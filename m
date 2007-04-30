Return-Path: <linux-kernel-owner+w=401wt.eu-S1423195AbXD3MUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423195AbXD3MUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423196AbXD3MUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:20:25 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48852 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423195AbXD3MUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:20:24 -0400
Date: Mon, 30 Apr 2007 14:20:22 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Geode-GX1 processor in 2.6.21
Message-ID: <20070430122022.GA9896@rhlx01.hs-esslingen.de>
References: <200704301251.05697.juergen127@kreuzholzen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704301251.05697.juergen127@kreuzholzen.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 30, 2007 at 12:51:05PM +0200, Juergen Beisert wrote:
> Hi all,
> 
> I do not understand it, but setting up some chipset features (tweaks) fail on 
> Geode GX1.
> 
> In arch/i386/kernel/cpu/cyrix.c function geode_configure() tries to enable 
> the "suspend on halt power saving feature". This is the line:
> 
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

Sounds quite likely.
You should check objdump -d output of cyrix.o to verify whether the compiler
"illegally" reorders some I/O instructions in geode_configure().
Probably you need to add a barrier() or wmb() or similar to these macros.
Or should this be a (code-invisible) PCI posting issue? In that case you need
to add some dummy read operations.

Also, it would probably be good to convert these macros into inline functions
in this header.

Andreas Mohr
