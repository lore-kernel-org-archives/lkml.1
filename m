Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZENKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZENKJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZENKJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:09:11 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:45053 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZENKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:09:10 -0400
Date: Thu, 14 May 2009 12:09:09 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Kwangwoo Lee <kwlee@mtekvision.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] TSC2007: private data for platform callbacks.
Message-ID: <20090514100909.GA23626@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a private data field to the tsc2007 platform data and pass this
to the callbacks.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/input/touchscreen/tsc2007.c |   52 +++++++++++++++++++++++-----------
 include/linux/i2c/tsc2007.h         |   10 ++++---
 2 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 948e167..5c4242d 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -83,10 +83,35 @@ struct tsc2007 {
 	unsigned		pendown;
 	int			irq;
 
-	int			(*get_pendown_state)(void);
-	void			(*clear_penirq)(void);
+	struct tsc2007_platform_data *pd;
 };
 
+/* ask platform for pendown state */
+static inline int ts_get_pendown_state(struct tsc2007 *ts)
+{
+	return ts->pd->get_pendown_state(ts->pd->priv);
+}
+
+/* ask platform to clear pendown irq if available */
+static inline void ts_clear_penirq(struct tsc2007 *ts)
+{
+	if (ts->pd->clear_penirq)
+		ts->pd->clear_penirq(ts->pd->priv);
+}
+
+static inline void ts_init_platform_hw(struct tsc2007 *ts)
+{
+	if (ts->pd->init_platform_hw)
+		ts->pd->init_platform_hw(ts->pd->priv);
+}
+
+static inline void ts_exit_platform_hw(struct tsc2007 *ts)
+{
+	if (ts->pd->exit_platform_hw)
+		ts->pd->exit_platform_hw(ts->pd->priv);
+}
+
+
 static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
 {
 	s32 data;
@@ -129,7 +154,7 @@ static void tsc2007_send_event(void *tsc)
 		rt = z2;
 		rt -= z1;
 		rt *= x;
-		rt *= ts->x_plate_ohms;
+		rt *= ts->pd->x_plate_ohms;
 		rt /= z1;
 		rt = (rt + 2047) >> 12;
 	} else
@@ -204,7 +229,7 @@ static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
 
 	spin_lock_irqsave(&ts->lock, flags);
 
-	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
+	if (unlikely(!ts_get_pendown_state(ts) && ts->pendown)) {
 		struct input_dev *input = ts->input;
 
 		dev_dbg(&ts->client->dev, "UP\n");
@@ -235,14 +260,13 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
 
 	spin_lock_irqsave(&ts->lock, flags);
 
-	if (likely(ts->get_pendown_state())) {
+	if (likely(ts_get_pendown_state(ts))) {
 		disable_irq_nosync(ts->irq);
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
 					HRTIMER_MODE_REL);
 	}
 
-	if (ts->clear_penirq)
-		ts->clear_penirq();
+	ts_clear_penirq(ts);
 
 	spin_unlock_irqrestore(&ts->lock, flags);
 
@@ -253,7 +277,7 @@ static int tsc2007_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct tsc2007 *ts;
-	struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
+	struct tsc2007_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input_dev;
 	int err;
 
@@ -283,12 +307,8 @@ static int tsc2007_probe(struct i2c_client *client,
 
 	spin_lock_init(&ts->lock);
 
-	ts->model             = pdata->model;
-	ts->x_plate_ohms      = pdata->x_plate_ohms;
-	ts->get_pendown_state = pdata->get_pendown_state;
-	ts->clear_penirq      = pdata->clear_penirq;
-
-	pdata->init_platform_hw();
+	ts->pd = pdata;
+	ts_init_platform_hw(ts);
 
 	snprintf(ts->phys, sizeof(ts->phys),
 		 "%s/input0", dev_name(&client->dev));
@@ -335,10 +355,8 @@ static int tsc2007_probe(struct i2c_client *client,
 static int tsc2007_remove(struct i2c_client *client)
 {
 	struct tsc2007	*ts = i2c_get_clientdata(client);
-	struct tsc2007_platform_data *pdata;
 
-	pdata = client->dev.platform_data;
-	pdata->exit_platform_hw();
+	ts_exit_platform_hw(ts);
 
 	free_irq(ts->irq, ts);
 	hrtimer_cancel(&ts->timer);
diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
index c6361fb..45582b3 100644
--- a/include/linux/i2c/tsc2007.h
+++ b/include/linux/i2c/tsc2007.h
@@ -7,11 +7,13 @@ struct tsc2007_platform_data {
 	u16	model;				/* 2007. */
 	u16	x_plate_ohms;
 
-	int	(*get_pendown_state)(void);
-	void	(*clear_penirq)(void);		/* If needed, clear 2nd level
+	int	(*get_pendown_state)(void *priv);
+	void	(*clear_penirq)(void *priv);	/* If needed, clear 2nd level
 						   interrupt source */
-	int	(*init_platform_hw)(void);
-	void	(*exit_platform_hw)(void);
+	int	(*init_platform_hw)(void *priv);
+	void	(*exit_platform_hw)(void *priv);
+
+	void	*priv;				/* passed to callbacks */
 };
 
 #endif
-- 
1.6.3

