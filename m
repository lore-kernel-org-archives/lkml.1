Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZGTW11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZGTW11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZGTW1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:27:25 -0400
Received: from mail.df.lth.se ([194.47.250.12]:63571 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753619AbZGTW1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:27:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Pierre Ossman <pierre@ossman.eu>, linux-arm-kernel@lists.arm.linux.org.uk,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/2] MMC Agressive clocking framework v5
Date: Tue, 21 Jul 2009 00:26:48 +0200
Message-Id: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modified the MMC core code to optionally call the
set_ios() operation on the driver with the clock frequency set
to 0 (gate) after a grace period of at least 8 MCLK cycles, then
restore it (ungate) before any new request. This gives
the driver the option to shut down the hardware block clock and
thus (in known designs) the MCI clock to the MMC/SD card when
the clock frequency is 0, i.e. the core has stated that the MCI
clock does not need to be generated.

It is inspired by existing clock gating code found in the OMAP
and Atmel drivers and brings this up to the host abstraction.
Gating is performed before and after any MMC request.

It exemplifies by implementing this for the MMCI/PL180 MMC/SD
host controller, but it should be simple to switch OMAP and
Atmel over to using this instead.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mmc/core/Kconfig   |   11 +++
 drivers/mmc/core/core.c    |   39 +++++++++-
 drivers/mmc/core/core.h    |    2 +
 drivers/mmc/core/debugfs.c |   10 ++-
 drivers/mmc/core/host.c    |  191 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/core/host.h    |    4 +
 include/linux/mmc/host.h   |   10 +++
 7 files changed, 263 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ab37a6d..5372fc9 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -14,3 +14,14 @@ config MMC_UNSAFE_RESUME
 	  This option is usually just for embedded systems which use
 	  a MMC/SD card for rootfs. Most people should say N here.
 
+config MMC_CLKGATE
+	bool "MMC host clock gaing (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  This will attempt to agressively gate the clock to the MMC host,
+	  which typically also will gate the MCI clock to the card. This
+	  is done to save power due to gating off the logic and bus noise
+	  when MMC is not in use. Your host driver has to support this in
+	  order for it to be of any use.
+
+	  If unsure, say N.
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d84c880..30a940b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -113,6 +113,8 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 
 		if (mrq->done)
 			mrq->done(mrq);
+
+		mmc_host_clk_gate(host);
 	}
 }
 
@@ -173,6 +175,7 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 			mrq->stop->mrq = mrq;
 		}
 	}
+	mmc_host_clk_ungate(host);
 	host->ops->request(host, mrq);
 }
 
@@ -279,7 +282,7 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
 
 		timeout_us = data->timeout_ns / 1000;
 		timeout_us += data->timeout_clks * 1000 /
-			(card->host->ios.clock / 1000);
+			(mmc_host_clk_rate(card->host) / 1000);
 
 		if (data->flags & MMC_DATA_WRITE)
 			/*
@@ -447,6 +450,40 @@ void mmc_set_clock(struct mmc_host *host, unsigned int hz)
 	mmc_set_ios(host);
 }
 
+#ifdef CONFIG_MMC_CLKGATE
+/*
+ * This gates the clock by setting it to 0 Hz.
+ */
+void mmc_gate_clock(struct mmc_host *host)
+{
+	host->clk_old = host->ios.clock;
+	host->ios.clock = 0;
+	host->clk_gated = true;
+	mmc_set_ios(host);
+}
+
+/*
+ * This restores the clock from gating by using the cached
+ * clock value.
+ */
+void mmc_ungate_clock(struct mmc_host *host)
+{
+	/*
+	 * We should previously have gated the clock, so the clock
+	 * shall be 0 here!
+	 * The clock may however be 0 during intialization,
+	 * when some request operations are performed before setting
+	 * the frequency. When ungate is requested in that situation
+	 * we just ignore the call.
+	 */
+	if (host->clk_old) {
+		BUG_ON(host->ios.clock);
+		mmc_set_clock(host, host->clk_old);
+	}
+	host->clk_gated = false;
+}
+#endif
+
 /*
  * Change the bus mode (open drain/push-pull) of a host.
  */
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index c819eff..ee27f81 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -27,6 +27,8 @@ void mmc_detach_bus(struct mmc_host *host);
 
 void mmc_set_chip_select(struct mmc_host *host, int mode);
 void mmc_set_clock(struct mmc_host *host, unsigned int hz);
