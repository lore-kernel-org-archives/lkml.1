Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZG1KqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZG1KqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZG1KqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:46:12 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31738 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZG1Kif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:38:35 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:38:43 +0300
Message-Id: <20090728103843.2371.13562.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 1/32] mmc: add 'enable' and 'disable' methods to mmc host
X-OriginalArrivalTime: 28 Jul 2009 10:38:11.0921 (UTC) FILETIME=[8156B410:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4610f1ede273078f99214c6284202998aa537a1d Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 22 Apr 2009 12:50:45 +0300
Subject: [PATCH] mmc: add 'enable' and 'disable' methods to mmc host

MMC hosts that support power saving can use the 'enable' and
'disable' methods to exit and enter power saving states.
An explanation of their use is provided in the comments
added to include/linux/mmc/host.h.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/core.c  |  177 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/core/host.c  |    1 +
 drivers/mmc/core/host.h  |    2 +
 include/linux/mmc/host.h |   47 ++++++++++++
 4 files changed, 221 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d84c880..9bc8d27 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -344,6 +344,101 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
 EXPORT_SYMBOL(mmc_align_data_size);
 
 /**
+ *	mmc_host_enable - enable a host.
+ *	@host: mmc host to enable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_enable(struct mmc_host *host)
+{
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (host->nesting_cnt++)
+		return 0;
+
+	cancel_delayed_work_sync(&host->disable);
+
+	if (host->enabled)
+		return 0;
+
+	if (host->ops->enable) {
+		int err;
+
+		host->en_dis_recurs = 1;
+		err = host->ops->enable(host);
+		host->en_dis_recurs = 0;
+
+		if (err) {
+			pr_debug("%s: enable error %d\n",
+				 mmc_hostname(host), err);
+			return err;
+		}
+	}
+	host->enabled = 1;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_host_enable);
+
+static int mmc_host_do_disable(struct mmc_host *host, int lazy)
+{
+	if (host->ops->disable) {
+		int err;
+
+		host->en_dis_recurs = 1;
+		err = host->ops->disable(host, lazy);
+		host->en_dis_recurs = 0;
+
+		if (err < 0) {
+			pr_debug("%s: disable error %d\n",
+				 mmc_hostname(host), err);
+			return err;
+		}
+		if (err > 0) {
+			unsigned long delay = msecs_to_jiffies(err);
+
+			mmc_schedule_delayed_work(&host->disable, delay);
+		}
+	}
+	host->enabled = 0;
+	return 0;
+}
+
+/**
+ *	mmc_host_disable - disable a host.
+ *	@host: mmc host to disable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_disable(struct mmc_host *host)
+{
+	int err;
+
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (--host->nesting_cnt)
+		return 0;
+
+	if (!host->enabled)
+		return 0;
+
+	err = mmc_host_do_disable(host, 0);
+	return err;
+}
+EXPORT_SYMBOL(mmc_host_disable);
+
+/**
  *	__mmc_claim_host - exclusively claim a host
  *	@host: mmc host to claim
  *	@abort: whether or not the operation should be aborted
@@ -379,11 +474,81 @@ int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
 		wake_up(&host->wq);
 	spin_unlock_irqrestore(&host->lock, flags);
 	remove_wait_queue(&host->wq, &wait);
+	if (!stop)
+		mmc_host_enable(host);
 	return stop;
 }
 
 EXPORT_SYMBOL(__mmc_claim_host);
 
+static int mmc_try_claim_host(struct mmc_host *host)
+{
+	int claimed_host = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (!host->claimed) {
+		host->claimed = 1;
+		claimed_host = 1;
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+	return claimed_host;
+}
+
+static void mmc_do_release_host(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->claimed = 0;
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	wake_up(&host->wq);
+}
+
+void mmc_host_deeper_disable(struct work_struct *work)
+{
+	struct mmc_host *host =
+		container_of(work, struct mmc_host, disable.work);
+
+	/* If the host is claimed then we do not want to disable it anymore */
+	if (!mmc_try_claim_host(host))
+		return;
+	mmc_host_do_disable(host, 1);
+	mmc_do_release_host(host);
+}
+
+/**
+ *	mmc_host_lazy_disable - lazily disable a host.
+ *	@host: mmc host to disable
+ *
+ *	Hosts that support power saving can use the 'enable' and 'disable'
+ *	methods to exit and enter power saving states. For more information
+ *	see comments for struct mmc_host_ops.
+ */
+int mmc_host_lazy_disable(struct mmc_host *host)
+{
+	if (!(host->caps & MMC_CAP_DISABLE))
+		return 0;
+
+	if (host->en_dis_recurs)
+		return 0;
+
+	if (--host->nesting_cnt)
+		return 0;
+
+	if (!host->enabled)
+		return 0;
+
+	if (host->disable_delay) {
+		mmc_schedule_delayed_work(&host->disable,
+				msecs_to_jiffies(host->disable_delay));
+		return 0;
+	} else
+		return mmc_host_do_disable(host, 1);
+}
+EXPORT_SYMBOL(mmc_host_lazy_disable);
+
 /**
  *	mmc_release_host - release a host
  *	@host: mmc host to release
@@ -393,15 +558,11 @@ EXPORT_SYMBOL(__mmc_claim_host);
  */
 void mmc_release_host(struct mmc_host *host)
 {
-	unsigned long flags;
-
 	WARN_ON(!host->claimed);
 
-	spin_lock_irqsave(&host->lock, flags);
-	host->claimed = 0;
-	spin_unlock_irqrestore(&host->lock, flags);
+	mmc_host_lazy_disable(host);
 
-	wake_up(&host->wq);
+	mmc_do_release_host(host);
 }
 
 EXPORT_SYMBOL(mmc_release_host);
