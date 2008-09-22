Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYIVVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYIVVsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYIVVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:48:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbYIVVsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:48:03 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Date: Mon, 22 Sep 2008 17:47:56 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-9-git-send-email-jwilson@redhat.com> <20080910150229.2b4f990d@bike.lwn.net>
In-Reply-To: <20080910150229.2b4f990d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221747.57170.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 17:02:29 Jonathan Corbet wrote:
> > +#define SUCCESS		0
> > +#define	TRUE		1
> > +#define FALSE		0
>
> (See my grumble in previous reviews...:)
>
> > +#define LOCK_CONTEXT	mutex_lock(&context->lock)
> > +#define UNLOCK_CONTEXT	mutex_unlock(&context->lock)
>
> Here too.

All gone.

> > +/* to prevent races between open() and disconnect() */
> > +static DECLARE_MUTEX(disconnect_sem);
>
> This should be a real mutex, I think.

Done.

> > +/* lcd or vfd? */
> > +static int is_lcd;
>
> The driver can only do one or the other?  You can't have both in the
> system?  And somehow the user is supposed to configure it at load time to
> do the right thing?

Should be autodetected by default now, based on usb device ID, but can still 
be overridden by a module para 'display_type'. Not sure exactly what would 
happen if the user had more than one, but I don't know why they would in the 
first place...

> > +static inline int send_packet(struct imon_context *context)
[...]
> > +		/* fill request into kmalloc'ed space: */
> > +		control_req = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
>
> Why GFP_NOIO?

Original author probably thought it was necessary. Certainly doesn't look like 
it is to me, I'll make that just GFP_KERNEL.

> > +	} else {
> > +		/* Wait for tranmission to complete(or abort) */
> > +		UNLOCK_CONTEXT;
> > +		wait_for_completion(&context->tx.finished);
> > +		LOCK_CONTEXT;
>
> Should that be an interruptible (or killable) wait?

Don't see why it couldn't be. Done.

> > +static ssize_t show_associate_remote(struct device *d,
> > +				     struct device_attribute *attr,
> > +				     char *buf)
> > +{
> > +	struct imon_context *context = dev_get_drvdata(d);
> > +
> > +	if (!context)
> > +		return -ENODEV;
> > +
> > +	if (context->ir_isassociating) {
> > +		strcpy(buf, "The device it associating press some button "
> > +			    "on the remote.\n");
> > +	} else if (context->ir_isopen) {
> > +		strcpy(buf, "Device is open and ready to associate.\n"
> > +			    "Echo something into this file to start "
> > +			    "the process.\n");
> > +	} else {
> > +		strcpy(buf, "Device is closed, you need to open it to "
> > +			    "associate the remote(you can use irw).\n");
> > +	}
> > +	return strlen(buf);
> > +}
>
> I *guess* that's one value per file, but it's still not quite the sysfs
> norm.  How about one-word status codes which can be made more verbose by
> user space?  (That's an API change, of course...)

Yuk. There really is no user space. But chances of someone stumbling upon 
these directions in sysfs are pretty slim. Reducing to single-word, and 
logging a url pointer to the lirc.org page on setting these up. Sound sane 
enough?

> > +static ssize_t store_associate_remote(struct device *d,
> > +				      struct device_attribute *attr,
> > +				      const char *buf, size_t count)
> > +{
> > +	struct imon_context *context;
> > +
> > +	context = dev_get_drvdata(d);
> > +
> > +	if (!context)
> > +		return -ENODEV;
> > +
> > +	if (!context->ir_isopen)
> > +		return -EINVAL;
> > +
> > +	if (context->ir_isopen) {
> > +		context->ir_isassociating = TRUE;
> > +		send_associate_24g(context);
> > +	}
> > +
> > +	return count;
> > +}
>
> No need to take the mutex here?

Added mutex here and in show_associate_remote() for good measure.

> > +/**
> > + * Called by lirc_dev when the application opens /dev/lirc
> > + */
> > +static int ir_open(void *data)
> > +{
> > +	int retval = SUCCESS;
> > +	struct imon_context *context;
> > +
> > +	/* prevent races with disconnect */
> > +	down(&disconnect_sem);
> > +
> > +	context = (struct imon_context *) data;
> > +
> > +	LOCK_CONTEXT;
> > +
> > +	if (context->ir_isopen) {
> > +		err("%s: IR port is already open", __func__);
> > +		retval = -EBUSY;
> > +		goto exit;
> > +	}
>
> I wonder if the single-open semantics are really doing what the author
> intended?  It is unsufficient to prevent concurrent calls elsewhere.

I think we're good to go with disconnect_sem being converted to an actual 
mutex, no?

> > +exit:
> > +	UNLOCK_CONTEXT;
> > +
> > +	up(&disconnect_sem);
> > +	return SUCCESS;
> > +}
>
> This discards "retval", which could hold an error status - the function
> returns "SUCCESS" even if ->ir_isopen is not set.

Gah. That's fugly. Fixed.

> > +static void imon_disconnect(struct usb_interface *interface)
[...]
> > +	/* Abort ongoing write */
> > +	if (atomic_read(&context->tx.busy)) {
> > +		usb_kill_urb(context->tx_urb);
> > +		wait_for_completion(&context->tx.finished);
> > +	}
>
> What if this races with another thread waiting for the completion?  It
> seems like it should be completed with complete_all(), but that wasn't the
> case.

Agreed. At this point, we're disconnecting, no point in waiting on anyone 
else.

I've attempted to remedy everything, compile-tested and briefly run-time 
tested the changes, and have pushed 'em all into my git tree. My shiny new 
iMon Knob receiver and remote are reasonably happy still (less some lockdep 
spew that I have to figure out what to do with still), but I have no vfd or 
lcd to test with, unfortunately.

-- 
Jarod Wilson
jarod@redhat.com

