Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZCJBVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZCJBVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZCJBVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:21:35 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46034 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZCJBVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=QGuVWOhv/ozaaQB9TzQ9yJimt2UeEFy10U6bapEl1BQyKfB7/m+N08H9F9SzKJF9Nu
         N5fVOXitizY5IX4vQ0cT/yuP5D0dhz0bDOcl3hy0kD2P64yC1uCMIvGJUvixQidw5aMi
         NpdHv4r0BRr76OK77ueHwiKXMFlntMEdZeTBY=
Message-ID: <49B5C091.3090303@gmail.com>
Date: Tue, 10 Mar 2009 02:21:21 +0100
From: =?ISO-8859-1?Q?Jos=E9_Mar=ED=ADa_Fern=E1ndez_Gonz=E1lez?= 
	<josemariafg@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mmc: Some microSD cards are not recognized by PCIxx12
 SDA controller
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: José M. Fernández <josemariafg@gmail.com>

My working laptop is a Toshiba Tecra M5 with Core2 Duo T7400 and 2GB of
memory. Since I'm using it I have found that some microSD cards (using
their size adapter) are not recognized when they are inserted in the
Tecra M5 SD slot. Now I own one of those cards (a Transcend 2GB
MM8GR02GUACU-PA), which works well with Windows XP and Toshiba drivers.
Looking for a fix I have done some web research about similar laptop
models, and following the clues I found next HTML page:

http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002089.html

about a kernel patch related to the SD controller in my laptop, which
involves a change on a mmc_delay call on controller startup. The
lspci -vv description for the SD controller is:

06:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller (prog-if 01)
        Subsystem: Toshiba America Info Systems Device 0001
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at ff9ff700 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci

When I applied the proposed change from that patch on mmc_delay
after MMC_POWER_ON, kernel started recognizing the microSD card,
but with errors I have seen with other SD cards:

Feb 21 18:39:25 olympo mmc0: card claims to support voltages below the defined range. These will be ignored.
Feb 21 18:39:25 olympo mmc0: SDIO card claims to support the incompletely defined 'low voltage range'. This will be ignored.
Feb 21 18:39:25 olympo mmc0: error -110 whilst initialising SDIO card

So, I extrapolated the change and, by chance, I found the fix,
which consist on raising the mmc_delay from 2 to 10 both on MMC_POWER_UP
and MMC_POWER_ON. I have been using the kernel with this fix for some
weeks, with no problem.

I don't know whether this patch can break something in the behavior of other
SD controllers, but at least it works for my laptop.

Signed-off-by: José M. Fernández <josemariafg@gmail.com>

---

diff -Nrpu linux-2.6.28.5/drivers/mmc/core/core.c.orig linux-2.6.28.5/drivers/mmc/core/core.c
--- linux-2.6.28.5/drivers/mmc/core/core.c.orig	2009-03-10 01:30:19.000000000 +0100
+++ linux-2.6.28.5/drivers/mmc/core/core.c	2009-03-10 01:29:44.000000000 +0100
@@ -514,7 +514,7 @@ static void mmc_power_up(struct mmc_host
 	 * This delay should be sufficient to allow the power supply
 	 * to reach the minimum voltage.
 	 */
-	mmc_delay(2);
+	mmc_delay(10);
 
 	host->ios.clock = host->f_min;
 	host->ios.power_mode = MMC_POWER_ON;
@@ -524,7 +524,7 @@ static void mmc_power_up(struct mmc_host
 	 * This delay must be at least 74 clock sizes, or 1 ms, or the
 	 * time required to reach a stable voltage.
 	 */
-	mmc_delay(2);
+	mmc_delay(10);
 }
 
 static void mmc_power_off(struct mmc_host *host)
