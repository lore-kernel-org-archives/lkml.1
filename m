Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZGNE7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZGNE7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZGNE7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:59:35 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:45793 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZGNE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rdoAhGrrMdkODjvoIJCIiK42Whz2hjtma/cQt8hkLg9sIfeHa/3lLcTQvLl+SHUSIx
         ux5q7GINgoJu7O7KCRNNbG1Mt9Gdxxg4aAxnOISsnOcdA3Jf9nNfMTHOE3ocvF4kpoVw
         +DBSo/YXsDIA9RcLJZOJWfpZKetk0jP09APJQ=
Date: Mon, 13 Jul 2009 21:59:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
Message-ID: <20090714044957.GD2822@dtor-d630.eng.vmware.com>
References: <4A40C288.2060702@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A40C288.2060702@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, Jun 23, 2009 at 01:54:48PM +0200, Richard Röjfors wrote:
> This patch removes the HR timer, since it's bad to do synchronous I2C
> in the HR timer callback context. The new implementation makes use
> of the global workqueue. The work is scheduled every 5ms when polling
> rather than 5 us.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.30/drivers/input/touchscreen/tsc2007.c
> ===================================================================
> --- linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 932)
> +++ linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 943)
> @@ -21,15 +21,13 @@
>   */
> 
>  #include <linux/module.h>
> -#include <linux/hrtimer.h>
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/interrupt.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c/tsc2007.h>
> 
> -#define TS_POLL_DELAY	(10 * 1000)	/* ns delay before the first sample */
> -#define TS_POLL_PERIOD	(5 * 1000)	/* ns delay between samples */
> +#define TS_POLL_PERIOD	msecs_to_jiffies(5) /* ms delay between samples */
> 
>  #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
>  #define TSC2007_MEASURE_AUX		(0x2 << 4)
> @@ -70,13 +68,11 @@
>  struct tsc2007 {
>  	struct input_dev	*input;
>  	char			phys[32];
> -	struct hrtimer		timer;
> +	struct delayed_work	work;
>  	struct ts_event		tc;
> 
>  	struct i2c_client	*client;
> 
> -	spinlock_t		lock;
> -
>  	u16			model;
>  	u16			x_plate_ohms;
> 
> @@ -142,8 +138,7 @@
>  	if (rt > MAX_12BIT) {
>  		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
> 
> -		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
> -			      HRTIMER_MODE_REL);
> +		schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
>  		return;
>  	}
> 
> @@ -153,7 +148,7 @@
>  	 * in some cases may not even settle at the expected value.
>  	 *
>  	 * The only safe way to check for the pen up condition is in the
> -	 * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
> +	 * work function by reading the pen signal state (it's a GPIO and IRQ).
>  	 */
>  	if (rt) {
>  		struct input_dev *input = ts->input;
> @@ -175,8 +170,7 @@
>  			x, y, rt);
>  	}
> 
> -	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
> -			HRTIMER_MODE_REL);
> +	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
>  }
> 
>  static int tsc2007_read_values(struct tsc2007 *tsc)
> @@ -197,13 +191,10 @@
>  	return 0;
>  }
> 
> -static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
> +static void tsc2007_work(struct work_struct *work)
>  {
> -	struct tsc2007 *ts = container_of(handle, struct tsc2007, timer);
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&ts->lock, flags);
> -
> +	struct tsc2007 *ts =
> +		container_of(to_delayed_work(work), struct tsc2007, work);
>  	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
>  		struct input_dev *input = ts->input;
> 
> @@ -222,30 +213,20 @@
>  		tsc2007_read_values(ts);
>  		tsc2007_send_event(ts);
>  	}
> -
> -	spin_unlock_irqrestore(&ts->lock, flags);
> -
> -	return HRTIMER_NORESTART;
>  }
> 
>  static irqreturn_t tsc2007_irq(int irq, void *handle)
>  {
>  	struct tsc2007 *ts = handle;
> -	unsigned long flags;
> 
> -	spin_lock_irqsave(&ts->lock, flags);
> -
>  	if (likely(ts->get_pendown_state())) {
>  		disable_irq_nosync(ts->irq);
> -		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
> -					HRTIMER_MODE_REL);
> +		schedule_delayed_work(&ts->work, 0);

Originally we scheduled reading with timy delay to let the device
settle, why don't we schedule with 1ms delay?

>  	}
> 
>  	if (ts->clear_penirq)
>  		ts->clear_penirq();
> 
> -	spin_unlock_irqrestore(&ts->lock, flags);
> -
>  	return IRQ_HANDLED;
>  }
> 
> @@ -278,11 +259,6 @@
> 
>  	ts->input = input_dev;
> 
> -	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	ts->timer.function = tsc2007_timer;
> -
> -	spin_lock_init(&ts->lock);
> -
>  	ts->model             = pdata->model;
>  	ts->x_plate_ohms      = pdata->x_plate_ohms;
>  	ts->get_pendown_state = pdata->get_pendown_state;
> @@ -308,6 +284,8 @@
> 
>  	ts->irq = client->irq;
> 
> +	INIT_DELAYED_WORK(&ts->work, tsc2007_work);
> +
>  	err = request_irq(ts->irq, tsc2007_irq, 0,
>  			client->dev.driver->name, ts);
>  	if (err < 0) {
> @@ -325,7 +303,6 @@
> 
>   err_free_irq:
>  	free_irq(ts->irq, ts);
> -	hrtimer_cancel(&ts->timer);

Why don't we cancel work here?

>   err_free_mem:
>  	input_free_device(input_dev);
>  	kfree(ts);
> @@ -337,11 +314,13 @@
>  	struct tsc2007	*ts = i2c_get_clientdata(client);
>  	struct tsc2007_platform_data *pdata;
> 
> +	/* cancel any work */
> +	cancel_delayed_work(&ts->work);
> +
>  	pdata = client->dev.platform_data;
>  	pdata->exit_platform_hw();
> 

So what happens if IRQ is raised here and work is scheduled again?

>  	free_irq(ts->irq, ts);
> -	hrtimer_cancel(&ts->timer);
>  	input_unregister_device(ts->input);
>  	kfree(ts);
> 

Could you please try the patch below and see if the touchscreen still
works for you? It should be applied on top of your patch.

Thanks!

-- 
Dmitry

Input: tsc2007 - properly shut off interrupts/delayed work

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Properly shut off interrupts/delayed work by free-ing IRQ first
and then ensuring that enable/disable is balanced. Also add
__devinit/__devexit markings, restore poll delay/period scheduling
logic, make sure we call exit_platform_hw() method when probe
fails.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/tsc2007.c |   76 ++++++++++++++++++++++-------------
 1 files changed, 48 insertions(+), 28 deletions(-)


diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index b512697..3c71e85 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -27,7 +27,8 @@
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>
 
-#define TS_POLL_PERIOD	msecs_to_jiffies(1) /* ms delay between samples */
+#define TS_POLL_DELAY			1 /* ms delay between samples */
+#define TS_POLL_PERIOD			1 /* ms delay between samples */
 
 #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
 #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -76,7 +77,7 @@ struct tsc2007 {
 	u16			model;
 	u16			x_plate_ohms;
 
-	unsigned		pendown;
+	bool			pendown;
 	int			irq;
 
 	int			(*get_pendown_state)(void);
@@ -131,18 +132,18 @@ static void tsc2007_send_event(void *tsc)
 	} else
 		rt = 0;
 
