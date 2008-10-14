Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYJNXTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYJNXTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYJNXSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:18:15 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:43026 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbYJNXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:18:12 -0400
Message-Id: <20081014231810.008236344@fluff.org.uk>
References: <20081014231714.739345038@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 00:17:16 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/5] s3cmci: cpufreq support
Content-Disposition: inline; filename=simtec/cpufreq/s3c24xx-cpufreq-driver-mmc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for cpu frequency changing.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-quilt5/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-quilt5.orig/drivers/mmc/host/s3cmci.c	2008-10-15 00:04:11.000000000 +0100
+++ linux-2.6.27-quilt5/drivers/mmc/host/s3cmci.c	2008-10-15 00:11:42.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
+#include <linux/cpufreq.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 
@@ -1033,10 +1034,33 @@ static void s3cmci_request(struct mmc_ho
 		s3cmci_send_request(mmc);
 }
 
+static void s3cmci_set_clk(struct s3cmci_host *host, struct mmc_ios *ios)
+{
+	u32 mci_psc;
+
+	/* Set clock */
+	for (mci_psc = 0; mci_psc < 255; mci_psc++) {
+		host->real_rate = host->clk_rate / (host->clk_div*(mci_psc+1));
+
+		if (host->real_rate <= ios->clock)
+			break;
+	}
+
+	if (mci_psc > 255)
+		mci_psc = 255;
+
+	host->prescaler = mci_psc;
+	writel(host->prescaler, host->base + S3C2410_SDIPRE);
+
+	/* If requested clock is 0, real_rate will be 0, too */
+	if (ios->clock == 0)
+		host->real_rate = 0;
+}
+
 static void s3cmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct s3cmci_host *host = mmc_priv(mmc);
-	u32 mci_psc, mci_con;
+	u32 mci_con;
 
 	/* Set the power state */
 
@@ -1074,23 +1098,7 @@ static void s3cmci_set_ios(struct mmc_ho
 		break;
 	}
 
-	/* Set clock */
-	for (mci_psc = 0; mci_psc < 255; mci_psc++) {
-		host->real_rate = host->clk_rate / (host->clk_div*(mci_psc+1));
-
-		if (host->real_rate <= ios->clock)
-			break;
-	}
-
-	if (mci_psc > 255)
-		mci_psc = 255;
-
-	host->prescaler = mci_psc;
-	writel(host->prescaler, host->base + S3C2410_SDIPRE);
-
-	/* If requested clock is 0, real_rate will be 0, too */
-	if (ios->clock == 0)
-		host->real_rate = 0;
+	s3cmci_set_clk(host, ios);
 
 	/* Set CLOCK_ENABLE */
 	if (ios->clock)
@@ -1148,6 +1156,61 @@ static struct s3c24xx_mci_pdata s3cmci_d
 	 * checks. Any zero fields to ensure reaonable defaults are picked. */
 };
 
+#ifdef CONFIG_CPU_FREQ
+
+static int s3cmci_cpufreq_transition(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct s3cmci_host *host;
+	struct mmc_host *mmc;
+	unsigned long newclk;
+	unsigned long flags;
+
+	host = container_of(nb, struct s3cmci_host, freq_transition);
+	newclk = clk_get_rate(host->clk);
+	mmc = host->mmc;
+
+	if ((val == CPUFREQ_PRECHANGE && newclk > host->clk_rate) ||
+	    (val == CPUFREQ_POSTCHANGE && newclk < host->clk_rate)) {
+		spin_lock_irqsave(&mmc->lock, flags);
+
+		host->clk_rate = newclk;
+
+		if (mmc->ios.power_mode != MMC_POWER_OFF &&
+		    mmc->ios.clock != 0)
+			s3cmci_set_clk(host, &mmc->ios);
+
+		spin_unlock_irqrestore(&mmc->lock, flags);
+	}
+
+	return 0;
+}
+
+static inline int s3cmci_cpufreq_register(struct s3cmci_host *host)
+{
+	host->freq_transition.notifier_call = s3cmci_cpufreq_transition;
+
+	return cpufreq_register_notifier(&host->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void s3cmci_cpufreq_deregister(struct s3cmci_host *host)
+{
+	cpufreq_unregister_notifier(&host->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+#else
+static inline int s3cmci_cpufreq_register(struct s3cmci_host *host)
+{
+	return 0;
+}
+
+static inline void s3cmci_cpufreq_deregister(struct s3cmci_host *host)
+{
+}
+#endif
+
 static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
 {
 	struct s3cmci_host *host;
@@ -1298,10 +1361,16 @@ static int __devinit s3cmci_probe(struct
 	    (host->is2440?"2440":""),
 	    host->base, host->irq, host->irq_cd, host->dma);
 
+	ret = s3cmci_cpufreq_register(host);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register cpufreq\n");
+		goto free_dmabuf;
+	}
+
 	ret = mmc_add_host(mmc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add mmc host.\n");
-		goto free_dmabuf;
+		goto free_cpufreq;
 	}
 
 	platform_set_drvdata(pdev, mmc);
@@ -1309,6 +1378,9 @@ static int __devinit s3cmci_probe(struct
 
 	return 0;
 
+ free_cpufreq:
+	s3cmci_cpufreq_deregister(host);
+
  free_dmabuf:
 	clk_disable(host->clk);
 
@@ -1342,6 +1414,7 @@ static void s3cmci_shutdown(struct platf
 	if (host->irq_cd >= 0)
 		free_irq(host->irq_cd, host);
 
+	s3cmci_cpufreq_deregister(host);
 	mmc_remove_host(mmc);
 	clk_disable(host->clk);
 }
Index: linux-2.6.27-quilt5/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.27-quilt5.orig/drivers/mmc/host/s3cmci.h	2008-10-10 15:44:48.000000000 +0100
+++ linux-2.6.27-quilt5/drivers/mmc/host/s3cmci.h	2008-10-15 00:10:30.000000000 +0100
@@ -67,4 +67,8 @@ struct s3cmci_host {
 
 	unsigned int		ccnt, dcnt;
 	struct tasklet_struct	pio_tasklet;
+
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
 };

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
