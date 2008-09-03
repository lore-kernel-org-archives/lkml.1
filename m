Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYICTLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYICTLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYICTLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:11:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52651 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYICTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:11:07 -0400
Date: Wed, 3 Sep 2008 13:10:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080903191023.GF2772@parisc-linux.org>
References: <20080903042539.GB2772@parisc-linux.org> <Pine.LNX.4.44L0.0809031043430.2594-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0809031043430.2594-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 11:40:21AM -0400, Alan Stern wrote:
> Most of your decisions look good to me.

Thanks for the review.

> > 'get version' is now a call rather than including a version field in
> > every request.
> 
> Have you given any thought to forward compatibility?  I imagine it's 
> too early to worry about that yet.

By forward compatibility, you mean when we rev the protocol to version 2
and try to communicate?  My thought was:

 - v1 host, v1 device -- status quo
 - v1 host, v2 device -- host will simply disconnect
 - v2 host, v1 device -- host can choose to speak v1 protocol or
   disconnect
 - v2 host, v2 device -- v2 protocol will be spoken

If we have the host transmit the highest version protocol it supports,
the device could reply with the highest version it supports.  Or we
could have the host transmit all the protocol versions it's willing to
support (eg 1, 3, 4 because we found a horrible security problem in
version 2).  It can all get quite involved.

> > Devices are now referred to as an ascii string rather than an encoded
> > 4-byte quantity.  This helps userspace configure the device and lets us
> > interoperate with other OSes that might want to implement this protocol.
> 
> Is this string intended to be meaningful to a human?  Or could it be 
> nothing more than an ASCII version of the device structure's address?

It needs to be typable by a human.  It's up to the implementation
whether it wants to report "1-1" so that "usbip --attach localhost 1-1"
continues to work.  I don't mind if I have to type "usbip --attach
localhost Jhd%s" as long as that's one of the options I get from usbip
--list.  It's not intended to be "usbip --attach 'AuthenTec, Inc. AES2501
Fingerprint Sensor'" (though I suppose a sufficiently imaginative
implementation could take any arbitrary string and try to DWIM ... that
wouldn't be prohibited).  Refusing to accept a string that came
from the list would be pretty mean though.

> > I've split 'cmd_submit' into four commands (control, data, isoc, irq).
> > That gives us the ability to make 'data' very small.
> 
> A number of important commands are missing.  Clear-Halt springs to
> mind, as do Reset-Device, Set-Configuration, and Set-Interface.

Set Configuration and Set Interface are requests on the command pipe
according to the usb 2.0 spec (these would be a control message
targetted at endpoint 0).  I don't find Reset Device in usb 2.0; in
usb-storage there's Bulk-Only Mass Storage Reset which is again a
request on the command pipe.  I also don't find Clear Halt in usb 2.0;
but if I'm reading 9.4.5 correctly, the Halt state is cleared by sending
a GetStatus control message to the appropriate endpoint.

> > Instead of transmitting the device number in every command, we now bind
> > each socket to a particular device.  This was already what happened,
> > so it was just overhead.
> 
> This isn't mentioned in your document.  There are "claim device" and 
> "release device" calls, but it doesn't say anywhere that only one 
> device can be claimed at a time.  Nor is there a status code for "No 
> device claimed".

This is true.  I'll make that more clear.  In fact, drawing a state
transition diagram might be in order.

> > There's no need to respond with the call number to each call -- the
> > caller should be using the call identifier to find out what type of
> > call it was.  Often the implementation will issue a command and then
> > wait for the response, so even that is unnecessary.
> 
> What happens when your protocol is used with a non-reliable transport?  
> Who is responsible for retransmissions/acknowledgements?

Good question, and one I hadn't been thinking about too hard since the
current implementation is over TCP.  See next answer ...

> > Replying with the status is vital.
> 
> The reply to a submit call will be sent when the USB transfer is
> complete.  Suppose the transfer takes a long time.  How does the client
> tell the difference between a long-running transfer and an unreceived
> submit?  Do you essentially assume that all protocol transfers are
> reliable?

How about this:

 - The sender has a timeout after which time, it will re-send the call.
 - If the recipient receives a call that is still outstanding, it
   replies with a status akin to NFS's EJUKEBOX that means "It's in
   progress".
 - If the recipient receives a call for a reply it has already sent, it
   just resends it.

I'd welcome some network expertise on this protocol.  Arnaldo?

> There isn't any field in the submit reply to report the status of the 
> transfer (as opposed to the status of the submission).  How do errors 
> like -EILSEQ get reported back to the client?

Isn't that error entirely within the remote device and should be retried
there?

> > I decided to make the 'call' value 32-bit (instead of 8-bit) to make
> > everything align nicely.  Then I wanted to slim down the data command
> > call, so I tucked the endpoint and direction in there too.
> 
> What about the extra flags that go with URB submissions?  
> URB_NO_INTERRUPT and URB_SHORT_NOT_OK might well be useful, 
> URB_ZERO_PACKET is certain to be needed, and even URB_ISO_ASAP might 
> come in handy.

I think including those flags in the 'call' variable would make sense,
assuming they make sense at this level.  I'm trying to understand that,
both in the context of pass-through and in the context of a pure
userspace USB device.

> > I have no experience with isosynchronous transactions, nor interrupt
> > transactions, so I decline to define them at this moment.
> 
> It will not be possible to support all the features of Linux's USB 
> stack for these types of transfers (I'm referring to the way the 
> bandwidth isn't released if a new URB is submitted during the 
> completion callback).

Right.

> Both types will require an additional "interval" field for submission,
> and Isochronous will require "start_frame", "number_of_packets", and a
> list of packet descriptors as well.  It also will require a status and
> length for each component packet in the reply.

That was my vague understanding, but I'd not looked into it really,
other than to note all those fields were unused for control and data
commands.

> In the unlink call, what is the "seqnum" field?  Is it supposed to be 
> the call identifier of the corresponding submit call?

Sorry, I thought I'd renamed it to 'victim'.  It is indeed the identifier
of the call that is to be unlinked.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
