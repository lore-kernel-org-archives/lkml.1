Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbXJLCfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbXJLCfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXJLCf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:35:28 -0400
Received: from lixom.net ([66.141.50.11]:56175 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbXJLCf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:35:27 -0400
Date: Thu, 11 Oct 2007 21:40:52 -0500
From: Olof Johansson <olof@lixom.net>
To: Paul Mackerras <paulus@samba.org>
Cc: grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
       kyle@parisc-linux.org, linuxppc-dev@ozlabs.org, lethal@linux-sh.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] powerpc: Switch to generic WARN_ON()/BUG_ON()
Message-ID: <20071012024052.GA19865@lixom.net>
References: <20071011171211.GB10877@lixom.net> <20071011171413.GC10877@lixom.net> <18190.52379.97647.468384@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18190.52379.97647.468384@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 11:23:39AM +1000, Paul Mackerras wrote:
> Olof Johansson writes:
> 
> > Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> > 4K text on a ppc64_defconfig. The main reason seems to be that prepping
> > the arguments to the conditional trap instructions is more work than
> > just doing a compare and branch.
> 
> It might be more instructions but it takes fewer cycles, I would
> expect.  Do you have the actual instruction sequences to compare?

Sure. Just looking at a couple of cases:

On range comparisons such as (a < CONST):
* without this patch, you end up with a comparison, then a cr-to-cr op +
mfcr + mask operation + tdnei.
* with the patch, you get a comparison and a conditional branch with
twi out of line.

On multiple comparisons like WARN_ON( a || b), it seems that there's an
added li to make the tdnei always hit for the first case. There it uses
a regular conditional branch, so no real difference in generated code
besides that.

Code examples. This was with a ppc64_defconfig, so CONFIG_POWER4_ONLY
wasn't enabled. It uses mfocrf when it is, which is alot cheaper. Still,
the rest of the code sequence is the same:

void irq_free_virt(unsigned int virq, unsigned int count)
{
        unsigned long flags;
        unsigned int i;

        WARN_ON (virq < NUM_ISA_INTERRUPTS);
        WARN_ON (count == 0 || (virq + count) > irq_virq_count);

        spin_lock_irqsave(&irq_big_lock, flags);

Without the patch:

c00000000000b33c <.irq_free_virt>:
c00000000000b33c:       7c 08 02 a6     mflr    r0
c00000000000b340:       2b 83 00 0f     cmplwi  cr7,r3,15
c00000000000b344:       fb c1 ff f0     std     r30,-16(r1)
c00000000000b348:       fb e1 ff f8     std     r31,-8(r1)
c00000000000b34c:       7c 9e 23 78     mr      r30,r4
c00000000000b350:       7c 7f 1b 78     mr      r31,r3
c00000000000b354:       4f dd e8 42     crnot   4*cr7+eq,4*cr7+gt
c00000000000b358:       f8 01 00 10     std     r0,16(r1)
c00000000000b35c:       f8 21 ff 81     stdu    r1,-128(r1)
c00000000000b360:       7c 00 00 26     mfcr    r0
c00000000000b364:       54 00 ff fe     rlwinm  r0,r0,31,31,31
c00000000000b368:       0b 00 00 00     tdnei   r0,0
c00000000000b36c:       2f a4 00 00     cmpdi   cr7,r4,0
c00000000000b370:       38 00 00 01     li      r0,1
c00000000000b374:       41 9e 00 1c     beq     cr7,c00000000000b390 <.irq_free_virt+0x54>
c00000000000b378:       e9 22 80 d8     ld      r9,-32552(r2)
c00000000000b37c:       7d 63 22 14     add     r11,r3,r4
c00000000000b380:       80 09 00 00     lwz     r0,0(r9)
c00000000000b384:       7f 8b 00 40     cmplw   cr7,r11,r0
c00000000000b388:       7c 00 00 26     mfcr    r0
c00000000000b38c:       54 00 f7 fe     rlwinm  r0,r0,30,31,31
c00000000000b390:       0b 00 00 00     tdnei   r0,0
c00000000000b394:       e8 62 80 f8     ld      r3,-32520(r2)
c00000000000b398:       48 54 4c b1     bl      c000000000550048 <._spin_lock_irqsave>
c00000000000b39c:       60 00 00 00     nop

With the patch:

c00000000000b0b0 <.irq_free_virt>:
c00000000000b0b0:       7c 08 02 a6     mflr    r0
c00000000000b0b4:       2b 83 00 0f     cmplwi  cr7,r3,15
c00000000000b0b8:       fb c1 ff f0     std     r30,-16(r1)
c00000000000b0bc:       fb e1 ff f8     std     r31,-8(r1)
c00000000000b0c0:       7c 9e 23 78     mr      r30,r4
c00000000000b0c4:       7c 7f 1b 78     mr      r31,r3
c00000000000b0c8:       f8 01 00 10     std     r0,16(r1)
c00000000000b0cc:       f8 21 ff 81     stdu    r1,-128(r1)
c00000000000b0d0:       41 bd 00 08     bgt     cr7,c00000000000b0d8 <.irq_free_virt+0x28>
c00000000000b0d4:       0f e0 00 00     twi     31,r0,0
c00000000000b0d8:       2f be 00 00     cmpdi   cr7,r30,0
c00000000000b0dc:       41 9e 00 18     beq     cr7,c00000000000b0f4 <.irq_free_virt+0x44>
c00000000000b0e0:       e9 22 80 d8     ld      r9,-32552(r2)
c00000000000b0e4:       7d 7f f2 14     add     r11,r31,r30
c00000000000b0e8:       80 09 00 00     lwz     r0,0(r9)
c00000000000b0ec:       7f 8b 00 40     cmplw   cr7,r11,r0
c00000000000b0f0:       40 bd 00 08     ble     cr7,c00000000000b0f8 <.irq_free_virt+0x48>
c00000000000b0f4:       0f e0 00 00     twi     31,r0,0
c00000000000b0f8:       e8 62 80 f8     ld      r3,-32520(r2)
c00000000000b0fc:       48 54 3f 75     bl      c00000000054f070 <._spin_lock_irqsave>
c00000000000b100:       60 00 00 00     nop
