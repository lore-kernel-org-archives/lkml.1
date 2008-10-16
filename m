Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbYJPQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbYJPQJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJPQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:09:43 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:20736 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYJPQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qZ7OtSRNLvngYH4CuGTQJ2a6cJv7aCS0w+mSqn+buSLcD9KkVUOtQBurexYJfEDKP0
         QGFQcHOrGXAWxd3Q1gCulVn3Wo88MVf0+D7Tt2NnuL6WRA0S7GMXVSC7Uh/o+V/hbb+5
         Qq2vPsT9q/AK3nsjIFkg2ilLx45oN6RN0TDrY=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] MMC: Fix race condition in resume/card detect code
Date: Thu, 16 Oct 2008 19:09:36 +0300
Message-Id: <1224173376-25829-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
enabled then race condition between mmc_rescan() and
mmc_resume()/mmc_sd_resume() appeared.

Resume functions can sleep into mmc_remove_card() and at this time
mmc_rescan() can be called by delayed work handler. Double-free of
kobject or double-remove of host->card can be result of this.

This patch adds an mutex which deny simultaneous executing of
mmc_sd_resume()/mmc_resume() and mmc_rescan() functions. Probably, it is
not right way.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/mmc/core/core.c  |    7 +++++++
 drivers/mmc/core/host.c  |    3 +++
 drivers/mmc/core/mmc.c   |    3 +++
 drivers/mmc/core/sd.c    |    3 +++
 include/linux/mmc/host.h |    3 +++
 5 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..838fee0 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -657,6 +657,9 @@ void mmc_rescan(struct work_struct *work)
 	u32 ocr;
 	int err;
 
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+	mutex_lock(&host->carddetect_lock);
+#endif
 	mmc_bus_get(host);
 
 	if (host->bus_ops == NULL) {
@@ -717,6 +720,10 @@ void mmc_rescan(struct work_struct *work)
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
+
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+	mutex_unlock(&host->carddetect_lock);
+#endif
 }
 
 void mmc_start_host(struct mmc_host *host)
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 6da80fd..90a7218 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -82,6 +82,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	device_initialize(&host->class_dev);
 
 	spin_lock_init(&host->lock);
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+	mutex_init(&host->carddetect_lock);
+#endif
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index fdd7c76..e335b50 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -523,6 +523,8 @@ static void mmc_resume(struct mmc_host *host)
 {
 	int err;
 
+	mutex_lock(&host->carddetect_lock);
+
 	BUG_ON(!host);
 	BUG_ON(!host->card);
 
@@ -538,6 +540,7 @@ static void mmc_resume(struct mmc_host *host)
 		mmc_release_host(host);
 	}
 
+	mutex_unlock(&host->carddetect_lock);
 }
 
 #else
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 26fc098..40a1404 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -585,6 +585,8 @@ static void mmc_sd_resume(struct mmc_host *host)
 {
 	int err;
 
+	mutex_lock(&host->carddetect_lock);
+
 	BUG_ON(!host);
 	BUG_ON(!host->card);
 
@@ -600,6 +602,7 @@ static void mmc_sd_resume(struct mmc_host *host)
 		mmc_release_host(host);
 	}
 
+	mutex_unlock(&host->carddetect_lock);
 }
 
 #else
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9c288c9..049598c 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -129,6 +129,9 @@ struct mmc_host {
 	/* private data */
 	spinlock_t		lock;		/* lock for claim and bus ops */
 
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+	struct mutex		carddetect_lock;
+#endif
 	struct mmc_ios		ios;		/* current io bus settings */
 	u32			ocr;		/* the current OCR setting */
 
-- 
1.5.6.5

