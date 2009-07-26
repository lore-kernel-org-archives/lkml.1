Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZGZICW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZGZICW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZGZICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:02:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:2177 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZGZICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ruuQbzWVNGW5I6j2pXwAS6yuW8xSBMPfS7XYCtz8tmd/SiBI95QkQChiZCQE7IrveO
         6x+T//CX4WBznBpSoQSdam/uMU8Di4I+Y1vAmRGpVb3myWHSB0oAOfTC7hIpc9p4CSTn
         sWRTwheD7OtE90jMHzfZW/kAmkWH/XSk3IcTI=
Date: Sun, 26 Jul 2009 01:02:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [PATCH 2/2] tsc2007: reduced number of I2C transfers
Message-ID: <20090726080212.GA24365@dtor-d630.eng.vmware.com>
References: <4A69DDED.50402@mocean-labs.com> <20090724180022.GA6477@dtor-d630.eng.vmware.com> <4A6A0D77.6000600@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A6A0D77.6000600@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 09:37:27PM +0200, Richard Röjfors wrote:
> On 7/24/09 8:00 PM, Dmitry Torokhov wrote:
>> On Fri, Jul 24, 2009 at 06:14:37PM +0200, Richard Röjfors wrote:
>>> Decreases the number of I2C transactions transferred by the driver.
>>> During probe we don't need to ask for the coordinates from the controller.
>>> When polling the controller we don't need to power down and enable IRQ
>>> if we are going to poll again.
>>>
>>> Signed-off-by: Richard Röjfors<richard.rojfors.ext@mocean-labs.com>
>>> ---
>>> Index: linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c
>>> ===================================================================
>>> --- linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1040)
>>> +++ linux-2.6.31-rc2/drivers/input/touchscreen/tsc2007.c	(revision 1053)
>>> @@ -178,6 +178,12 @@
>>>   		ts->penstate = PEN_STATE_UP;
>>>   }
>>>
>>> +static void tsc2007_power_down(struct tsc2007 *tsc)
>>> +{
>>> +	/* power down */
>>> +	tsc2007_xfer(tsc, PWRDOWN);
>>> +}
>>> +
>>>   static int tsc2007_read_values(struct tsc2007 *tsc)
>>>   {
>>>   	/* y- still on; turn on only y+ (and ADC) */
>>> @@ -188,11 +194,8 @@
>>>
>>>   	/* turn y+ off, x- on; we'll use formula #1 */
>>>   	tsc->tc.z1 = tsc2007_xfer(tsc, READ_Z1);
>>> -	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2);
>>> +	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2 | TSC2007_POWER_OFF_IRQ_EN);
>>
>> I think this leaves the controller powered on and with with PENIRQ
>> disabled.
>>
>
> You are right, I think we should leave the patch like below, just get  
> rid of the unnecessary read during startup.
>

I modified the patch a bit before applying. In fact there were a few
changes to all the patces so it would be nice if you could take a look
at the 'next' branch of my tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git next

Also, I di dnot quite like the logic of the patch making
get_pendown_state callback optional; could you please try the patch
below and let me know of it works for you?

Thanks!

-- 
Dmitry


Input: tsc2007 - make get_pendown_state platform callback optional

In cases when get_pendown_state callback is not available have
the driver to fallback on pressure calculation to determine if
the pen is up.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/tsc2007.c |  170 +++++++++++++++++++----------------
 1 files changed, 92 insertions(+), 78 deletions(-)


diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index f710af4..ac5e0e8 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -70,7 +70,6 @@ struct tsc2007 {
 	struct input_dev	*input;
 	char			phys[32];
 	struct delayed_work	work;
-	struct ts_event		tc;
 
 	struct i2c_client	*client;
 
@@ -106,51 +105,96 @@ static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
 	return val;
 }
 
