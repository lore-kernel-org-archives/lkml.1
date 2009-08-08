Return-Path: <linux-kernel-owner+w=401wt.eu-S1750866AbZHHODE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866AbZHHODE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbZHHODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:03:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZHHODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:03:00 -0400
Date: Sat, 8 Aug 2009 16:02:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>
Subject: HTC Dream for staging: small cleanups [was Re: Support for
	synaptic touchscreen in HTC dream]
Message-ID: <20090808140250.GC13226@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <20090714175201.GB14661@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714175201.GB14661@dtor-d630.eng.vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This adds support for synaptic touchscreen, used in HTC dream
> > cellphone.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> This is pretty large body of code, could we get a sign-off from Arve as
> well since he seems to be the author?

Yes; it is now in staging with his sign-offs.

> > +config TOUCHSCREEN_SYNAPTICS_I2C_RMI
> > +	tristate "Synaptics i2c touchscreen"
> > +	depends on I2C
> > +	help
> > +	  This enables support for Synaptics RMI over I2C based touchscreens.
> > +	  Such touchscreen is used in HTC Dream.
> > +
> 
> To compile this driver as a module...

Ok.

> > +static struct workqueue_struct *synaptics_wq;
> 
> Do we need a separate workqueue? Is reading the device that slow that we
> can use keventd?

Added to the TODO.

> > +	int snap_up[2];
> > +	u32 flags;
> > +	int (*power)(int on);
> 
> 'bool on'?

Added to the TODO.

> > +static int i2c_read(struct synaptics_ts_data *ts, u8 reg, char *msg)
> > +{
> > +	int ret = i2c_smbus_read_byte_data(ts->client, 0xf0);
> 
> We are not using 'reg'?

Fixed, thanks.

> Some more info as to what you are trying to do here would be nice.

Done, Arve provided a comment.

> > +	input_report_abs(ts->input_dev, ABS_PRESSURE, z);
> > +	input_report_abs(ts->input_dev, ABS_TOOL_WIDTH, w);
> > +	input_report_key(ts->input_dev, BTN_TOUCH, finger);
> > +	finger2_pressed = finger > 1 && finger != 7;
> > +	input_report_key(ts->input_dev, BTN_2, finger2_pressed);
> > +	if (finger2_pressed) {
> > +		input_report_abs(ts->input_dev, ABS_HAT0X, pos[1][0]);
> > +		input_report_abs(ts->input_dev, ABS_HAT0Y, pos[1][1]);
> 
> ABS_HAT is pretty unusual for a touchscreen...

Added to the TODO list. It should be cleaned up before merge.

> > +		if ((buf[14] & 0xc0) != 0x40) {
> > +			printk(KERN_WARNING "synaptics_ts_work_func:"
> > +			       " bad read %x %x %x %x %x %x %x %x %x"
> > +			       " %x %x %x %x %x %x, ret %d\n",
> > +			       buf[0], buf[1], buf[2], buf[3],
> > +			       buf[4], buf[5], buf[6], buf[7],
> > +			       buf[8], buf[9], buf[10], buf[11],
> > +			       buf[12], buf[13], buf[14], ret);
> 
> Umm... for ()?

I removed debugging instead.

> > +static int synaptics_ts_probe(
> 
> __devinit()

Done.

> > +	ts->input_dev = input_allocate_device();
> > +	if (ts->input_dev == NULL) {
> > +		ret = -ENOMEM;
> > +		pr_err("synaptics: Failed to allocate input device\n");
> > +		goto err_input_dev_alloc_failed;
> > +	}
> > +	ts->input_dev->name = "synaptics-rmi-touchscreen";
> 
> BUS_I2C, etc.

I'm doing this:

	ts->input_dev->name = "synaptics-rmi-touchscreen";
	ts->input_dev->phys = "msm/input0";
	ts->input_dev->id.bustype = BUS_I2C;

I don't know if it is right; if you can suggest better strings...

> > +	set_bit(EV_SYN, ts->input_dev->evbit);
> 
> __set_bit(), no need to lock the bus.

Done.

> > +	if (client->irq) {
> > +		ret = request_irq(client->irq, synaptics_ts_irq_handler,
> > +				  0, client->name, ts);
> 
> I think threaded IRQ will fit the bill and will take care of
> IRQ/workqueue shutdown races. Of course you still need to use workqueue
> if polling.

Yep, but that's TODO for now.

> > +	pr_info("synaptics: Start touchscreen %s in %s mode\n", 
> 
> Probably "synaptics_ts" throughout so nobody is confused?

Yep.

> > +static int synaptics_ts_remove(struct i2c_client *client)
> 
> __devexit()

Ok.

> > +MODULE_DESCRIPTION("Synaptics Touchscreen Driver");
> > +MODULE_LICENSE("GPL");
> 
> MODULE_AUTHOR()?

Fixed; this, and some others were fixed before. Here is just the new
stuff.

---

Small fixes to synaptics touchscreen driver, and add a TODO list of
stuff that should be fixed between merge into kernel proper.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/Kconfig b/drivers/staging/dream/Kconfig
index 1fdbd48..e19d403 100644
--- a/drivers/staging/dream/Kconfig
+++ b/drivers/staging/dream/Kconfig
@@ -8,4 +8,8 @@ config TOUCHSCREEN_SYNAPTICS_I2C_RMI
 	help
 	  This enables support for Synaptics RMI over I2C based touchscreens.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called synaptics_i2c_rmi.
+
+
 
diff --git a/drivers/staging/dream/synaptics_i2c_rmi.c b/drivers/staging/dream/synaptics_i2c_rmi.c
index 6e23276..d786a55 100644
--- a/drivers/staging/dream/synaptics_i2c_rmi.c
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -189,13 +189,7 @@ static void synaptics_ts_work_func(struct work_struct *work)
 			continue;
 		}
 		if ((buf[14] & 0xc0) != 0x40) {
-			pr_warning("synaptics_ts_work_func:"
-			       " bad read %x %x %x %x %x %x %x %x %x"
-			       " %x %x %x %x %x %x, ret %d\n",
-			       buf[0], buf[1], buf[2], buf[3],
-			       buf[4], buf[5], buf[6], buf[7],
-			       buf[8], buf[9], buf[10], buf[11],
-			       buf[12], buf[13], buf[14], ret);
+			pr_warning("synaptics_ts_work_func: bad data\n");
 			if (bad_data)
 				synaptics_init_panel(ts);
 			bad_data = 1;
@@ -517,7 +511,7 @@ static int __devinit synaptics_ts_probe(
 	register_early_suspend(&ts->early_suspend);
 #endif
 
-	pr_info("synaptics: Start touchscreen %s in %s mode\n", 
+	pr_info("synaptics_ts: Start touchscreen %s in %s mode\n", 
 		ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
 
 	return 0;
@@ -534,7 +528,7 @@ err_check_functionality_failed:
 	return ret;
 }
 
-static int synaptics_ts_remove(struct i2c_client *client)
+static int __devexit synaptics_ts_remove(struct i2c_client *client)
 {
 	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
 #ifdef CONFIG_HAS_EARLYSUSPEND


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
