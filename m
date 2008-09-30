Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYI3KY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYI3KY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYI3KXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:23:41 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33876 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYI3KXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:23:38 -0400
Message-Id: <20080930102336.217571444@zoo.weinigel.se>
References: <20080930102313.418263345@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Tue, 30 Sep 2008 12:23:15 +0200
From: Christer Weinigel <christer@weinigel.se>
To: drzeus-list@drzeus.cx
Cc: Christer Weinigel <christer.weinigel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/3] RFC: Low-latency SDIO, convert sdio_irq_thread to workqueue.
Content-Disposition: inline; filename=sdio-async-workqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sdio_irq_thread into a workqueue.  The polling logic is moved
to delayed_work which runs periodically.

There are two major changes in behaviour from the thread version:

First, mmc_signal_sdio_irq will use an asynchronous operation to read
SDIO_CCCR_INTx, and the asynchronous callback then schedules
sdio_irq_work to do the processing.  Since this function can be called
from interrupt context, the request function in the SDIO host driver
can no longer sleep, something that it could get away with before when
all calls into the SDIO layer were made from a thread context.  

Second, I disable interrupts in mmc_claim_host (and enable them from
mmc_release_host).  Since the first thing mmc_signal_sdio_irq does is
mmc_try_claim_host, it can't do anything if someone else has claimed
the host anyway.  I don't think this should break anything.

Existing SDIO function drivers should still work as before and should
not notice any difference.

This work is done for my employer, CSR.

Signed-off-by: Christer Weinigel CSR <christer.weinigel@csr.com>

