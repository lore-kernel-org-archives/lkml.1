Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXJWVj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXJWVj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXJWVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:39:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXJWVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:39:17 -0400
Date: Tue, 23 Oct 2007 14:38:52 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071023143852.df06530a.zaitcev@redhat.com>
In-Reply-To: <200710231138.38266.oliver@neukum.org>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	<200710231138.38266.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:38:37 +0200, Oliver Neukum <oliver@neukum.org> wrote:

> > +	/* XXX Anchor these instead */
> > +	spin_lock_irqsave(&dev->buflock, flags);
> > +	if (!dev->read_urb_finished) {
> > +		spin_unlock_irqrestore(&dev->buflock, flags);
> > +		usb_kill_urb(dev->interrupt_in_urb);
> > +	} else
> > +		spin_unlock_irqrestore(&dev->buflock, flags);

> Why bother? Simply call usb_kill_urb() unconditionally.

Is it always safe to kill unfilled URBs? The filled but unsubmitted ones
are ok, but in this case it's possible that we only allocated something
but never submitted. Our current implementation happens to be safe by
virtue of ->dev being NULL in such case. I do not remember if we always
guaranteed that and since Vitaly is going to take this code for a
backport, I decided to play it safe.

I would rather leave this.

> > @@ -162,8 +182,6 @@ static void adu_delete(struct adu_device *dev)
> >  {
> >  	dbg(2, "%s enter", __FUNCTION__);
> >  
> > -	adu_abort_transfers(dev);
> > -
> >  	/* free data structures */
> >  	usb_free_urb(dev->interrupt_in_urb);
> >  	usb_free_urb(dev->interrupt_out_urb);
> > @@ -239,7 +257,10 @@ static void adu_interrupt_out_callback(struct urb *urb)
> >  		goto exit;
> >  	}
> >  
> > +	spin_lock(&dev->buflock);
> > +	dev->out_urb_finished = 1;
> >  	wake_up_interruptible(&dev->write_wait);
> > +	spin_unlock(&dev->buflock);
> 
> This leaves a race here:
> 
> 	while (count > 0) {
> 		spin_lock_irqsave(&dev->buflock, flags);
> 		if (!dev->out_urb_finished) {
> 			spin_unlock_irqrestore(&dev->buflock, flags);
> 
> 			timeout = COMMAND_TIMEOUT;
> 			while (timeout > 0) {
> 				if (signal_pending(current)) {
> 					dbg(1," %s : interrupted", __FUNCTION__);
> 					retval = -EINTR;
> 					goto exit;
> 				}
> 				mutex_unlock(&dev->mtx);
> 				timeout = interruptible_sleep_on_timeout(&dev->write_wait, timeout);
> 
> You can detect that the urb has not finished but the notification happens before
> you go to sleep.

That's a common issue with sleep_on and its derivatives really.
I would need to replace it with explicit queue adds to fix.

I suppose I can fix it too.

> > @@ -272,13 +293,11 @@ static int adu_open(struct inode *inode, struct file *file)
> >  		goto exit_no_device;
> >  	}
> >  
> > -	/* lock this device */
> > -	if ((retval = mutex_lock_interruptible(&dev->mtx))) {
> > +	if ((retval = mutex_lock_interruptible(&adutux_mutex))) {
> >  		dbg(2, "%s : mutex lock failed", __FUNCTION__);
> >  		goto exit_no_device;
> >  	}

> This is racy:
> 	dev = usb_get_intfdata(interface);
> 	if ((retval = mutex_lock_interruptible(&adutux_mutex))) {
> 		dbg(2, "%s : mutex lock failed", __FUNCTION__);
> 		goto exit_no_device;
> 	}
> 
> You need to manipulate intfdata under lock, or disconnect will
> happily free the datastructures.

Ah yes. Sorry about that, will fix.

> > @@ -297,13 +316,14 @@ static int adu_open(struct inode *inode, struct file *file)
> >  		dev->read_urb_finished = 0;
> >  		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
> > -		if (retval)
> > +		if (retval) {
> > +			dev->read_urb_finished = 1;
> >  			--dev->open_count;
> > +		}
> 
> You should set file->private_data to NULL in the error case.

What for? Nobody ever tests it or dereferences it after ->open returned
an error. I can set 0xaaaabbbb to it just as well.

> > @@ -486,10 +495,14 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
> >  				/* we wait for I/O to complete */
> >  				set_current_state(TASK_INTERRUPTIBLE);
> >  				add_wait_queue(&dev->read_wait, &wait);
> > -				if (!dev->read_urb_finished)
> > +				spin_lock_irqsave(&dev->buflock, flags);
> > +				if (!dev->read_urb_finished) {
> > +					spin_unlock_irqrestore(&dev->buflock, flags);
> >  					timeout = schedule_timeout(COMMAND_TIMEOUT);
> 
> I find it a bit silly to bother with _irqsave if you call schedule_timeout() in the
> next line.

True, this is not really necessary... And I set and clear such flags
without locking around them when I'm sure that URB is not in progress.
I just added it in case someone wants to expand this code by testing
two things together or something, because here the callback certainly
can strike at any time. The whole excercise started because Vitaliy
wanted to reuse the code.

-- Pete
