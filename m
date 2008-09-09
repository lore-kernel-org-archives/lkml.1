Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYIIXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYIIXbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYIIXbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:31:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:35983 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbYIIXbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:31:04 -0400
Date: Tue, 9 Sep 2008 17:30:57 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 04/18] lirc driver for 2nd-gen and later Media Center
 Ed. USB IR transceivers
Message-ID: <20080909173057.6d93a7ef@bike.lwn.net>
In-Reply-To: <1220933164-10160-5-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
	<1220933164-10160-5-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Sep 2008 00:05:49 -0400
Jarod Wilson <jwilson@redhat.com> wrote:

> +/*
> + * LIRC driver for Philips eHome USB Infrared Transceiver
> + * and the Microsoft MCE 2005 Remote Control
> + *
> + * (C) by Martin A. Blatter <martin_a_blatter@yahoo.com>
> + *
> + * Transmitter support and reception code cleanup.
> + * (C) by Daniel Melander <lirc@rajidae.se>

As I understand it, proper assertions of copyright need the word
"copyright" and a year; the "(C)" trigraph doesn't have any legal meaning.

> + * This driver will only work reliably with kernel version 2.6.10
> + * or higher, probably because of differences in USB device enumeration
> + * in the kernel code. Device initialization fails most of the time
> + * with earlier kernel versions.

My guess is that this will not be a major impediment to mainline inclusion;
this comment can probably go.

> +/* lock irctl structure */
> +#define IRLOCK		mutex_lock(&ir->lock)
> +#define IRUNLOCK	mutex_unlock(&ir->lock)

Might I request that these go away?  They can only obfuscate the code.

> +/* init strings */
> +static char init1[] = {0x00, 0xff, 0xaa, 0xff, 0x0b};
> +static char init2[] = {0xff, 0x18};
> +
> +static char pin_init1[] = { 0x9f, 0x07};
> +static char pin_init2[] = { 0x9f, 0x13};
> +static char pin_init3[] = { 0x9f, 0x0d};

Documentation here would be nice; what do these magic numbers do?

> +/* request incoming or send outgoing usb packet - used to initialize remote */
> +static void request_packet_async(struct irctl *ir,
> +				 struct usb_endpoint_descriptor *ep,
> +				 unsigned char *data, int size, int urb_type)

What is the locking regime for this function?  As far as I can tell, it's
called with no locking at all, even though it's manipulating the irctl
structure. 

