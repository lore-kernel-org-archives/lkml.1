Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZGONtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZGONtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZGONtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:49:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40296 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbZGONtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:49:05 -0400
Date: Wed, 15 Jul 2009 15:48:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Support for synaptic touchscreen in HTC dream
Message-ID: <20090715134855.GB2538@elf.ucw.cz>
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

On Tue 2009-07-14 10:52:12, Dmitry Torokhov wrote:
> On Tue, Jul 14, 2009 at 12:06:34PM +0200, Pavel Machek wrote:
> > From: Arve Hj?nnev?g <arve@android.com>
> > 
> > This adds support for synaptic touchscreen, used in HTC dream
> > cellphone.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> This is pretty large body of code, could we get a sign-off from Arve as
> well since he seems to be the author?

Arve?

> > +config TOUCHSCREEN_SYNAPTICS_I2C_RMI
> > +	tristate "Synaptics i2c touchscreen"
> > +	depends on I2C
> > +	help
> > +	  This enables support for Synaptics RMI over I2C based touchscreens.
> > +	  Such touchscreen is used in HTC Dream.
> > +
> 
> To compile this driver as a module...

Done.

> > +static struct workqueue_struct *synaptics_wq;
> 
> Do we need a separate workqueue? Is reading the device that slow that we
> can use keventd?

Arve?

> > +	int snap_up_on[2];
> > +	int snap_up_off[2];
> > +	int snap_down[2];
> > +	int snap_up[2];
> > +	u32 flags;
> > +	int (*power)(int on);
> 
> 'bool on'?

Ok.

> > +static int i2c_read(struct synaptics_ts_data *ts, u8 reg, char *msg)
> > +{
> > +	int ret = i2c_smbus_read_byte_data(ts->client, 0xf0);
> 
> We are not using 'reg'?

Uff... I thought I actually tested it?!

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

It is trying to do something useful for multitouch. People actually
use multitouch on HTC dream. I guess I can strip it from version being
merged...

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

> > +static enum hrtimer_restart synaptics_ts_timer_func(struct hrtimer *timer)
> > +{
> > +	struct synaptics_ts_data *ts =
> > +		container_of(timer, struct synaptics_ts_data, timer);
> > +
> > +	queue_work(synaptics_wq, &ts->work);
> > +
> > +	hrtimer_start(&ts->timer, ktime_set(0, 12500000), HRTIMER_MODE_REL);
> 
> I was always wondering why use high-resolution timer and then offload to
> a workqueue which scheduling we have no idea about. Why can't we simply
> reschedule work in case when we are in polling mode?


> > +	INIT_WORK(&ts->work, synaptics_ts_work_func);
> > +	ts->client = client;
> > +	i2c_set_clientdata(client, ts);
> > +	pdata = client->dev.platform_data;
> > +	if (pdata)
> > +		ts->power = pdata->power;
> > +	else
> > +		pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> 
> Where is it freed?

It is not, but this should not trigger. Converted to static fake_pdata.

> > +	ts->input_dev->name = "synaptics-rmi-touchscreen";
> 
> BUS_I2C, etc.

I figured out BUS_I2C. Anything else I need to set?

> > +	set_bit(EV_SYN, ts->input_dev->evbit);
> 
> __set_bit(), no need to lock the bus.

Ok.

> > +	set_bit(EV_KEY, ts->input_dev->evbit);
> > +	set_bit(BTN_TOUCH, ts->input_dev->keybit);
> > +	set_bit(BTN_2, ts->input_dev->keybit);
> 
> BTN_2 is kinda generic... Normally joysticks use it... 

Ok, what is the recommended protocol for multitouch? Should I strip it
out from merge version?

> > +	if (client->irq) {
> > +		ret = request_irq(client->irq, synaptics_ts_irq_handler,
> > +				  0, client->name, ts);
> 
> I think threaded IRQ will fit the bill and will take care of
> IRQ/workqueue shutdown races. Of course you still need to use workqueue
> if polling.

I guess we'll just strip polling version for now?

> > +	if (!ts->use_irq) {
> > +		hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > +		ts->timer.function = synaptics_ts_timer_func;
> > +		hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
> > +	}
> > +
> > +	pr_info("synaptics: Start touchscreen %s in %s mode\n", 
> 
> Probably "synaptics_ts" throughout so nobody is confused?

Well, there's no other hardware from synaptics in those machines :-).

> > +		ts->input_dev->name, ts->use_irq ? "interrupt" : "polling");
> > +
> > +	return 0;
> > +
> > + err_input_register_device_failed:
> > +	input_free_device(ts->input_dev);
> > +
> 
> Don't see canceling timer nor shutting off WQ here. Also, maybe
> implement open() and close() so we don't reschedule WQ while polling?

> > +{
> > +	struct synaptics_ts_data *ts = i2c_get_clientdata(client);
> > +
> > +	if (ts->use_irq)
> > +		free_irq(client->irq, ts);
> > +	else
> > +		hrtimer_cancel(&ts->timer);
> 
> What about the work?

> > +static void __exit synaptics_ts_exit(void)
> > +{
> > +	i2c_del_driver(&synaptics_ts_driver);
> > +	if (synaptics_wq)
> > +		destroy_workqueue(synaptics_wq);
> > +}
> > +
> > +module_init(synaptics_ts_init);
> > +module_exit(synaptics_ts_exit);
> > +
> > +MODULE_DESCRIPTION("Synaptics Touchscreen Driver");
> > +MODULE_LICENSE("GPL");
> 
> MODULE_AUTHOR()?

Ok.

> Thanks.

Thanks for review!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
