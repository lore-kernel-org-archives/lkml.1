Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXCIRcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXCIRcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXCIRcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:32:21 -0500
Received: from out-smtp.licor.com ([63.151.144.205]:2581 "HELO
	out-smtp.licor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752684AbXCIRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:32:20 -0500
Message-ID: <45F19A20.5010700@licor.com>
Date: Fri, 09 Mar 2007 11:32:16 -0600
From: Chris Lesiak <chris.lesiak@licor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi subsystem: destroy the spi_bitbang workqueue only
 after the spi master is unregistered
References: <45EEE34A.6070009@licor.com> <200703071031.39997.david-b@pacbell.net> <45EF4F32.2050601@licor.com> <200703082219.33296.david-b@pacbell.net>
In-Reply-To: <200703082219.33296.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Lesiak <chris.lesiak@licor.com>

This patch fixes a bug in the cleanup of an spi_bitbang bus.  The
workqueue associated with the bus was destroyed before the call to
spi_unregister_master.  That meant that spi devices on that bus would be
unable to do IO in their remove method.  The shutdown flag should have
been able to prevent a segfault, but was never getting set.  By waiting
to destroy the workqueue until after the master is unregistered, devices
are able to do IO in their remove methods.  An added benefit is that
neither the shutdown flag nor a wait for the queue of messages to empty
is needed.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>

---

diff -uprN -X linux-2.6.20-vanilla/Documentation/dontdiff linux-2.6.20-vanilla/drivers/spi/spi_bitbang.c linux-2.6.20/drivers/spi/spi_bitbang.c
--- linux-2.6.20-vanilla/drivers/spi/spi_bitbang.c	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.20/drivers/spi/spi_bitbang.c	2007-03-09 11:23:42.000000000 -0600
@@ -302,10 +302,6 @@ static void bitbang_work(struct work_str
 		setup_transfer = NULL;
 
 		list_for_each_entry (t, &m->transfers, transfer_list) {
-			if (bitbang->shutdown) {
-				status = -ESHUTDOWN;
-				break;
-			}
 
 			/* override or restore speed and wordsize */
 			if (t->speed_hz || t->bits_per_word) {
@@ -410,8 +406,6 @@ int spi_bitbang_transfer(struct spi_devi
 	m->status = -EINPROGRESS;
 
 	bitbang = spi_master_get_devdata(spi->master);
-	if (bitbang->shutdown)
-		return -ESHUTDOWN;
 
 	spin_lock_irqsave(&bitbang->lock, flags);
 	if (!spi->max_speed_hz)
@@ -506,28 +500,12 @@ EXPORT_SYMBOL_GPL(spi_bitbang_start);
  */
 int spi_bitbang_stop(struct spi_bitbang *bitbang)
 {
-	unsigned	limit = 500;
-
-	spin_lock_irq(&bitbang->lock);
-	bitbang->shutdown = 0;
-	while (!list_empty(&bitbang->queue) && limit--) {
-		spin_unlock_irq(&bitbang->lock);
+	spi_unregister_master(bitbang->master);
 
-		dev_dbg(bitbang->master->cdev.dev, "wait for queue\n");
-		msleep(10);
-
-		spin_lock_irq(&bitbang->lock);
-	}
-	spin_unlock_irq(&bitbang->lock);
-	if (!list_empty(&bitbang->queue)) {
-		dev_err(bitbang->master->cdev.dev, "queue didn't empty\n");
-		return -EBUSY;
-	}
+	WARN_ON(!list_empty(&bitbang->queue));
 
 	destroy_workqueue(bitbang->workqueue);
 
-	spi_unregister_master(bitbang->master);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_stop);
diff -uprN -X linux-2.6.20-vanilla/Documentation/dontdiff linux-2.6.20-vanilla/include/linux/spi/spi_bitbang.h linux-2.6.20/include/linux/spi/spi_bitbang.h
--- linux-2.6.20-vanilla/include/linux/spi/spi_bitbang.h	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.20/include/linux/spi/spi_bitbang.h	2007-03-09 11:23:42.000000000 -0600
@@ -25,7 +25,6 @@ struct spi_bitbang {
 	spinlock_t		lock;
 	struct list_head	queue;
 	u8			busy;
-	u8			shutdown;
 	u8			use_dma;
 
 	struct spi_master	*master;




