Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369AbZH0RWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbZH0RWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZH0RWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:21 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62531 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZH0RWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFtdlkqrR7PD/2dsb2JhbADBXYg+AZAHBYQZ
X-IronPort-AV: E=Sophos;i="4.44,287,1249257600"; 
   d="scan'208";a="376634293"
Date: Thu, 27 Aug 2009 10:22:18 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH 1/1, v2]
	usb-use-kfifo-to-buffer-usb-generic-serial-writes.patch
Message-ID: <20090827172218.GA3618@cuplxvomd02.corp.sa.net>
References: <20090827013454.GA23601@cuplxvomd02.corp.sa.net> <200908271014.54282.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908271014.54282.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:14:53AM +0200, Oliver Neukum wrote:
> 
> > +	/* send the data out the bulk port */
> > +	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
> > +	if (result) {
> > +		dev_err(&port->dev,
> > +			"%s - failed submitting write urb, error %d\n",
> > +						__func__, result);
> > +		/* don't have to grab the lock here, as we will
> > +		   retry if != 0 */
> > +		port->write_urb_busy = 0;
> > +		status = result;
> 
> This looks deficient. If the first part of a transmission fails,
> the fifo's remaining content should be discarded and if possible
> an error returned to user space.

I thought about that, and perhaps I don't know enough about about USB failure
modes, but it's not really clear to me that the FIFO's contents should be tossed. 
The pro argument is that losing more data may make it clearer that an error
occurred, but the con is that this may be a transient error and why should we
discard perfectly good data? I'm definitely open to discussion on this.

> [..]
> > @@ -487,8 +515,8 @@ void usb_serial_generic_write_bulk_callback(struct urb
> > *urb) port->urbs_in_flight = 0;
> >  		spin_unlock_irqrestore(&port->lock, flags);
> >  	} else {
> > -		/* Handle the case for single urb mode */
> >  		port->write_urb_busy = 0;
> > +		usb_serial_generic_write_start(port, 0);
> 
> This is a problem. This may fail due to a system suspend.
> In that case you cannot depend on the next write restarting
> IO. You need to restart IO in resume()

It's not so clear that this is a problem. Serial output is not idempotent the
way disk output is; you trade the risk of dropped data for the risk of
duplicated data.  I have a belief, open to challenge, that users can handle
would regard duplicated data as more confusing than dropped data.

> > @@ -970,6 +971,11 @@ int usb_serial_probe(struct usb_interface *interface,
> >  			dev_err(&interface->dev, "No free urbs available\n");
> >  			goto probe_error;
> >  		}
> > +		port->write_fifo = kfifo_alloc(PAGE_SIZE, GFP_KERNEL,
> > +			&port->write_fifo_lock);
> 
> Whence do you take the fifo's size? What does this do to latency?

This is the same size that simple UART-based serial devices use. I would expect
that you would normally be limited by the output data rate, so latency wouldn't
be a big issue.

> [..]
> > @@ -96,6 +98,8 @@ struct usb_serial_port {
> >  	unsigned char		*bulk_out_buffer;
> >  	int			bulk_out_size;
> >  	struct urb		*write_urb;
> > +	struct kfifo		*write_fifo;
> > +	spinlock_t		write_fifo_lock;
> 
> Do you really need a separate lock?

No. I could, theoretically, grab the BKL, but why hold up anything you don't
have to? If someone wants to make an argument based on cacheline thrashing,
they could certainly do so, but the data rates being used here are relatively
low.

> 		Oliver

David VL