-static void tsc2007_send_event(void *tsc)
+static void tsc2007_read_values(struct tsc2007 *tsc, struct ts_event *tc)
 {
-	struct tsc2007	*ts = tsc;
-	u32		rt;
-	u16		x, y, z1, z2;
+	/* y- still on; turn on only y+ (and ADC) */
+	tc->y = tsc2007_xfer(tsc, READ_Y);
+
+	/* turn y- off, x+ on, then leave in lowpower */
+	tc->x = tsc2007_xfer(tsc, READ_X);
+
+	/* turn y+ off, x- on; we'll use formula #1 */
+	tc->z1 = tsc2007_xfer(tsc, READ_Z1);
+	tc->z2 = tsc2007_xfer(tsc, READ_Z2);
 
-	x = ts->tc.x;
-	y = ts->tc.y;
-	z1 = ts->tc.z1;
-	z2 = ts->tc.z2;
+	/* Prepare for next touch reading - power down ADC, enable PENIRQ */
+	tsc2007_xfer(tsc, PWRDOWN);
+}
+
+static u32 tsc2007_calculate_pressure(struct tsc2007 *tsc, struct ts_event *tc)
+{
+	u32 rt = 0;
 
 	/* range filtering */
-	if (x == MAX_12BIT)
-		x = 0;
+	if (tc->x == MAX_12BIT)
+		tc->x = 0;
 
-	if (likely(x && z1)) {
+	if (likely(tc->x && tc->z1)) {
 		/* compute touch pressure resistance using equation #1 */
-		rt = z2;
-		rt -= z1;
-		rt *= x;
-		rt *= ts->x_plate_ohms;
-		rt /= z1;
+		rt = tc->z2 - tc->z1;
+		rt *= tc->x;
+		rt *= tsc->x_plate_ohms;
+		rt /= tc->z1;
 		rt = (rt + 2047) >> 12;
-	} else
-		rt = 0;
-
-	/*
-	 * Sample found inconsistent by debouncing or pressure is beyond
-	 * the maximum. Don't report it to user space, repeat at least
-	 * once more the measurement
-	 */
-	if (rt > MAX_12BIT) {
-		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
-		return;
 	}
 
+	return rt;
+}
+
+static void tsc2007_send_up_event(struct tsc2007 *tsc)
+{
+	struct input_dev *input = tsc->input;
+
+	dev_dbg(&tsc->client->dev, "UP\n");
+
+	input_report_key(input, BTN_TOUCH, 0);
+	input_report_abs(input, ABS_PRESSURE, 0);
+	input_sync(input);
+}
+
+static void tsc2007_work(struct work_struct *work)
+{
+	struct tsc2007 *ts =
+		container_of(to_delayed_work(work), struct tsc2007, work);
+	struct ts_event tc;
+	u32 rt;
+
 	/*
 	 * NOTE: We can't rely on the pressure to determine the pen down
-	 * state, even this controller has a pressure sensor.  The pressure
-	 * value can fluctuate for quite a while after lifting the pen and
-	 * in some cases may not even settle at the expected value.
+	 * state, even though this controller has a pressure sensor.
+	 * The pressure value can fluctuate for quite a while after
+	 * lifting the pen and in some cases may not even settle at the
+	 * expected value.
 	 *
 	 * The only safe way to check for the pen up condition is in the
-	 * work function by reading the pen signal state (it's a GPIO and IRQ).
+	 * work function by reading the pen signal state (it's a GPIO
+	 * and IRQ). Unfortunately such callback is not always available,
+	 * in that case we have rely on the pressure anyway.
 	 */
+	if (ts->get_pendown_state) {
+		if (unlikely(!ts->get_pendown_state())) {
+			tsc2007_send_up_event(ts);
+			ts->pendown = false;
+			goto out;
+		}
+
+		dev_dbg(&ts->client->dev, "pen is still down\n");
+	}
+
+	tsc2007_read_values(ts, &tc);
+
+	rt = tsc2007_calculate_pressure(ts, &tc);
+	if (rt > MAX_12BIT) {
+		/*
+		 * Sample found inconsistent by debouncing or pressure is
+		 * beyond the maximum. Don't report it to user space,
+		 * repeat at least once more the measurement.
+		 */
+		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
+		goto out;
+
+	}
+
 	if (rt) {
 		struct input_dev *input = ts->input;
 
@@ -161,68 +205,38 @@ static void tsc2007_send_event(void *tsc)
 			ts->pendown = true;
 		}
 
-		input_report_abs(input, ABS_X, x);
-		input_report_abs(input, ABS_Y, y);
+		input_report_abs(input, ABS_X, tc.x);
+		input_report_abs(input, ABS_Y, tc.y);
 		input_report_abs(input, ABS_PRESSURE, rt);
 
 		input_sync(input);
 
 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
-			x, y, rt);
-	}
-}
-
-static int tsc2007_read_values(struct tsc2007 *tsc)
-{
-	/* y- still on; turn on only y+ (and ADC) */
-	tsc->tc.y = tsc2007_xfer(tsc, READ_Y);
-
-	/* turn y- off, x+ on, then leave in lowpower */
-	tsc->tc.x = tsc2007_xfer(tsc, READ_X);
-
-	/* turn y+ off, x- on; we'll use formula #1 */
-	tsc->tc.z1 = tsc2007_xfer(tsc, READ_Z1);
-	tsc->tc.z2 = tsc2007_xfer(tsc, READ_Z2);
-
-	/* Prepare for next touch reading - power down ADC, enable PENIRQ */
-	tsc2007_xfer(tsc, PWRDOWN);
-
-	return 0;
-}
-
-static void tsc2007_work(struct work_struct *work)
-{
-	struct tsc2007 *ts =
-		container_of(to_delayed_work(work), struct tsc2007, work);
-
-	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
-		struct input_dev *input = ts->input;
-
-		dev_dbg(&ts->client->dev, "UP\n");
-
-		input_report_key(input, BTN_TOUCH, 0);
-		input_report_abs(input, ABS_PRESSURE, 0);
-		input_sync(input);
+			tc.x, tc.y, rt);
 
+	} else if (!ts->get_pendown_state && ts->pendown) {
+		/*
+		 * We don't have callback to check pendown state, so we
+		 * have to assume that since pressure reported is 0 the
+		 * pen was lifted up.
+		 */
+		tsc2007_send_up_event(ts);
 		ts->pendown = false;
-		enable_irq(ts->irq);
-	} else {
-		/* pen is still down, continue with the measurement */
-		dev_dbg(&ts->client->dev, "pen is still down\n");
-
-		tsc2007_read_values(ts);
-		tsc2007_send_event(ts);
+	}
 
+ out:
+	if (ts->pendown)
 		schedule_delayed_work(&ts->work,
 				      msecs_to_jiffies(TS_POLL_PERIOD));
-	}
+	else
+		enable_irq(ts->irq);
 }
 
 static irqreturn_t tsc2007_irq(int irq, void *handle)
 {
 	struct tsc2007 *ts = handle;
 
-	if (likely(ts->get_pendown_state())) {
+	if (!ts->get_pendown_state || likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
 		schedule_delayed_work(&ts->work,
 				      msecs_to_jiffies(TS_POLL_DELAY));
