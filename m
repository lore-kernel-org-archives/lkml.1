Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZCKNCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZCKNCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZCKNCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:02:00 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZCKNB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YmDRWFSTOaM2TR1RAUTxrLv9Pq3yZjJj5ExpWfuwwszbHOU6ja6od+OB39pzjDSbjH
         QGiVBWsIB54uEd/ksq4vLx+epdzwki97QBv7b15NN7AD+LGDvOwbRY6m23YdGxealVTH
         Ig7+85FFgkXJGG/JgcvY2ZSJSnaew2W42etbM=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:59:28 +0900
Message-Id: <20090311125928.1563.26784.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 05/05] tmio_mmc: Support multiple interrupts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Magnus Damm <damm@opensource.se>

Add support for tmio_mmc hardware configurations with
multiple interrupts. With this patch applied all interrupts
passed as platform data will be used by the driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |   58 ++++++++++++++++++++++++++++++++-----------
 drivers/mmc/host/tmio_mmc.h |    1 
 2 files changed, 44 insertions(+), 15 deletions(-)

--- 0013/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-03-11 19:38:59.000000000 +0900
@@ -537,6 +537,45 @@ static struct mmc_host_ops tmio_mmc_ops 
 	.get_ro         = tmio_mmc_get_ro,
 };
 
+static int tmio_mmc_hook_irqs(struct platform_device *dev, int hook)
+{
+	struct mmc_host *mmc = platform_get_drvdata(dev);
+	struct tmio_mmc_host *host = mmc_priv(mmc);
+	struct resource *res;
+	int ret = -ENXIO;
+	int q, m;
+	int k = 0;
+	int n = 0;
+
+	while ((res = platform_get_resource(dev, IORESOURCE_IRQ, k))) {
+		for (n = res->start; hook && n <= res->end; n++) {
+			if (request_irq(n, tmio_mmc_irq, IRQF_DISABLED,
+					dev_name(&dev->dev), host))
+				goto rollback;
+
+			set_irq_type(n, IRQ_TYPE_EDGE_FALLING);
+		}
+		k++;
+	}
+
+	if (hook)
+		return k > 0 ? 0 : -ENOENT;
+
+	k--;
+	ret = 0;
+
+ rollback:
+	for (q = k; k >= 0; k--) {
+		for (m = n; m >= res->start; m--)
+			free_irq(m, host);
+
+		res = platform_get_resource(dev, IORESOURCE_IRQ, k - 1);
+		m = res->end;
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_PM
 static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 {
@@ -636,25 +675,16 @@ static int __devinit tmio_mmc_probe(stru
 	tmio_mmc_clk_stop(host);
 	reset(host);
 
-	ret = platform_get_irq(dev, 0);
-	if (ret >= 0)
-		host->irq = ret;
-	else
-		goto unmap_cnf;
-
-	disable_mmc_irqs(host->ctl, TMIO_MASK_ALL);
-
-	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED, "tmio-mmc",
-		host);
+	ret = tmio_mmc_hook_irqs(dev, 1);
 	if (ret)
 		goto unmap_cnf;
 
-	set_irq_type(host->irq, IRQ_TYPE_EDGE_FALLING);
+	disable_mmc_irqs(host->ctl, TMIO_MASK_ALL);
 
 	mmc_add_host(mmc);
 
-	printk(KERN_INFO "%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-	       (unsigned long)host->ctl, host->irq);
+	printk(KERN_INFO "%s at 0x%08lx\n", mmc_hostname(host->mmc),
+	       (unsigned long)host->ctl);
 
 	/* Unmask the IRQs we want to know about */
 	enable_mmc_irqs(host->ctl,  TMIO_MASK_IRQ);
@@ -681,7 +711,7 @@ static int __devexit tmio_mmc_remove(str
 	if (mmc) {
 		struct tmio_mmc_host *host = mmc_priv(mmc);
 		mmc_remove_host(mmc);
-		free_irq(host->irq, host);
+		tmio_mmc_hook_irqs(dev, 0);
 		if (host->cnf)
 			iounmap(host->cnf);
 		iounmap(host->ctl);
--- 0001/drivers/mmc/host/tmio_mmc.h
+++ work/drivers/mmc/host/tmio_mmc.h	2009-03-11 19:38:03.000000000 +0900
@@ -112,7 +112,6 @@ struct tmio_mmc_host {
 	struct mmc_request      *mrq;
 	struct mmc_data         *data;
 	struct mmc_host         *mmc;
-	int                     irq;
 
 	/* pio related stuff */
 	struct scatterlist      *sg_ptr;
