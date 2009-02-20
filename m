Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZBTMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZBTMAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZBTMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:00:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:39180 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZBTMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vWp/HxO5TMANvQsfFf/eCRYpKDRJodqKQJtBf+uEnwemgrzGIdlxSB/Z1gb0gfeH6x
         DMkWi6ApV1ZMouXNKDD01WApfaDgXfypglOgt085LEnmMj4H2oOZGc6awTHZaec8Y+Kk
         nM6xDQOA/WUXAX5wfkMDQSQw1U7OjUgqg07z8=
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 21:00:16 +0900
Message-ID: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com>
Subject: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when 
	resuming
From: Kim Kyuwon <chammoru@gmail.com>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       dbrownell@users.sourceforge.net,
       =?EUC-KR?B?seix1L/4?= <q1.kim@samsung.com>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most registers lose its state when the processor wakes up from sleep state.
Thus registers should be initialized, when the processor wakes up. However the
current hsmmc 'resume' function doesn't consider this issue and finally makes
deadlock. So this patch fixes this problem.

Signed-off-by: Kim Kyuwon <chammoru@gmail.com>
---
 drivers/mmc/host/omap_hsmmc.c |  155 +++++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 76 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 56363c5..5a73fa6 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -55,6 +55,7 @@
 #define VS30			(1 << 25)
 #define SDVS18			(0x5 << 9)
 #define SDVS30			(0x6 << 9)
+#define SDVS_MASK		0x00000E00
 #define SDVSCLR			0xFFFFF1FF
 #define SDVSDET			0x00000400
 #define AUTOIDLE		0x1
@@ -861,6 +862,34 @@ static int omap_hsmmc_get_ro(struct mmc_host *mmc)
 	return pdata->slots[0].get_ro(host->dev, 0);
 }

+static void omap_hsmmc_init(struct mmc_omap_host *host)
+{
+	u32 hctl, capa, value;
+
+	/* Only MMC1 supports 3.0V */
+	if (host->id == OMAP_MMC1_DEVID) {
+		hctl = SDVS30;
+		capa = VS30 | VS18;
+	} else {
+		hctl = SDVS18;
+		capa = VS18;
+	}
+
+	value = OMAP_HSMMC_READ(host->base, HCTL) & ~SDVS_MASK;
+	OMAP_HSMMC_WRITE(host->base, HCTL, value | hctl);
+
+	value = OMAP_HSMMC_READ(host->base, CAPA);
+	OMAP_HSMMC_WRITE(host->base, CAPA, value | capa);
+
+	/* Set the controller to AUTO IDLE mode */
+	value = OMAP_HSMMC_READ(host->base, SYSCONFIG);
+	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, value | AUTOIDLE);
+
+	/* Set SD bus power bit */
+	value = OMAP_HSMMC_READ(host->base, HCTL);
+	OMAP_HSMMC_WRITE(host->base, HCTL, value | SDBP);
+}
+
 static struct mmc_host_ops mmc_omap_ops = {
 	.request = omap_mmc_request,
 	.set_ios = omap_mmc_set_ios,
@@ -876,7 +905,6 @@ static int __init omap_mmc_probe(struct
platform_device *pdev)
 	struct mmc_omap_host *host = NULL;
 	struct resource *res;
 	int ret = 0, irq;
-	u32 hctl, capa;

 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "Platform Data is missing\n");
