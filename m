Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXI0Kwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXI0Kwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXI0Kwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:52:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22959 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbXI0Kwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:52:37 -0400
X-IronPort-AV: i="4.21,202,1188792000"; 
   d="scan'208"; a="40491162:sNHT41043107"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] [INPUT] Blackfin BF54x Input Keypad controller driver
Date: Thu, 27 Sep 2007 11:52:33 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0EA61B5D@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] [INPUT] Blackfin BF54x Input Keypad controller driver
Thread-Index: AcgAQnZZPPMocgdpTh+99pv4L3ykqwAFvFxg
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, <bryan.wu@analog.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>
Cc: <linux-input@atrey.karlin.mff.cuni.cz>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>
X-OriginalArrivalTime: 27 Sep 2007 10:52:35.0708 (UTC) FILETIME=[836DA3C0:01C800F4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

>-----Original Message-----
>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Sent: Mittwoch, 26. September 2007 15:38
>To: bryan.wu@analog.com; Michael Hennerich
>Cc: linux-input@atrey.karlin.mff.cuni.cz; Linux Kernel; uclinux-dist-
>devel@blackfin.uclinux.org
>Subject: Re: [PATCH 1/2] [INPUT] Blackfin BF54x Input Keypad controller
>driver
>
>Hi Bryan, Michael,
>
>On 9/25/07, Bryan Wu <bryan.wu@analog.com> wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>> Date: Sun, 5 Aug 2007 18:45:26 +0800
>> Subject: [PATCH 1/2] [INPUT] Blackfin BF54x Input Keypad controller
>driver
>>
>
>Thank you for the patch. Couple of comments:
>
>> +
>> +static void bfin_kpad_timer(unsigned long data)
>> +{
>> +       struct platform_device *pdev =  (struct platform_device *)
data;
>> +       struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
>> +
>> +       if (bfin_kpad_get_keypressed(bf54x_kpad)) {
>> +               /* Try again later */
>> +               mod_timer(&bf54x_kpad->timer, jiffies
>> +                               + bf54x_kpad->keyup_test_jiffies);
>> +               return;
>> +       }
>> +
>> +       input_report_key(bf54x_kpad->input, bf54x_kpad->lastkey, 0);
>> +       input_sync(bf54x_kpad->input);
>> +
>
>So it is not possible to press another key without releaseing the first
>one?

No -
The main purpose of this driver is to serve a dedicated number (<=8x8)
of unique keys in an embedded application - it's not intended to replace
a full AT keyboard.

There are options to detect multiple keys pressed by hardware. But the
default I choose only generates an interrupt when a single key is
pressed.
Two or more keys don't generate interrupts.

In case you press a single key without releasing it and press another
key.
The second key pressed will be ignored.

If someone wants to have Multiple Key Resolution - he should drop me an
email. 

It must be noted that only certain key-press combinations can be exactly
resolved.

1)Keys pressed in single row and single column
2)Keys pressed in single row and multiple columns
3)Keys pressed in multiple rows and single column

