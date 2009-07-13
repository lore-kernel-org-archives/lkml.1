Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZGMJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZGMJbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZGMJby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:31:54 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:43479 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZGMJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pDqY4TfP4xPIO43Getb4hDVl5JKvpbWMpMLSmV1dV8k6TSlBu+LRtitXwkXhH3NCg5
         tR8EGpkgneKJTbIkf3t+MLIGDurKAcrngPbN8vqgkppsszncO95IeU4EKHst+re/sooj
         /u9pDRpo1fJMSCgKpZX2gCdFmRhi72kKFRHtU=
Date: Mon, 13 Jul 2009 02:31:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kim Kyuwon <chammoru@gmail.com>, Kim Kyuwon <q1.kim@samsung.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com> <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com> <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com> <20090511031208.GA15208@dtor-d630.eng.vmware.com> <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com> <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
> Hi Dmitry,
> 
> 
> I don't see this driver picked up yet in your -next branch. We should
> target this driver to be mainlined in next merge window. This is very
> important driver for some of the embedded systems, including palm pre
> :)
> 

I was wondering if somebody could test the patch below and if it still
works then I will apply to the next branch. Thanks!

-- 
Dmitry


Input: max7359 - use threaded IRQs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Convert max7359 driver to use IRQ threading instead of using
workqueue.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/max7359_keypad.c |   34 +++++++++++++------------------
 1 files changed, 14 insertions(+), 20 deletions(-)


diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index e359db3..c823c0b 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -57,8 +57,6 @@ struct max7359_keypad {
 	/* matrix key code map */
 	unsigned short keycodes[MAX7359_MAX_KEY_NUM];
 
-	struct work_struct work;
-
 	struct input_dev *input_dev;
 	struct i2c_client *client;
 
@@ -103,10 +101,10 @@ static void max7359_build_keycode(struct max7359_keypad *keypad,
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
 }
 
-static void max7359_worker(struct work_struct *work)
+/* runs in an IRQ thread -- can (and will!) sleep */
+static irqreturn_t max7359_interrupt(int irq, void *dev_id)
 {
-	struct max7359_keypad *keypad =
-			container_of(work, struct max7359_keypad, work);
+	struct max7359_keypad *keypad = dev_id;
 	struct input_dev *input_dev = keypad->input_dev;
 	int val, row, col, release, code;
 
@@ -116,26 +114,23 @@ static void max7359_worker(struct work_struct *work)
 	release = val & 0x40;
 	code = (row << 3) + col;
 
+	dev_dbg(&keypad->client->dev,
+		"key[%d:%d] %s\n", row, col, release ? "release" : "press");
+
 	input_event(input_dev, EV_MSC, MSC_SCAN, code);
 	input_report_key(input_dev, keypad->keycodes[code], !release);
 	input_sync(input_dev);
 
 	enable_irq(keypad->irq);
-
-	dev_dbg(&keypad->client->dev, "key[%d:%d] %s\n", row, col,
-					(release ? "release" : "press"));
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t max7359_interrupt(int irq, void *dev_id)
+static irqreturn_t max7359_hardirq(int irq, void *dev_id)
 {
 	struct max7359_keypad *keypad = dev_id;
 
-	if (!work_pending(&keypad->work)) {
-		disable_irq_nosync(keypad->irq);
-		schedule_work(&keypad->work);
-	}
-
-	return IRQ_HANDLED;
+	disable_irq_nosync(keypad->irq);
+	return IRQ_WAKE_THREAD;
 }
 
 /*
@@ -223,7 +218,6 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	keypad->client = client;
 	keypad->input_dev = input_dev;
 	keypad->irq = client->irq;
-	INIT_WORK(&keypad->work, max7359_worker);
 
 	input_dev->name = client->name;
 	input_dev->id.bustype = BUS_I2C;
@@ -241,8 +235,9 @@ static int __devinit max7359_probe(struct i2c_client *client,
 
 	max7359_build_keycode(keypad, keymap_data);
 
-	error = request_irq(keypad->irq, max7359_interrupt,
-			    IRQF_TRIGGER_LOW, client->name, keypad);
+	error = request_threaded_irq(keypad->irq,
+				     max7359_hardirq, max7359_interrupt,
+				     IRQF_TRIGGER_LOW, client->name, keypad);
 	if (error) {
 		dev_err(&client->dev, "failed to register interrupt\n");
 		goto failed_free_mem;
@@ -275,9 +270,8 @@ static int __devexit max7359_remove(struct i2c_client *client)
 {
 	struct max7359_keypad *keypad = i2c_get_clientdata(client);
 
-	cancel_work_sync(&keypad->work);
-	input_unregister_device(keypad->input_dev);
 	free_irq(keypad->irq, keypad);
+	input_unregister_device(keypad->input_dev);
 	i2c_set_clientdata(client, NULL);
 	kfree(keypad);
 
