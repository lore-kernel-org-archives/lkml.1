Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCHCjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCHCjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 21:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZCHCiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 21:38:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:48205 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZCHCiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 21:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ir/DCeO+v/HkUxpuTT50OVO/IBC3E4blye+CHXx08XVhKfPlJiEOirVr7GLVg9n97s
         j4s2dXmKvP6Mt8PdgBRq7AADewDqebJVrM4w7kyCM6M27KCn7TiGwunayvk4dTrhpMwl
         nU1Z4bshogWLJM1FRfk83KpeTcRzOvvTsZlMM=
Date: Sat, 7 Mar 2009 18:38:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-ID: <20090308023836.GA22645@dtor-d630.eng.vmware.com>
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi felipe,

On Thu, Feb 19, 2009 at 02:31:17PM +0200, Felipe Balbi wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> lm8323 is the keypad driver used in n810 device. This
> driver has been sitting in linux-omap for quite a long
> time, it's about time to get comments from upstream and
> get it merged.
> 

Thank you ofr the patch. I did not quite like the hard-coding of 3 PWMs,
I think an array works better and also you enable IRQ before allocating
input device, which is not safe. Also probe() leaks input device
structure in certain scenarios. I have a fixup patch and would
appreciate if you coould try it.

Thanks!

-- 
Dmitry


Input: lm8323 fixups

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/lm8323.c |  236 ++++++++++++++++-----------------------
 include/linux/i2c/lm8323.h      |   10 +-
 2 files changed, 100 insertions(+), 146 deletions(-)


diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index a796680..9f4ef51 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -137,6 +137,7 @@ struct lm8323_pwm {
 	struct mutex		lock;
 	struct work_struct	work;
 	struct led_classdev	cdev;
+	struct lm8323_chip	*chip;
 };
 
 struct lm8323_chip {
@@ -154,9 +155,7 @@ struct lm8323_chip {
 	int			size_y;
 	int			debounce_time;
 	int			active_time;
-	struct lm8323_pwm	pwm1;
-	struct lm8323_pwm	pwm2;
-	struct lm8323_pwm	pwm3;
+	struct lm8323_pwm	pwm[LM8323_NUM_PWMS];
 };
 
 #define client_to_lm8323(c)	container_of(c, struct lm8323_chip, client)
@@ -165,20 +164,6 @@ struct lm8323_chip {
 #define cdev_to_pwm(c)		container_of(c, struct lm8323_pwm, cdev)
 #define work_to_pwm(w)		container_of(w, struct lm8323_pwm, work)
 
-static struct lm8323_chip *pwm_to_lm8323(struct lm8323_pwm *pwm)
-{
-	switch (pwm->id) {
-	case 1:
-		return container_of(pwm, struct lm8323_chip, pwm1);
-	case 2:
-		return container_of(pwm, struct lm8323_chip, pwm2);
-	case 3:
-		return container_of(pwm, struct lm8323_chip, pwm3);
-	default:
-		return NULL;
-	}
-}
-
 #define LM8323_MAX_DATA 8
 
 /*
@@ -395,6 +380,7 @@ static void lm8323_work(struct work_struct *work)
 {
 	struct lm8323_chip *lm = work_to_lm8323(work);
 	u8 ints;
+	int i;
 
 	mutex_lock(&lm->lock);
 
@@ -414,17 +400,12 @@ static void lm8323_work(struct work_struct *work)
 						  "reinitialising\n");
 			lm8323_configure(lm);
 		}
-		if (ints & INT_PWM1) {
-			dev_vdbg(&lm->client->dev, "pwm1 engine completed\n");
-			pwm_done(&lm->pwm1);
-		}
-		if (ints & INT_PWM2) {
-			dev_vdbg(&lm->client->dev, "pwm2 engine completed\n");
-			pwm_done(&lm->pwm2);
-		}
-		if (ints & INT_PWM3) {
-			dev_vdbg(&lm->client->dev, "pwm3 engine completed\n");
-			pwm_done(&lm->pwm3);
+		for (i = 0; i < LM8323_NUM_PWMS; i++) {
+			if (ints & (1 << (INT_PWM1 + i))) {
+				dev_vdbg(&lm->client->dev,
+					 "pwm%d engine completed\n", i);
+				pwm_done(&lm->pwm[i]);
+			}
 		}
 	}
 
@@ -459,9 +440,7 @@ static int lm8323_read_id(struct lm8323_chip *lm, u8 *buf)
 
 static void lm8323_write_pwm_one(struct lm8323_pwm *pwm, int pos, u16 cmd)
 {
-	struct lm8323_chip *lm = pwm_to_lm8323(pwm);
-
-	lm8323_write(lm, 4, LM8323_CMD_PWM_WRITE, (pos << 2) | pwm->id,
+	lm8323_write(pwm->chip, 4, LM8323_CMD_PWM_WRITE, (pos << 2) | pwm->id,
 		     (cmd & 0xff00) >> 8, cmd & 0x00ff);
 }
 
@@ -474,14 +453,13 @@ static void lm8323_write_pwm_one(struct lm8323_pwm *pwm, int pos, u16 cmd)
 static void lm8323_write_pwm(struct lm8323_pwm *pwm, int kill,
 			     int len, const u16 *cmds)
 {
-	struct lm8323_chip *lm = pwm_to_lm8323(pwm);
 	int i;
 
 	for (i = 0; i < len; i++)
 		lm8323_write_pwm_one(pwm, i, cmds[i]);
 
 	lm8323_write_pwm_one(pwm, i++, PWM_END(kill));
-	lm8323_write(lm, 2, LM8323_CMD_START_PWM, pwm->id);
+	lm8323_write(pwm->chip, 2, LM8323_CMD_START_PWM, pwm->id);
 	pwm->running = 1;
 }
 
@@ -546,7 +524,7 @@ static void lm8323_pwm_set_brightness(struct led_classdev *led_cdev,
 				      enum led_brightness brightness)
 {
 	struct lm8323_pwm *pwm = cdev_to_pwm(led_cdev);
-	struct lm8323_chip *lm = pwm_to_lm8323(pwm);
+	struct lm8323_chip *lm = pwm->chip;
 
 	mutex_lock(&pwm->lock);
 	pwm->desired_brightness = brightness;
@@ -582,7 +560,7 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm8323_pwm *pwm = cdev_to_pwm(led_cdev);
 	int ret;
-	int time;
+	unsigned long time;
 
 	ret = strict_strtoul(buf, 10, &time);
 	/* Numbers only, please. */
@@ -598,28 +576,22 @@ static DEVICE_ATTR(time, 0644, lm8323_pwm_show_time, lm8323_pwm_store_time);
 static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
 		    const char *name)
 {
-	struct lm8323_pwm *pwm = NULL;
+	struct lm8323_pwm *pwm;
 
 	BUG_ON(id > 3);
 
-	switch (id) {
-	case 1:
-		pwm = &lm->pwm1;
-		break;
-	case 2:
-		pwm = &lm->pwm2;
-		break;
-	case 3:
-		pwm = &lm->pwm3;
-		break;
-	}
+	pwm = &lm->pwm[id - 1];
 
 	pwm->id = id;
 	pwm->fade_time = 0;
 	pwm->brightness = 0;
 	pwm->desired_brightness = 0;
 	pwm->running = 0;
+	pwm->enabled = 0;
+	INIT_WORK(&pwm->work, lm8323_pwm_work);
 	mutex_init(&pwm->lock);
+	pwm->chip = lm;
+
 	if (name) {
 		pwm->cdev.name = name;
 		pwm->cdev.brightness_set = lm8323_pwm_set_brightness;
@@ -628,15 +600,12 @@ static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
 			return -1;
 		}
 		if (device_create_file(pwm->cdev.dev,
-					     &dev_attr_time) < 0) {
+					&dev_attr_time) < 0) {
 			dev_err(dev, "couldn't register time attribute\n");
 			led_classdev_unregister(&pwm->cdev);
 			return -1;
 		}
-		INIT_WORK(&pwm->work, lm8323_pwm_work);
 		pwm->enabled = 1;
-	} else {
-		pwm->enabled = 0;
 	}
 
 	return 0;