-	/* Sample found inconsistent by debouncing or pressure is beyond
+	/*
+	 * Sample found inconsistent by debouncing or pressure is beyond
 	 * the maximum. Don't report it to user space, repeat at least
 	 * once more the measurement
 	 */
 	if (rt > MAX_12BIT) {
 		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
-
-		schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 		return;
 	}
 
-	/* NOTE: We can't rely on the pressure to determine the pen down
+	/*
+	 * NOTE: We can't rely on the pressure to determine the pen down
 	 * state, even this controller has a pressure sensor.  The pressure
 	 * value can fluctuate for quite a while after lifting the pen and
 	 * in some cases may not even settle at the expected value.
@@ -157,7 +158,7 @@ static void tsc2007_send_event(void *tsc)
 			dev_dbg(&ts->client->dev, "DOWN\n");
 
 			input_report_key(input, BTN_TOUCH, 1);
-			ts->pendown = 1;
+			ts->pendown = true;
 		}
 
 		input_report_abs(input, ABS_X, x);
@@ -169,8 +170,6 @@ static void tsc2007_send_event(void *tsc)
 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
 			x, y, rt);
 	}
-
-	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 }
 
 static int tsc2007_read_values(struct tsc2007 *tsc)
@@ -195,6 +194,7 @@ static void tsc2007_work(struct work_struct *work)
 {
 	struct tsc2007 *ts =
 		container_of(to_delayed_work(work), struct tsc2007, work);
+
 	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
 		struct input_dev *input = ts->input;
 
@@ -204,7 +204,7 @@ static void tsc2007_work(struct work_struct *work)
 		input_report_abs(input, ABS_PRESSURE, 0);
 		input_sync(input);
 
-		ts->pendown = 0;
+		ts->pendown = false;
 		enable_irq(ts->irq);
 	} else {
 		/* pen is still down, continue with the measurement */