Index: linux-2.6.26.2/drivers/mmc/core/sdio_irq.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/sdio_irq.c
+++ linux-2.6.26.2/drivers/mmc/core/sdio_irq.c
@@ -28,18 +28,10 @@
 static int process_sdio_pending_irqs(struct mmc_card *card)
 {
 	int i, ret, count;
-	unsigned char pending;
-
-	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
-	if (ret) {
-		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
-		       mmc_card_id(card), ret);
-		return ret;
-	}
 
 	count = 0;
 	for (i = 1; i <= 7; i++) {
-		if (pending & (1 << i)) {
+		if (card->pending_irqs & (1 << i)) {
 			struct sdio_func *func = card->sdio_func[i - 1];
 			if (!func) {
 				printk(KERN_WARNING "%s: pending IRQ for "
@@ -47,6 +39,7 @@ static int process_sdio_pending_irqs(str
 					mmc_card_id(card));
 				ret = -EINVAL;
 			} else if (func->irq_handler) {
+				card->pending_irqs &= ~(1 << i);
 				func->irq_handler(func);
 				count++;
 			} else {
@@ -63,86 +56,29 @@ static int process_sdio_pending_irqs(str
 	return ret;
 }
 
-static int sdio_irq_thread(void *_host)
+/* Set realtime priority on the workqueue thread. */
+static void sdio_irq_sched_work(struct work_struct *work)
 {
-	struct mmc_host *host = _host;
 	struct sched_param param = { .sched_priority = 1 };
-	unsigned long period, idle_period;
-	int ret;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
+}
 
-	/*
-	 * We want to allow for SDIO cards to work even on non SDIO
-	 * aware hosts.  One thing that non SDIO host cannot do is
-	 * asynchronous notification of pending SDIO card interrupts
-	 * hence we poll for them in that case.
-	 */
-	idle_period = msecs_to_jiffies(10);
-	period = (host->caps & MMC_CAP_SDIO_IRQ) ?
-		MAX_SCHEDULE_TIMEOUT : idle_period;
-
-	pr_debug("%s: IRQ thread started (poll period = %lu jiffies)\n",
-		 mmc_hostname(host), period);
-
-	do {
-		/*
-		 * We claim the host here on drivers behalf for a couple
-		 * reasons:
-		 *
-		 * 1) it is already needed to retrieve the CCCR_INTx;
-		 * 2) we want the driver(s) to clear the IRQ condition ASAP;
-		 * 3) we need to control the abort condition locally.
-		 *
-		 * Just like traditional hard IRQ handlers, we expect SDIO
-		 * IRQ handlers to be quick and to the point, so that the
-		 * holding of the host lock does not cover too much work
-		 * that doesn't require that lock to be held.
-		 */
-		ret = __mmc_claim_host(host, &host->sdio_irq_thread_abort);
-		if (ret)
-			break;
-		ret = process_sdio_pending_irqs(host->card);
-		mmc_release_host(host);
-
-		/*
-		 * Give other threads a chance to run in the presence of
-		 * errors.  FIXME: determine if due to card removal and
-		 * possibly exit this thread if so.
-		 */
-		if (ret < 0)
-			ssleep(1);
-
-		/*
-		 * Adaptive polling frequency based on the assumption
-		 * that an interrupt will be closely followed by more.
-		 * This has a substantial benefit for network devices.
-		 */
-		if (!(host->caps & MMC_CAP_SDIO_IRQ)) {
-			if (ret > 0)
-				period /= 2;
-			else {
-				period++;
-				if (period > idle_period)
-					period = idle_period;
-			}
-		}
+static void sdio_irq_work(struct work_struct *work)
+{
+	struct mmc_host *host = container_of(work, struct mmc_host, irq_work);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (host->caps & MMC_CAP_SDIO_IRQ)
-			host->ops->enable_sdio_irq(host, 1);
-		if (!kthread_should_stop())
-			schedule_timeout(period);
-		set_current_state(TASK_RUNNING);
-	} while (!kthread_should_stop());
+	process_sdio_pending_irqs(host->card);
 
-	if (host->caps & MMC_CAP_SDIO_IRQ)
-		host->ops->enable_sdio_irq(host, 0);
+	mmc_release_host(host);
+}
 
-	pr_debug("%s: IRQ thread exiting with code %d\n",
-		 mmc_hostname(host), ret);
+static void sdio_irq_poll_work(struct work_struct *work)
+{
+	struct mmc_host *host = container_of(work, struct mmc_host,
+					     irq_poll_work.work);
 
-	return ret;
+	mmc_signal_sdio_irq(host);
 }
 
 static int sdio_card_irq_get(struct mmc_card *card)
@@ -152,14 +88,21 @@ static int sdio_card_irq_get(struct mmc_
 	WARN_ON(!host->claimed);
 
 	if (!host->sdio_irqs++) {
-		atomic_set(&host->sdio_irq_thread_abort, 0);
-		host->sdio_irq_thread =
-			kthread_run(sdio_irq_thread, host, "ksdiorqd");
-		if (IS_ERR(host->sdio_irq_thread)) {
-			int err = PTR_ERR(host->sdio_irq_thread);
+		host->irq_workqueue =
+			create_singlethread_workqueue("ksdiorqd");
+		if (!host->irq_workqueue) {
 			host->sdio_irqs--;
-			return err;
+			return -ENOMEM;
 		}
+
+		INIT_WORK(&host->irq_sched_work, sdio_irq_sched_work);
+		INIT_WORK(&host->irq_work, sdio_irq_work);
+		INIT_DELAYED_WORK(&host->irq_poll_work,
+				  sdio_irq_poll_work);
+
+		queue_work(host->irq_workqueue, &host->irq_sched_work);
+
+		host->irq_poll_period = msecs_to_jiffies(10);
 	}
 
 	return 0;
@@ -172,14 +115,114 @@ static int sdio_card_irq_put(struct mmc_
 	WARN_ON(!host->claimed);
 	BUG_ON(host->sdio_irqs < 1);
 
-	if (!--host->sdio_irqs) {
-		atomic_set(&host->sdio_irq_thread_abort, 1);
-		kthread_stop(host->sdio_irq_thread);
+	if (!--host->sdio_irqs)
+		destroy_workqueue(host->irq_workqueue);
+
+	return 0;
+}
+
+void sdio_enable_irq(struct mmc_host *host)
+{
+	if (host->sdio_irqs) {
+		if (host->caps & MMC_CAP_SDIO_IRQ)
+			host->ops->enable_sdio_irq(host, 1);
+		else {
+			queue_delayed_work(host->irq_workqueue,
+					   &host->irq_poll_work,
+					   host->irq_poll_period);
+		}
+	}
+}
+
+void sdio_disable_irq(struct mmc_host *host)
+{
+	if (host->sdio_irqs) {
+		if (host->caps & MMC_CAP_SDIO_IRQ)
+			host->ops->enable_sdio_irq(host, 0);
+		else
+			cancel_delayed_work(&host->irq_poll_work);
+	}
+}
+
+int sdio_kick_irq(struct mmc_host *host)
+{
+	if (!host->card)
+		return 0;
+
+	if (host->sdio_irqs && host->card->pending_irqs) {
+		queue_work(host->irq_workqueue, &host->irq_work);
+		return 1;
 	}
 
 	return 0;
 }
 
+static void sdio_irq_pending_done(struct mmc_request *mrq);
+
+/**
+ *	mmc_signal_sdio_irq - signal a SDIO IRQ
+ *	@host: SDIO host
+ *
+ *	This function should be called by the MMC host driver when
+ *	it has detected a SDIO IRQ.
+ */
+void mmc_signal_sdio_irq(struct mmc_host *host)
+{
+	/*
+	 * We claim the host here on drivers behalf and don't release
+	 * it until all interrupts are processed.
+	 */
+
+	if (!mmc_try_claim_host(host)) {
+		/* this should only happen if the MMC host
+		 * driver signals SDIO interrupts even if they
+		 * are disabled  */
+		pr_debug("%s: card already claimed\n", __func__);
+		return;
+	}
+
+	mmc_io_rw_direct_start(host->card, 0, 0, SDIO_CCCR_INTx, 0, 1,
+			       sdio_irq_pending_done, host);
+}
+EXPORT_SYMBOL_GPL(mmc_signal_sdio_irq);
+
+/* Called when the asynchronous operation has fetched the pending irqs */
+static void sdio_irq_pending_done(struct mmc_request *mrq)
+{
+	struct mmc_host *host = mrq->done_data;
+	int ret;
+
+	ret = mmc_io_rw_direct_result(host->card, &host->card->pending_irqs);
+	if (ret) {
+		pr_warning("%s: error %d reading SDIO_CCCR_INTx\n",
+			   mmc_card_id(host->card), ret);
+		host->card->pending_irqs = 0;
+		mmc_release_host(host);
+		return;
+	}
+
+	if (!(host->caps & MMC_CAP_SDIO_IRQ)) {
+		unsigned long idle_period = msecs_to_jiffies(100);
+
+		/*
+		 * Adaptive polling frequency based on the assumption
+		 * that an interrupt will be closely followed by more.
+		 * This has a substantial benefit for network devices.
+		 */
+		if (host->card->pending_irqs)
+			host->irq_poll_period /= 2;
+		else {
+			host->irq_poll_period++;
+			if (host->irq_poll_period > idle_period)
+				host->irq_poll_period = idle_period;
+		}
+	}
+
+	/* If pending_irqs is set this this will kick the SDIO irq
+	 * handling, otherwise we'll just release the host. */
+	mmc_release_host(host);
+}
+
 /**
  *	sdio_claim_irq - claim the IRQ for a SDIO function
  *	@func: SDIO function
Index: linux-2.6.26.2/include/linux/mmc/host.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/host.h
+++ linux-2.6.26.2/include/linux/mmc/host.h
@@ -128,8 +128,11 @@ struct mmc_host {
 	unsigned int		bus_refs;	/* reference counter */
 
 	unsigned int		sdio_irqs;
-	struct task_struct	*sdio_irq_thread;
-	atomic_t		sdio_irq_thread_abort;
+	struct workqueue_struct *irq_workqueue;
+	struct delayed_work     irq_poll_work;
+	unsigned long           irq_poll_period;
+	struct work_struct      irq_work;
+	struct work_struct      irq_sched_work;
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger	*led;		/* activity led */
@@ -159,12 +162,7 @@ extern int mmc_resume_host(struct mmc_ho
 
 extern void mmc_detect_change(struct mmc_host *, unsigned long delay);
 extern void mmc_request_done(struct mmc_host *, struct mmc_request *);
-
-static inline void mmc_signal_sdio_irq(struct mmc_host *host)
-{
-	host->ops->enable_sdio_irq(host, 0);
-	wake_up_process(host->sdio_irq_thread);
-}
+extern void mmc_signal_sdio_irq(struct mmc_host *host);
 
 #endif
 
Index: linux-2.6.26.2/drivers/mmc/core/core.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/core.c
+++ linux-2.6.26.2/drivers/mmc/core/core.c
@@ -34,6 +34,7 @@
 #include "mmc_ops.h"
 #include "sd_ops.h"
 #include "sdio_ops.h"
+#include "sdio_irq.h"
 
 static struct workqueue_struct *workqueue;
 
@@ -294,6 +295,30 @@ void mmc_set_data_timeout(struct mmc_dat
 EXPORT_SYMBOL(mmc_set_data_timeout);
 
 /**
+ *	mmc_try_claim_host - exclusively claim a host
+ *	@host: mmc host to claim
+ *
+ *	Claim a host for a set of operations.  Returns true with the
+ *	lock held if it acquired the lock or false if it failed.
+ */
+int mmc_try_claim_host(struct mmc_host *host)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (!host->claimed) {
+		host->claimed = 1;
+		sdio_disable_irq(host);
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(mmc_try_claim_host);
+
+/**
  *	__mmc_claim_host - exclusively claim a host
  *	@host: mmc host to claim
  *	@abort: whether or not the operation should be aborted
@@ -322,6 +347,7 @@ int __mmc_claim_host(struct mmc_host *ho
 		schedule();
 		spin_lock_irqsave(&host->lock, flags);
 	}
+	sdio_disable_irq(host);
 	set_current_state(TASK_RUNNING);
 	if (!stop)
 		host->claimed = 1;
@@ -347,7 +373,11 @@ void mmc_release_host(struct mmc_host *h
 
 	WARN_ON(!host->claimed);
 
+	if (sdio_kick_irq(host))
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
+	sdio_enable_irq(host);
 	host->claimed = 0;
 	spin_unlock_irqrestore(&host->lock, flags);
 
Index: linux-2.6.26.2/drivers/mmc/core/sdio_irq.h
===================================================================
--- /dev/null
+++ linux-2.6.26.2/drivers/mmc/core/sdio_irq.h
@@ -0,0 +1,17 @@
+/*
+ *  linux/drivers/mmc/core/sdio_irq.h
+ *
+ *  Copyright (C) 2008 CSR
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _MMC_CORE_SDIO_IRQ_H
+#define _MMC_CORE_SDIO_IRQ_H
+
+void sdio_enable_irq(struct mmc_host *host);
+void sdio_disable_irq(struct mmc_host *host);
+bool sdio_kick_irq(struct mmc_host *host);
+
+#endif
Index: linux-2.6.26.2/include/linux/mmc/card.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/card.h
+++ linux-2.6.26.2/include/linux/mmc/card.h
@@ -127,6 +127,8 @@ struct mmc_card {
 	int			incr_addr;	/* true if a block operation should increment the address */
 	u8			*buf;		/* the buffer for a block operation */
 	unsigned		size;		/* the size of a block operation */
+
+	unsigned char		pending_irqs;	/* pending SDIO interrupts */
 };
 
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)
Index: linux-2.6.26.2/include/linux/mmc/core.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/core.h
+++ linux-2.6.26.2/include/linux/mmc/core.h
@@ -137,6 +137,7 @@ extern int mmc_wait_for_app_cmd(struct m
 
 extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card *);
 
+extern int mmc_try_claim_host(struct mmc_host *host);
 extern int __mmc_claim_host(struct mmc_host *host, atomic_t *abort);
 extern void mmc_release_host(struct mmc_host *host);
 

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