@@ -658,7 +627,7 @@ static ssize_t lm8323_set_disable(struct device *dev,
 {
 	struct lm8323_chip *lm = dev_get_drvdata(dev);
 	int ret;
-	int i;
+	unsigned long i;
 
 	ret = strict_strtoul(buf, 10, &i);
 
@@ -671,46 +640,50 @@ static ssize_t lm8323_set_disable(struct device *dev,
 static DEVICE_ATTR(disable_kp, 0644, lm8323_show_disable, lm8323_set_disable);
 
 static int lm8323_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
-	struct lm8323_platform_data *pdata;
+	struct lm8323_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *idev;
 	struct lm8323_chip *lm;
-	int i, err = 0;
+	int i, err;
 	unsigned long tmo;
 	u8 data[2];
 
-	lm = kzalloc(sizeof *lm, GFP_KERNEL);
-	if (!lm)
-		return -ENOMEM;
-
-	i2c_set_clientdata(client, lm);
-	lm->client = client;
-	pdata = client->dev.platform_data;
 	if (!pdata || !pdata->size_x || !pdata->size_y) {
 		dev_err(&client->dev, "missing platform_data\n");
-		err = -EINVAL;
-		goto fail2;
+		return -EINVAL;
 	}
 
-	lm->size_x = pdata->size_x;
-	if (lm->size_x > 8) {
+	if (pdata->size_x > 8) {
 		dev_err(&client->dev, "invalid x size %d specified\n",
-				lm->size_x);
-		err = -EINVAL;
-		goto fail2;
+			pdata->size_x);
+		return -EINVAL;
 	}
 
-	lm->size_y = pdata->size_y;
-	if (lm->size_y > 12) {
+	if (pdata->size_y > 12) {
 		dev_err(&client->dev, "invalid y size %d specified\n",
-				lm->size_y);
-		err = -EINVAL;
-		goto fail2;
+			pdata->size_y);
+		return -EINVAL;
 	}
 
+	lm = kzalloc(sizeof *lm, GFP_KERNEL);
+	idev = input_allocate_device();
+	if (!lm || !idev) {
+		err = -ENOMEM;
+		goto fail1;
+	}
+
+	i2c_set_clientdata(client, lm);
+
+	lm->client = client;
+	lm->idev = idev;
+	mutex_init(&lm->lock);
+	INIT_WORK(&lm->work, lm8323_work);
+
+	lm->size_x = pdata->size_x;
+	lm->size_y = pdata->size_y;
 	dev_vdbg(&client->dev, "Keypad size: %d x %d\n",
-			lm->size_x, lm->size_y);
+		 lm->size_x, lm->size_y);
 
 	lm->debounce_time = pdata->debounce_time;
 	lm->active_time = pdata->active_time;
@@ -726,61 +699,38 @@ static int lm8323_probe(struct i2c_client *client,
 
 		if (time_after(jiffies, tmo)) {
 			dev_err(&client->dev,
-					"timeout waiting for initialisation\n");
+				"timeout waiting for initialisation\n");
 			break;
 		}
 
 		msleep(1);
 	}
+
 	lm8323_configure(lm);
 
 	/* If a true probe check the device */
 	if (lm8323_read_id(lm, data) != 0) {
 		dev_err(&client->dev, "device not found\n");
 		err = -ENODEV;
-		goto fail2;
+		goto fail1;
 	}
 
-	if (init_pwm(lm, 1, &client->dev, pdata->pwm1_name) < 0)
-		goto fail3;
-	if (init_pwm(lm, 2, &client->dev, pdata->pwm2_name) < 0)
-		goto fail4;
-	if (init_pwm(lm, 3, &client->dev, pdata->pwm3_name) < 0)
-		goto fail5;
-
-	mutex_init(&lm->lock);
-	INIT_WORK(&lm->work, lm8323_work);
-
-	err = request_irq(client->irq, lm8323_irq,
-			  IRQF_TRIGGER_FALLING | IRQF_DISABLED,
-			  "lm8323", lm);
-	if (err) {
-		dev_err(&client->dev, "could not get IRQ %d\n", client->irq);
-		goto fail6;
+	for (i = 0; i < LM8323_NUM_PWMS; i++) {
+		err = init_pwm(lm, i + 1, &client->dev, pdata->pwm_names[i]);
+		if (err < 0)
+			goto fail2;
 	}
 
-	device_init_wakeup(&client->dev, 1);
-	enable_irq_wake(client->irq);
-
 	lm->kp_enabled = 1;
 	err = device_create_file(&client->dev, &dev_attr_disable_kp);
 	if (err < 0)
-		goto fail7;
-
-	idev = input_allocate_device();
-	if (!idev) {
-		err = -ENOMEM;
-		goto fail8;
-	}
+		goto fail2;
 
-	if (pdata->name)
-		idev->name = pdata->name;
-	else
-		idev->name = "LM8323 keypad";
-	snprintf(lm->phys, sizeof(lm->phys), "%s/input-kp", client->dev.bus_id);
+	idev->name = pdata->name ? : "LM8323 keypad";
+	snprintf(lm->phys, sizeof(lm->phys),
+		 "%s/input-kp", dev_name(&client->dev));
 	idev->phys = lm->phys;
 
-	lm->keys_down = 0;
 	idev->evbit[0] = BIT(EV_KEY);
 	for (i = 0; i < LM8323_KEYMAP_SIZE; i++) {
 		if (pdata->keymap[i] > 0)
@@ -792,30 +742,36 @@ static int lm8323_probe(struct i2c_client *client,
 	if (pdata->repeat)
 		__set_bit(EV_REP, idev->evbit);
 
-	lm->idev = idev;
 	err = input_register_device(idev);
 	if (err) {
 		dev_dbg(&client->dev, "error registering input device\n");
-		goto fail8;
+		goto fail3;
 	}
 
+	err = request_irq(client->irq, lm8323_irq,
+			  IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			  "lm8323", lm);
+	if (err) {
+		dev_err(&client->dev, "could not get IRQ %d\n", client->irq);
+		goto fail4;
+	}
+
+	device_init_wakeup(&client->dev, 1);
+	enable_irq_wake(client->irq);
+
 	return 0;
 
-fail8:
-	device_remove_file(&client->dev, &dev_attr_disable_kp);
-fail7:
-	free_irq(client->irq, lm);
-fail6:
-	if (lm->pwm3.enabled)
-		led_classdev_unregister(&lm->pwm3.cdev);
-fail5:
-	if (lm->pwm2.enabled)
-		led_classdev_unregister(&lm->pwm2.cdev);
 fail4:
-	if (lm->pwm1.enabled)
-		led_classdev_unregister(&lm->pwm1.cdev);
+	input_unregister_device(idev);
+	idev = NULL;
 fail3:
+	device_remove_file(&client->dev, &dev_attr_disable_kp);
 fail2:
+	while (--i >= 0)
+		if (lm->pwm[i].enabled)
+			led_classdev_unregister(&lm->pwm[i].cdev);
+fail1:
+	input_free_device(idev);
 	kfree(lm);
 	return err;
 }
@@ -823,18 +779,20 @@ fail2:
 static int lm8323_remove(struct i2c_client *client)
 {
 	struct lm8323_chip *lm = i2c_get_clientdata(client);
+	int i;
 
 	disable_irq_wake(client->irq);
 	free_irq(client->irq, lm);
 	cancel_work_sync(&lm->work);
+
 	input_unregister_device(lm->idev);
+
 	device_remove_file(&lm->client->dev, &dev_attr_disable_kp);
-	if (lm->pwm3.enabled)
-		led_classdev_unregister(&lm->pwm3.cdev);
-	if (lm->pwm2.enabled)
-		led_classdev_unregister(&lm->pwm2.cdev);
-	if (lm->pwm1.enabled)
-		led_classdev_unregister(&lm->pwm1.cdev);
+
+	for (i = 0; i < 3; i++)
+		if (lm->pwm[i].enabled)
+			led_classdev_unregister(&lm->pwm[i].cdev);
+
 	kfree(lm);
 
 	return 0;
@@ -848,6 +806,7 @@ static int lm8323_remove(struct i2c_client *client)
 static int lm8323_suspend(struct i2c_client *client, pm_message_t mesg)
 {
 	struct lm8323_chip *lm = i2c_get_clientdata(client);
+	int i;
 
 	set_irq_wake(client->irq, 0);
 	disable_irq(client->irq);
@@ -856,12 +815,9 @@ static int lm8323_suspend(struct i2c_client *client, pm_message_t mesg)
 	lm->pm_suspend = 1;
 	mutex_unlock(&lm->lock);
 
-	if (lm->pwm1.enabled)
-		led_classdev_suspend(&lm->pwm1.cdev);
-	if (lm->pwm2.enabled)
-		led_classdev_suspend(&lm->pwm2.cdev);
-	if (lm->pwm3.enabled)
-		led_classdev_suspend(&lm->pwm3.cdev);
+	for (i = 0; i < 3; i++)
+		if (lm->pwm[i].enabled)
+			led_classdev_suspend(&lm->pwm[i].cdev);
 
 	return 0;
 }
@@ -869,17 +825,15 @@ static int lm8323_suspend(struct i2c_client *client, pm_message_t mesg)
 static int lm8323_resume(struct i2c_client *client)
 {
 	struct lm8323_chip *lm = i2c_get_clientdata(client);
+	int i;
 
 	mutex_lock(&lm->lock);
 	lm->pm_suspend = 0;
 	mutex_unlock(&lm->lock);
 
-	if (lm->pwm1.enabled)
-		led_classdev_resume(&lm->pwm1.cdev);
-	if (lm->pwm2.enabled)
-		led_classdev_resume(&lm->pwm2.cdev);
-	if (lm->pwm3.enabled)
-		led_classdev_resume(&lm->pwm3.cdev);
+	for (i = 0; i < 3; i++)
+		if (lm->pwm[i].enabled)
+			led_classdev_resume(&lm->pwm[i].cdev);
 
 	enable_irq(client->irq);
 	set_irq_wake(client->irq, 1);
diff --git a/include/linux/i2c/lm8323.h b/include/linux/i2c/lm8323.h
index 67e82bc..50fad47 100644
--- a/include/linux/i2c/lm8323.h
+++ b/include/linux/i2c/lm8323.h
@@ -25,7 +25,9 @@
  * so keys can be mapped directly at the index of the
  * LM8323 keycode instead of subtracting one.
  */
-#define LM8323_KEYMAP_SIZE (0x7f + 1)
+#define LM8323_KEYMAP_SIZE	(0x7f + 1)
+
+#define LM8323_NUM_PWMS		3
 
 struct lm8323_platform_data {
 	int debounce_time; /* Time to watch for key bouncing, in ms. */
@@ -36,11 +38,9 @@ struct lm8323_platform_data {
 	int repeat:1;
 	const s16 *keymap;
 
-	char *pwm1_name; /* Device name for PWM1. */
-	char *pwm2_name; /* Device name for PWM2. */
-	char *pwm3_name; /* Device name for PWM3. */
+	const char *pwm_names[LM8323_NUM_PWMS];
 
-	char *name; /* Device name. */
+	const char *name; /* Device name. */
 };
 
 #endif /* __LINUX_LM8323_H */
