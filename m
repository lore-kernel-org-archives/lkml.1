Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYGYD5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYGYD5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 23:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYGYD5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 23:57:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4547 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752224AbYGYD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 23:57:35 -0400
Date: Thu, 24 Jul 2008 23:57:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption.
 prev->next should be next (ffff88003b8f82f8)
In-Reply-To: <200807240040.21006.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0807240931220.3494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, David Brownell wrote:

> 	I modified dummy_hcd to print messages whenever a request
> 	was queued to an endpoint, or acompletion was issued.
> 	If the endpoint queue was empty at that time, it's shown.
...
> ep-c: queue req c10980e0 (q empty)
> 
> 	Here's where it starts to go squirrely...
> 	
> 	You would EXPECT to see a completion callback here since
> 	that's what dummy_queue() says to do:  write this small
> 	packet into a FIFO (just like Real Hardware would) and
> 	wait for the host to collect it.
> 
> 	Note that the emulated FIFO is represented by a request
> 	object ... one that *never* seems to get a completion
> 	issued for it.  That seems very wrong...

I think I see the problem.  Starting at line 533, we have:

	/* implement an emulated single-request FIFO */
	if (ep->desc && (ep->desc->bEndpointAddress & USB_DIR_IN) &&
			list_empty (&dum->fifo_req.queue) &&
			list_empty (&ep->queue) &&
			_req->length <= FIFO_SIZE) {
		req = &dum->fifo_req;
		req->req = *_req;
		req->req.buf = dum->fifo_buf;
		memcpy (dum->fifo_buf, _req->buf, _req->length);
		req->req.context = dum;
		req->req.complete = fifo_complete;

		spin_unlock (&dum->lock);
		_req->actual = _req->length;
		_req->status = 0;
		_req->complete (_ep, _req);
		spin_lock (&dum->lock);
	}
	list_add_tail (&req->queue, &ep->queue);
	spin_unlock_irqrestore (&dum->lock, flags);

The list_add_tail() gets called at the wrong time if the completion
routine resubmits.  It should look more like this:

		list_add_tail (&req->queue, &ep->queue);
		spin_unlock (&dum->lock);
		_req->actual = _req->length;
		_req->status = 0;
		_req->complete (_ep, _req);
		spin_lock (&dum->lock);
	} else {
		list_add_tail (&req->queue, &ep->queue);
	}
	spin_unlock_irqrestore (&dum->lock, flags);

Can you make the necessary change and try it out?

Alan Stern

