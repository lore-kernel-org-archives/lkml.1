Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZGTSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZGTSvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZGTSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:51:38 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37815 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZGTSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x8lz3wM363mS2wPUDd9Pb2Cjm0BO0HY6a7nqar6/G2GFzn+ElHOSiSd90C156YZ6kb
         BL3exAZTQrcrIWVh9ahJtYTxoFbobVd+H04FfUWKpWBBuUomNsmMzp9J8034H5W8gRYZ
         ++3CW4EL57N9T8/m6LKJS+2zb+o8isngX48/c=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [PATCH] au1xmmc: allow platforms to disable certain host capabilities
Date: Mon, 20 Jul 2009 20:51:22 +0200
Message-Id: <1248115882-20221-2-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248115882-20221-1-git-send-email-manuel.lauss@gmail.com>
References: <1248115882-20221-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the hardware supports a 4/8bit SD interface and the driver
unconditionally advertises all hardware caps to the MMC core, not all
datalines may actually be wired up.  This patch introduces another
field to au1xmmc platform data allowing platforms to disable certain
advanced host controller features.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 arch/mips/include/asm/mach-au1x00/au1100_mmc.h |    1 +
 drivers/mmc/host/au1xmmc.c                     |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-au1x00/au1100_mmc.h b/arch/mips/include/asm/mach-au1x00/au1100_mmc.h
index c35e209..a674643 100644
--- a/arch/mips/include/asm/mach-au1x00/au1100_mmc.h
+++ b/arch/mips/include/asm/mach-au1x00/au1100_mmc.h
@@ -46,6 +46,7 @@ struct au1xmmc_platform_data {
 	int(*card_readonly)(void *mmc_host);
 	void(*set_power)(void *mmc_host, int state);
 	struct led_classdev *led;
+	unsigned long mask_host_caps;
 };
 
 #define SD0_BASE	0xB0600000
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 70509c9..d50e7ea 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1005,6 +1005,9 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->ocr_avail = AU1XMMC_OCR;
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 
+	/* platform may not be able to use 4/8 bit datapath */
+	mmc->caps &= ~(host->platdata->mask_host_caps);
+
 	host->status = HOST_S_IDLE;
 
 	/* board-specific carddetect setup, if any */
-- 
1.6.3.3

