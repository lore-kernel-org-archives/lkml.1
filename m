Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbZH1NF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbZH1NF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZH1NF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:05:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:44135 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZH1NF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:05:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: David VomLehn <dvomlehn@cisco.com>
Subject: Re: [PATCH 1/1, v2] usb-use-kfifo-to-buffer-usb-generic-serial-writes.patch
Date: Fri, 28 Aug 2009 15:07:10 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com
References: <20090827013454.GA23601@cuplxvomd02.corp.sa.net> <200908271014.54282.oliver@neukum.org> <20090827172218.GA3618@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090827172218.GA3618@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908281507.11143.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 27. August 2009 19:22:18 schrieb David VomLehn:
> On Thu, Aug 27, 2009 at 10:14:53AM +0200, Oliver Neukum wrote:
> > > +	/* send the data out the bulk port */
> > > +	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
> > > +	if (result) {
> > > +		dev_err(&port->dev,
> > > +			"%s - failed submitting write urb, error %d\n",
> > > +						__func__, result);
> > > +		/* don't have to grab the lock here, as we will
> > > +		   retry if != 0 */
> > > +		port->write_urb_busy = 0;
> > > +		status = result;
> >
> > This looks deficient. If the first part of a transmission fails,
> > the fifo's remaining content should be discarded and if possible
> > an error returned to user space.
>
> I thought about that, and perhaps I don't know enough about about USB
> failure modes, but it's not really clear to me that the FIFO's contents
> should be tossed. The pro argument is that losing more data may make it
> clearer that an error occurred, but the con is that this may be a transient
> error and why should we discard perfectly good data? I'm definitely open to
> discussion on this.

You may be writing a command. If you clip out a sequence in the middle you
might be sending an altered command without telling user space.

> > [..]
> >
> > > @@ -487,8 +515,8 @@ void usb_serial_generic_write_bulk_callback(struct
> > > urb *urb) port->urbs_in_flight = 0;
> > >  		spin_unlock_irqrestore(&port->lock, flags);
> > >  	} else {
> > > -		/* Handle the case for single urb mode */
> > >  		port->write_urb_busy = 0;
> > > +		usb_serial_generic_write_start(port, 0);
> >
> > This is a problem. This may fail due to a system suspend.
> > In that case you cannot depend on the next write restarting
> > IO. You need to restart IO in resume()
>
> It's not so clear that this is a problem. Serial output is not idempotent
> the way disk output is; you trade the risk of dropped data for the risk of
> duplicated data.  I have a belief, open to challenge, that users can handle
> would regard duplicated data as more confusing than dropped data.

How can this duplicate data? If you know that you need to call
usb_serial_generic_write_start, you also know that no further
transfer will occur. If you don't test and restart on resume, you
get this scenario:

user space writes to device
user space waits for answer

kernel transfers 1. buffer
system suspension - 2. buffer cannot be transfered,
	as usb_serial_generic_write_start gets -EPERM
system resumption - 2. buffer is never transmitted,
	user space times out and reports an error

> > [..]
> >
> > > @@ -96,6 +98,8 @@ struct usb_serial_port {
> > >  	unsigned char		*bulk_out_buffer;
> > >  	int			bulk_out_size;
> > >  	struct urb		*write_urb;
> > > +	struct kfifo		*write_fifo;
> > > +	spinlock_t		write_fifo_lock;
> >
> > Do you really need a separate lock?
>
> No. I could, theoretically, grab the BKL, but why hold up anything you
> don't have to? If someone wants to make an argument based on cacheline
> thrashing, they could certainly do so, but the data rates being used here
> are relatively low.

Is there any lock the usb serial subsystem provides you could use?

	Regards
		Oliver

