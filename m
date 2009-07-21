Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZGUK7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZGUK7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZGUK7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:59:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZGUK7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:59:36 -0400
Date: Tue, 21 Jul 2009 12:59:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090721105924.GK4133@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Do you have a link? (I replaced it with disable_irq_nosync, if that is
> > enough...)
> >
> 
> link: http://patchwork.kernel.org/patch/35515/

Thanks!

Here's my attempt at that conversion; unfortunately I'm stuck in
2.6.29 for msm stuff, so I was not even able to compile-test it :-(.
									Pavel

diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi.c b/drivers/input/touchscreen/synaptics_i2c_rmi.c
index 771b710..4816262 100644
--- a/drivers/input/touchscreen/synaptics_i2c_rmi.c
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi.c
@@ -13,6 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * http://www.synaptics.com/sites/default/files/511_000099_01F.pdf
  */
 
 #include <linux/module.h>
@@ -34,7 +35,6 @@ struct synaptics_ts_data {
 	u16 addr;
 	struct i2c_client *client;
 	struct input_dev *input_dev;
-	int use_irq;
 	struct hrtimer timer;
 	struct work_struct  work;
 	u16 max[2];
@@ -87,6 +87,22 @@ static int synaptics_init_panel(struct synaptics_ts_data *ts)
 
 static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
 {
+/* 
+ * This sensor sends two 6-byte absolute finger reports, an optional
+ * 2-byte relative report followed by a status byte. This function
+ * reads the two finger reports and transforms the coordinates
+ * according the platform data so they can be aligned with the lcd
+ * behind the touchscreen. Typically we flip the y-axis since the
+ * sensor uses the bottom left corner as the origin, but if the sensor
+ * is mounted upside down the platform data will request that the
+ * x-axis should be flipped instead. The snap to inactive edge border
+ * are used to allow tapping the edges of the screen on the G1. The
+ * active area of the touchscreen is smaller than the lcd. When the
+ * finger gets close the edge of the screen we snap it to the
+ * edge. This allows ui elements at the edge of the screen to be hit,
+ * and it prevents hitting ui elements that are not at the edge of the
+ * screen when the finger is touching the edge.
+ */
 	int pos[2][2];
 	int f, a;
 	int base = 2;
@@ -144,7 +160,7 @@ static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
 	input_sync(ts->input_dev);
 }
 
-static void synaptics_ts_work_func(struct work_struct *work)
+static void synaptics_ts_work(struct synaptics_ts_data *ts)
 {
 	int i;
 	int ret;
@@ -152,8 +168,6 @@ static void synaptics_ts_work_func(struct work_struct *work)
 	struct i2c_msg msg[2];
 	u8 start_reg = 0;
 	u8 buf[15];
-	struct synaptics_ts_data *ts =
-		container_of(work, struct synaptics_ts_data, work);
 
 	msg[0].addr = ts->client->addr;
 	msg[0].flags = 0;
@@ -164,7 +178,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
 	msg[1].len = sizeof(buf);
 	msg[1].buf = buf;
 
-	for (i = 0; i < ((ts->use_irq && !bad_data) ? 1 : 10); i++) {
+	for (i = 0; i < (!bad_data ? 1 : 10); i++) {
 		ret = i2c_transfer(ts->client->adapter, msg, 2);
 		if (ret < 0) {
 			pr_err("ts_work: i2c_transfer failed\n");
@@ -190,27 +204,20 @@ static void synaptics_ts_work_func(struct work_struct *work)
 
 		decode_report(ts, buf);
 	}
-	if (ts->use_irq)
-		enable_irq(ts->client->irq);
+	enable_irq(ts->client->irq);
 }
 
-static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
-{
-	struct synaptics_ts_data *ts =
-		container_of(timer, struct synaptics_ts_data, timer);
-
-	queue_work(synaptics_wq, &ts->work);
 
-	hrtimer_start(&ts->timer, ktime_set(0, 12500000), HRTIMER_MODE_REL);
-	return HRTIMER_NORESTART;
+static irqreturn_t synaptics_ts_hardirq(int irq, void *dev_id)
+{
+	disable_irq_nosync(irq);
+	return IRQ_WAKE_THREAD;
 }
 
 static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
 {
 	struct synaptics_ts_data *ts = dev_id;
-
-	disable_irq_nosync(ts->client->irq);
-	queue_work(synaptics_wq, &ts->work);
+	synaptics_ts_work(ts);
 	return IRQ_HANDLED;
 }
 
@@ -469,24 +476,21 @@ static int __devinit synaptics_ts_probe(
 		       ts->input_dev->name);
 		goto err_input_register_device_failed;
 	}
-	if (client->irq) {
-		ret = request_irq(client->irq, synaptics_ts_irq_handler,
-				  0, client->name, ts);
-		if (ret == 0) {
-			ret = i2c_set(ts, 0xf1, 0x01, "enable abs int");
-			if (ret)
-				free_irq(client->irq, ts);
-		}
-		if (ret == 0)
-			ts->use_irq = 1;
-		else
-			dev_err(&client->dev, "request_irq failed\n");
-	}
-	if (!ts->use_irq) {
-		hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		ts->timer.function = synaptics_ts_timer_func;
-		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+
+	ret = request_threaded_irq(client->irq,
+				   synatptics_ts_hardirq, synaptics_ts_irq_handler,
+				   0, client->name, ts);
+
+	if (ret)
+		pr_err("synaptics: could not register irq\n");
+
+
+	ret = i2c_set(ts, 0xf1, 0x01, "enable abs int");
+	if (ret) {
+		pr_err("synaptics: could not enable irq\n");
+		free_irq(client->irq, ts);
 	}
+
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	ts->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
 	ts->early_suspend.suspend = synaptics_ts_early_suspend;
@@ -495,7 +499,7 @@ static int __devinit synaptics_ts_probe(
 #endif
 
 	pr_info("synaptics: Start touchscreen %s in %s mode\n", 
-		ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
+		ts->input_dev->name, "interrupt");
 
 	return 0;
 
@@ -517,10 +521,7 @@ static int synaptics_ts_remove(struct i2c_client *client)
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	unregister_early_suspend(&ts->early_suspend);
 #endif
-	if (ts->use_irq)
-		free_irq(client->irq, ts);
-	else
-		hrtimer_cancel(&ts->timer);
+	free_irq(client->irq, ts);
 	input_unregister_device(ts->input_dev);
 	kfree(ts);
 	return 0;
@@ -532,12 +533,9 @@ static int synaptics_ts_suspend(struct i2c_client *client, pm_message_t mesg)
 	int ret;
 	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
 
-	if (ts->use_irq)
-		disable_irq(client->irq);
-	else
-		hrtimer_cancel(&ts->timer);
+	disable_irq(client->irq);
 	ret = cancel_work_sync(&ts->work);
-	if (ret && ts->use_irq) /* if work was pending disable-count is now 2 */
+	if (ret) /* if work was pending disable-count is now 2 */
 		enable_irq(client->irq);
 	i2c_set(ts, 0xf1, 0, "disable interrupt");
 	i2c_set(ts, 0xf0, 0x86, "deep sleep");
@@ -563,11 +561,8 @@ static int synaptics_ts_resume(struct i2c_client *client)
 
 	synaptics_init_panel(ts);
 
-	if (ts->use_irq) {
-		enable_irq(client->irq);
-		i2c_set(ts, 0xf1, 0x01, "enable abs int");
-	} else
-		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+	enable_irq(client->irq);
+	i2c_set(ts, 0xf1, 0x01, "enable abs int");
 
 	return 0;
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
