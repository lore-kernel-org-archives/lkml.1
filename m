Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYLCFYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYLCFYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYLCFYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:24:33 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51336 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750847AbYLCFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:24:32 -0500
Date: Wed, 3 Dec 2008 00:07:09 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Friesen <cfriesen@nortel.com>, mikulas@artax.karlin.mff.cuni.cz,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203050709.GL20858@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, Chris Friesen <cfriesen@nortel.com>,
	mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
	kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202224403.GA8277@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 11:44:03PM +0100, Pavel Machek wrote:
> > >
> > > Yikes.  I was under the impression that once the journal hit the platter  
> > > then the data were safe (barring media corruption).
> > 
> > Well, this is a case of media corruption (or a cosmic ray hitting
> > hitting a ribbon cable in the disk controller sending the write to the
> > wrong location on disk, or someone bumping the server causing the disk
> > head to lift up a little higher than normal while it was writing the
> > disk sector, etc.).  But it is a case of the hard drive misbehaving. 
> 
> I could not parse this. Negation seems to be missing somewhere.

I was agreeing with your original statement.  Once the journal hits
the platter, the data is safe, barring hard drive malfunctions (not
just media corruption).  I was just listing the many other types of
hard drive failures that could cause data loss.

> > Heck, if you have a hiccup while writing an inode table block out to
> > disk (for example a power failure at just the wrong time), so the
> > memory (which is more voltage sensitive than hard drives) DMA's
> > garbage which gets written to the inode table, you could lose a large
> > number of adjacent inodes when garbage gets splatted over the inode
> > table.
> 
> Ok, "memory failed before disk" is ... bad hardware.

It's PC class hardware.  Live with it.  Back when SGI made their own
hardware, they noticed this problem, and so they wired up their SGI
machines with powerfail interrupts, and extra big capacitors in their
power supplies, and when Irix got a powerfail interrupt, it would
frantically run around aborting DMA transfers to avoid this particular
problem.  At least, that's what an old-timer SGI engineer (who is
unfortunately no longer at SGI) told me.

PC class hardware don't have power fail interrupts.  Hence, my advice
to you is that if you use a filesystem that does logical journalling
--- better have a UPS.

> ...but... you seem to be saying that modern filesystems can damage
> data even on "sane" hardware.

The example I gave was one where a disk failure could cause a file
that had previously been sucessfully written to disk and fsync()'ed to
be damaged by another filesystem operation ***in the face of hard
drive failure***.  Surely that is obvious.  The most obvious case of
that might be if the disk controller gets confused and slams a data
block into the wrong location on disk (there's a reason why DIF
includes the sector number in its checksum and why some enterprise
databases do the same thing in their tablespace blocks --- it happens
often enough that paranoid data integrity engineers worry about it).

The example I gave, where a b-tree is doing split, and there is a
failure writing to the b-tree causing ancillary damage files
referenced in the b-tree node getting split, can happen with **any**
filesystem.  The only thing that will save you here would be a
copy-on-write type filesystem, such as WAFL or btrfs.

> You seem to be saying that ext2/ext3 only work if these are met:
> 
> 1) power may fail any time.

Well, ext2/ext3 will work fine if the power is always reliable, too.  :-)

> 2) writes are always successful.

To the extent that write failures while writing filesystem metdata
can, if you are unluky be catastrophic, yeah.  Fortunally normally
such write failures are fairly rare, but if you worry about such
things, RAID is the answer.  As I said, I believe this is going to be
true for pretty much any update-in-place filesystem.  It's always
possible to construct failure scenarios if the hardware is unreliable.

> 
> 3) connection to the disk always works.
> 
> AFAICT it is unsafe to run ext2/ext3 on any media that can be removed
> without unmounting (missing fsync error propagation), and it is unsafe
> to run ext2/ext3 on any flash-based storage with block interface (SD
> cards, flash sticks).

The data on the disk before the connection is yanked should be safe
(although as we mentioned in another thread, the flash drive itself
may not be happy if you are writing to the Flash Translation Layer at
the time when power is cut; if that causes a previously written sector
to disappear, that's an example of a hardware failure that **any**
filesystem won't necessarily be able to recover from).

Your definition of "safe" seems to include worrying about making sure
that all processes that may have previously touched a file or a
directory gets an error when they try to do an fsync() on that file or
directory, and that given that fsync clears the error condition after
it returns it,it is therefore "unsafe".  

The reality is that most applications don't proper error checking, and
even fewer actually call fsync(), so if you are putting your root
filesytem on a 32G flash card, and it pops out easily due to hardware
design issues, the question of whether fsync() gets properly progated
to all potentially interested applications is the ***least*** of your
worries.

							- Ted
