Return-Path: <linux-kernel-owner+w=401wt.eu-S1764612AbXJOBqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764612AbXJOBqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762601AbXJOBpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:45:49 -0400
Received: from thunk.org ([69.25.196.29]:34424 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759869AbXJOBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:45:47 -0400
Date: Sun, 14 Oct 2007 21:45:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015014503.GF9715@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>,
	James Bottomley <James.Bottomley@steeleye.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <20071013220539.GD29934@parisc-linux.org> <1192400672.3351.56.camel@localhost.localdomain> <200710141845.44750.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710141845.44750.rob@landley.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 06:45:44PM -0500, Rob Landley wrote:
> I admit a certain amount of personal annoyance that once the SCSI
> layer consumes a category of device (USB, SATA, PATA), they can
> often _only_ be used by going through the SCSI midlayer.  (This
> strikes me as analogous to TCP/IP claiming ethernet and PPP devices
> so thoroughly that you can no longer address them as eth1 or
> /dev/ttyS0.)

That's because modern USB, ATAPI (what was once known as IDE), SATA
really *all* using the SCSI command protocols at the low level, just
as Ethernet and PPP interfaces really are fundamentally the same
thing.  You can rail against it, but that's the mark of someone who
refuses to accept reality.

> This has the annoying effect of bundling together different types of
> devices and making device enumeration unnecessarily difficult: my
> laptop only has one SATA hard drive and can't gain another without a
> soldering iron, but that drive could move from /dev/sda to /dev/sdb
> if I reboot the system with a USB key plugged in.  This seems like a
> regrettable loss of orthogonality to me.  I remember back when
> /dev/usb0 and /dev/hda were separate devices that showed up in /dev,
> but these days "it's SCSI" seems to trump "it's USB", "it's ATA", or
> "it's SATA".  (Even though none of those are actually SCSI hardware,
> they just send a similar packet protocol across the wire.)

You're showing your ignorance here.  In fact in the past few years,
ATA and SCSI has been converging significantly, with the ATAPI
specification has essentially incorporating the SCSI protocol by
reference and by value --- with the point that SAS was developed by
the SCSI Trade Association, and SAS is effectively a superset of SATA,
to the point where with care, you can actually mix SAS and SATA drives
on the same in enclosure (SAS and SATA are physically compatible on
the connector level).

More to the point, with SATA, hot plugging has been designed in, so
probing order is not going to be well defined, just as with USB
devices.  And there are already relatively common situations where the
same disk can show up via multiple different interfaces.

For example, if you have a modern Thinkpad with an secondary SATA hard
drive in an Ultrabay, and you plug it into the Ultrabay in your T60,
it will show up as a SATA drive.  However, if you plug it into the
Advanced dock, it shows up as a USB device.  And with iSCSI not only
can you encapsulate a SCSI command stream over USB, you can do so over
IP as well.  In any case, regardless of how the physical SATA drive is
attached to the system, you want it to show up as the same device and
be mounted in the same location.

That's why identifying filesystem by UUID's or Labels is so critical.
This is not a new concept; we've had the capability to do this for
over a decade, and I always knew it would be necessary for us to do
this sooner or later --- which is why I added the UUID support to ext2
back in 1996.

> The fact that udev can theoretically unwind this hairball is not an
> excuse for conflating different categories of devices in the first
> place.

See the thinkpad Ultrabay drive example above.  You address hosts by
IP address; it doesn't matter whether you access them via a PPP
interface, or a wireless interface, or a ethernet interface.
Similarly, a disk could in theory be accessible over USB, SATA, or
iSCSI, and the Thinkpad example is only one such where the same
filesystem might be accessible over multiple interfaces.  And with
multipath fiber channel SAN's (and I hate to break it to you, but FC
also uses SCSI protocols) storage is very much looking more and more
like networking.

						- Ted
