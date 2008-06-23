Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbYFWTpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbYFWTpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYFWTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:45:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38476 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752774AbYFWTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:45:06 -0400
Date: Mon, 23 Jun 2008 15:45:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Vrabel <david.vrabel@csr.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <485FF44C.4010600@csr.com>
Message-ID: <Pine.LNX.4.44L0.0806231522500.30973-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, David Vrabel wrote:

> Alan Stern wrote:
> > On Mon, 23 Jun 2008, David Vrabel wrote:
> > 
> >> Note that this 1024 byte multiple is for one particular WUSB mass
> >> storage device.  The WUSB standard permits max packet sizes of up 3584
> >> (in multiples of 512), but I suspect WUSB mass storage devices will only
> >> use 512, 1024, or 2048.
> >>
> >> For a solution, we may be able to do something if the HWA host
> >> controller is passed a single URB with an s-g list (rather than one URB
> >> per s-g list entry) and was careful about how it segmented the URB into
> >> transfers to the rpipe.
> > 
> > That would be ideal.  However there is no way to pass an S-G list along 
> > with an URB; there's no field for it in the data structure.  And none 
> > of the existing host controller drivers support such a thing.
> > 
> > I suppose we could add a field to struct urb and add a flag indicating 
> > whether the controller driver supports S-G lists.
> 
> This is what I was thinking.
> 
> Can the number of entries in a sg list be limited?  e.g., if the
> hardware only had support for say, 64 entries?

Yes, there are two fields in struct request_queue for this: 
max_phys_segments (the driver's limit) and max_hw_segments (the 
hardware's limit).

Standard EHCI hardware requires that the memory locations of the data
for each packet be "virtually contiguous", i.e., discontiguities are
allowed only at 4-KB page boundaries.  This severely limits the ability
to handle general S-G lists.  For example, a 1024-byte packet can't be
broken up into two 512-byte pieces unless the first piece ends at a
page boundary and the second piece begins at a page boundary.  Maybe
HWA host controllers are required to be more flexible, I don't know.

This may mean that your suggested approach won't work.

Alan Stern

