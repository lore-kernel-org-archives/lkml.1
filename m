Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYLBWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYLBWmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYLBWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:42:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYLBWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:42:22 -0500
Date: Tue, 2 Dec 2008 23:44:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202224403.GA8277@elf.ucw.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202205558.GD20858@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 15:55:58, Theodore Tso wrote:
> On Tue, Dec 02, 2008 at 11:22:58AM -0600, Chris Friesen wrote:
> > Theodore Tso wrote:
> >
> >> Even for ext3/ext4 which is doing physical journalling, it's still the
> >> case that the journal commits first, and it's only later when the
> >> write happens that we write out the change.  If the disk fails some of
> >> the writes, it's possible to lose data, especially if the two blocks
> >> involved in the node split are far apart, and the write to the
> >> existing old btree block fails.
> >
> > Yikes.  I was under the impression that once the journal hit the platter  
> > then the data were safe (barring media corruption).
> 
> Well, this is a case of media corruption (or a cosmic ray hitting
> hitting a ribbon cable in the disk controller sending the write to the
> wrong location on disk, or someone bumping the server causing the disk
> head to lift up a little higher than normal while it was writing the
> disk sector, etc.).  But it is a case of the hard drive misbehaving. 

I could not parse this. Negation seems to be missing somewhere.

> Heck, if you have a hiccup while writing an inode table block out to
> disk (for example a power failure at just the wrong time), so the
> memory (which is more voltage sensitive than hard drives) DMA's
> garbage which gets written to the inode table, you could lose a large
> number of adjacent inodes when garbage gets splatted over the inode
> table.

Ok, "memory failed before disk" is ... bad hardware.

...but... you seem to be saying that modern filesystems can damage
data even on "sane" hardware.

Lets define sane as:

1) if disk says sector was successfully written, it is so, until you
start writing to that sector again.

	(but disk may say "error writing". Filesystem should propagate
	that back to the userland, reliably. "Error writing" is
	extremely rare on modern disks, but can happen if you run out
	of spare blocks.)

	(and if you ask for sector write, sector is in undefined 
	state until drive returns success. Flashes behave like this
	-- reads return errors. Do disks?)

2) connection to the disk either works or fails totally. Bit errors
are reliably detected at connection level.

3) power may fail any time.

You seem to be saying that ext2/ext3 only work if these are met:

1) power may fail any time.

2) writes are always successful.

3) connection to the disk always works.

AFAICT it is unsafe to run ext2/ext3 on any media that can be removed
without unmounting (missing fsync error propagation), and it is unsafe
to run ext2/ext3 on any flash-based storage with block interface (SD
cards, flash sticks).
 
> Ext3 tends to recover from this better than other filesystems, thanks
> to the fact that it does physical block journalling, but you do pay
> for this in terms of performance if you have a metadata-intensive
> workload, because you're writing more bytes to the journal for each
> metadata opeation.

And thanks for that! Actually I'd be willing to pay some more
performance to get reliability up.

> > It seems like the more I learn about filesystems, the more failure modes  
> > there are and the fewer guarantees can be made.  It's amazing that  
> > things work as well as they do...
> 
> There are certainly things you can do.  Put your fileservers's on
> UPS's.  Use RAID.  Make backups.   Do all three.  :-)

I was almost stupid enough to move primary copy of ~ and linux trees
to SD... I do have UPSes, unfortunately they are li-ion and i'm
running off them most of the time. I do have backups, but restoring
them all the time is boring & time consuming. I'll try to stick two
MMC cards into SD slot to make it RAID 1 :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
