Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZEGO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZEGO1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZEGO1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:27:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52172 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751171AbZEGO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:27:11 -0400
Date: Thu, 7 May 2009 10:27:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Oliver Neukum <oliver@neukum.org>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <20090507010634.52bef075@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0905071004550.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Alan Cox wrote:

> >     Write routine:
> > 	Copy bytes into the available URB buffers, submitting URBs as 
> > 	they get filled.  At the end, if the next URB is partially full 
> > 	then submit it only if NIF < P.
> 
> There are good known algorithms for this and essentially the logic is
> about speed and time estimation. You don't need to queue a partially
> filled URB until you reach the time point that the hardware is in danger
> of having sent everything already queued. So under load once you've
> stuffed 4K down the pipe you know at 38400 baud that you can relax for
> quite some time.

Agreed.  An implicit point of my earlier message was that we might be
able to avoid tricky time-and-speed estimates by relying on the fact
that the USB-Serial device will NAK an URB until it has sufficient
buffer space to accept the data (i.e., flow control is built in at the
USB protocol level).

So instead of relaxing for some difficult-to-estimate time, we can
simply relax until the next URB completion occurs.  As long as a 
certain minimum number of URBs are still in flight, we can assume that 
the hardware isn't in danger of sending all the queued data.

This assumption might not be valid at the start of a transfer, since 
an URB can't complete for a minimum of 1 ms (at full speed), but it 
should stabilize quickly.

> > Allocating URBs on the fly adds a lot of complication.  There has to be 
> > a minimum number of pre-allocated URBs; otherwise write_room could 
> > never return a positive value.  If you allocate additional URBs 
> > later on, when would you free them?
> 
> write_room can allocate URBs I think (would need to be atomic allocations)
> 
> 	write_room()
> 		if no_urbs && urbs_queued < max_queued
> 			allocate an urb
> 		return space_in_last_urb;

That would work.  It doesn't seem to be much better than allocating 
URBs in the write routine.  After all, as long as allocations always 
succeed the details don't matter much.

A more interesting question is whether to deallocate URBs as they 
complete or to reuse them.  A simple approach (which Oliver no doubt 
has already considered) is:

	write_complete(urb):
		if (write_urb->transfer_length > 0)
			submit(write_urb);
			write_urb = urb;
		else
			urb_free(urb);

Alan Stern

