Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYKQTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYKQTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYKQTby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:31:54 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32690 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYKQTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:31:52 -0500
Date: Mon, 17 Nov 2008 21:31:25 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMC: Add 8-bit bus width support
Message-ID: <20081117193125.GA23241@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <20081117123521.GA15417@angel.research.nokia.com> <20081117124945.GF9161@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117124945.GF9161@fluff.org.uk>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Nov 2008 19:31:25.0169 (UTC) FILETIME=[144A2E10:01C948EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 12:49:45PM +0000, ext Ben Dooks wrote:
> I'll try and give this a test on the S3C6410, which has the option
> of having channel 1 being 8bit. Any idea of cards that support 8bit?

Hi Ben

Below is sample for HSMMC driver which tells the mmc driver the
host has 8-bit capability and enables it when told to.

The test board has an eMMC chip with 8 data lines connected to
HSMMC controller.  I am not aware of mmc cards having 8 pins yet.

Jarkko

>From 8318b7e7fd9a163b1fccf397a1b040d1a4e18d97 Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Mon, 17 Nov 2008 21:05:31 +0200
Subject: [PATCH] OMAP: HSMMC: Add 8-bit bus width mode support

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 0df6841..28182af 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -75,6 +75,7 @@
 #define MSBS			(1 << 5)
 #define BCE			(1 << 1)
 #define FOUR_BIT		(1 << 1)
+#define DW8			(1 << 5)
 #define CC			0x1
 #define TC			0x02
 #define OD			0x1
@@ -753,6 +754,7 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	u16 dsor = 0;
 	unsigned long regval;
 	unsigned long timeout;
+	u32 con;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
@@ -763,12 +765,18 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		break;
 	}
 
+	con =  OMAP_HSMMC_READ(host->base, CON);
 	switch (mmc->ios.bus_width) {
+	case MMC_BUS_WIDTH_8:
+		OMAP_HSMMC_WRITE(host->base, CON, con | DW8);
+		break;
 	case MMC_BUS_WIDTH_4:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
 		OMAP_HSMMC_WRITE(host->base, HCTL,
 			OMAP_HSMMC_READ(host->base, HCTL) | FOUR_BIT);
 		break;
 	case MMC_BUS_WIDTH_1:
+		OMAP_HSMMC_WRITE(host->base, CON, con & ~DW8);
 		OMAP_HSMMC_WRITE(host->base, HCTL,
 			OMAP_HSMMC_READ(host->base, HCTL) & ~FOUR_BIT);
 		break;
@@ -965,6 +973,8 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 
 	if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+	if (pdata->slots[host->slot_id].wires >= 8)
+		mmc->caps |= MMC_CAP_8_BIT_DATA;
 
 	/* Only MMC1 supports 3.0V */
 	if (host->id == OMAP_MMC1_DEVID) {
-- 
1.5.6.5