+void mmc_gate_clock(struct mmc_host *host);
+void mmc_ungate_clock(struct mmc_host *host);
 void mmc_set_bus_mode(struct mmc_host *host, unsigned int mode);
 void mmc_set_bus_width(struct mmc_host *host, unsigned int width);
 u32 mmc_select_voltage(struct mmc_host *host, u32 ocr);
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 610dbd1..1a969bd 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -149,11 +149,17 @@ void mmc_add_host_debugfs(struct mmc_host *host)
 	host->debugfs_root = root;
 
 	if (!debugfs_create_file("ios", S_IRUSR, root, host, &mmc_ios_fops))
-		goto err_ios;
+		goto err_remove_files;
+
+#ifdef CONFIG_MMC_CLKGATE
+	if (!debugfs_create_u32("clk_delay", (S_IRUSR | S_IWUSR),
+				root, &host->clk_delay))
+		goto err_remove_files;
+#endif
 
 	return;
 
-err_ios:
+err_remove_files:
 	debugfs_remove_recursive(root);
 	host->debugfs_root = NULL;
 err_root:
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 5e945e6..a046b2c 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2003 Russell King, All Rights Reserved.
  *  Copyright (C) 2007-2008 Pierre Ossman
+ *  Copyright (C) 2009 Linus Walleij
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -48,6 +49,191 @@ void mmc_unregister_host_class(void)
 static DEFINE_IDR(mmc_host_idr);
 static DEFINE_SPINLOCK(mmc_host_lock);
 
