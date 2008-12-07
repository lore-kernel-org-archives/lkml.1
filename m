Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYLGEPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYLGEPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYLGEPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:15:11 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4833 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753533AbYLGEPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:15:09 -0500
Date: Sat, 6 Dec 2008 23:15:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Christian Lamparter <chunkeey@web.de>, Greg KH <gregkh@suse.de>,
       <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] p54usb: rewriting rx/tx routines to make use of
 usb_anchor's facilities
In-Reply-To: <493AF2EE.20605@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.0812061919480.16554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Larry Finger wrote:

> Christian Lamparter wrote:
> > 
> > Alan, I've got a question about:
> > "Create and initialize a usb_anchor structure, and each time you create
> > a new URB, call usb_anchor_urb().  Then you can free the URB as soon as
> > it is submitted; the anchor will keep it pinned until it completes, and
> > it is automatically removed from the anchor when the completion routine
> > is called."
> > 
> > Do we have to call usb_free_urb again, if we're resubmitting the urb in the
> > complete callback? (the code what I'm referring to is p54u_rx_cb in p54usb.c)
> 
> I am very interested in the answer to this question. My interpretation is that
> you cannot resubmit the urb after it has been posted to usb_anchor_usb() because
> the USB core will have deleted it, and that the callback routine will have to
> allocate a new urb, anchor it, and then free it as well.

I looked quickly at your new code.  It seems basically right, but there
are few things that still need attention.  For instance, you removed a
line to free an URB's transfer buffer.  The USB core will automatically
call kfree(urb->transfer_buffer) for you when the URB is deallocated,
but only if you have set the URB_FREE_BUFFER bit in
urb->transfer_flags.  I didn't check to see whether the driver does 
this.

To answer your questions about anchors...  The main idea is simple
enough.  When you create an URB, its refcount is 1.  Each call to
usb_get_urb() increments the refcount and each call to usb_put_urb()  
or usb_free_urb() decrements it; when the refcount reaches 0 the URB is
deallocated.  When you successfully submit an URB, the core increments
its refcount; the refcount is then decremented when the completion
routine returns.

When you add an URB to an anchor, its refcount is incremented.  When it
is removed from the anchor, the refcount is decremented again.  An
anchored URB is automatically removed from its anchor just before the
completion routine is called.  So if your completion routine wants to
resubmit an URB, it has to add the URB back to the anchor.  And if
the submission fails then you have to decide what to do (usually you 
would unanchor the URB, which would cause it to be deallocated later).

As a sketch: (1) Initially:

	usb_alloc_urb			=> refcount = 1
	usb_anchor_urb			=> refcount = 2
	usb_submit_urb			=> refcount = 3
	usb_free_urb			=> refcount = 2

(2) Later on:

	URB completes
	URB is removed from anchor	=> refcount = 1
	Completion routine is called

(3a) If the completion routine doesn't resubmit:

	Completion routine returns	=> refcount = 0,
					URB is deallocated

(3b) If the completion routine does resubmit:

	usb_anchor_urb			=> refcount = 2
	usb_submit_urb			=> refcount = 3
	Completion routine returns	=> refcount = 2
	Go back to (2)...

Hopefully this clarifies things.

Alan Stern

