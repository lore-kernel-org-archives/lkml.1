Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbXJWJiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbXJWJiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXJWJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:38:14 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:55393 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbXJWJiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:38:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB: FIx locks and urb->status in adutux
Date: Tue, 23 Oct 2007 11:38:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pete Zaitcev <zaitcev@redhat.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au
References: <20071022203447.db6d7950.zaitcev@redhat.com>
In-Reply-To: <20071022203447.db6d7950.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231138.38266.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 23 Oktober 2007 schrieb Pete Zaitcev:
> Two main issues fixed here are:
>  - An improper use of in-struct lock to protect an open count
>  - Use of urb status for -EINPROGRESS

> +	/* XXX Anchor these instead */
> +	spin_lock_irqsave(&dev->buflock, flags);
> +	if (!dev->read_urb_finished) {
> +		spin_unlock_irqrestore(&dev->buflock, flags);
> +		usb_kill_urb(dev->interrupt_in_urb);
> +	} else
> +		spin_unlock_irqrestore(&dev->buflock, flags);
> +
> +	spin_lock_irqsave(&dev->buflock, flags);
> +	if (!dev->out_urb_finished) {
> +		spin_unlock_irqrestore(&dev->buflock, flags);
> +		usb_kill_urb(dev->interrupt_out_urb);
> +	} else
> +		spin_unlock_irqrestore(&dev->buflock, flags);

Why bother? Simply call usb_kill_urb() unconditionally.
  
>  exit:
> +	mutex_unlock(&dev->mtx);
>  	dbg(2," %s : leave", __FUNCTION__);
>  }
>  
> @@ -162,8 +182,6 @@ static void adu_delete(struct adu_device *dev)
>  {
>  	dbg(2, "%s enter", __FUNCTION__);
>  
> -	adu_abort_transfers(dev);
> -
>  	/* free data structures */
>  	usb_free_urb(dev->interrupt_in_urb);
>  	usb_free_urb(dev->interrupt_out_urb);
> @@ -239,7 +257,10 @@ static void adu_interrupt_out_callback(struct urb *urb)
>  		goto exit;
>  	}
>  
> +	spin_lock(&dev->buflock);
> +	dev->out_urb_finished = 1;
>  	wake_up_interruptible(&dev->write_wait);
> +	spin_unlock(&dev->buflock);

This leaves a race here:

	while (count > 0) {
		spin_lock_irqsave(&dev->buflock, flags);
		if (!dev->out_urb_finished) {
			spin_unlock_irqrestore(&dev->buflock, flags);

			timeout = COMMAND_TIMEOUT;
			while (timeout > 0) {
				if (signal_pending(current)) {
					dbg(1," %s : interrupted", __FUNCTION__);
					retval = -EINTR;
					goto exit;
				}
				mutex_unlock(&dev->mtx);
				timeout = interruptible_sleep_on_timeout(&dev->write_wait, timeout);

You can detect that the urb has not finished but the notification happens before
you go to sleep.

>  exit:
>  
>  	adu_debug_data(5, __FUNCTION__, urb->actual_length,
> @@ -272,13 +293,11 @@ static int adu_open(struct inode *inode, struct file *file)
>  		goto exit_no_device;
>  	}
>  
> -	/* lock this device */
> -	if ((retval = mutex_lock_interruptible(&dev->mtx))) {
> +	if ((retval = mutex_lock_interruptible(&adutux_mutex))) {
>  		dbg(2, "%s : mutex lock failed", __FUNCTION__);
>  		goto exit_no_device;
>  	}

This is racy:
	dev = usb_get_intfdata(interface);
	if (!dev) {
		retval = -ENODEV;
		goto exit_no_device;
	}

	if ((retval = mutex_lock_interruptible(&adutux_mutex))) {
		dbg(2, "%s : mutex lock failed", __FUNCTION__);
		goto exit_no_device;
	}

You need to manipulate intfdata under lock, or disconnect will
happily free the datastructures.

>  
> -	/* increment our usage count for the device */
>  	++dev->open_count;
>  	dbg(2,"%s : open count %d", __FUNCTION__, dev->open_count);
>  
> @@ -297,13 +316,14 @@ static int adu_open(struct inode *inode, struct file *file)
>  				 le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize),
>  				 adu_interrupt_in_callback, dev,
>  				 dev->interrupt_in_endpoint->bInterval);
> -		/* dev->interrupt_in_urb->transfer_flags |= URB_ASYNC_UNLINK; */
>  		dev->read_urb_finished = 0;
>  		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
> -		if (retval)
> +		if (retval) {
> +			dev->read_urb_finished = 1;
>  			--dev->open_count;
> +		}

You should set file->private_data to NULL in the error case.

[..]
> @@ -486,10 +495,14 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
>  				/* we wait for I/O to complete */
>  				set_current_state(TASK_INTERRUPTIBLE);
>  				add_wait_queue(&dev->read_wait, &wait);
> -				if (!dev->read_urb_finished)
> +				spin_lock_irqsave(&dev->buflock, flags);
> +				if (!dev->read_urb_finished) {
> +					spin_unlock_irqrestore(&dev->buflock, flags);
>  					timeout = schedule_timeout(COMMAND_TIMEOUT);

I find it a bit silly to bother with _irqsave if you call schedule_timeout() in the
next line.

	Regards
		Oliver
