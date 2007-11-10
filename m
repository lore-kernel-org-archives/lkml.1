Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXKJVVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXKJVVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXKJVU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:20:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4651 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754231AbXKJVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:20:55 -0500
Date: Sat, 10 Nov 2007 16:20:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: linux-usb-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <mdharm-usb@one-eyed-alien.net>, <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Linux-usb-users] USB storage: corrupted data transfers
In-Reply-To: <47361D24.8020708@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711101611290.9084-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Mark Lord wrote:

> Something may be broken in USB / usb-storage land.
> 
> I've got a 2GB USB stick here.
> I want to copy it to an image file on my hard drive:
> 
>     cat /dev/sdb > usbkey.image1
> 
> Make a second copy, with or without unplugging/replugging the stick:
> 
>     cat /dev/sdb > usbkey.image2
> 
> After doing this, the two copies *differ*.
> 
> So I wrote a little program to compare them and determine *how* they differ,
> and the result is very interesting.
> 
> Periodically, or or the other file has 8192 *zero* bytes inserted
> in place of it's data.   Not replacing it's data, just inserted
> into the stream, causing the real data (which follows) to be offset by 8192.

That's strange.  It happens periodically, you say?  What's the period?

> If one skips over the inserted 8192 bytes in the file, the data from that point
> onward matches the other file, until another 8192 zeros are encountered.
> 
> The total sizes of the two image files match each other,
> but that's probably just due to the logic in the 'cat' program.
> 
> I wonder where those extraneous pairs of zero pages are coming from?

Me too.  It seems rather unlikely that they are coming from the USB
device or the transport, since at that level everything is addressed in
terms of sector numbers.  I don't see how 16 extra sectors could just
get inserted.  More believable would be a problem in the block layer,
the filesystem, or the application.

> This makes USB drives somewhat unreliable for backups and the like,
> which unfortunately is exactly what just about everybody uses them for.

Or it makes all drives somewhat unreliable, depending on just where the 
problem is.

> This (so far) is with 2.6.23.1 (w/slab allocater), and 2.6.24-rc2,
> on two different machines (both Intel based, but different chipset, CPU, RAM, ...).
> 
> I suspect not all brands/models of USB sticks would give the same results,
> but it is rather worrisome that it happens at all.

You could try doing a more specific test.  Write a program to access
the block device sector-by-sector and store a distinct recognizable
byte pattern to each sector.  (Maybe just repeat the 4-byte sector 
number over and over.)  Then write another program to read the
data back and see what bytes ended up in which sectors.

At the same time, use the usbmon facility (see
Documentation/usb/usbmon.txt) to record exactly what data gets sent
to/from the stick.  That should at least be sufficient to determine the
problem is in the stick itself, in the SCSI/USB layers, or someplace
higher up.

Alan Stern