@@ -947,6 +1108,8 @@ void mmc_stop_host(struct mmc_host *host)
 	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
+	if (host->caps & MMC_CAP_DISABLE)
+		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
@@ -975,6 +1138,8 @@ void mmc_stop_host(struct mmc_host *host)
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
+	if (host->caps & MMC_CAP_DISABLE)
+		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 5e945e6..a268d12 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -83,6 +83,7 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	spin_lock_init(&host->lock);
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
+	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
index c2dc3d2..8c87e11 100644
--- a/drivers/mmc/core/host.h
+++ b/drivers/mmc/core/host.h
@@ -14,5 +14,7 @@
 int mmc_register_host_class(void);
 void mmc_unregister_host_class(void);
 
+void mmc_host_deeper_disable(struct work_struct *work);
+
 #endif
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 3e7615e..338a9b3 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -51,6 +51,35 @@ struct mmc_ios {
 };
 
 struct mmc_host_ops {
+	/*
+	 * Hosts that support power saving can use the 'enable' and 'disable'
+	 * methods to exit and enter power saving states. 'enable' is called
+	 * when the host is claimed and 'disable' is called (or scheduled with
+	 * a delay) when the host is released. The 'disable' is scheduled if
+	 * the disable delay set by 'mmc_set_disable_delay()' is non-zero,
+	 * otherwise 'disable' is called immediately. 'disable' may be
+	 * scheduled repeatedly, to permit ever greater power saving at the
+	 * expense of ever greater latency to re-enable. Rescheduling is
+	 * determined by the return value of the 'disable' method. A positive
+	 * value gives the delay in milliseconds.
+	 *
+	 * In the case where a host function (like set_ios) may be called
+	 * with or without the host claimed, enabling and disabling can be
+	 * done directly and will nest correctly. Call 'mmc_host_enable()' and
+	 * 'mmc_host_lazy_disable()' for this purpose, but note that these
+	 * functions must be paired.
+	 *
+	 * Alternatively, 'mmc_host_enable()' may be paired with
+	 * 'mmc_host_disable()' which calls 'disable' immediately.  In this
+	 * case the 'disable' method will be called with 'lazy' set to 0.
+	 * This is mainly useful for error paths.
+	 *
+	 * Because lazy disable may be called from a work queue, the 'disable'
+	 * method must claim the host when 'lazy' != 0, which will work
+	 * correctly because recursion is detected and handled.
+	 */
+	int (*enable)(struct mmc_host *host);
+	int (*disable)(struct mmc_host *host, int lazy);
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
 	/*
 	 * Avoid calling these three functions too often or in a "fast path",
@@ -118,6 +147,7 @@ struct mmc_host {
 #define MMC_CAP_SPI		(1 << 4)	/* Talks only SPI protocols */
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
+#define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
@@ -142,6 +172,13 @@ struct mmc_host {
 	unsigned int		removed:1;	/* host is being removed */
 #endif
 
+	/* Only used with MMC_CAP_DISABLE */
+	int			enabled;	/* host is enabled */
+	int			nesting_cnt;	/* "enable" nesting count */
+	int			en_dis_recurs;	/* detect recursion */
+	unsigned int		disable_delay;	/* disable delay in msecs */
+	struct delayed_work	disable;	/* disabling work */
+
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
@@ -197,5 +234,15 @@ struct regulator;
 int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
 
+int mmc_host_enable(struct mmc_host *host);
+int mmc_host_disable(struct mmc_host *host);
+int mmc_host_lazy_disable(struct mmc_host *host);
+
+static inline void mmc_set_disable_delay(struct mmc_host *host,
+					 unsigned int disable_delay)
+{
+	host->disable_delay = disable_delay;
+}
+
 #endif
 
-- 
1.5.6.3

