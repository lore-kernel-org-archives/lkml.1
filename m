Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYIIX7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYIIX7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYIIX7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:59:37 -0400
Received: from scing.com ([217.160.110.58]:45476 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYIIX7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:59:37 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 03/18] lirc driver for 1st-gen Media Center Ed. USB IR transceivers
Date: Wed, 10 Sep 2008 01:59:32 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>, dconti@acm.wwu.edu
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-4-git-send-email-jwilson@redhat.com> <20080909132140.3c0adcca@bike.lwn.net>
In-Reply-To: <20080909132140.3c0adcca@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809100159.32524.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 21:21:40 Jonathan Corbet wrote:
>
> > + * 2003_11_11 - Restructured to minimalize code interpretation in
> > the + *	      driver. The normal use case will be with lirc.
> > + *
> > + * 2004_01_01 - Removed all code interpretation. Generate mode2
> > data + *	      for passing off to lirc. Cleanup
> > + *
> > + * 2004_01_04 - Removed devfs handle. Put in a temporary
> > workaround + *	      for a known issue where repeats generate two
> > + *	      sequential spaces (last_was_repeat_gap)
> > + *
> > + * 2004_02_17 - Changed top level api to no longer use fops, and
> > + *	      instead use new interface for polling via
> > + *	      lirc_thread. Restructure data read/mode2 generation to
> > + *	      a single pass, reducing number of buffers. Rev to .2
> > + *
> > + * 2004_02_27 - Last of fixups to plugin->add_to_buf API. Properly
> > + *	      handle broken fragments from the receiver. Up the
> > + *	      sample rate and remove any pacing from
> > + *	      fetch_more_data. Fixes all known issues.
>
> General convention is that this sort of changelog information belongs
> in the SCM, not in the code.  That's doubly true for the USB skeleton
> driver info.

I don't really care and I agree that the SCM is the preferred place for 
the information. The only problem is that the info is in a different 
SCM (lirc cvs repository).

I've removed the changelogs from all files as long as no names wre 
mentioned.

> > +#include <linux/smp_lock.h>
>
> It doesn't look like this include is needed.

removed

> > +/* Structure to hold all of our device specific stuff */
> > +struct usb_skel {
>
> Perhaps renaming this structure to something more directly
> descriptive would make sense?

renamed to mceusb_device

> > +	struct usb_device *udev; /* save off the usb device pointer */
> > +	struct usb_interface *interface; /* the interface for this device
> > */ +	unsigned char minor;	 /* the starting minor number for this
> > device */
>
> Minor numbers don't necessarily fit in an unsigned char.
>
> > +	unsigned char num_ports; /* the number of ports this device has
> > */ +	char num_interrupt_in;	 /* number of interrupt in endpoints */
> > +	char num_bulk_in;	 /* number of bulk in endpoints */
> > +	char num_bulk_out;	 /* number of bulk out endpoints */
> > +
> > +	unsigned char *bulk_in_buffer;	/* the buffer to receive data */
> > +	int bulk_in_size;		/* the size of the receive buffer */
> > +	__u8 bulk_in_endpointAddr;	/* the address of bulk in endpoint */
> > +
> > +	unsigned char *bulk_out_buffer;	/* the buffer to send data */
> > +	int bulk_out_size;		/* the size of the send buffer */
> > +	struct urb *write_urb;		/* the urb used to send data */
> > +	__u8 bulk_out_endpointAddr;	/* the address of bulk out endpoint
> > */ +
> > +	atomic_t write_busy;		/* true iff write urb is busy */
> > +	struct completion write_finished; /* wait for the write to finish
> > */ +
> > +	wait_queue_head_t wait_q; /* for timeouts */
> > +	int open_count;		/* number of times this port has been opened */
> > +	struct mutex sem;	/* locks this structure */
>
> "sem" is not a semaphore; it should probably have a different name.

renamed to lock

> > +static void mceusb_setup(struct usb_device *udev)
> > +{
> > +	char data[8];
> > +	int res;
> > +
> > +	memset(data, 0, 8);
> > +
> > +	/* Get Status */
> > +	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> > +			      USB_REQ_GET_STATUS, USB_DIR_IN,
> > +			      0, 0, data, 2, HZ * 3);
>
> res is set many times in this function, but it is never checked.  It
> seems to me like the addition of some error handling would be a good
> idea.

sigh, It would be a good idea, not sure if I'm motivated enough to add 
that to a driver I can't test and I know almost nothing about.


> > +	/* These two are sent by the windows driver, but stall for
> > +	 * me. I dont have an analyzer on the linux side so i can't
> > +	 * see what is actually different and why the device takes
> > +	 * issue with them
> > +	 */
>
> Hmm...how was that information obtained?  If this driver was
> reverse-engineered, it would be good to know just what process was
> followed.

That's probably a question for the original author, Dan. CC added. I'm 
just cleaning them up for kernel inclusion.

> > +static int msir_fetch_more_data(struct usb_skel *dev, int
> > dont_block) +{
>
> ...
>
> > +			/* retry a few times on overruns; map all
> > +			   other errors to -EIO */
> > +			if (retval) {
> > +				if (retval == -EOVERFLOW && retries < 5) {
> > +					retries++;
> > +					interruptible_sleep_on_timeout(
> > +						&dev->wait_q, HZ);
> > +					continue;
>
> As others have noted, I think, getting new sleep_on() calls into the
> kernel is kind of a hard sell.

there are more, I'll fix them all before the next patchset get posted. 

> ...
>
> > +
> > +	/* select a "subminor" number (part of a minor number) */
> > +	down(&minor_table_mutex);
>
> So...this driver has a mutex called "sem" and a semaphore called
> "minor_table_mutex".  I suspect that minor_table_mutex should, in
> fact, be a mutex.

yes, the declaration looks like this:
static DECLARE_MUTEX(...);

which gives us a single holder semaphore. the static in front of 
DECLARE_MUTEX() fools checkpatch. changed to to DEFINE_MUTEX, also in 
two other drivers.

>
> ...
>
> > +error:
> > +	mceusb_delete(dev);
> > +	dev = NULL;
> > +	dprintk("%s: retval = %x", __func__, retval);
> > +	up(&minor_table_mutex);
> > +	return retval;
> > +}
>
> This will leak the memory allocated for dev.  It also leaves the
> entry in minor_table pointing to a nonfunctional device.

fixed.

Thanks for the review.

Janne

