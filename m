Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZFWLzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZFWLzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbZFWLyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:54:49 -0400
Received: from av9-2-sn2.hy.skanova.net ([81.228.8.180]:43473 "EHLO
	av9-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbZFWLyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:54:47 -0400
Message-ID: <4A40C288.2060702@mocean-labs.com>
Date: Tue, 23 Jun 2009 13:54:48 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] tsc2007: remove HR timer
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the HR timer, since it's bad to do synchronous I2C
in the HR timer callback context. The new implementation makes use
of the global workqueue. The work is scheduled every 5ms when polling
rather than 5 us.

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.30/drivers/input/touchscreen/tsc2007.c
===================================================================
--- linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 932)
+++ linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 943)
@@ -21,15 +21,13 @@
  */

 #include <linux/module.h>
-#include <linux/hrtimer.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>

-#define TS_POLL_DELAY	(10 * 1000)	/* ns delay before the first sample */
-#define TS_POLL_PERIOD	(5 * 1000)	/* ns delay between samples */
+#define TS_POLL_PERIOD	msecs_to_jiffies(5) /* ms delay between samples */

 #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
 #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -70,13 +68,11 @@
 struct tsc2007 {
 	struct input_dev	*input;
 	char			phys[32];
-	struct hrtimer		timer;
+	struct delayed_work	work;
 	struct ts_event		tc;

 	struct i2c_client	*client;

-	spinlock_t		lock;
-
 	u16			model;
 	u16			x_plate_ohms;

@@ -142,8 +138,7 @@
 	if (rt > MAX_12BIT) {
 		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);

-		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			      HRTIMER_MODE_REL);
+		schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 		return;
 	}

@@ -153,7 +148,7 @@
 	 * in some cases may not even settle at the expected value.
 	 *
 	 * The only safe way to check for the pen up condition is in the
-	 * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
+	 * work function by reading the pen signal state (it's a GPIO and IRQ).
 	 */
 	if (rt) {
 		struct input_dev *input = ts->input;
@@ -175,8 +170,7 @@
 			x, y, rt);
 	}

-	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			HRTIMER_MODE_REL);
+	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 }

 static int tsc2007_read_values(struct tsc2007 *tsc)
@@ -197,13 +191,10 @@
 	return 0;
 }

-static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
+static void tsc2007_work(struct work_struct *work)
 {
-	struct tsc2007 *ts = container_of(handle, struct tsc2007, timer);
-	unsigned long flags;
-
-	spin_lock_irqsave(&ts->lock, flags);
-
+	struct tsc2007 *ts =
+		container_of(to_delayed_work(work), struct tsc2007, work);
 	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
 		struct input_dev *input = ts->input;

@@ -222,30 +213,20 @@
 		tsc2007_read_values(ts);
 		tsc2007_send_event(ts);
 	}
-
-	spin_unlock_irqrestore(&ts->lock, flags);
-
-	return HRTIMER_NORESTART;
 }

 static irqreturn_t tsc2007_irq(int irq, void *handle)
 {
 	struct tsc2007 *ts = handle;
-	unsigned long flags;

-	spin_lock_irqsave(&ts->lock, flags);
-
 	if (likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
-		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
-					HRTIMER_MODE_REL);
+		schedule_delayed_work(&ts->work, 0);
 	}

 	if (ts->clear_penirq)
 		ts->clear_penirq();

-	spin_unlock_irqrestore(&ts->lock, flags);
-
 	return IRQ_HANDLED;
 }

@@ -278,11 +259,6 @@

 	ts->input = input_dev;

-	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	ts->timer.function = tsc2007_timer;
-
-	spin_lock_init(&ts->lock);
-
 	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
 	ts->get_pendown_state = pdata->get_pendown_state;
@@ -308,6 +284,8 @@

 	ts->irq = client->irq;

+	INIT_DELAYED_WORK(&ts->work, tsc2007_work);
+
 	err = request_irq(ts->irq, tsc2007_irq, 0,
 			client->dev.driver->name, ts);
 	if (err < 0) {
@@ -325,7 +303,6 @@

  err_free_irq:
 	free_irq(ts->irq, ts);
-	hrtimer_cancel(&ts->timer);
  err_free_mem:
 	input_free_device(input_dev);
 	kfree(ts);
@@ -337,11 +314,13 @@
 	struct tsc2007	*ts = i2c_get_clientdata(client);
 	struct tsc2007_platform_data *pdata;

+	/* cancel any work */
+	cancel_delayed_work(&ts->work);
+
 	pdata = client->dev.platform_data;
 	pdata->exit_platform_hw();

 	free_irq(ts->irq, ts);
-	hrtimer_cancel(&ts->timer);
 	input_unregister_device(ts->input);
 	kfree(ts);

