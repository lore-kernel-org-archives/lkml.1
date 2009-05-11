Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZEKLoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZEKLoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZEKLoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:44:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:49400 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZEKLoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t4Ro4p3+K3o5X1UCH76DfCAIMUOr6DBCrcCCQR7fa8Arj6mzkKXV4b9qv0Fy0+5j5E
         v2RHjj+7n0LdMdKq9q0bI0WseUGxRA/fObTcNj5FqVdXhWNPR3Yfjk0UVga7AaIcQD0N
         +0uawTjph6V9arfBAI1kTM6hApAwv/5YQbIXQ=
MIME-Version: 1.0
Date: Mon, 11 May 2009 20:44:00 +0900
Message-ID: <483a38b80905110444n7d55b967j70cf2639dff1c706@mail.gmail.com>
Subject: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt context
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d5de0d22109de7564f9bf1df688acbe6b18f41db Mon Sep 17 00:00:00 2001
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Date: Mon, 11 May 2009 20:05:50 +0900
Subject: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt context.

This patch enhances pointer movements much smoother.
The original patch is written by Thierry.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Kwangwoo Lee <kwangwoo.lee@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c
b/drivers/input/touchscreen/tsc2007.c
index 948e167..03bbe58 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -70,6 +70,7 @@ struct ts_event {
 struct tsc2007 {
 	struct input_dev	*input;
 	char			phys[32];
+	struct work_struct	work;
 	struct hrtimer		timer;
 	struct ts_event		tc;

@@ -173,6 +174,9 @@ static void tsc2007_send_event(void *tsc)

 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
 			x, y, rt);
+	} else {
+		if (!ts->pendown)
+			ts->pendown = 1;
 	}

 	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
@@ -197,6 +201,13 @@ static int tsc2007_read_values(struct tsc2007 *tsc)
 	return 0;
 }

+static void tsc2007_work(struct work_struct *work)
+{
+	struct tsc2007 *ts = container_of(work, struct tsc2007, work);
+	tsc2007_read_values(ts);
+	tsc2007_send_event(ts);
+}
+
 static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
 {
 	struct tsc2007 *ts = container_of(handle, struct tsc2007, timer);
@@ -218,9 +229,7 @@ static enum hrtimer_restart tsc2007_timer(struct
hrtimer *handle)
 	} else {
 		/* pen is still down, continue with the measurement */
 		dev_dbg(&ts->client->dev, "pen is still down\n");
-
-		tsc2007_read_values(ts);
-		tsc2007_send_event(ts);
+		schedule_work(&ts->work);
 	}

 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -253,7 +262,7 @@ static int tsc2007_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct tsc2007 *ts;
-	struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
+	struct tsc2007_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input_dev;
 	int err;

@@ -280,6 +289,7 @@ static int tsc2007_probe(struct i2c_client *client,

 	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function = tsc2007_timer;
+	INIT_WORK(&ts->work, tsc2007_work);

 	spin_lock_init(&ts->lock);

-- 
1.5.6.5
