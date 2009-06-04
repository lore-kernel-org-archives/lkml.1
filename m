Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZFDSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZFDSNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZFDSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:13:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZFDSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lzaj+kkeF3rxZtB1h91UOmVms2Vb/0yjD1xvwMTwAUBEmBVj+qRD9df5Iz6e5twAoH
         utY334g3I0Ow5rLEzkwrW3GS6K6K4/OdtoON5dYqpmFNqo5hRwoYqfYB+BQOzWkpZtGb
         lb6W5QNRuiF+pIbLW22wyh76spVuFGJlkP6sg=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Philipp Zabel <philipp.zabel@gmail.com>, Ian Molton <spyro@f2s.com>
Subject: [PATCH 5/7] mmc: tmio_mmc: map SD control registers after enabling the MFD cell
Date: Thu,  4 Jun 2009 20:12:35 +0200
Message-Id: <1244139157-16404-6-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASIC3 can disable the memory, so we need to wait for mfd_cell->enable
to enable the memory before we can map the SD control registers.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/tmio_mmc.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index b576640..fe6d2b6 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -493,11 +493,6 @@ static int tmio_mmc_resume(struct platform_device *dev)
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 	int ret = 0;
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
 		ret = cell->enable(dev);
@@ -505,6 +500,11 @@ static int tmio_mmc_resume(struct platform_device *dev)
 			goto out;
 	}
 
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE,
+		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
+
 	mmc_resume_host(mmc);
 
 out:
@@ -563,11 +563,6 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	mmc->f_min = mmc->f_max / 512;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-	/* Enable the MMC/SD Control registers */
-	sd_config_write16(host, CNF_CMD, SDCREN);
-	sd_config_write32(host, CNF_CTL_BASE,
-		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
-
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
 		ret = cell->enable(dev);
@@ -575,6 +570,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 			goto unmap_cnf;
 	}
 
+	/* Enable the MMC/SD Control registers */
+	sd_config_write16(host, CNF_CMD, SDCREN);
+	sd_config_write32(host, CNF_CTL_BASE,
+		(dev->resource[0].start >> host->bus_shift) & 0xfffe);
+
 	/* Disable SD power during suspend */
 	sd_config_write8(host, CNF_PWR_CTL_3, 0x01);
 
-- 
1.6.3.1