@@ -212,6 +212,9 @@ static void tsc2007_work(struct work_struct *work)
 
 		tsc2007_read_values(ts);
 		tsc2007_send_event(ts);
+
+		schedule_delayed_work(&ts->work,
+				      msecs_to_jiffies(TS_POLL_PERIOD));
 	}
 }
 
@@ -221,7 +224,8 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
 
 	if (likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
-		schedule_delayed_work(&ts->work, 0);
+		schedule_delayed_work(&ts->work,
+				      msecs_to_jiffies(TS_POLL_DELAY));
 	}
 
 	if (ts->clear_penirq)
@@ -230,8 +234,21 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
 	return IRQ_HANDLED;
 }
 
-static int tsc2007_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static void tsc2007_free_irq(struct tsc2007 *ts)
+{
+	free_irq(ts->irq, ts);
+	if (cancel_delayed_work_sync(&ts->work)) {
+		/*
+		 * Work was pending, therefore we need to enable
+		 * IRQ here to balance the disable_irq() done in the
+		 * interrupt handler.
+		 */
+		enable_irq(ts->irq);
+	}
+}
+
+static int __devinit tsc2007_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
 {
 	struct tsc2007 *ts;
 	struct tsc2007_platform_data *pdata = pdata = client->dev.platform_data;
@@ -255,17 +272,15 @@ static int tsc2007_probe(struct i2c_client *client,
 	}
 
 	ts->client = client;
-	i2c_set_clientdata(client, ts);
-
+	ts->irq = client->irq;
 	ts->input = input_dev;
+	INIT_DELAYED_WORK(&ts->work, tsc2007_work);
 
 	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
 	ts->get_pendown_state = pdata->get_pendown_state;
 	ts->clear_penirq      = pdata->clear_penirq;
 
-	pdata->init_platform_hw();
-
 	snprintf(ts->phys, sizeof(ts->phys),
 		 "%s/input0", dev_name(&client->dev));
 
@@ -280,12 +295,9 @@ static int tsc2007_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
 
+	pdata->init_platform_hw();
 	tsc2007_read_values(ts);
 
-	ts->irq = client->irq;
-
-	INIT_DELAYED_WORK(&ts->work, tsc2007_work);
-
 	err = request_irq(ts->irq, tsc2007_irq, 0,
 			client->dev.driver->name, ts);
 	if (err < 0) {
@@ -297,29 +309,37 @@ static int tsc2007_probe(struct i2c_client *client,
 	if (err)
 		goto err_free_irq;
 
+	i2c_set_clientdata(client, ts);
 	dev_info(&client->dev, "registered with irq (%d)\n", ts->irq);
 
 	return 0;
 
  err_free_irq:
-	free_irq(ts->irq, ts);
+	tsc2007_free_irq(ts);
+	pdata->exit_platform_hw();
  err_free_mem:
 	input_free_device(input_dev);
 	kfree(ts);
 	return err;
 }
 
-static int tsc2007_remove(struct i2c_client *client)
+static int __devexit tsc2007_remove(struct i2c_client *client)
 {
 	struct tsc2007	*ts = i2c_get_clientdata(client);
-	struct tsc2007_platform_data *pdata;
+	struct tsc2007_platform_data *pdata = client->dev.platform_data;
 
-	cancel_delayed_work_sync(&ts->work);
+	free_irq(ts->irq, ts);
+	if (cancel_delayed_work_sync(&ts->work)) {
+		/*
+		 * Work was pending, therefore we need to enable
+		 * IRQ here to balance the disabel done in the
+		 * interrupt handler.
+		 */
+		enable_irq(ts->irq);
+	}
 
-	pdata = client->dev.platform_data;
 	pdata->exit_platform_hw();
 
-	free_irq(ts->irq, ts);
 	input_unregister_device(ts->input);
 	kfree(ts);
 
@@ -340,7 +360,7 @@ static struct i2c_driver tsc2007_driver = {
 	},
 	.id_table	= tsc2007_idtable,
 	.probe		= tsc2007_probe,
-	.remove		= tsc2007_remove,
+	.remove		= __devexit_p(tsc2007_remove),
 };
 
 static int __init tsc2007_init(void)
