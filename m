Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZKKEog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZKKEog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 23:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbZKKEof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 23:44:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756702AbZKKEoe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 23:44:34 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-mmc@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 04:44:36 +0000
Message-ID: <1257914676.2237.57.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] mmc: add module parameter to set whether cards are assumed
 removable
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some people run general-purpose distribution kernels on netbooks with
a card that is physically non-removable or logically non-removable
(e.g. used for /home) and cannot be cleanly unmounted during suspend.
Add a module parameter to set whether cards are assumed removable or
non-removable, with the default set by CONFIG_MMC_UNSAFE_RESUME.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/core/Kconfig |    4 +++-
 drivers/mmc/core/core.c  |   16 ++++++++++++++++
 drivers/mmc/core/core.h  |    2 ++
 drivers/mmc/core/mmc.c   |   23 +----------------------
 drivers/mmc/core/sd.c    |   21 +--------------------
 5 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ab37a6d..bb22ffd 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config MMC_UNSAFE_RESUME
-	bool "Allow unsafe resume (DANGEROUS)"
+	bool "Assume MMC/SD cards are non-removable (DANGEROUS)"
 	help
 	  If you say Y here, the MMC layer will assume that all cards
 	  stayed in their respective slots during the suspend. The
@@ -14,3 +14,5 @@ config MMC_UNSAFE_RESUME
 	  This option is usually just for embedded systems which use
 	  a MMC/SD card for rootfs. Most people should say N here.
 
+	  This option sets a default which can be overridden by the
+	  module parameter "removable=0" or "removable=1".
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d98b0e2..010c964 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -48,6 +48,22 @@ int use_spi_crc = 1;
 module_param(use_spi_crc, bool, 0);
 
 /*
+ * We normally treat cards as removed during suspend if they are not
+ * known to be on a non-removable bus, to avoid the risk of writing
+ * back data to a different card after resume.  Allow this to be
+ * overridden if necessary.
+ */
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+int mmc_assume_removable;
+#else
+int mmc_assume_removable = 1;
+#endif
+module_param_named(removable, mmc_assume_removable, bool, 0644);
+MODULE_PARM_DESC(
+	removable,
+	"MMC/SD cards are removable and may be removed during suspend");
+
+/*
  * Internal function. Schedule delayed work in the MMC work queue.
  */
 static int mmc_schedule_delayed_work(struct delayed_work *work,
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 1c68783..d20b7bc 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -64,7 +64,9 @@ int mmc_attach_mmc(struct mmc_host *host, u32 ocr);
 int mmc_attach_sd(struct mmc_host *host, u32 ocr);
 int mmc_attach_sdio(struct mmc_host *host, u32 ocr);
 
+/* Module parameters */
 extern int use_spi_crc;
+extern int mmc_assume_removable;
 
 /* Debugfs information for hosts and cards */
 void mmc_add_host_debugfs(struct mmc_host *host);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index bfefce3..c111894 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -602,25 +602,6 @@ static int mmc_awake(struct mmc_host *host)
 	return err;
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
-static const struct mmc_bus_ops mmc_ops = {
-	.awake = mmc_awake,
-	.sleep = mmc_sleep,
-	.remove = mmc_remove,
-	.detect = mmc_detect,
-	.suspend = mmc_suspend,
-	.resume = mmc_resume,
-	.power_restore = mmc_power_restore,
-};
-
-static void mmc_attach_bus_ops(struct mmc_host *host)
-{
-	mmc_attach_bus(host, &mmc_ops);
-}
-
-#else
-
 static const struct mmc_bus_ops mmc_ops = {
 	.awake = mmc_awake,
 	.sleep = mmc_sleep,
@@ -645,15 +626,13 @@ static void mmc_attach_bus_ops(struct mmc_host *host)
 {
 	const struct mmc_bus_ops *bus_ops;
 
-	if (host->caps & MMC_CAP_NONREMOVABLE)
+	if (host->caps & MMC_CAP_NONREMOVABLE || !mmc_assume_removable)
 		bus_ops = &mmc_ops_unsafe;
 	else
 		bus_ops = &mmc_ops;
 	mmc_attach_bus(host, bus_ops);
 }
 
-#endif
-
 /*
  * Starting point for MMC card init.
  */
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 10b2a4d..fdd414e 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -606,23 +606,6 @@ static void mmc_sd_power_restore(struct mmc_host *host)
 	mmc_release_host(host);
 }
 
-#ifdef CONFIG_MMC_UNSAFE_RESUME
-
-static const struct mmc_bus_ops mmc_sd_ops = {
-	.remove = mmc_sd_remove,
-	.detect = mmc_sd_detect,
-	.suspend = mmc_sd_suspend,
-	.resume = mmc_sd_resume,
-	.power_restore = mmc_sd_power_restore,
-};
-
-static void mmc_sd_attach_bus_ops(struct mmc_host *host)
-{
-	mmc_attach_bus(host, &mmc_sd_ops);
-}
-
-#else
-
 static const struct mmc_bus_ops mmc_sd_ops = {
 	.remove = mmc_sd_remove,
 	.detect = mmc_sd_detect,
@@ -643,15 +626,13 @@ static void mmc_sd_attach_bus_ops(struct mmc_host *host)
 {
 	const struct mmc_bus_ops *bus_ops;
 
-	if (host->caps & MMC_CAP_NONREMOVABLE)
+	if (host->caps & MMC_CAP_NONREMOVABLE || !mmc_assume_removable)
 		bus_ops = &mmc_sd_ops_unsafe;
 	else
 		bus_ops = &mmc_sd_ops;
 	mmc_attach_bus(host, bus_ops);
 }
 
-#endif
-
 /*
  * Starting point for SD card init.
  */
-- 
1.6.5.2


