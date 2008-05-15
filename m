Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYEODup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYEODup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYEODud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:50:33 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4395 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYEODua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ugVjL1gC7U8RnSQolXOcXT4dq7r9ennz+LOVrV22P/wr5tIaLOLxNuxvzGm1v/kmlFHOhOQ1KU36eYL4qUKgWnW6rRZ3m315zYFifPgEfse5UcTHgyA/i2nP6d3a+02ImKToFB7yf8UNdRQVKByEvC6fuBP5K6XSKQMHkKEVu+k=
Date: Wed, 14 May 2008 23:50:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515035026.GA11067@anvil.corenet.prv>
References: <20080514221519.GA6575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514221519.GA6575@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, May 14, 2008 at 03:15:19PM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This driver was originally written by James McKenzie but forward ported
> and cleaned up by me to get it to work with modern kernel versions.
> 
> Tested on my mac mini and it actually works!
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
> 
> Jiri, is it ok for this quirks addtion to go through Dmitry's triee?  Or
> do you want me to split it out into two different patches?
> 
> Dmitry, is this ok to go through your tree?  Or I can take it as well if
> you don't want it :)
>

I'll take it, although I have a couple of comments.

> +
> +struct appleir {
> +	struct input_dev *input_dev;
> +	u8 *data;
> +	dma_addr_t dma_buf;
> +	struct usb_device *usbdev;
> +	struct urb *urb;
> +	int timer_initted;
> +	struct timer_list key_up_timer;
> +	int current_key;
> +	char phys[32];
> +};
> +
> +static struct usb_device_id appleir_ids[] = {
> +	{USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IR)},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(usb, appleir_ids);
> +
> +/* I have two devices both of which report the following */
> +/* 25 87 ee 83 0a  	+  */
> +/* 25 87 ee 83 0c  	-  */
> +/* 25 87 ee 83 09	<< */
> +/* 25 87 ee 83 06	>> */
> +/* 25 87 ee 83 05	>" */
> +/* 25 87 ee 83 03	menu */
> +/* 26 00 00 00 00	for key repeat*/
> +
> +/* Thomas Glanzmann reports the following responses */
> +/* 25 87 ee ca 0b	+  */
> +/* 25 87 ee ca 0d	-  */
> +/* 25 87 ee ca 08	<< */
> +/* 25 87 ee ca 07	>> */
> +/* 25 87 ee ca 04	>" */
> +/* 25 87 ee ca 02 	menu */
> +/* 26 00 00 00 00       for key repeat*/
> +/* He also observes the following event sometimes */
> +/* sent after a key is release, which I interpret */
> +/* as a flat battery message */
> +/* 25 87 e0 ca 06	flat battery */
> +
> +static int keymap[MAX_KEYS] = {
> +	KEY_RESERVED,
> +	KEY_MENU,
> +	KEY_PLAYPAUSE,
> +	KEY_NEXTSONG,
> +	KEY_PREVIOUSSONG,
> +	KEY_VOLUMEUP,
> +	KEY_VOLUMEDOWN,
> +	KEY_RESERVED,
> +};
> +
> +static void dump_packet(struct appleir *appleir, char *msg, u8 *data, int len)
> +{
> +	int i;
> +
> +	printk(KERN_ERR "appleir: %s (%d bytes)", msg, len);
> +
> +	for (i = 0; i < len; ++i)
> +		printk(" %02x", data[i]);
> +	printk("\n");
> +}
> +
> +static void key_up(struct appleir *appleir, int key)
> +{
> +	/* printk (KERN_ERR "key %d up\n", key); */
> +	input_report_key(appleir->input_dev, key, 0);
> +	input_sync(appleir->input_dev);
> +}
> +
> +static void key_down(struct appleir *appleir, int key)
> +{
> +	/* printk (KERN_ERR "key %d down\n", key); */
> +	input_report_key(appleir->input_dev, key, 1);
> +	input_sync(appleir->input_dev);
> +}
> +
> +static void battery_flat(struct appleir *appleir)
> +{
> +	dev_err(&appleir->input_dev->dev, "possible flat battery?\n");
> +}
> +
> +static void key_up_tick(unsigned long data)
> +{
> +	struct appleir *appleir = (struct appleir *)data;
> +
> +	if (appleir->current_key) {
> +		key_up(appleir, appleir->current_key);
> +		appleir->current_key = 0;
> +	}
> +}
> +
> +static void new_data(struct appleir *appleir, u8 *data, int len)
> +{
> +	static const u8 keydown[] = { 0x25, 0x87, 0xee };
> +	static const u8 keyrepeat[] = { 0x26, 0x00, 0x00, 0x00, 0x00 };
> +	static const u8 flatbattery[] = { 0x25, 0x87, 0xe0 };
> +
> +#if 0
> +	dump_packet(appleir, "received", data, len);
> +#endif
> +
> +	if (len != 5)
> +		return;
> +
> +	if (!memcmp(data, keydown, sizeof(keydown))) {
> +		/*If we already have a key down, take it up before marking */
> +		/*this one down */
> +		if (appleir->current_key)
> +			key_up(appleir, appleir->current_key);
> +		appleir->current_key = keymap[(data[4] >> 1) & MAX_KEYS_MASK];
> +
> +		key_down(appleir, appleir->current_key);
> +		/*remote doesn't do key up, either pull them up, in the test */
> +		/*above, or here set a timer which pulls them up after 1/8 s */
> +		mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
> +
> +		return;
> +	}
> +
> +	if (!memcmp(data, keyrepeat, sizeof(keyrepeat))) {
> +		key_down(appleir, appleir->current_key);

Repeats are usually transmitted as an event different from normal
key down (event values for repeat is 2 vs 1 for key down).

> +		/*remote doesn't do key up, either pull them up, in the test */
> +		/*above, or here set a timer which pulls them up after 1/8 s */
> +		mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
> +		return;
> +	}
> +
> +	if (!memcmp(data, flatbattery, sizeof(flatbattery))) {
> +		battery_flat(appleir);
> +		/* Fall through */
> +	}
> +
> +	dump_packet(appleir, "unknown packet", data, len);
> +}
> +
> +static void appleir_urb(struct urb *urb)
> +{
> +	struct appleir *appleir = urb->context;
> +	int status = urb->status;
> +	int retval;
> +
> +	switch (status) {
> +	case 0:
> +		new_data(appleir, urb->transfer_buffer, urb->actual_length);
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +		/* this urb is terminated, clean up */
> +		dbg("%s - urb shutting down with status: %d", __func__,
> +		    urb->status);
> +		return;
> +	default:
> +		dbg("%s - nonzero urb status received: %d", __func__,
> +		    urb->status);
> +	}
> +
> +	retval = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (retval)
> +		err("%s - usb_submit_urb failed with result %d", __func__,
> +		    retval);
> +}
> +
> +static int appleir_open(struct input_dev *dev)
> +{
> +	struct appleir *appleir = input_get_drvdata(dev);
> +
> +	if (usb_submit_urb(appleir->urb, GFP_KERNEL))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static void appleir_close(struct input_dev *dev)
> +{
> +	struct appleir *appleir = input_get_drvdata(dev);
> +
> +	usb_kill_urb(appleir->urb);
> +	del_timer_sync(&appleir->key_up_timer);
> +}
> +
> +static int appleir_probe(struct usb_interface *intf,
> +			 const struct usb_device_id *id)
> +{
> +	struct usb_device *dev = interface_to_usbdev(intf);
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct appleir *appleir = NULL;

The assigment is not needed.

> +	struct input_dev *input_dev;
> +	int retval = -ENOMEM;
> +	int i;
> +
> +	appleir = kzalloc(sizeof(struct appleir), GFP_KERNEL);
> +	if (!appleir)
> +		goto fail;
> +
> +	appleir->data = usb_buffer_alloc(dev, URB_SIZE, GFP_KERNEL,
> +					 &appleir->dma_buf);
> +	if (!appleir->data)
> +		goto fail;
> +
> +	appleir->urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!appleir->urb)
> +		goto fail;
> +
> +	appleir->usbdev = dev;
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev)
> +		goto fail;
> +
> +	appleir->input_dev = input_dev;
> +
> +	usb_make_path(dev, appleir->phys, sizeof(appleir->phys));
> +	strlcpy(appleir->phys, "/input0", sizeof(appleir->phys));
> +
> +	input_dev->name = "Apple Mac mini infrared remote control driver";
> +	input_dev->phys = appleir->phys;
> +	usb_to_input_id(dev, &input_dev->id);
> +	input_dev->dev.parent = &intf->dev;
> +	input_set_drvdata(input_dev, appleir);
> +
> +	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
> +	input_dev->ledbit[0] = 0;
> +
> +	for (i = 0; i < MAX_KEYS; i++)
> +		set_bit(keymap[i], input_dev->keybit);
> +
> +	clear_bit(0, input_dev->keybit);
> +
> +	input_dev->open = appleir_open;
> +	input_dev->close = appleir_close;
> +
> +	endpoint = &intf->cur_altsetting->endpoint[0].desc;
> +
> +	usb_fill_int_urb(appleir->urb, dev,
> +			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
> +			 appleir->data, 8,
> +			 appleir_urb, appleir, endpoint->bInterval);
> +
> +	appleir->urb->transfer_dma = appleir->dma_buf;
> +	appleir->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	usb_set_intfdata(intf, appleir);
> +
> +	init_timer(&appleir->key_up_timer);
> +
> +	appleir->key_up_timer.function = key_up_tick;
> +	appleir->key_up_timer.data = (unsigned long)appleir;
> +
> +	appleir->timer_initted++;
> +
> +	retval = input_register_device(appleir->input_dev);
> +	if (retval)
> +		goto fail;
> +
> +	return 0;
> +
> +fail:
> +	if (appleir) {
> +		if (appleir->data)
> +			usb_buffer_free(dev, URB_SIZE, appleir->data,
> +					appleir->dma_buf);
> +
> +		if (appleir->timer_initted)
> +			del_timer_sync(&appleir->key_up_timer);

You dont need to do it here. The timer is guranteed to be not running
since it is starte din ->open().

> +
> +		if (appleir->input_dev)
> +			input_free_device(appleir->input_dev);
> +
> +		kfree(appleir);
> +	}
> +
> +	return retval;
> +}
> +
> +static void appleir_disconnect(struct usb_interface *intf)
> +{
> +	struct appleir *appleir = usb_get_intfdata(intf);
> +
> +	usb_set_intfdata(intf, NULL);
> +	if (appleir) {
> +		input_unregister_device(appleir->input_dev);
> +		if (appleir->timer_initted)
> +			del_timer_sync(&appleir->key_up_timer);
> +		usb_kill_urb(appleir->urb);

Already done in ->close()

> +		usb_free_urb(appleir->urb);
> +		usb_buffer_free(interface_to_usbdev(intf), URB_SIZE,
> +				appleir->data, appleir->dma_buf);
> +		kfree(appleir);
> +	}
> +}
> +
> +static struct usb_driver appleir_driver = {
> +	.name = "appleir",
> +	.probe = appleir_probe,
> +	.disconnect = appleir_disconnect,
> +	.id_table = appleir_ids,
> +};
> +
> +static int __init appleir_init(void)
> +{
> +	int retval;
> +
> +	retval = usb_register(&appleir_driver);
> +	if (retval)
> +		goto out;
> +	info(DRIVER_VERSION ":" DRIVER_DESC);

Do we need to print the driver identification? I personally like drivers
to be silent unless they find a device but if you prefer to have it
that's fine.

-- 
Dmitry
