Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZCKNCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZCKNCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZCKNBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:01:51 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZCKNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dOrrbDuxouRlowWCNUAWaF1N0MY3C5ruPccnuT4jr45BJm6E22r8fQ5Ajc8TrveqIJ
         C1sLFS2uUpC45RBLBJhT9CGc4tagtfo3LKLCRTP+jpUeJ+3iNC/OhP1avK/BJzAzGCsl
         4S3vdmLnwap8ea1Rhfs/zPMHty8Uomd+9FXHs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:59:19 +0900
Message-Id: <20090311125919.1563.39503.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 04/05] tmio_mmc: Make cnf area optional
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Magnus Damm <damm@opensource.se>

Add support for tmio_mmc hardware configurations that
lack the cnf io area. With this patch such hardware
can pass a single ctl io area with the platform data.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- 0012/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-03-11 19:35:46.000000000 +0900
@@ -37,12 +37,18 @@
 
 static void tmio_mmc_cnf_power(struct tmio_mmc_host *host, int on)
 {
+	if (!host->cnf)
+		return;
+
 	tmio_iowrite8(on ? 0x02 : 0x00, host->cnf + CNF_PWR_CTL_2);
 }
 
 static void tmio_mmc_cnf_setup_regs(struct tmio_mmc_host *host,
 				    struct platform_device *dev)
 {
+	if (!host->cnf)
+		return;
+
 	/* Enable the MMC/SD Control registers */
 	tmio_iowrite16(SDCREN, host->cnf + CNF_CMD);
 	tmio_iowrite32(dev->resource[0].start & 0xfffe,
@@ -52,12 +58,18 @@ static void tmio_mmc_cnf_setup_regs(stru
 static void tmio_mmc_cnf_setup_clock(struct tmio_mmc_host *host,
 				     int divide_by_one)
 {
+	if (!host->cnf)
+		return;
+
 	tmio_iowrite8(divide_by_one ? 0 : 1,
 		      host->cnf + CNF_SD_CLK_MODE);
 }
 
 static void tmio_mmc_cnf_setup_late(struct tmio_mmc_host *host)
 {
+	if (!host->cnf)
+		return;
+
 	/* Disable SD power during suspend */
 	tmio_iowrite8(0x01, host->cnf + CNF_PWR_CTL_3);
 
@@ -576,12 +588,8 @@ static int __devinit tmio_mmc_probe(stru
 	struct mmc_host *mmc;
 	int ret = -ENOMEM;
 
-	if (dev->num_resources != 3)
-		goto out;
-
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf) {
+	if (!res_ctl) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -598,9 +606,12 @@ static int __devinit tmio_mmc_probe(stru
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
+	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	if (res_cnf) {
+		host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
+		if (!host->cnf)
+			goto unmap_ctl;
+	}
 
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
@@ -651,7 +662,8 @@ static int __devinit tmio_mmc_probe(stru
 	return 0;
 
 unmap_cnf:
-	iounmap(host->cnf);
+	if (host->cnf)
+		iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -670,8 +682,9 @@ static int __devexit tmio_mmc_remove(str
 		struct tmio_mmc_host *host = mmc_priv(mmc);
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
+		if (host->cnf)
+			iounmap(host->cnf);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
