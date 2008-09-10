Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYIJVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYIJVCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYIJVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:02:36 -0400
Received: from vena.lwn.net ([206.168.112.25]:38136 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYIJVCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:02:34 -0400
Date: Wed, 10 Sep 2008 15:02:29 -0600
From: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Message-ID: <20080910150229.2b4f990d@bike.lwn.net>
In-Reply-To: <1220933164-10160-9-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
	<1220933164-10160-5-git-send-email-jwilson@redhat.com>
	<1220933164-10160-6-git-send-email-jwilson@redhat.com>
	<1220933164-10160-7-git-send-email-jwilson@redhat.com>
	<1220933164-10160-8-git-send-email-jwilson@redhat.com>
	<1220933164-10160-9-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define SUCCESS		0
> +#define	TRUE		1
> +#define FALSE		0

(See my grumble in previous reviews...:)

> +#define LOCK_CONTEXT	mutex_lock(&context->lock)
> +#define UNLOCK_CONTEXT	mutex_unlock(&context->lock)

Here too.

> +/* to prevent races between open() and disconnect() */
> +static DECLARE_MUTEX(disconnect_sem);

This should be a real mutex, I think.

> +/* lcd or vfd? */
> +static int is_lcd;

The driver can only do one or the other?  You can't have both in the
system?  And somehow the user is supposed to configure it at load time to
do the right thing?

> +/**
> + * Sends a packet to the VFD.
> + */
> +static inline int send_packet(struct imon_context *context)
> +{
> +	unsigned int pipe;
> +	int interval = 0;
> +	int retval = SUCCESS;
> +	struct usb_ctrlrequest *control_req = NULL;
> +
> +	/* Check if we need to use control or interrupt urb */
> +	if (!context->tx_control) {
> +		pipe = usb_sndintpipe(context->dev,
> +				      context->tx_endpoint->bEndpointAddress);
> +		interval = context->tx_endpoint->bInterval;
> +
> +		usb_fill_int_urb(context->tx_urb, context->dev, pipe,
> +				 context->usb_tx_buf,
> +				 sizeof(context->usb_tx_buf),
> +				 usb_tx_callback, context, interval);
> +
> +		context->tx_urb->actual_length = 0;
> +	} else {
> +		/* fill request into kmalloc'ed space: */
> +		control_req = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);

Why GFP_NOIO?

> +		if (control_req == NULL)
> +			return -ENOMEM;
> +
> +		/* setup packet is '21 09 0200 0001 0008' */
> +		control_req->bRequestType = 0x21;
> +		control_req->bRequest = 0x09;
> +		control_req->wValue = cpu_to_le16(0x0002);
> +		control_req->wIndex = cpu_to_le16(0x0100);
> +		control_req->wLength = cpu_to_le16(0x0800);
> +
> +		/* control pipe is endpoint 0x00 */
> +		pipe = usb_sndctrlpipe(context->dev, 0);
> +
> +		/* build the control urb */
> +		usb_fill_control_urb(context->tx_urb, context->dev, pipe,
> +				     (unsigned char *)control_req,
> +				     context->usb_tx_buf,
> +				     sizeof(context->usb_tx_buf),
> +				     usb_tx_callback, context);
> +		context->tx_urb->actual_length = 0;
> +	}
> +
> +	init_completion(&context->tx.finished);
> +	atomic_set(&(context->tx.busy), 1);
> +
> +	retval =  usb_submit_urb(context->tx_urb, GFP_KERNEL);
> +	if (retval != SUCCESS) {
> +		atomic_set(&(context->tx.busy), 0);
> +		err("%s: error submitting urb(%d)", __func__, retval);
> +	} else {
> +		/* Wait for tranmission to complete(or abort) */
> +		UNLOCK_CONTEXT;
> +		wait_for_completion(&context->tx.finished);
> +		LOCK_CONTEXT;

Should that be an interruptible (or killable) wait?

> +static ssize_t show_associate_remote(struct device *d,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct imon_context *context = dev_get_drvdata(d);
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	if (context->ir_isassociating) {
> +		strcpy(buf, "The device it associating press some button "
> +			    "on the remote.\n");
> +	} else if (context->ir_isopen) {
> +		strcpy(buf, "Device is open and ready to associate.\n"
> +			    "Echo something into this file to start "
> +			    "the process.\n");
> +	} else {
> +		strcpy(buf, "Device is closed, you need to open it to "
> +			    "associate the remote(you can use irw).\n");
> +	}
> +	return strlen(buf);
> +}

I *guess* that's one value per file, but it's still not quite the sysfs
norm.  How about one-word status codes which can be made more verbose by
user space?  (That's an API change, of course...)

> +static ssize_t store_associate_remote(struct device *d,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct imon_context *context;
> +
> +	context = dev_get_drvdata(d);
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	if (!context->ir_isopen)
> +		return -EINVAL;
> +
> +	if (context->ir_isopen) {
> +		context->ir_isassociating = TRUE;
> +		send_associate_24g(context);
> +	}
> +
> +	return count;
> +}

No need to take the mutex here?

> +/**
> + * Called by lirc_dev when the application opens /dev/lirc
> + */
> +static int ir_open(void *data)
> +{
> +	int retval = SUCCESS;
> +	struct imon_context *context;
> +
> +	/* prevent races with disconnect */
> +	down(&disconnect_sem);
> +
> +	context = (struct imon_context *) data;
> +
> +	LOCK_CONTEXT;
> +
> +	if (context->ir_isopen) {
> +		err("%s: IR port is already open", __func__);
> +		retval = -EBUSY;
> +		goto exit;
> +	}

I wonder if the single-open semantics are really doing what the author
intended?  It is unsufficient to prevent concurrent calls elsewhere.

> +	/* initial IR protocol decode variables */
> +	context->rx.count = 0;
> +	context->rx.initial_space = 1;
> +	context->rx.prev_bit = 0;
> +
> +	usb_fill_int_urb(context->rx_urb, context->dev,
> +		usb_rcvintpipe(context->dev,
> +				context->rx_endpoint->bEndpointAddress),
> +		context->usb_rx_buf, sizeof(context->usb_rx_buf),
> +		usb_rx_callback, context, context->rx_endpoint->bInterval);
> +
> +	retval = usb_submit_urb(context->rx_urb, GFP_KERNEL);
> +
> +	if (retval)
> +		err("%s: usb_submit_urb failed for ir_open(%d)",
> +		    __func__, retval);
> +	else {
> +		context->ir_isopen = TRUE;
> +		info("IR port opened");
> +	}
> +
> +exit:
> +	UNLOCK_CONTEXT;
> +
> +	up(&disconnect_sem);
> +	return SUCCESS;
> +}

This discards "retval", which could hold an error status - the function
returns "SUCCESS" even if ->ir_isopen is not set.

> +/**
> + * Callback function for USB core API: disonnect
> + */
> +static void imon_disconnect(struct usb_interface *interface)
> +{
> +	struct imon_context *context;
> +
> +	/* prevent races with ir_open()/vfd_open() */
> +	down(&disconnect_sem);
> +
> +	context = usb_get_intfdata(interface);
> +	LOCK_CONTEXT;
> +
> +	info("%s: iMON device disconnected", __func__);
> +
> +	/* sysfs_remove_group is safe to call even if sysfs_create_group
> +	 * hasn't been called */
> +	sysfs_remove_group(&interface->dev.kobj,
> +			   &imon_attribute_group);
> +	usb_set_intfdata(interface, NULL);
> +	context->dev_present = FALSE;
> +
> +	/* Stop reception */
> +	usb_kill_urb(context->rx_urb);
> +
> +	/* Abort ongoing write */
> +	if (atomic_read(&context->tx.busy)) {
> +		usb_kill_urb(context->tx_urb);
> +		wait_for_completion(&context->tx.finished);
> +	}

What if this races with another thread waiting for the completion?  It
seems like it should be completed with complete_all(), but that wasn't the
case. 

