Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYICPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYICPkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYICPkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:40:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33277 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047AbYICPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:40:23 -0400
Date: Wed, 3 Sep 2008 11:40:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <bgmerrell@novell.com>, <hirofuchi@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <usbip-devel@lists.sourceforge.net>
Subject: Re: USBIP protocol
In-Reply-To: <20080903042539.GB2772@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.0809031043430.2594-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Matthew Wilcox wrote:

> Here's a document for discussion.  No code yet, though I'm quite willing
> to modify the current usbip code to follow this new protocol.  Just a
> matter of time.
> 
> http://www.kernel.org/pub/linux/kernel/people/willy/usbip/usbip-protocol-draft-1

Most of your decisions look good to me.

> 'get version' is now a call rather than including a version field in
> every request.

Have you given any thought to forward compatibility?  I imagine it's 
too early to worry about that yet.

> Devices are now referred to as an ascii string rather than an encoded
> 4-byte quantity.  This helps userspace configure the device and lets us
> interoperate with other OSes that might want to implement this protocol.

Is this string intended to be meaningful to a human?  Or could it be 
nothing more than an ASCII version of the device structure's address?

> I've split 'cmd_submit' into four commands (control, data, isoc, irq).
> That gives us the ability to make 'data' very small.

A number of important commands are missing.  Clear-Halt springs to
mind, as do Reset-Device, Set-Configuration, and Set-Interface.

> Instead of transmitting the device number in every command, we now bind
> each socket to a particular device.  This was already what happened,
> so it was just overhead.

This isn't mentioned in your document.  There are "claim device" and 
"release device" calls, but it doesn't say anywhere that only one 
device can be claimed at a time.  Nor is there a status code for "No 
device claimed".

> There's no need to respond with the call number to each call -- the
> caller should be using the call identifier to find out what type of
> call it was.  Often the implementation will issue a command and then
> wait for the response, so even that is unnecessary.

What happens when your protocol is used with a non-reliable transport?  
Who is responsible for retransmissions/acknowledgements?

> Replying with the status is vital.

The reply to a submit call will be sent when the USB transfer is
complete.  Suppose the transfer takes a long time.  How does the client
tell the difference between a long-running transfer and an unreceived
submit?  Do you essentially assume that all protocol transfers are
reliable?

There isn't any field in the submit reply to report the status of the 
transfer (as opposed to the status of the submission).  How do errors 
like -EILSEQ get reported back to the client?

> I decided to make the 'call' value 32-bit (instead of 8-bit) to make
> everything align nicely.  Then I wanted to slim down the data command
> call, so I tucked the endpoint and direction in there too.

What about the extra flags that go with URB submissions?  
URB_NO_INTERRUPT and URB_SHORT_NOT_OK might well be useful, 
URB_ZERO_PACKET is certain to be needed, and even URB_ISO_ASAP might 
come in handy.

> I have no experience with isosynchronous transactions, nor interrupt
> transactions, so I decline to define them at this moment.

It will not be possible to support all the features of Linux's USB 
stack for these types of transfers (I'm referring to the way the 
bandwidth isn't released if a new URB is submitted during the 
completion callback).

Both types will require an additional "interval" field for submission,
and Isochronous will require "start_frame", "number_of_packets", and a
list of packet descriptors as well.  It also will require a status and
length for each component packet in the reply.

In the unlink call, what is the "seqnum" field?  Is it supposed to be 
the call identifier of the corresponding submit call?

Alan Stern

