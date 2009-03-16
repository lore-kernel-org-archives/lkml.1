Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbZCPT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbZCPT0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZCPT0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:26:30 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45541
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZCPT02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:26:28 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 14:26:23 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, tytso@mit.edu, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz>
In-Reply-To: <20090316122847.GI2405@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161426.24904.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 07:28:47 Pavel Machek wrote:
> Hi!
> > > +	Fortunately writes failing are very uncommon on traditional
> > > +	spinning disks, as they have spare sectors they use when write
> > > +	fails.
> >
> > I vaguely recall that the behavior of when a write error _does_ occur is
> > to remount the filesystem read only?  (Is this VFS or per-fs?)
>
> Per-fs.

Might be nice to note that in the doc.

> > Is there any kind of hotplug event associated with this?
>
> I don't think so.

There probably should be, but that's a separate issue.

> > I'm aware write errors shouldn't happen, and by the time they do it's too
> > late to gracefully handle them, and all we can do is fail.  So how do we
> > fail?
>
> Well, even remount-ro may be too late, IIRC.

Care to elaborate?  (When a filesystem is mounted RO, I'm not sure what 
happens to the pages that have already been dirtied...)

> > (Writes aren't always cleanly at the start of an erase block, so critical
> > data _before_ what you touch is endangered too.)
>
> Well, flashes do remap, so it is actually "random blocks".

Fun.

When "please do not turn of your playstation until game save completes" 
honestly seems like the best solution for making the technology reliable, 
something is wrong with the technology.

I think I'll stick with rotating disks for now, thanks.

> > > +	otherwise, disks may write garbage during powerfail.
> > > +	Not sure how common that problem is on generic PC machines.
> > > +
> > > +	Note that atomic write is very hard to guarantee for RAID-4/5/6,
> > > +	because it needs to write both changed data, and parity, to
> > > +	different disks.
> >
> > These days instead of "atomic" it's better to think in terms of
> > "barriers".
>
> This is not about barriers (that should be different topic). Atomic
> write means that either whole sector is written, or nothing at all is
> written. Because raid5 needs to update both master data and parity at
> the same time, I don't think it can guarantee this during powerfail.

Good point, but I thought that's what journaling was for?

I'm aware that any flash filesystem _must_ be journaled in order to work 
sanely, and must be able to view the underlying erase granularity down to the 
bare metal, through any remapping the hardware's doing.  Possibly what's 
really needed is a "flash is weird" section, since flash filesystems can't be 
mounted on arbitrary block devices.

Although an "-O erase_size=128" option so they _could_ would be nice.  There's 
"mtdram" which seems to be the only remaining use for ram disks, but why there 
isn't an "mtdwrap" that works with arbitrary underlying block devices, I have 
no idea.  (Layering it on top of a loopback device would be most useful.)

> > > +Requirements
> > > +* write errors not allowed
> > > +
> > > +* sector writes are atomic
> > > +
> > > +(see expectations.txt; note that most/all linux block-based
> > > +filesystems have similar expectations)
> > > +
> > > +* write caching is disabled. ext2 does not know how to issue barriers
> > > +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
> >
> > And here we're talking about ext2.  Does neither one know about write
> > barriers, or does this just apply to ext2?  (What about ext4?)
>
> This document is about ext2. Ext3 can support barriers in
> 2.6.28. Someone else needs to write ext4 docs :-).
>
> > Also I remember a historical problem that not all disks honor write
> > barriers, because actual data integrity makes for horrible benchmark
> > numbers.  Dunno how current that is with SATA, Alan Cox would probably
> > know.
>
> Sounds like broken disk, then. We should blacklist those.

It wasn't just one brand of disk cheating like that, and you'd have to ask him 
(or maybe Jens Axboe or somebody) whether the problem is still current.  I've 
been off in embedded-land for a few years now...

Rob
