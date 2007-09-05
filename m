Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXIEDOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXIEDOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 23:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXIEDOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 23:14:44 -0400
Received: from mxsf01.insightbb.com ([74.128.0.71]:33880 "EHLO
	mxsf01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXIEDOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 23:14:43 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 23:14:43 EDT
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="22593720"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEO53UZKhRO4/2dsb2JhbACBWQ
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="113341117"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Subject: Re: [PATCH] Add support for keyboard on SEGA Dreamcast
Date: Tue, 4 Sep 2007 23:04:50 -0400
User-Agent: KMail/1.9.3
Cc: Paul Mundt <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
In-Reply-To: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709042304.51510.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Tuesday 04 September 2007 19:34, Adrian McMenamin wrote:
> This patch will add support for the Dreamcast keyboard when used
> alongside the maple bus patch (http://lkml.org/lkml/2007/9/4/165) and
> the pvr2 patch.
> 
> Signed off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>

Thnank you very much for your patch. Couple of comments:
 
> +
> +static unsigned char dc_kbd_keycode[256] = {

Const?

> +
> +static int dc_kbd_connect(struct maple_device *dev)
> +{
> +	int i, retval;
> +	unsigned long data = be32_to_cpu(dev->devinfo.function_data[0]);
> +	struct dc_kbd *kbd;
> +	if (dev->function != MAPLE_FUNC_KEYBOARD)
> +		return -EINVAL;
> +
> +	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
> +	if (unlikely(!kbd))
> +		return -ENOMEM;
> +
> +	dev->private_data = kbd;
> +	kbd->dev = input_allocate_device();
> +	if (unlikely(!kbd->dev))
> +		goto cleanup;
> +
> +	kbd->dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
> +
> +	for (i = 0; i < 255; i++)
> +		set_bit(dc_kbd_keycode[i], kbd->dev->keybit);
> +
> +	clear_bit(0, kbd->dev->keybit);
> +
> +	kbd->dev->private = kbd;
> +
> +	kbd->dev->name = dev->product_name;
> +	kbd->dev->id.bustype = BUS_MAPLE;

Do we really need a new bus type? Would not BUS_HOST suffice?

> +
> +	retval = input_register_device(kbd->dev);
> +	if (unlikely(retval))
> +		goto cleanup;
> +
> +	maple_getcond_callback(dev, dc_kbd_callback, (25 * HZ) / 1000,
> +			       MAPLE_FUNC_KEYBOARD);
> +
> +	printk(KERN_INFO "input: keyboard(0x%lx): %s\n", data,
> +	       kbd->dev->name);

Input core already prints a line when a new input device is registered,
do we need another one?

> +
> +	return 0;
> +
> +      cleanup:
> +	kfree(kbd);
> +	return -EINVAL;

It loks like call to input_free_device() is missing here. You would leak
memory if input_register_device would fail. 

I would also get rid of all likelys/unlikelys here - driver registration is
not a hot path...

> +}
> +
> +static void dc_kbd_disconnect(struct maple_device *dev)
> +{
> +	struct dc_kbd *kbd = dev->private_data;
> +
> +	input_unregister_device(kbd->dev);
> +	kfree(kbd);

Are we guaranteed that the dc_kbd_callback is not running in a separate
thread?

Please also consider implementing support for changing keyma. Since
the keymap is pretty full I think the best way is to copy the vanilla
keymap into a per-device memory and set up keymap, keycodesize and
keycodemax in input device structure.

Thank you.

-- 
Dmitry
