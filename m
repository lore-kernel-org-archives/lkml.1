Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbYKUX7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbYKUX7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYKUX6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:58:53 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:52269 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYKUX6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:58:52 -0500
Date: Sat, 22 Nov 2008 01:00:47 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stefan@datenfreihafen.org, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Ribeiro <drwyrm@gmail.com>,
       ao2@openezx.org
Message-ID: <20081122000047.GB28067@dodger.lab.datenfreihafen.org>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <20081121160521.959037675@dodger.lab.datenfreihafen.org> <20081121170518.GA4416@USFSHXP-002051>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121170518.GA4416@USFSHXP-002051>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [patch 08/14] input: PCAP2 based touchscreen driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thanks for the fast review. I hope we could address all your points with a new
patch below.

On Fri, 2008-11-21 at 12:05, Dmitry Torokhov wrote:
> On Fri, Nov 21, 2008 at 05:04:11PM +0100, stefan@datenfreihafen.org wrote:
> > Touchscreen driver based on the PCAP2 multi function device.
> > 
> > Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> > 
> > +
> > +static int __devexit pcap_ts_remove(struct platform_device *pdev)
> > +{
> > +	ezx_pcap_unregister_event(PCAP_IRQ_TS);
> > +
> > +	del_timer_sync(&pcap_ts->timer);
> > +
> > +	input_unregister_device(pcap_ts->input);
> > +	kfree(pcap_ts);
> > +
> 
> Could pcap_ts->work be still running at this point?

Good point. Adding a cancel_work_sync()
 
> > +static struct platform_driver pcap_ts_driver = {
> > +	.probe		= pcap_ts_probe,
> > +	.remove		= __devexit_p(pcap_ts_remove),
> > +	.suspend	= pcap_ts_suspend,
> > +	.resume		= pcap_ts_resume,
> 
> I think it is preferred that .suspend and .resume assigments are
> guarded by #ifdef CONFIG_PM, not creating NULL stubs as this will
> (theoretically) allow removing .suspend and .resume pointers from
> driver stucture when compiling without PM support.

Change to #ifdef

> Also try running through checkpatch.pl - there are a few warnings I'd
> like to be fixed as well.

Can you elaborate on this? I tested with checkpatch.pl here, but did not get
anny warning.

> Otherwise looks pretty good.

Thanks. Let's hope the PCAP2 driver goes in this time so we can merge this one
as well.

> Oh, and you need to add your sign-off please. Thanks!

Added.


From: Daniel Ribeiro <drwyrm@gmail.com>
Subject: input: PCAP2 based touchscreen driver
To: dmitry.torokhov@gmail.com
Cc: eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org

Touchscreen driver based on the PCAP2 multi function device.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>

---
 drivers/input/touchscreen/Kconfig   |    9 ++
 drivers/input/touchscreen/Makefile  |    1 +
 drivers/input/touchscreen/pcap_ts.c |  256 +++++++++++++++++++++++++++++++++++
 3 files changed, 266 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3d1ab8f..a1bd364 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -376,4 +376,13 @@ config TOUCHSCREEN_TOUCHIT213
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchit213.
 
+config TOUCHSCREEN_PCAP
+	tristate "Motorola PCAP touchscreen"
+	depends on EZX_PCAP
+	help
+	  Say Y here if you have a Motorola EZX telephone and
+	  want to support the built-in touchscreen.
+
+	  If unsure, say N.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 15cf290..97d8931 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -31,3 +31,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
 wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
+obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
new file mode 100644
index 0000000..a7ff2e2
--- /dev/null
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -0,0 +1,256 @@
+/*
+ * pcap_ts.c - Touchscreen driver for Motorola PCAP2 based touchscreen as found
+ * 	       in the EZX phone platform.
+ *
+ *  Copyright (C) 2006 Harald Welte <laforge@openezx.org>
+ *  Copyright (C) 2007-2008 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ *  Based on information found in the original Motorola 2.4.x ezx-ts.c driver.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/pm.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/ezx-pcap.h>
+
+struct pcap_ts {
+	struct input_dev *input;
+	struct timer_list timer;
+	struct work_struct work;
+	u16 x, y;
+	u16 pressure;
+	u8 read_state;
+};
+
+struct pcap_ts *pcap_ts;
+
+#define X_AXIS_MIN	0
+#define X_AXIS_MAX	1023
+
+#define Y_AXIS_MAX	X_AXIS_MAX
+#define Y_AXIS_MIN	X_AXIS_MIN
+
+#define PRESSURE_MAX	X_AXIS_MAX
+#define PRESSURE_MIN	X_AXIS_MIN
+
+/* if we try to read faster, pressure reading becomes unreliable */
+#define SAMPLE_INTERVAL		(HZ/50)
+
+static void pcap_ts_read_xy(void)
+{
+	u32 res[2];
+
+	ezx_pcap_get_adc_channel_result(PCAP_ADC_CH_TS_X1, PCAP_ADC_CH_TS_Y1,
+									res);
+	ezx_pcap_disable_adc();
+
+	switch (pcap_ts->read_state) {
+	case PCAP_ADC_TS_M_PRESSURE:
+		/* save pressure, start xy read */
+		pcap_ts->pressure = res[0];
+		pcap_ts->read_state = PCAP_ADC_TS_M_XY;
+		schedule_work(&pcap_ts->work);
+		break;
+	case PCAP_ADC_TS_M_XY:
+		pcap_ts->y = res[0];
+		pcap_ts->x = res[1];
+		if (pcap_ts->x <= X_AXIS_MIN || pcap_ts->x >= X_AXIS_MAX ||
+		    pcap_ts->y <= Y_AXIS_MIN || pcap_ts->y >= Y_AXIS_MAX ||
+		    pcap_ts->pressure <= PRESSURE_MIN ||
+		    pcap_ts->pressure >= PRESSURE_MAX) {
+			/* pen has been released */
+			input_report_key(pcap_ts->input, BTN_TOUCH, 0);
+			input_report_abs(pcap_ts->input, ABS_PRESSURE, 0);
+
+			/* no need for timer, we'll get interrupted with
+			 * next touch down event */
+			del_timer(&pcap_ts->timer);
+
+			/* ask PCAP2 to interrupt us if touch event happens
+			 * again */
+			pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
+			ezx_pcap_unmask_event(PCAP_IRQ_TS);
+			schedule_work(&pcap_ts->work);
+		} else {
+			/* pen is touching the screen*/
+			input_report_abs(pcap_ts->input, ABS_X, pcap_ts->x);
+			input_report_abs(pcap_ts->input, ABS_Y, pcap_ts->y);
+			input_report_key(pcap_ts->input, BTN_TOUCH, 1);
+			input_report_abs(pcap_ts->input, ABS_PRESSURE,
+						pcap_ts->pressure);
+
+			/* switch back to pressure read mode */
+			pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
+			mod_timer(&pcap_ts->timer,
+					jiffies + SAMPLE_INTERVAL);
+		}
+		input_sync(pcap_ts->input);
+		break;
+	default:
+		break;
+	}
+}
+
+static void pcap_ts_work(struct work_struct *unused)
+{
+	u32 tmp;
+
+	switch (pcap_ts->read_state) {
+	case PCAP_ADC_TS_M_STANDBY:
+		/* set TS to standby */
+		ezx_pcap_read(PCAP_REG_ADC, &tmp);
+		tmp &= ~PCAP_ADC_TS_M_MASK;
+		tmp |= (PCAP_ADC_TS_M_STANDBY << PCAP_ADC_TS_M_SHIFT);
+		ezx_pcap_write(PCAP_REG_ADC, tmp);
+		break;
+	case PCAP_ADC_TS_M_PRESSURE:
+	case PCAP_ADC_TS_M_XY:
+		/* start adc conversion */
+		ezx_pcap_start_adc(PCAP_ADC_BANK_1, PCAP_ADC_T_NOW,
+			(pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT),
+						pcap_ts_read_xy, NULL);
+		break;
+	}
+}
+
+static void pcap_ts_event_touch(u32 events, void *unused)
+{
+	/* pen touch down, mask touch event and start reading pressure */
+	ezx_pcap_mask_event(PCAP_IRQ_TS);
+	pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
+	schedule_work(&pcap_ts->work);
+}
+
+static void pcap_ts_timer_fn(unsigned long data)
+{
+	schedule_work(&pcap_ts->work);
+}
+
+static int __devinit pcap_ts_probe(struct platform_device *pdev)
+{
+	struct input_dev *input_dev;
+	int err = -ENOMEM;
+
+	pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!pcap_ts || !input_dev)
+		goto fail;
+
+	INIT_WORK(&pcap_ts->work, pcap_ts_work);
+
+	pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
+
+	init_timer(&pcap_ts->timer);
+	pcap_ts->timer.data = (unsigned long) pcap_ts;
+	pcap_ts->timer.function = &pcap_ts_timer_fn;
+
+	pcap_ts->input = input_dev;
+
+	input_dev->name = "pcap-touchscreen";
+	input_dev->phys = "pcap_ts/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor = 0x0001;
+	input_dev->id.product = 0x0002;
+	input_dev->id.version = 0x0100;
+	input_dev->dev.parent = &pdev->dev;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN,
+			     PRESSURE_MAX, 0, 0);
+
+	ezx_pcap_register_event(PCAP_IRQ_TS, pcap_ts_event_touch,
+							NULL, "Touch Screen");
+
+	err = input_register_device(pcap_ts->input);
+	if (err)
+		goto fail_touch;
+
+	schedule_work(&pcap_ts->work);
+
+	return 0;
+
+fail_touch:
+	ezx_pcap_unregister_event(PCAP_IRQ_TS);
+fail:
+	input_free_device(input_dev);
+	kfree(pcap_ts);
+
+	return err;
+}
+
+static int __devexit pcap_ts_remove(struct platform_device *pdev)
+{
+	ezx_pcap_unregister_event(PCAP_IRQ_TS);
+
+	del_timer_sync(&pcap_ts->timer);
+
+	input_unregister_device(pcap_ts->input);
+	cancel_work_sync(&pcap_ts->work);
+	kfree(pcap_ts);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pcap_ts_suspend(struct platform_device *dev, pm_message_t state)
+{
+	u32 tmp;
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp |= PCAP_ADC_TS_REF_LOWPWR;
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+	return 0;
+}
+
+static int pcap_ts_resume(struct platform_device *dev)
+{
+	u32 tmp;
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp &= ~PCAP_ADC_TS_REF_LOWPWR;
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+	return 0;
+}
+#endif
+
+static struct platform_driver pcap_ts_driver = {
+	.probe		= pcap_ts_probe,
+	.remove		= __devexit_p(pcap_ts_remove),
+#ifdef CONFIG_PM
+	.suspend	= pcap_ts_suspend,
+	.resume		= pcap_ts_resume,
+#endif
+	.driver		= {
+		.name	= "pcap-ts",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pcap_ts_init(void)
+{
+	return platform_driver_register(&pcap_ts_driver);
+}
+
+static void __exit pcap_ts_exit(void)
+{
+	platform_driver_unregister(&pcap_ts_driver);
+}
+
+module_init(pcap_ts_init);
+module_exit(pcap_ts_exit);
+
+MODULE_DESCRIPTION("Motorola PCAP2 touchscreen driver");
+MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
+MODULE_LICENSE("GPL");
-- 
tg: (8e9f66c..) ezx/pcap_ts (depends on: ezx/local/pcap)