>
>> +       /* Clear IRQ Status */
>> +
>> +       bfin_kpad_clear_irq();
>> +       enable_irq(bf54x_kpad->irq);
>> +}
>> +
>> +static irqreturn_t bfin_kpad_isr(int irq, void *dev_id)
>> +{
>> +       struct platform_device *pdev = dev_id;
>> +       struct bfin_kpad_platform_data *pdata =
pdev->dev.platform_data;
>> +       struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
>> +       int key;
>> +       u16 rowcol = bfin_read_KPAD_ROWCOL();
>> +
>> +       key = bfin_kpad_find_key(pdata, rowcol);
>> +
>> +       input_report_key(bf54x_kpad->input, key, 1);
>> +       input_sync(bf54x_kpad->input);
>> +
>> +       if (bfin_kpad_get_keypressed(bf54x_kpad)) {
>> +               disable_irq(bf54x_kpad->irq);
>> +               bf54x_kpad->lastkey = key;
>> +               bf54x_kpad->timer.expires = jiffies
>> +                                       +
bf54x_kpad->keyup_test_jiffies;
>> +               add_timer(&bf54x_kpad->timer);
>> +
>> +               return IRQ_HANDLED;
>> +       }
>> +
>> +       input_report_key(bf54x_kpad->input, key, 0);
>> +       input_sync(bf54x_kpad->input);
>> +
>> +       bfin_kpad_clear_irq();
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static int __devinit bfin_kpad_probe(struct platform_device *pdev)
>> +{
>> +       struct bf54x_kpad *bf54x_kpad;
>> +       struct bfin_kpad_platform_data *pdata =
pdev->dev.platform_data;
>> +       int i, error;
>> +
>> +
>> +       if (!pdata->rows || !pdata->cols || !pdata->keymap) {
>> +               printk(KERN_ERR DRV_NAME"No rows, cols or keymap from
>pdata\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!pdata->keymapsize || pdata->keymapsize > (pdata->rows *
>pdata->cols)) {
>> +               printk(KERN_ERR DRV_NAME"Invalid keymapsize\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       bf54x_kpad = kzalloc(sizeof(struct bf54x_kpad), GFP_KERNEL);
>> +
>> +       if (!bf54x_kpad) {
>> +               return -ENOMEM;
>> +       }
>
>Loose extra braces please.
>
>> +
>> +       platform_set_drvdata(pdev, bf54x_kpad);
>> +
>> +
>> +       if (!pdata->debounce_time || !pdata->debounce_time > MAX_MULT
||
>> +               !pdata->coldrive_time || !pdata->coldrive_time >
>MAX_MULT) {
>> +               printk(KERN_ERR DRV_NAME
>> +                       "Invalid Debounce/Columdrive Time from
pdata\n");
>> +               bfin_write_KPAD_MSEL(0xFF0);    /* Default MSEL */
>> +       } else {
>> +               bfin_write_KPAD_MSEL(((pdata->debounce_time /
TIME_SCALE)
>> +                        & DBON_SCALE) | (((pdata->coldrive_time /
>TIME_SCALE) << 8)
>> +                         & COLDRV_SCALE));
>> +
>> +       }
>> +
>> +       if (!pdata->keyup_test_interval) {
>> +               bf54x_kpad->keyup_test_jiffies =
msecs_to_jiffies(50);
>> +       } else {
>> +               bf54x_kpad->keyup_test_jiffies =
>> +                       msecs_to_jiffies(pdata->keyup_test_interval);
>> +       }
>> +
>> +       if (peripheral_request_list(&per_rows[MAX_RC - pdata->rows],
>DRV_NAME)) {
>> +               printk(KERN_ERR DRV_NAME
>> +               ": Requesting Peripherals failed\n");
>> +               error = -EFAULT;
>> +               goto out;
>> +       }
>> +
>> +       if (peripheral_request_list(&per_cols[MAX_RC - pdata->cols],
>DRV_NAME)) {
>> +               printk(KERN_ERR DRV_NAME
>> +               ": Requesting Peripherals failed\n");
>> +               error = -EFAULT;
>> +               goto out1;
>> +       }
>> +
>> +       bf54x_kpad->irq = platform_get_irq(pdev, 0);
>> +
>> +       if (bf54x_kpad->irq < 0) {
>> +               error = -ENODEV;
>> +               goto out2;
>> +       }
>> +
>> +       error = request_irq(bf54x_kpad->irq, bfin_kpad_isr,
>> +                                IRQF_SAMPLE_RANDOM, DRV_NAME, pdev);
>> +
>> +       if (error) {
>> +               printk(KERN_ERR DRV_NAME
>> +                       ": unable to claim irq %d; error %d\n",
>> +                       bf54x_kpad->irq, error);
>> +               error = -EBUSY;
>> +               goto out2;
>> +       }
>> +
>
>Its it guaranteed that IRQ will not be raised here? Because if it may
>then yo need to allocate input device before regitering IRQ handler.


Yes it is guaranteed -
There won't be an IRQ before KPAD_EN is set in KPAD_CTL register, that
is done at the very end of this bfin_kpad_probe function, after setting
up the input device.


>
>> +
>> +       bf54x_kpad->input = input_allocate_device();
>> +
>> +       if (!bf54x_kpad->input) {
>> +               error = -ENOMEM;
>> +               goto out3;
>> +       }
>> +
>> +       bf54x_kpad->input->name = pdev->name;
>> +       bf54x_kpad->input->phys = "bf54x-keys/input0";
>> +       bf54x_kpad->input->cdev.dev = &pdev->dev;
>> +       bf54x_kpad->input->private = bf54x_kpad;
>> +
>> +       bf54x_kpad->input->id.bustype = BUS_HOST;
>> +       bf54x_kpad->input->id.vendor = 0x0001;
>> +       bf54x_kpad->input->id.product = 0x0001;
>> +       bf54x_kpad->input->id.version = 0x0100;
>
>May I recommend using a temp variable for bf54x_kpad->input. It may
>reduce size of generated code.
>
>> +
>> +       bf54x_kpad->input->keycode = pdata->keymap;
>
>Normally we copy the vanilla keymap to the device structure so if it
>gets changed and later driver gets unbound/rebound the new input
>device will get a fresh unaffected keymap.
>
>> +       bf54x_kpad->input->keycodesize = sizeof(unsigned int);
>
>unsigned short should cover all our keycodes.
>
>> +       bf54x_kpad->input->keycodemax = pdata->keymapsize;
>> +
>> +       /* setup input device */
>> +       set_bit(EV_KEY, bf54x_kpad->input->evbit);
>
>You might want to add EV_REP to get autorepeat. You don't need
>atomicity so you may want to use __set_bit().

I'll add an option for EV_REP to 
struct bfin_kpad_platform_data bf54x_kpad_data


>> +
>> +       for (i = 0; i < pdata->keymapsize; i++)
>> +               set_bit(pdata->keymap[i] & KEY_MAX,
bf54x_kpad->input-
>>keybit);
>
>__clear_bit(KEY_RESERVED, bf54x_kpad->input->keybit); to make sure we
>don't advertise it to the userspace.
>
>> +
>> +       error = input_register_device(bf54x_kpad->input);
>> +
>> +       if (error) {
>> +               printk(KERN_ERR DRV_NAME": Unable to register input
>device\n");
>
>Printing the error code might be a good idea too.
>
>> +               goto out4;
>> +       }
>> +
>> +       /* Init Keypad Key Up/Release test timer */
>> +
>> +       init_timer(&bf54x_kpad->timer);
>> +       bf54x_kpad->timer.function = bfin_kpad_timer;
>> +       bf54x_kpad->timer.data = (unsigned long) pdev;
>> +
>> +
>> +       bfin_write_KPAD_PRESCALE(bfin_kpad_get_prescale(TIME_SCALE));
>> +
>> +       bfin_write_KPAD_CTL((((pdata->cols - 1) << 13) & KPAD_COLEN)
|
>> +                               (((pdata->rows - 1) << 10) &
KPAD_ROWEN)
>|
>> +                               (2 & KPAD_IRQMODE));
>> +
>> +
>> +       bfin_write_KPAD_CTL(bfin_read_KPAD_CTL() | KPAD_EN);
>> +
>> +       printk(KERN_ERR DRV_NAME
>> +               ": Blackfin BF54x Keypad registered IRQ %d\n",
>bf54x_kpad->irq);
>> +
>> +       return 0;
>> +
>> +
>> +out4:
>> +       input_free_device(bf54x_kpad->input);
>> +out3:
>> +       free_irq(bf54x_kpad->irq, pdev);
>> +out2:
>> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
>> +out1:
>> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
>> +out:
>> +       kfree(bf54x_kpad);
>> +
>
>Please add platform_set_devdata(pdev, NULL); so we don;t leave dirty
>pointers around.

I guess you mean platform_set_drvdata.

>
>> +       return error;
>> +}
>> +
>> +static int __devexit bfin_kpad_remove(struct platform_device *pdev)
>> +{
>> +       struct bfin_kpad_platform_data *pdata =
pdev->dev.platform_data;
>> +       struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
>> +
>> +
>> +       del_timer_sync(&bf54x_kpad->timer);
>> +       free_irq(bf54x_kpad->irq, pdev);
>
>Same here.
>
>> +
>> +       peripheral_free_list(&per_rows[MAX_RC - pdata->rows]);
>> +       peripheral_free_list(&per_cols[MAX_RC - pdata->cols]);
>> +
>> +       input_unregister_device(bf54x_kpad->input);
>> +
>> +       kfree(bf54x_kpad);
>> +
>> +       return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int bfin_kpad_suspend(struct platform_device *pdev,
pm_message_t
>state)
>> +{
>> +       return 0;
>
>Hmm.. I'd t least stopped timer here.
>
>> +}
>> +
>> +static int bfin_kpad_resume(struct platform_device *pdev)
>> +{
>> +
>> +       return 0;
>> +}
>> +#else
>> +#define bfin_kpad_suspend      NULL
>> +#define bfin_kpad_resume       NULL
>> +#endif
>> +
>> +struct platform_driver bfin_kpad_device_driver = {
>> +       .probe          = bfin_kpad_probe,
>> +       .remove         = __devexit_p(bfin_kpad_remove),
>> +       .suspend        = bfin_kpad_suspend,
>> +       .resume         = bfin_kpad_resume,
>> +       .driver         = {
>> +               .name   = DRV_NAME,
>> +       }
>> +};
>> +
>> +static int __init bfin_kpad_init(void)
>> +{
>> +       return platform_driver_register(&bfin_kpad_device_driver);
>> +}
>> +
>> +static void __exit bfin_kpad_exit(void)
>> +{
>> +       platform_driver_unregister(&bfin_kpad_device_driver);
>> +}
>> +
>> +module_init(bfin_kpad_init);
>> +module_exit(bfin_kpad_exit);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>> +MODULE_DESCRIPTION("Keypad driver for BF54x Processors");
>> diff --git a/include/asm-blackfin/mach-bf548/bf54x_keys.h
b/include/asm-
>blackfin/mach-bf548/bf54x_keys.h
>> new file mode 100644
>> index 0000000..e7e1352
>> --- /dev/null
>> +++ b/include/asm-blackfin/mach-bf548/bf54x_keys.h
>> @@ -0,0 +1,18 @@
>> +#ifndef _BFIN_KPAD_H
>> +#define _BFIN_KPAD_H
>> +
>> +#include <linux/input.h>
>
>This include is not needed here.

I just thought it would be convenient for someone including bf54x_keys.h
to also have the key code defines for his keymap. 

But I guess you are right - and we might avoid double inclusion. 

#if defined(CONFIG_KEYBOARD_BFIN) ||
defined(CONFIG_KEYBOARD_BFIN_MODULE)
static int bf548_keymap[] = {
	KEYVAL(0, 0, KEY_ENTER),
	KEYVAL(0, 1, KEY_HELP),
	KEYVAL(0, 2, KEY_0),
	KEYVAL(0, 3, KEY_BACKSPACE),
	KEYVAL(1, 0, KEY_TAB),
	KEYVAL(1, 1, KEY_9),
	KEYVAL(1, 2, KEY_8),
	KEYVAL(1, 3, KEY_7),
	KEYVAL(2, 0, KEY_DOWN),
	KEYVAL(2, 1, KEY_6),
	KEYVAL(2, 2, KEY_5),
	KEYVAL(2, 3, KEY_4),
	KEYVAL(3, 0, KEY_UP),
	KEYVAL(3, 1, KEY_3),
	KEYVAL(3, 2, KEY_2),
	KEYVAL(3, 3, KEY_1),
};

static struct bfin_kpad_platform_data bf54x_kpad_data = {
	.rows			= 4,
	.cols			= 4,
	.keymap 		= bf548_keymap,
	.keymapsize 		= ARRAY_SIZE(bf548_keymap),
	.debounce_time		= 5000,	/* ns (5ms) */
	.coldrive_time		= 1000, /* ns (1ms) */
	.keyup_test_interval	= 50, /* ms (50ms) */
};

static struct resource bf54x_kpad_resources[] = {
	{
		.start = IRQ_KEY,
		.end = IRQ_KEY,
		.flags = IORESOURCE_IRQ,
	},
};

static struct platform_device bf54x_kpad_device = {
	.name		= "bf54x-keys",
	.id		= -1,
	.num_resources 	= ARRAY_SIZE(bf54x_kpad_resources),
	.resource 	= bf54x_kpad_resources,
	.dev		= {
		.platform_data = &bf54x_kpad_data,
	},
};
#endif

>
>> +
>> +struct bfin_kpad_platform_data {
>> +       int rows;
>> +       int cols;
>> +       int *keymap;
>> +       unsigned int keymapsize;
>> +       u32 debounce_time;      /* in ns */
>> +       u32 coldrive_time;      /* in ns */
>> +       u32 keyup_test_interval; /* in ms */
>> +};
>> +
>> +#define KEYVAL(col, row, val) (((1 << col) << 24) | ((1 << row) <<
16) |
>(val))
>> +
>> +#endif

All your other comments make prefect sense to me.
We will submit an updated patch soon.

Best regards,
Michael

>
>Thank you.
>
>--
>Dmitry
