Return-Path: <linux-kernel-owner+w=401wt.eu-S934829AbXHLLyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829AbXHLLyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbXHLLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:54:11 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40487 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765561AbXHLLyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:54:09 -0400
Date: Sun, 12 Aug 2007 13:53:54 +0200 (MEST)
Message-Id: <200708121153.l7CBrsm5011470@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk, mikpe@it.uu.se
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]
Cc: bzolnier@gmail.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 18:33:43 +0100, Alan Cox wrote:
> > However, I'm gettting consistently lower read throughput with pata_artop
> > (13-19 MB/s) than with aec62xx (22 MB/s) on an oldish WD drive, and using
> > pata_artop triggers a WARN_ON(irqs_disabled()) in arch/arm/mm/consistent.c:
> 
> It would be nice to know why - is the cable detet coming out right on
> this ?

The box has a short 40-wire cable, so pata_artop drops to udma/33
while aec62xx does udma/100 without intervention. I added an override
to artop6260_cable_detect() to make it return PATA40_SHORT on this
platform, and with that it does udma/100 as expected.

Read performance fluctuates quite a bit, but seems to be 1-3 MB/s
slower than aec62xx on average. I compared lspci -vvxxx and the
only differences are a latency setting and some ROM thingy:

--- lspci-ide	2007-08-12 13:07:12.000000000 +0200
+++ lspci-libata	2007-08-12 13:12:55.000000000 +0200
@@ -1,32 +1,32 @@
 00:01.0 Mass storage controller: Artop Electronic Corp ATP865 NO-ROM (rev 07)
 	Subsystem: Artop Electronic Corp ATP865 NO-ROM
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
 	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
-	Latency: 0 (2750ns min, 1000ns max), Cache Line Size 08
+	Latency: 144 (2750ns min, 1000ns max), Cache Line Size 08
 	Interrupt: pin A routed to IRQ 28
 	Region 0: I/O ports at 1050 [size=8]
 	Region 1: I/O ports at 1060 [size=4]
 	Region 2: I/O ports at 1058 [size=8]
 	Region 3: I/O ports at 1064 [size=4]
 	Region 4: I/O ports at 1040 [size=16]
-	Expansion ROM at 48000000 [disabled by cmd] [size=64K]
+	Expansion ROM at 48000000 [disabled] [size=64K]
 	Capabilities: [58] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
-00: 91 11 08 00 45 01 90 02 07 00 80 01 08 00 00 00
+00: 91 11 08 00 45 01 90 02 07 00 80 01 08 90 00 00
 10: 51 10 00 00 61 10 00 00 59 10 00 00 65 10 00 00
 20: 41 10 00 00 00 00 00 00 00 00 00 00 91 11 08 00
-30: 01 00 00 48 58 00 00 00 00 00 00 00 1c 01 0b 04
+30: 00 00 00 48 58 00 00 00 00 00 00 00 1c 01 0b 04
 40: 31 00 00 00 06 00 00 00 70 84 96 00 00 00 00 02
 50: ff ff ff ff f0 ff 34 50 01 00 02 06 00 00 00 00
 60: 31 00 00 00 06 00 00 00 70 84 96 00 00 00 00 02
 70: 00 00 00 00 f0 ff 34 50 01 00 02 06 00 00 00 00
 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 c0: 31 00 00 00 06 00 00 00 70 84 96 00 00 00 00 02
 d0: 00 00 00 00 f0 ff 34 50 01 00 02 06 00 00 00 00
 e0: 31 00 00 00 06 00 00 00 70 84 96 00 00 00 00 02
 f0: 00 00 00 00 f0 ff 34 50 01 00 02 06 00 00 00 00

> > WARNING: at arch/arm/mm/consistent.c:364 dma_free_coherent()
> 
> ARM has a problem with dma_free_coherent with IRQ disabled. Unfortunately
> under high load ARM decides to use dma_free_coherent inside
> dma_unmap_sg(). This as far as I can see is an ARM problem not a libata
> problem and one you can duplicate with other drivers under high load.

Yes, I now see that happening also with the IDE aec62xx driver.
It used to only be a single-line WARNING, only recently has the
ARM kernel started to also do a stack dump when it triggers.

/Mikael
