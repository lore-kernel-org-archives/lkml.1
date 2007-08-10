Return-Path: <linux-kernel-owner+w=401wt.eu-S935740AbXHJOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935740AbXHJOjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbXHJOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:39:31 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57273 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbXHJOj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:39:29 -0400
Date: Fri, 10 Aug 2007 16:38:23 +0200 (MEST)
Message-Id: <200708101438.l7AEcNna029762@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 01:45:38 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Friday 10 August 2007, Alan Cox wrote:
> > On Thu, 9 Aug 2007 23:19:34 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > 
> > > Maximum supported UDMA mode for AEC6280[R] is UDMA5 (not UDMA4)
> > > and for AEC6880[R] it is UDMA6 (not UDMA5):
> > > 
> > > * Fix the problem by adding missing struct ata_port_info to artop_init_one().
> > > 
> > > * Use the right naming (s/626/628/).
> > > 
> > > * Bump driver version.
> > > 
> > > Fixes IDE->libata regression, problem was never present in IDE aec62xx driver.
> > 
> > Have you tested this ??
> 
> -ENODEV so no and testing is welcomed.
> 
> However I went over both drivers to make sure that this change is safe
> and correct.
> 
> BTW presence of the above bugs would strongly indicate that pata_artop has
> never been tested (properly) with AEC6x80[R], otherwise these bugs should
> have been noticed and fixed much earlier.

Tested on ATP865 (1191:0008 rev 07) in a DS101 box (an ARM-based NAS).
Seems to work fine.

However, I'm gettting consistently lower read throughput with pata_artop
(13-19 MB/s) than with aec62xx (22 MB/s) on an oldish WD drive, and using
pata_artop triggers a WARN_ON(irqs_disabled()) in arch/arm/mm/consistent.c:

WARNING: at arch/arm/mm/consistent.c:364 dma_free_coherent()
[<c001fe7c>] (dump_stack+0x0/0x14) from [<c00210ec>] (dma_free_coherent+0x38/0x200)
[<c00210b4>] (dma_free_coherent+0x0/0x200) from [<c00253a8>] (dma_unmap_sg+0x15c/0x198)
[<c002524c>] (dma_unmap_sg+0x0/0x198) from [<c0111984>] (ata_sg_clean+0xe4/0x1dc)
[<c01118a0>] (ata_sg_clean+0x0/0x1dc) from [<c0111ac8>] (__ata_qc_complete+0x4c/0xcc)
 r8:c02eca20 r7:00000004 r6:c02ec000 r5:c02ec000 r4:c02eca20
[<c0111a7c>] (__ata_qc_complete+0x0/0xcc) from [<c0111be8>] (ata_qc_complete+0xa0/0xe4)
 r5:c02eca20 r4:c02eca20
[<c0111b48>] (ata_qc_complete+0x0/0xe4) from [<c01121b8>] (ata_hsm_qc_complete+0x104/0x10c)
 r4:00000000
[<c01120b4>] (ata_hsm_qc_complete+0x0/0x10c) from [<c01127fc>] (ata_hsm_move+0x63c/0x694)
 r6:c02ec000 r5:00000050 r4:00000000
[<c01121c0>] (ata_hsm_move+0x0/0x694) from [<c0116628>] (ata_interrupt+0x188/0x240)
[<c01164a0>] (ata_interrupt+0x0/0x240) from [<c0051b24>] (handle_IRQ_event+0x44/0x84)
[<c0051ae0>] (handle_IRQ_event+0x0/0x84) from [<c005339c>] (handle_level_irq+0xb0/0x108)
 r7:c02250e8 r6:00000000 r5:0000001c r4:c020e600
[<c00532ec>] (handle_level_irq+0x0/0x108) from [<c001b044>] (__exception_text_start+0x44/0x60)
 r5:c020e600 r4:0000001c
[<c001b000>] (__exception_text_start+0x0/0x60) from [<c001ba44>] (__irq_svc+0x24/0x60)
Exception stack(0xc0209f64 to 0xc0209fac)
9f60:          00000000 00000002 00000000 00000000 c001cfa0 c0208000 c0018de8 
9f80: c02250e8 00017570 690541f1 0001746c c0209fc0 c0209fac c0209fac c001cd38 
9fa0: c001cfa4 60000013 ffffffff                                              
 r6:10000000 r5:0000001f r4:ffffffff
[<c001cce4>] (cpu_idle+0x0/0x8c) from [<c018f020>] (rest_init+0x48/0x58)
 r5:c02174d0 r4:c021fa58
[<c018efd8>] (rest_init+0x0/0x58) from [<c0008b7c>] (start_kernel+0x238/0x294)
[<c0008944>] (start_kernel+0x0/0x294) from [<00008038>] (0x8038)

So far I've only seen this happen when I run hdparm -Tt /dev/sda.

So something's still not quite right.

aec62xx is perfectly reliable on this box.

/Mikael