@@ -981,28 +1009,7 @@ static int __init omap_mmc_probe(struct
platform_device *pdev)
 	if (pdata->slots[host->slot_id].wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;

-	/* Only MMC1 supports 3.0V */
-	if (host->id == OMAP_MMC1_DEVID) {
-		hctl = SDVS30;
-		capa = VS30 | VS18;
-	} else {
-		hctl = SDVS18;
-		capa = VS18;
-	}
-
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) | hctl);
-
-	OMAP_HSMMC_WRITE(host->base, CAPA,
-			OMAP_HSMMC_READ(host->base, CAPA) | capa);
-
-	/* Set the controller to AUTO IDLE mode */
-	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
-			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
-
-	/* Set SD bus power bit */
-	OMAP_HSMMC_WRITE(host->base, HCTL,
-			OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
+	omap_hsmmc_init(host);

 	/* Request IRQ for MMC operations */
 	ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
@@ -1127,41 +1134,38 @@ static int omap_mmc_suspend(struct
platform_device *pdev, pm_message_t state)
 	if (host && host->suspended)
 		return 0;

-	if (host) {
-		ret = mmc_suspend_host(host->mmc, state);
-		if (ret == 0) {
-			host->suspended = 1;
-
-			OMAP_HSMMC_WRITE(host->base, ISE, 0);
-			OMAP_HSMMC_WRITE(host->base, IE, 0);
+	ret = mmc_suspend_host(host->mmc, state);
+	if (ret == 0) {
+		host->suspended = 1;

-			if (host->pdata->suspend) {
-				ret = host->pdata->suspend(&pdev->dev,
-								host->slot_id);
-				if (ret)
-					dev_dbg(mmc_dev(host->mmc),
-						"Unable to handle MMC board"
-						" level suspend\n");
-			}
+		OMAP_HSMMC_WRITE(host->base, ISE, 0);
+		OMAP_HSMMC_WRITE(host->base, IE, 0);

-			if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
-				OMAP_HSMMC_WRITE(host->base, HCTL,
-					OMAP_HSMMC_READ(host->base, HCTL)
-					& SDVSCLR);
-				OMAP_HSMMC_WRITE(host->base, HCTL,
-					OMAP_HSMMC_READ(host->base, HCTL)
-					| SDVS30);
-				OMAP_HSMMC_WRITE(host->base, HCTL,
-					OMAP_HSMMC_READ(host->base, HCTL)
-					| SDBP);
-			}
+		if (host->pdata->suspend) {
+			ret = host->pdata->suspend(&pdev->dev, host->slot_id);
+			if (ret)
+				dev_dbg(mmc_dev(host->mmc),
+					"Unable to handle MMC board"
+					" level suspend\n");
+		}

-			clk_disable(host->fclk);
-			clk_disable(host->iclk);
-			clk_disable(host->dbclk);
+		if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
+			OMAP_HSMMC_WRITE(host->base, HCTL,
+				OMAP_HSMMC_READ(host->base, HCTL)
+				& SDVSCLR);
+			OMAP_HSMMC_WRITE(host->base, HCTL,
+				OMAP_HSMMC_READ(host->base, HCTL)
+				| SDVS30);
+			OMAP_HSMMC_WRITE(host->base, HCTL,
+				OMAP_HSMMC_READ(host->base, HCTL)
+				| SDBP);
 		}

+		clk_disable(host->fclk);
+		clk_disable(host->iclk);
+		clk_disable(host->dbclk);
 	}
+
 	return ret;
 }

@@ -1174,36 +1178,35 @@ static int omap_mmc_resume(struct platform_device *pdev)
 	if (host && !host->suspended)
 		return 0;

-	if (host) {
+	ret = clk_enable(host->fclk);
+	if (ret)
+		goto clk_en_err;

-		ret = clk_enable(host->fclk);
-		if (ret)
-			goto clk_en_err;
-
-		ret = clk_enable(host->iclk);
-		if (ret) {
-			clk_disable(host->fclk);
-			clk_put(host->fclk);
-			goto clk_en_err;
-		}
+	ret = clk_enable(host->iclk);
+	if (ret) {
+		clk_disable(host->fclk);
+		clk_put(host->fclk);
+		goto clk_en_err;
+	}

-		if (clk_enable(host->dbclk) != 0)
-			dev_dbg(mmc_dev(host->mmc),
-					"Enabling debounce clk failed\n");
+	if (clk_enable(host->dbclk) != 0)
+		dev_dbg(mmc_dev(host->mmc),
+				"Enabling debounce clk failed\n");

-		if (host->pdata->resume) {
-			ret = host->pdata->resume(&pdev->dev, host->slot_id);
-			if (ret)
-				dev_dbg(mmc_dev(host->mmc),
-					"Unmask interrupt failed\n");
-		}
+	omap_hsmmc_init(host);

-		/* Notify the core to resume the host */
-		ret = mmc_resume_host(host->mmc);
-		if (ret == 0)
-			host->suspended = 0;
+	if (host->pdata->resume) {
+		ret = host->pdata->resume(&pdev->dev, host->slot_id);
+		if (ret)
+			dev_dbg(mmc_dev(host->mmc),
+				"Unmask interrupt failed\n");
 	}

+	/* Notify the core to resume the host */
+	ret = mmc_resume_host(host->mmc);
+	if (ret == 0)
+		host->suspended = 0;
+
 	return ret;

 clk_en_err:
-- 
1.5.2.5


-- 
Kim Kyuwon
