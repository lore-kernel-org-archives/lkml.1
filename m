Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZG1Kix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZG1Kix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZG1Kiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:38:51 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16396 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZG1Kit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:38:49 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:39:04 +0300
Message-Id: <20090728103904.2371.68231.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 4/32] mmc: add ability to save power by powering off cards
X-OriginalArrivalTime: 28 Jul 2009 10:38:36.0640 (UTC) FILETIME=[90128600:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e6355578d082d94707c8fda1e1342c478019b5c8 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 11 May 2009 12:20:57 +0300
Subject: [PATCH] mmc: add ability to save power by powering off cards

Power can be saved by powering off cards that are not
in use.  This is similar to suspend / resume except
it is under the control of the driver, and does not
require any power management support.  It can only
be used when the driver can monitor whether the card
is removed, otherwise it is unsafe.  This is possible
because, unlike suspend, the driver still receives
card detect and / or cover switch interrupts.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c  |   34 ++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |    2 ++
 drivers/mmc/core/mmc.c   |   11 +++++++++++
 drivers/mmc/core/sd.c    |   11 +++++++++++
 include/linux/mmc/host.h |    3 +++
 5 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index bab5015..39f7bd1 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1145,6 +1145,40 @@ void mmc_stop_host(struct mmc_host *host)
 	mmc_power_off(host);
 }
 
+void mmc_power_save_host(struct mmc_host *host)
+{
+	mmc_bus_get(host);
+
+	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
+		mmc_bus_put(host);
+		return;
+	}
+
+	if (host->bus_ops->power_save)
+		host->bus_ops->power_save(host);
+
+	mmc_bus_put(host);
+
+	mmc_power_off(host);
+}
+EXPORT_SYMBOL(mmc_power_save_host);
+
+void mmc_power_restore_host(struct mmc_host *host)
+{
+	mmc_bus_get(host);
+
+	if (!host->bus_ops || host->bus_dead || !host->bus_ops->power_restore) {
+		mmc_bus_put(host);
+		return;
+	}
+
+	mmc_power_up(host);
+	host->bus_ops->power_restore(host);
+
+	mmc_bus_put(host);
+}
+EXPORT_SYMBOL(mmc_power_restore_host);
+
 #ifdef CONFIG_PM
 
 /**
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index c819eff..f7eb4c4 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -20,6 +20,8 @@ struct mmc_bus_ops {
 	void (*detect)(struct mmc_host *);
 	void (*suspend)(struct mmc_host *);
 	void (*resume)(struct mmc_host *);
+	void (*power_save)(struct mmc_host *);
+	void (*power_restore)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 3e35075..01f7226 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -549,6 +549,14 @@ static void mmc_resume(struct mmc_host *host)
 
 }
 
+static void mmc_power_restore(struct mmc_host *host)
+{
+	host->card->state &= ~MMC_STATE_HIGHSPEED;
+	mmc_claim_host(host);
+	mmc_init_card(host, host->ocr, host->card);
+	mmc_release_host(host);
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_ops = {
@@ -556,6 +564,7 @@ static const struct mmc_bus_ops mmc_ops = {
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
+	.power_restore = mmc_power_restore,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
@@ -570,6 +579,7 @@ static const struct mmc_bus_ops mmc_ops = {
 	.detect = mmc_detect,
 	.suspend = NULL,
 	.resume = NULL,
+	.power_restore = mmc_power_restore,
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
@@ -577,6 +587,7 @@ static const struct mmc_bus_ops mmc_ops_unsafe = {
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
+	.power_restore = mmc_power_restore,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 80cccd2..debe26e 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -603,6 +603,14 @@ static void mmc_sd_resume(struct mmc_host *host)
 
 }
 
+static void mmc_sd_power_restore(struct mmc_host *host)
+{
+	host->card->state &= ~MMC_STATE_HIGHSPEED;
+	mmc_claim_host(host);
+	mmc_sd_init_card(host, host->ocr, host->card);
+	mmc_release_host(host);
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_sd_ops = {
@@ -610,6 +618,7 @@ static const struct mmc_bus_ops mmc_sd_ops = {
 	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static void mmc_sd_attach_bus_ops(struct mmc_host *host)
@@ -624,6 +633,7 @@ static const struct mmc_bus_ops mmc_sd_ops = {
 	.detect = mmc_sd_detect,
 	.suspend = NULL,
 	.resume = NULL,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static const struct mmc_bus_ops mmc_sd_ops_unsafe = {
@@ -631,6 +641,7 @@ static const struct mmc_bus_ops mmc_sd_ops_unsafe = {
 	.detect = mmc_sd_detect,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
+	.power_restore = mmc_sd_power_restore,
 };
 
 static void mmc_sd_attach_bus_ops(struct mmc_host *host)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index bb867d2..c1cbe59 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -223,6 +223,9 @@ static inline void *mmc_priv(struct mmc_host *host)
 extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
 extern int mmc_resume_host(struct mmc_host *);
 
+extern void mmc_power_save_host(struct mmc_host *host);
+extern void mmc_power_restore_host(struct mmc_host *host);
+
 extern void mmc_detect_change(struct mmc_host *, unsigned long delay);
 extern void mmc_request_done(struct mmc_host *, struct mmc_request *);
 
-- 
1.5.6.3

