Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZJ3Aah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZJ3Aah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZJ3Aah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:30:37 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:42138 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754708AbZJ3Aag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:30:36 -0400
Subject: CPUFREQ: S3C24XX Watchdog frequency scaling support.
Message-Id: <20091030003025.403905302@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Simtec Linux Team <linux@simtec.co.uk>
Content-Disposition: inline; filename=simtec/ready/cpufreq/watchdog-driver-update.patch
Date: Fri, 30 Oct 2009 00:30:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CPU frequency scaling to the S3C24XX Watchdog
driver.

Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Ben Dooks <ben@simtec.co.uk>

---
 drivers/watchdog/s3c2410_wdt.c |   89 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

Index: b/drivers/watchdog/s3c2410_wdt.c
===================================================================
--- a/drivers/watchdog/s3c2410_wdt.c	2009-08-28 11:44:05.000000000 +0100
+++ b/drivers/watchdog/s3c2410_wdt.c	2009-08-28 11:55:47.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/clk.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include <mach/map.h>
 
@@ -142,9 +143,14 @@ static void s3c2410wdt_start(void)
 	spin_unlock(&wdt_lock);
 }
 
+static inline int s3c2410wdt_is_running(void)
+{
+	return readl(wdt_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
+}
+
 static int s3c2410wdt_set_heartbeat(int timeout)
 {
-	unsigned int freq = clk_get_rate(wdt_clock);
+	unsigned long freq = clk_get_rate(wdt_clock);
 	unsigned int count;
 	unsigned int divisor = 1;
 	unsigned long wtcon;
@@ -155,7 +161,7 @@ static int s3c2410wdt_set_heartbeat(int 
 	freq /= 128;
 	count = timeout * freq;
 
-	DBG("%s: count=%d, timeout=%d, freq=%d\n",
+	DBG("%s: count=%d, timeout=%d, freq=%lu\n",
 	    __func__, count, timeout, freq);
 
 	/* if the count is bigger than the watchdog register,
@@ -324,6 +330,73 @@ static irqreturn_t s3c2410wdt_irq(int ir
 	s3c2410wdt_keepalive();
 	return IRQ_HANDLED;
 }
+
+
+#ifdef CONFIG_CPU_FREQ
+
+static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
+					  unsigned long val, void *data)
+{
+	int ret;
+
+	if (!s3c2410wdt_is_running())
+		goto done;
+
+	if (val == CPUFREQ_PRECHANGE) {
+		/* To ensure that over the change we don't cause the
+		 * watchdog to trigger, we perform an keep-alive if
+		 * the watchdog is running.
+		 */
+
+		s3c2410wdt_keepalive();
+	} else if (val == CPUFREQ_POSTCHANGE) {
+		s3c2410wdt_stop();
+
+		ret = s3c2410wdt_set_heartbeat(tmr_margin);
+
+		if (ret >= 0)
+			s3c2410wdt_start();
+		else
+			goto err;
+	}
+
+done:
+	return 0;
+
+ err:
+	dev_err(wdt_dev, "cannot set new value for timeout %d\n", tmr_margin);
+	return ret;
+}
+
+static struct notifier_block s3c2410wdt_cpufreq_transition_nb = {
+	.notifier_call	= s3c2410wdt_cpufreq_transition,
+};
+
+static inline int s3c2410wdt_cpufreq_register(void)
+{
+	return cpufreq_register_notifier(&s3c2410wdt_cpufreq_transition_nb,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void s3c2410wdt_cpufreq_deregister(void)
+{
+	cpufreq_unregister_notifier(&s3c2410wdt_cpufreq_transition_nb,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+#else
+static inline int s3c2410wdt_cpufreq_register(void)
+{
+	return 0;
+}
+
+static inline void s3c2410wdt_cpufreq_deregister(void)
+{
+}
+#endif
+
+
+
 /* device interface */
 
 static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
@@ -387,6 +460,11 @@ static int __devinit s3c2410wdt_probe(st
 
 	clk_enable(wdt_clock);
 
+	if (s3c2410wdt_cpufreq_register() < 0) {
+		printk(KERN_ERR PFX "failed to register cpufreq\n");
+		goto err_clk;
+	}
+
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
@@ -407,7 +485,7 @@ static int __devinit s3c2410wdt_probe(st
 	if (ret) {
 		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
-		goto err_clk;
+		goto err_cpufreq;
 	}
 
 	if (tmr_atboot && started == 0) {
@@ -432,6 +510,9 @@ static int __devinit s3c2410wdt_probe(st
 
 	return 0;
 
+ err_cpufreq:
+	s3c2410wdt_cpufreq_deregister();
+
  err_clk:
 	clk_disable(wdt_clock);
 	clk_put(wdt_clock);
@@ -451,6 +532,8 @@ static int __devinit s3c2410wdt_probe(st
 
 static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
+	s3c2410wdt_cpufreq_deregister();
+
 	release_resource(wdt_mem);
 	kfree(wdt_mem);
 	wdt_mem = NULL;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
