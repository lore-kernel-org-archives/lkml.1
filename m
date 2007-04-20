Return-Path: <linux-kernel-owner+w=401wt.eu-S1423018AbXDTATm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbXDTATm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423020AbXDTATl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:19:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423019AbXDTATk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:19:40 -0400
Date: Thu, 19 Apr 2007 17:19:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
In-Reply-To: <20070419234014.GB3215@suse.de>
Message-ID: <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org>
References: <1175812632.17147.12.camel@localhost.localdomain>
 <200704191611.52125.jesse.barnes@intel.com>
 <20070419234014.GB3215@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Apr 2007, Greg KH wrote:

> On Thu, Apr 19, 2007 at 04:11:50PM -0700, Jesse Barnes wrote:
> > On Thursday, April 5, 2007 3:37 pm Adam Jackson wrote:
> > > So I'm attempting to do something fairly heinous (X server across
> > > five video cards), and I hit a fun bug in bridge range setup.  See
> > > attached lspci and dmesg, but the short of it is I've got two VGA
> > > chips on one card behind a bridge, which is itself behind a second
> > > PCI bridge, and the bridge ranges get set up so that I can't map the
> > > ROMs, which means I can't post them, and therefore can't use them
> > > period.

Ok, let me start out by saying that at this point in the development cycle 
(ie trying to get 2.6.21 out some day), I can't really find it in myself 
to care all that deeply about people doing something quote _that_ fairly 
heinous ;)

> > > The alignment restriction on the ROMs seems a bit extreme:
> > >
> > > % sudo setpci -s 7:2 ROM_ADDRESS=ffffffff
> > > % sudo setpci -s 7:2 ROM_ADDRESS
> > > f0000001

Yeah, they seem to want 256MB.

> > Yep, looks like those two devices had a problem.  Supposedly they want 
> > to sit at 256M?  Given that we're only giving each bridge 1M of memory 
> > space that would definitely be a problem.

We should be sizing the bridge regions by how much space the devices 
behind the bridges actually need, BUT I can guess at two problems:

 - On PC's, we generally trust any BIOS setup. If the bridge has been 
   initialized to some value that seems half-way valid we generally leave 
   it there. Moving things around tends to cause a lot  more problems than 
   it fixes.
 - we normally do *not* try to assign ROM resources at all, because a 
   number of video cards in particular do some really strange stuff with 
   the ROMS, like share the decoders for the ROM's and the other PCI 
   resources!

IOW, I think that what happens is that the BIOS has set it up to have a 
32MB window, and since the kernel doesn't think there is anything wrong 
with that, it leaves it well enough alone.

You could try adding "pci=rom" to the kernel command line, which should 
make the kernel try to assign space for the roms too.

I think we used to *never* assign PCI bus resources on x86, but that thing 
got fixed some time ago. Now I think we only re-assign them if they were 
unassigned *or* if the assignment wasn't working before. But I'm not 100% 
sure about that second part... It's been working so well that I don't 
think we've had a lot of problems with resource assignment lately, and 
I've paged it all out of my brain.

Ivan, can you remind my tired old brain?

		Linus