+#ifdef CONFIG_MMC_CLKGATE
+
+/*
+ * Enabling clock gating will make the core call out to the host
+ * once up and once down when it performs a request or card operation
+ * intermingled in any fashion. The driver will see this through
+ * set_ios() operations with ios.clock field set to 0 to gate
+ * (disable) the block clock, and to the old frequency to enable
+ * it again.
+ */
+static void mmc_host_clk_gate_delayed(struct mmc_host *host)
+{
+	unsigned long tick_ns;
+	unsigned long freq = host->ios.clock;
+	unsigned long flags;
+	int users;
+
+	if (!freq) {
+		pr_err("%s: frequency set to 0 in disable function, "
+		       "this means the clock is already disabled.\n",
+		       mmc_hostname(host));
+		return;
+	}
+	/*
+	 * New requests may have appeared while we were scheduling,
+	 * then there is no reason to delay the check before
+	 * clk_disable().
+	 */
+	spin_lock_irqsave(&host->clk_lock, flags);
+	users = host->clk_requests;
+	/*
+	 * Delay 8 bus cycles (from MMC spec) before attempting
+	 * to disable the MMCI block clock. The reference count
+	 * may have gone up again after this delay due to
+	 * rescheduling!
+	 */
+	if (!users) {
+		spin_unlock_irqrestore(&host->clk_lock, flags);
+		tick_ns = (1000000000 + freq - 1) / freq;
+		ndelay(host->clk_delay * tick_ns);
+	} else {
+		/* New users appeared while waiting for this work */
+		host->clk_pending_gate = false;
+		spin_unlock_irqrestore(&host->clk_lock, flags);
+		return;
+	}
+	spin_lock_irqsave(&host->clk_lock, flags);
+	if (!host->clk_requests) {
+		spin_unlock_irqrestore(&host->clk_lock, flags);
+		/* this will set host->ios.clock to 0 */
+		mmc_gate_clock(host);
+		spin_lock_irqsave(&host->clk_lock, flags);
+#ifdef CONFIG_MMC_DEBUG
+		pr_debug("%s: disabled MCI clock\n",
+			 mmc_hostname(host));
+#endif
+	}
+	host->clk_pending_gate = false;
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+}
+
+/*
+ * Internal work. Work to disable the clock at some later point.
+ */
+static void mmc_host_clk_gate_work(struct work_struct *work)
+{
+	struct mmc_host *host = container_of(work, struct mmc_host,
+					      clk_disable_work);
+
+	mmc_host_clk_gate_delayed(host);
+}
+
+/*
+ *	mmc_host_clk_ungate - make sure the host ios.clock is
+ *	restored to some non-zero value past this call.
+ *	@host: host to ungate.
+ *
+ *	Increase clock reference count and ungate clock if first user.
+ */
+void mmc_host_clk_ungate(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	if (host->clk_gated) {
+		spin_unlock_irqrestore(&host->clk_lock, flags);
+		mmc_ungate_clock(host);
+		spin_lock_irqsave(&host->clk_lock, flags);
+#ifdef CONFIG_MMC_DEBUG
+		pr_debug("%s: ungated MCI clock\n",
+			 mmc_hostname(host));
+#endif
+	}
+	host->clk_requests++;
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+}
+
+/*
+ *	mmc_host_clk_gate - call the host driver with ios.clock
+ *	set to zero as often as possible so as to make it
+ *	possible to gate off hardware MCI clocks.
+ *	@host: host to gate.
+ *
+ *	Decrease clock reference count and schedule disablement of clock.
+ */
+void mmc_host_clk_gate(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	host->clk_requests--;
+	if (!host->clk_requests) {
+		host->clk_pending_gate = true;
+		schedule_work(&host->clk_disable_work);
+	}
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+}
+
+/*
+ *	mmc_host_clk_rate - get current clock frequency setting no matter
+ *	whether it's gated or not.
+ *	@host: host to get the clock frequency for.
+ */
+unsigned int mmc_host_clk_rate(struct mmc_host *host)
+{
+	unsigned long freq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	if (host->clk_gated)
+		freq = host->clk_old;
+	else
+		freq = host->ios.clock;
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+	return freq;
+}
+
+/*
+ *	mmc_host_clk_init - set up clock gating code
+ *	@host: host with potential hardware clock to control
+ */
+static inline void mmc_host_clk_init(struct mmc_host *host)
+{
+	host->clk_requests = 0;
+	host->clk_delay = 8; /* hold MCI clock in 8 cycles by default */
+	host->clk_gated = false;
+	host->clk_pending_gate = false;
+	INIT_WORK(&host->clk_disable_work, mmc_host_clk_gate_work);
+	spin_lock_init(&host->clk_lock);
+}
+
+/*
+ *	mmc_host_clk_exit - shut down clock gating code
+ *	@host: host with potential hardware clock to control
+ */
+static inline void mmc_host_clk_exit(struct mmc_host *host)
+{
+	if (cancel_work_sync(&host->clk_disable_work))
+		mmc_host_clk_gate_delayed(host);
+	BUG_ON(host->clk_requests > 0);
+}
+
+#else
+inline void mmc_host_clk_ungate(struct mmc_host *host)
+{
+}
+
+inline void mmc_host_clk_gate(struct mmc_host *host)
+{
+}
+
+inline unsigned int mmc_host_clk_rate(struct mmc_host *host)
+{
+	return host->ios.clock;
+}
+
+static inline void mmc_host_clk_init(struct mmc_host *host)
+{
+}
+
+static inline void mmc_host_clk_exit(struct mmc_host *host)
+{
+}
+#endif
+
 /**
  *	mmc_alloc_host - initialise the per-host structure.
  *	@extra: sizeof private data structure
@@ -80,6 +266,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	host->class_dev.class = &mmc_host_class;
 	device_initialize(&host->class_dev);
 
+	mmc_host_clk_init(host);
+
 	spin_lock_init(&host->lock);
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
@@ -156,6 +344,8 @@ void mmc_remove_host(struct mmc_host *host)
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
+
+	mmc_host_clk_exit(host);
 }
 
 EXPORT_SYMBOL(mmc_remove_host);
@@ -176,4 +366,3 @@ void mmc_free_host(struct mmc_host *host)
 }
 
 EXPORT_SYMBOL(mmc_free_host);
-
diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
index c2dc3d2..81ff77b 100644
--- a/drivers/mmc/core/host.h
+++ b/drivers/mmc/core/host.h
@@ -10,9 +10,13 @@
  */
 #ifndef _MMC_CORE_HOST_H
 #define _MMC_CORE_HOST_H
+#include <linux/mmc/host.h>
 
 int mmc_register_host_class(void);
 void mmc_unregister_host_class(void);
+void mmc_host_clk_ungate(struct mmc_host *host);
+void mmc_host_clk_gate(struct mmc_host *host);
+unsigned int mmc_host_clk_rate(struct mmc_host *host);
 
 #endif
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 3e7615e..06cefe3 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -119,6 +119,16 @@ struct mmc_host {
 #define MMC_CAP_NEEDS_POLL	(1 << 5)	/* Needs polling for card-detection */
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 
+#ifdef CONFIG_MMC_CLKGATE
+	int			clk_requests;	/* internal reference counter */
+	unsigned int		clk_delay;	/* number of MCI clk hold cycles */
+	bool			clk_gated;	/* clock gated */
+	bool			clk_pending_gate; /* pending clock gating */
+	struct work_struct	clk_disable_work; /* delayed clock disablement */
+	unsigned int		clk_old;	/* old clock value cache */
+	spinlock_t		clk_lock;	/* lock for clk fields */
+#endif
+
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
 	unsigned short		max_hw_segs;	/* see blk_queue_max_hw_segments */
-- 
1.6.2.5

