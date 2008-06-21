Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYFUVu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYFUVu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYFUVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:50:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3583 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752038AbYFUVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:50:17 -0400
Date: Sat, 21 Jun 2008 17:50:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <485D1C67.7050907@firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.0806211727330.24335-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008, Andi Kleen wrote:

> > Splitting would work.  But it has to be done fairly high up in the 
> > stack, ideally in the block layer.
> 
> That's true. Or you would need to reserve requests for this, which is likely
> a bad idea. Perhaps you're better off just copying in this (hopefully
> rare) case. Fortunately lately thanks to work from Peter Z. allocating memory
> in the write out path is much safer than it used to be.
> 
> Also for my edification: is that a general restriction of the wireless usb
> spec or just a specific hardware quirk in some design?

It's a combination of factors.  The USB spec requires that during a
bulk data transfer, all packets except the last must have the maximum
packet size defined for the device.  In fact, a packet whose size is
smaller than the maximum always marks the end of a transfer.  (More
precisely, the transfer ends when the expected number of bytes has been
received or when a short packet is received, whichever occurs first.)  

The USB host controller drivers, in concert with the USB scatter-gather
library, package each S-G element as a separate set of packets.  This
is easy to do, of course, since each element represents data that is
contiguous in DMA space.  Until recently the maximum packet sizes have
been no larger than 512 bytes; hence filesystem transfers would never
cause problems because they always involve complete sectors and so the
S-G elements are always a multiple of 512 in length.  Thus the
transfers would always consist of nothing but maximum-sized packets.

But now there is a new spec for Wireless USB devices, and it permits
the maximum packet size to be 1024.  So when an S-G element is 3584
bytes (this actually was observed in testing), it gets packaged as
three 1024-byte packets followed by a 512-byte packet.  The device
naturally thinks that the 512-byte packet signals the end of the
transfer, and therefore it doesn't accept the remaining S-G elements in
the list.

> >> I don't think the block layer knows about such kinds of restrictions.
> > 
> > Evidently not.  Is it feasible to add such knowledge to the block
> > layer?
> 
> You would need to ask Jens, but I would assume he would ask:
> - Is it common?

This is the only situation I know about.  But of course it will become 
more and more common as wireless USB devices spread into use.

> - Is it performance critical?

For people using wireless USB drives, yes.

> and presumably the answer to both would be "no" ?

In theory this could be fixed at the host controller level, by making 
packets span S-G elements.  But this would be a very large and 
difficult change.  Altering the block layer should be a lot easier (he 
said, secure in his blind ignorance).  For example, the DMA alignment 
restriction could be made to apply to the _end_ of each S-G element as 
well as the _beginning_, except for the last element in the list.

Alan Stern

