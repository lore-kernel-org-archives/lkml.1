Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXIJDu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXIJDu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 23:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbXIJDuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 23:50:51 -0400
Received: from mxsf00.insightbb.com ([74.128.0.70]:42319 "EHLO
	mxsf00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbXIJDuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 23:50:50 -0400
X-IronPort-AV: E=Sophos;i="4.20,229,1186372800"; 
   d="scan'208";a="28405552"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAhc5EZKjlCP/2dsb2JhbACBXQ
X-IronPort-AV: E=Sophos;i="4.20,229,1186372800"; 
   d="scan'208";a="114785549"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Subject: Re: [PATCH 2/3] Maple bus support for the Sega Dreamcast - keyboard support
Date: Sun, 9 Sep 2007 23:50:46 -0400
User-Agent: KMail/1.9.3
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org
References: <8b67d60709091001l3cd6adf6m2dab8e815f47435d@mail.gmail.com> <20070909214438.79959ace@laptopd505.fenrus.org> <8b67d60709091357k2bc0c673kef5716a97f07bd3a@mail.gmail.com>
In-Reply-To: <8b67d60709091357k2bc0c673kef5716a97f07bd3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709092350.47602.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Sunday 09 September 2007 16:57, Adrian McMenamin wrote:
> 
> Add maple bus keyboard support to the kernel.
> 
> Signed-off by Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 

Couple of more things:

> +
> +extern int maple_driver_register(struct device_driver *drv);
> +

No externs in *.c files, please. Isn't this defined in maple.h which is
being included?

> +
> +static void dc_kbd_callback(struct mapleq *mq)
> +{
> +	struct maple_device *mapledev = mq->dev;
> +	struct dc_kbd *kbd = mapledev->private_data;
> +	unsigned long *buf = mq->recvbuf;

I very much prefer an empty line between variables and the code.

> +	if (!mutex_trylock(&maple_keyb_mutex)) /* Can only be locked if
> already in cleanup */
> +		return;
> +	if (buf[1] == mapledev->function) {
> +		memcpy(kbd->new, buf + 2, 8);
> +		dc_scan_kbd(kbd);
> +	}
> +	mutex_unlock(&maple_keyb_mutex);
> +}
> +
> +static int dc_kbd_connect(struct maple_device *dev)
> +{
> +	int i, retval = 0;
> +	struct dc_kbd *kbd;
> +	if (!(dev->function & MAPLE_FUNC_KEYBOARD))
> +		return -EINVAL;
> +
> +	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
> +	if (unlikely(!kbd))
> +		return -ENOMEM;
> +
> +	dev->private_data = kbd;
> +	kbd->dev = input_allocate_device();
> +	if (!kbd->dev){
> +		retval = -ENODEV;
> +		goto cleanup_memory;
> +	}
> +
> +	for (i = 0; i < NR_SCANCODES; i++)
> +		kbd->keycode[i] = dc_kbd_keycode[i];

memcpy?

> +	kbd->dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
> +	kbd->dev->keycodesize = sizeof (unsigned char);
> +	kbd->dev->keycodemax = ARRAY_SIZE(kbd->keycode);
> +	kbd->dev->keycode = kbd->keycode;
> +
> +
> +	for (i = 0; i < 255; i++)

Are you sure it is 255 and not NR_SCANCODES?
 
> +		set_bit(dc_kbd_keycode[i], kbd->dev->keybit);
> +
> +	clear_bit(0, kbd->dev->keybit);
> +
> +	kbd->dev->private = kbd;

Please use input_set_drvdata() here and input_get_drvdata() when
accessing it.

> +
> +	kbd->dev->name = dev->product_name;
> +	kbd->dev->id.bustype = BUS_HOST;
> +

maple_device appears to be fully integrated in sysfs, please add:
	kbd->dev->dev.parent = &dev->dev;

Btw, introducing a temp for kbd->dev should reduce generated code
somewhat.

> +	retval = input_register_device(kbd->dev);
> +	if (retval)
> +		goto cleanup;
> +	/* Maple polling is locked to VBLANK - which may be just 50/s */
> +	maple_getcond_callback(dev, dc_kbd_callback, HZ/50,
> +			       MAPLE_FUNC_KEYBOARD);
> +	return retval;
> +
> +cleanup:
> +	input_free_device(kbd->dev);
> +cleanup_memory:
> +	kfree(kbd);
> +	return retval;
> +}
> +
> +static void dc_kbd_disconnect(struct maple_device *dev)
> +{
> +	struct dc_kbd *kbd;
> +	mutex_lock(&maple_keyb_mutex);
> +	kbd = dev->private_data;
> +
> +	input_unregister_device(kbd->dev);
> +	kfree(kbd);
> +	mutex_unlock(&maple_keyb_mutex);
> +}
> +
> +/* allow the keyboard to be used */
> +static int probe_maple_kbd(struct device *dev)
> +{
> +	struct maple_device *mdev;
> +	struct maple_driver *mdrv;
> +	int proberes;
> +
> +	mdev = to_maple_dev(dev);
> +	mdrv = to_maple_driver(dev->driver);
> +
> +	proberes = dc_kbd_connect(mdev);
> +	if (unlikely(proberes))
> +		return proberes;
> +	mdev->driver = mdrv;
> +	mdev->registered = 1;
> +	return 0;
> +}
> +
> +static struct maple_driver dc_kbd_driver = {
> +	.function = MAPLE_FUNC_KEYBOARD,
> +	.connect = dc_kbd_connect,
> +	.disconnect = dc_kbd_disconnect,
> +	.drv = {
> +		.name = "Dreamcast_keyboard",
> +		.probe = probe_maple_kbd,
> +		},
> +};
> +
> +static int __init dc_kbd_init(void)
> +{
> +	int retval;
> +	retval = maple_driver_register(&dc_kbd_driver.drv);
> +	if (retval)
> +		return retval;
> +	return 0;

"return maple_driver_register(&dc_kbd_driver.drv);" is much shorter...

> +}
> +
> +static void __exit dc_kbd_exit(void)
> +{
> +	driver_unregister(&dc_kbd_driver.drv);
> +}
> +
> +module_init(dc_kbd_init);
> +module_exit(dc_kbd_exit);

If these are fixed you may add:

	 Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thank you.

-- 
Dmitry