> +{
...
> +				if (urb_type == PHILUSB_OUTBOUND) {
> +					/* outbound data */
> +					usb_fill_int_urb(async_urb, ir->usbdev,
> +						usb_sndintpipe(ir->usbdev,
> +							ep->bEndpointAddress),
> +					async_buf,
> +					size,
> +					(usb_complete_t) usb_async_callback,
> +					ir, ep->bInterval);

This kind of formatting suggests that, just maybe, the control structures
in this function have been nested too deeply.

> +static int unregister_from_lirc(struct irctl *ir)
> +{
> +	struct lirc_plugin *p = ir->p;
> +	int devnum;
> +	int rtn;
> +
> +	devnum = ir->devnum;
> +	dprintk(DRIVER_NAME "[%d]: unregister from lirc called\n", devnum);
> +
> +	rtn = lirc_unregister_plugin(p->minor);
> +	if (rtn > 0) {
> +		printk(DRIVER_NAME "[%d]: error in lirc_unregister minor: %d\n"
> +			"Trying again...\n", devnum, p->minor);
> +		if (rtn == -EBUSY) {
> +			printk(DRIVER_NAME
> +				"[%d]: device is opened, will unregister"
> +				" on close\n", devnum);
> +			return -EAGAIN;
> +		}
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(HZ);
> +
> +		rtn = lirc_unregister_plugin(p->minor);
> +		if (rtn > 0)
> +			printk(DRIVER_NAME "[%d]: lirc_unregister failed\n",
> +			devnum);
> +	}

Looking at lirc_unregister_plugin(), I don't see any cause of failure that
could be expected to go away one second later.  But this code has the look
of something somebody actually needed once upon a time.  Am I missing
something?  It seems there should be a better way.

> +static int set_use_inc(void *data)
> +{
> +	struct irctl *ir = data;
> +
> +	if (!ir) {
> +		printk(DRIVER_NAME "[?]: set_use_inc called with no context\n");
> +		return -EIO;
> +	}
> +	dprintk(DRIVER_NAME "[%d]: set use inc\n", ir->devnum);
> +
> +	if (!ir->flags.connected) {
> +		if (!ir->usbdev)
> +			return -ENOENT;
> +		ir->flags.connected = 1;
> +	}
> +
> +	return SUCCESS;
> +}
> +
> +static void set_use_dec(void *data)
> +{
> +	struct irctl *ir = data;
> +
> +	if (!ir) {
> +		printk(DRIVER_NAME "[?]: set_use_dec called with no context\n");
> +		return;
> +	}
> +	dprintk(DRIVER_NAME "[%d]: set use dec\n", ir->devnum);
> +
> +	if (ir->flags.connected) {
> +		IRLOCK;
> +		ir->flags.connected = 0;
> +		IRUNLOCK;
> +	}
> +}

One function sets ir->flags.connected under lock, the other does not.  Is
that what was intended?

Also, set_use_inc() is returning a normal zero-or-negative-error status to
an outside caller.  It shouldn't return a locally-defined symbol like
SUCCESS.  I'd just use "return 0;". 

> +static ssize_t lirc_write(struct file *file, const char *buf,
> +			  size_t n, loff_t *ppos)
> +{
> +	int i, count = 0, cmdcount = 0;
> +	struct irctl *ir = NULL;
> +	int wbuf[LIRCBUF_SIZE]; /* Workbuffer with values from lirc */
> +	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
> +	unsigned long signal_duration = 0; /* Singnal length in us */
> +	struct timeval start_time, end_time;

That looks like roughly 1400 bytes on the stack - on a 32-bit system.

[...]

> +	/* delay with the closest number of ticks */
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(usecs_to_jiffies(signal_duration));

Why do you need to delay here?  And wouldn't something like msleep() be a
better way to do it?

lirc_write() seems short on locking.

> +static void set_transmitter_mask(struct irctl *ir, unsigned int mask)
> +{
> +	if (ir->flags.transmitter_mask_inverted)
> +		ir->transmitter_mask = (mask != 0x03 ? mask ^ 0x03 : mask) << 1;
> +	else
> +		ir->transmitter_mask = mask;
> +}

What this short function is doing is not entirely obvious to me.

> +/* Sets the send carrier frequency */
> +static int set_send_carrier(struct irctl *ir, int carrier)
> +{
> +	int clk = 10000000;
> +	int prescaler = 0, divisor = 0;
> +	unsigned char cmdbuf[] = { 0x9F, 0x06, 0x01, 0x80 };

And this sequence of magic numbers does...?

> +static int lirc_ioctl(struct inode *node, struct file *filep,
> +		      unsigned int cmd, unsigned long arg)
> +{
> +	int result;
> +	unsigned int ivalue;
> +	unsigned long lvalue;
> +	struct irctl *ir = NULL;
> +
> +	/* Retrieve lirc_plugin data for the device */
> +	ir = lirc_get_pdata(filep);
> +	if (!ir && !ir->usb_ep_out)
> +		return -EFAULT;
> +
> +
> +	switch (cmd) {
> +	case LIRC_SET_TRANSMITTER_MASK:
> +
> +		result = get_user(ivalue, (unsigned int *) arg);
> +		if (result)
> +			return result;
> +		switch (ivalue) {
> +		case 0x01: /* Transmitter 1     => 0x04 */
> +		case 0x02: /* Transmitter 2     => 0x02 */
> +		case 0x03: /* Transmitter 1 & 2 => 0x06 */
> +			set_transmitter_mask(ir, ivalue);
> +			break;
> +
> +		default: /* Unsupported transmitter mask */
> +			return MCE_MAX_CHANNELS;
> +		}
> +
> +		dprintk(DRIVER_NAME ": SET_TRANSMITTERS mask=%d\n", ivalue);
> +		break;
> +
> +	case LIRC_GET_SEND_MODE:
> +
> +		result = put_user(LIRC_SEND2MODE(LIRC_CAN_SEND_PULSE &
> +						 LIRC_CAN_SEND_MASK),
> +				  (unsigned long *) arg);
> +
> +		if (result)
> +			return result;
> +		break;
> +
> +	case LIRC_SET_SEND_MODE:
> +
> +		result = get_user(lvalue, (unsigned long *) arg);
> +
> +		if (result)
> +			return result;
> +		if (lvalue != (LIRC_MODE_PULSE&LIRC_CAN_SEND_MASK))
> +			return -EINVAL;
> +		break;
> +
> +	case LIRC_SET_SEND_CARRIER:
> +
> +		result = get_user(ivalue, (unsigned int *) arg);
> +		if (result)
> +			return result;
> +
> +		set_send_carrier(ir, ivalue);
> +		break;
> +
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct file_operations lirc_fops = {
> +	.write	= lirc_write,
> +};

My first reaction here was that .ioctl=lirc_ioctl is missing.  But, of
course, it's the plugin ioctl() function instead.  I still think that needs
some cleaning up.

> +static int usb_remote_probe(struct usb_interface *intf,
> +				const struct usb_device_id *id)
> +{

[...]

> +mem_failure_switch:
> +
> +	/* free allocated memory incase of failure */
> +	switch (mem_failure) {
> +	case 9:
> +		usb_free_urb(ir->urb_in);
> +	case 7:
> +		usb_buffer_free(dev, maxp, ir->buf_in, ir->dma_in);
> +	case 5:
> +		lirc_buffer_free(rbuf);
> +	case 4:
> +		kfree(rbuf);
> +	case 3:
> +		kfree(plugin);
> +	case 2:
> +		kfree(ir);
> +	case 1:
> +		printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n",
> +			devnum, mem_failure);
> +		return -ENOMEM;
> +	}

Usually this kind of error recovery is handled at the end of the function
with a series of cascading goto labels.  To find it wedged into the middle
of this (very long) function as a switch is a bit disorienting.  Normal
execution will just route around the whole thing via the (missing) default
branch.  I think it would be better to put it at the end and use the normal
conventions that everybody knows how to read.

> +	plugin->minor = minor;
> +	ir->p = plugin;
> +	ir->devnum = devnum;
> +	ir->usbdev = dev;
> +	ir->len_in = maxp;
> +	ir->flags.connected = 0;
> +	ir->flags.pinnacle = is_pinnacle;
> +	ir->flags.transmitter_mask_inverted =
> +		usb_match_id(intf, transmitter_mask_list) ? 0 : 1;

At this point, the plugin is already registered, but you're still
initializing it.  Are you sure there's no potential for a race here?

> +#ifdef MODULE
> +static int __init usb_remote_init(void)
> +{

I'm curious: you don't need to initialize if not compiled as a module?

> +	int i;
> +
> +	printk(KERN_INFO "\n");
> +	printk(KERN_INFO DRIVER_NAME ": " DRIVER_DESC " " DRIVER_VERSION "\n");
> +	printk(KERN_INFO DRIVER_NAME ": " DRIVER_AUTHOR "\n");
> +	dprintk(DRIVER_NAME ": debug mode enabled\n");
> +
> +	request_module("lirc_dev");

You're calling functions from lirc_dev.c, so modprobe will not load this
module until lirc_dev is already there.  There's no point in trying to load
it explicitly with request_module().

> +	i = usb_register(&usb_remote_driver);
> +	if (i < 0) {
> +		printk(DRIVER_NAME ": usb register failed, result = %d\n", i);
> +		return -ENODEV;
> +	}
> +
> +	return SUCCESS;
> +}

"return 0;" please.

jon
