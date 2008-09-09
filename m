Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYIITVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYIITVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYIITVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:21:43 -0400
Received: from vena.lwn.net ([206.168.112.25]:48659 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYIITVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:21:42 -0400
Date: Tue, 9 Sep 2008 13:21:40 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 03/18] lirc driver for 1st-gen Media Center Ed. USB IR
 transceivers
Message-ID: <20080909132140.3c0adcca@bike.lwn.net>
In-Reply-To: <1220933164-10160-4-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config LIRC_MCEUSB
> +	tristate "Microsoft Media Center Ed. Receiver, v1"
> +	default n
> +	depends on LIRC_DEV
> +	help
> +	  Driver for the Microsoft Media Center Ed. Receiver, v1

A little more verbosity in these help texts might be nice.  

> + * 2003_11_11 - Restructured to minimalize code interpretation in the
> + *	      driver. The normal use case will be with lirc.
> + *
> + * 2004_01_01 - Removed all code interpretation. Generate mode2 data
> + *	      for passing off to lirc. Cleanup
> + *
> + * 2004_01_04 - Removed devfs handle. Put in a temporary workaround
> + *	      for a known issue where repeats generate two
> + *	      sequential spaces (last_was_repeat_gap)
> + *
> + * 2004_02_17 - Changed top level api to no longer use fops, and
> + *	      instead use new interface for polling via
> + *	      lirc_thread. Restructure data read/mode2 generation to
> + *	      a single pass, reducing number of buffers. Rev to .2
> + *
> + * 2004_02_27 - Last of fixups to plugin->add_to_buf API. Properly
> + *	      handle broken fragments from the receiver. Up the
> + *	      sample rate and remove any pacing from
> + *	      fetch_more_data. Fixes all known issues.

General convention is that this sort of changelog information belongs in
the SCM, not in the code.  That's doubly true for the USB skeleton driver
info.

> +#include <linux/smp_lock.h>

It doesn't look like this include is needed.

> +/* Structure to hold all of our device specific stuff */
> +struct usb_skel {

Perhaps renaming this structure to something more directly descriptive
would make sense?

> +	struct usb_device *udev; /* save off the usb device pointer */
> +	struct usb_interface *interface; /* the interface for this device */
> +	unsigned char minor;	 /* the starting minor number for this device */

Minor numbers don't necessarily fit in an unsigned char.

> +	unsigned char num_ports; /* the number of ports this device has */
> +	char num_interrupt_in;	 /* number of interrupt in endpoints */
> +	char num_bulk_in;	 /* number of bulk in endpoints */
> +	char num_bulk_out;	 /* number of bulk out endpoints */
> +
> +	unsigned char *bulk_in_buffer;	/* the buffer to receive data */
> +	int bulk_in_size;		/* the size of the receive buffer */
> +	__u8 bulk_in_endpointAddr;	/* the address of bulk in endpoint */
> +
> +	unsigned char *bulk_out_buffer;	/* the buffer to send data */
> +	int bulk_out_size;		/* the size of the send buffer */
> +	struct urb *write_urb;		/* the urb used to send data */
> +	__u8 bulk_out_endpointAddr;	/* the address of bulk out endpoint */
> +
> +	atomic_t write_busy;		/* true iff write urb is busy */
> +	struct completion write_finished; /* wait for the write to finish */
> +
> +	wait_queue_head_t wait_q; /* for timeouts */
> +	int open_count;		/* number of times this port has been opened */
> +	struct mutex sem;	/* locks this structure */

"sem" is not a semaphore; it should probably have a different name.

> +static void mceusb_setup(struct usb_device *udev)
> +{
> +	char data[8];
> +	int res;
> +
> +	memset(data, 0, 8);
> +
> +	/* Get Status */
> +	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +			      USB_REQ_GET_STATUS, USB_DIR_IN,
> +			      0, 0, data, 2, HZ * 3);

res is set many times in this function, but it is never checked.  It seems
to me like the addition of some error handling would be a good idea.

...

> +	/* These two are sent by the windows driver, but stall for
> +	 * me. I dont have an analyzer on the linux side so i can't
> +	 * see what is actually different and why the device takes
> +	 * issue with them
> +	 */

Hmm...how was that information obtained?  If this driver was
reverse-engineered, it would be good to know just what process was
followed. 

> +static int msir_fetch_more_data(struct usb_skel *dev, int dont_block)
> +{
...
> +			/* retry a few times on overruns; map all
> +			   other errors to -EIO */
> +			if (retval) {
> +				if (retval == -EOVERFLOW && retries < 5) {
> +					retries++;
> +					interruptible_sleep_on_timeout(
> +						&dev->wait_q, HZ);
> +					continue;

As others have noted, I think, getting new sleep_on() calls into the kernel
is kind of a hard sell.

> +/**
> + *	mceusb_probe
> + *
> + *	Called by the usb core when a new device is connected that it
> + *	thinks this driver might be interested in.
> + */
> +static int mceusb_probe(struct usb_interface *interface,
> +			const struct usb_device_id *id)
> +{

...
> +
> +	/* select a "subminor" number (part of a minor number) */
> +	down(&minor_table_mutex);

So...this driver has a mutex called "sem" and a semaphore called
"minor_table_mutex".  I suspect that minor_table_mutex should, in fact, be
a mutex.

...
> +error:
> +	mceusb_delete(dev);
> +	dev = NULL;
> +	dprintk("%s: retval = %x", __func__, retval);
> +	up(&minor_table_mutex);
> +	return retval;
> +}

This will leak the memory allocated for dev.  It also leaves the entry in
minor_table pointing to a nonfunctional device.

jon
