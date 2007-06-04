Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbXFDWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbXFDWN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXFDWNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:13:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53834 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756925AbXFDWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:13:46 -0400
Date: Tue, 5 Jun 2007 00:13:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/mmc/core/core.{h,c}: cleanups
Message-ID: <20070604221349.GF5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...

This patch contains the following cleanups:
- make the following needlessly global functions static:
  - core.c: mmc_schedule_delayed_work()
  - core.c: mmc_flush_scheduled_work()
- removes the prototope of the following non-existing function:
  - core.h: mmc_schedule_work()
- proper prototypes for three functions from core.c in core.h
 
Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/mmc/core/core.c |   37 +++++++++++++++++++------------------
 drivers/mmc/core/core.h |    6 +++---
 drivers/mmc/core/host.c |    4 ----
 3 files changed, 22 insertions(+), 25 deletions(-)

--- linux-2.6.22-rc3-mm1/drivers/mmc/core/core.h.old	2007-06-04 21:53:42.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/mmc/core/core.h	2007-06-04 23:19:44.000000000 +0200
@@ -64,9 +64,9 @@ static inline void mmc_delay(unsigned in
 	}
 }
 
-int mmc_schedule_work(struct work_struct *work);
-int mmc_schedule_delayed_work(struct delayed_work *work, unsigned long delay);
-void mmc_flush_scheduled_work(void);
+void mmc_rescan(struct work_struct *work);
+void mmc_start_host(struct mmc_host *host);
+void mmc_stop_host(struct mmc_host *host);
 
 #endif
 
--- linux-2.6.22-rc3-mm1/drivers/mmc/core/core.c.old	2007-06-04 21:54:46.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/mmc/core/core.c	2007-06-04 21:57:38.000000000 +0200
@@ -37,6 +37,25 @@
 extern int mmc_attach_mmc(struct mmc_host *host, u32 ocr);
 extern int mmc_attach_sd(struct mmc_host *host, u32 ocr);
 
+static struct workqueue_struct *workqueue;
+
+/*
+ * Internal function. Schedule delayed work in the MMC work queue.
+ */
+static int mmc_schedule_delayed_work(struct delayed_work *work,
+				     unsigned long delay)
+{
+	return queue_delayed_work(workqueue, work, delay);
+}
+
+/*
+ * Internal function. Flush all scheduled work from the MMC work queue.
+ */
+static void mmc_flush_scheduled_work(void)
+{
+	flush_workqueue(workqueue);
+}
+
 /**
  *	mmc_request_done - finish processing an MMC request
  *	@host: MMC host which completed request
@@ -640,24 +659,6 @@ EXPORT_SYMBOL(mmc_resume_host);
 
 #endif
 
-static struct workqueue_struct *workqueue;
-
-/*
- * Internal function. Schedule delayed work in the MMC work queue.
- */
-int mmc_schedule_delayed_work(struct delayed_work *work, unsigned long delay)
-{
-	return queue_delayed_work(workqueue, work, delay);
-}
-
-/*
- * Internal function. Flush all scheduled work from the MMC work queue.
- */
-void mmc_flush_scheduled_work(void)
-{
-	flush_workqueue(workqueue);
-}
-
 static int __init mmc_init(void)
 {
 	int ret;
--- linux-2.6.22-rc3-mm1/drivers/mmc/core/host.c.old	2007-06-04 23:18:35.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/mmc/core/host.c	2007-06-04 23:19:25.000000000 +0200
@@ -23,10 +23,6 @@
 
 #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
 
-extern void mmc_rescan(struct work_struct *work);
-extern void mmc_start_host(struct mmc_host *host);
-extern void mmc_stop_host(struct mmc_host *host);
-
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);

