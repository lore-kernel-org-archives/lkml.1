Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbZD3Wp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbZD3Wp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763955AbZD3Wp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:45:29 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:42924 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762239AbZD3Wp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:45:28 -0400
Date: Fri, 1 May 2009 00:45:24 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Ricoh R5C822 and QUIRK_FORCE_DMA
Message-ID: <20090430224524.GA9487@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently got a used Thinkpad X41, which has a built-in Ricoh
R5C822 Rev 13 SD controller, which seems to only use dma if I add
the FORCE_DMA quirk:

|04:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
|Host Adapter (rev 13)
|        Subsystem: IBM ThinkPad X60s / Z60t
|        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
|ParErr- Stepping- SERR+ FastB2B- DisINTx-
|        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
|        Latency: 64
|        Interrupt: pin B routed to IRQ 17
|        Region 0: Memory at a0201000 (32-bit, non-prefetchable) [size=256]
|        Capabilities: [80] Power Management version 2
|                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
|                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
|        Kernel driver in use: sdhci-pci
|00: 80 11 22 08 06 01 10 02 13 00 05 08 00 40 80 00
|10: 00 10 20 a0 00 00 00 00 00 00 00 00 00 00 00 00
|20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 56 05
|30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 02 00 00
|40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|80: 01 00 02 fe 00 40 00 48 00 00 00 00 00 00 00 00
|90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|a0: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 56 05
|b0: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
|c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|e0: a1 21 80 01 00 00 00 00 40 00 00 00 00 00 00 00
|f0: 00 00 00 00 00 00 00 00 03 00 20 04 00 00 00 00

I found that (using 2.6.30-rc4) the SD controller is rather slow and
makes the X cursor jumpy, so I suspected it is using PIO rather than
DMA.  vmstat also showed a high system percentage instead of just
iowait.

After adding a 'No DMA available' debugging statement I found that
this revision does not seem to claim DMA support.  However, after
seeing in some dmesg logs that at least Rev 18 and greater do
support DMA, I thought I'd try to add SDHCI_QUIRK_FORCE_DMA to
sdhci-pci.c.

Lo and behold, the speed has now doubled (4MB/s vs. nearly 8MB/s),
the mouse cursor is no longer jumpy and system percentage is down to
5% with 95% iowait.

Do you know any controller bugs for this revision which may be the
reason for not advertising DMA capability?
I haven't done any big tests yet, but at first glance it seems to
read/write the card just fine.

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
