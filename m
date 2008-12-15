Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYLOLBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYLOLBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYLOLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:01:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47222 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYLOLBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:01:34 -0500
Date: Mon, 15 Dec 2008 12:03:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081215110310.GA10274@elf.ucw.cz>
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
> 
> Heck, if you have a hiccup while writing an inode table block out to
> disk (for example a power failure at just the wrong time), so the
...
> Ext3 tends to recover from this better than other filesystems, thanks
> to the fact that it does physical block journalling, but you do pay
> for this in terms of performance if you have a metadata-intensive
> workload, because you're writing more bytes to the journal for each
> metadata opeation.
> 
> > It seems like the more I learn about filesystems, the more failure modes  
> > there are and the fewer guarantees can be made.  It's amazing that  
> > things work as well as they do...
> 
> There are certainly things you can do.  Put your fileservers's on
> UPS's.  Use RAID.  Make backups.   Do all three.  :-)

Okay, so we pretty much	know that ext3 journalling helps in "user hit
the reset button" case. (And we are pretty sure ext2/ext3 works in
"clean unmount" case). Otherwise

*) kernel bug -> journalling does not help.

*) sudden powerfail -> journalling helps works on SGI high-end
hardware. It may or may not help on PC-class hardware.

We already do periodic checks, even on ext3. Maybe we should do fsck
more often if we see evidence of unclean shutdowns (because we know
PC hardware is crap...). I actually have patch somewhere, should I
ressurect it?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
