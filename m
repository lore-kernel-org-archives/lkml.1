Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXFLTxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXFLTxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXFLTxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:53:08 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:7709 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbXFLTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jfvd8OHoArknUwaz3pYiTL8W9nMOIVhUiMRkfV7ELsa1LouQyaSGQVczK/vhPMTZ2LAof9UlI2MtpsyhTSR4Ih0HPEjdsLDba7tWntCaDP/nebQwxI39OzgjOY6G5iCCndoMfBd68iQ89C19D6OntWmkF3WS8kykFvzj3QzTKig=
Message-ID: <170fa0d20706121253v62d13f70p3694eeab1852092a@mail.gmail.com>
Date: Tue, 12 Jun 2007 15:53:03 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070612161029.GB28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612161029.GB28279@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Chris Mason <chris.mason@oracle.com> wrote:
> Hello everyone,
>
> After the last FS summit, I started working on a new filesystem that
> maintains checksums of all file data and metadata.  Many thanks to Zach
> Brown for his ideas, and to Dave Chinner for his help on
> benchmarking analysis.
>
> The basic list of features looks like this:
>
>         * Extent based file storage (2^64 max file size)
>         * Space efficient packing of small files
>         * Space efficient indexed directories
>         * Dynamic inode allocation
>         * Writable snapshots
>         * Subvolumes (separate internal filesystem roots)
>         - Object level mirroring and striping
>         * Checksums on data and metadata (multiple algorithms available)
>         - Strong integration with device mapper for multiple device support
>         - Online filesystem check
>         * Very fast offline filesystem check
>         - Efficient incremental backup and FS mirroring
>
> The ones with marked with * are mostly working, and the others are on
> my todo list.  There are more details on the FS design, some benchmarks
> and download links here:
>
> http://oss.oracle.com/~mason/btrfs/
>
> The current status is a very early alpha state, and the kernel code
> weighs in at a sparsely commented 10,547 lines.  I'm releasing now in
> hopes of finding people interested in testing, benchmarking,
> documenting, and contributing to the code.
>
> I've gotten this far pretty quickly, and plan on continuing to knock off
> the features as fast as I can.  Hopefully I'll manage a release every
> few weeks or so.  The disk format will probably change in some major way
> every couple of releases.
>
> The TODO list has some critical stuff:
>
>         * Ability to return -ENOSPC instead of oopsing
>         * mmap()ed writes
>         * Fault tolerance, (EIO, bad metadata etc)
>         * Concurrency.  I use one mutex for all operations today
>         * ACLs and extended attributes
>         * Reclaim dead roots after a crash
>         * Various other bits from the feature list above
>
> And finally, here's a quick and dirty summary of the FS design points:
>
>         * One large Btree per subvolume
>         * Copy on write logging for all data and metadata
>         * Reference count snapshots are the basis of the transaction
>           system.  A transaction is just a snapshot where the old root
>           is immediately deleted on commit
>         * Subvolumes can be snapshotted any number of times
>         * Snapshots are read/write and can be snapshotted again
>         * Directories are doubly indexed to improve readdir speeds
>
> So, please give it a try or a look and let me know what you think.

Chris,

Given the substantial work that you've already put into btrfs and the
direction you're Todo list details; it feels as though Btrfs will
quickly provide the features that only Sun's ZFS provides.

Looking at your Btrfs benchmark and design pages it is clear that
you're motivation is a filesystem that addresses modern concerns
(performance that doesn't degrade over time, online fsck, fast offline
fsck, data/metadata checksums, unlimited snapshots, efficient remote
mirroring, etc).  There is still much "Todo" but you've made very
impressive progress for the first announcement!

I have some management oriented questions/comments.

1)
Regarding the direction of Btrfs as it relates to integration with DM.
 The allocation policies, the ease of configuring DM-based
striping/mirroring, management of large pools of storage all seems to
indicate that Btrfs will manage the physical spindles internally.
This is very ZFS-ish (ZFS pools) so I'd like to understand where you
see Btrfs going in this area.

Your initial benchmarks were all done ontop of a single disk with an
LVM stack yet your roadmap/todo and design speaks to a tighter
integration of the volume management features.  So long term is
traditional LVM/MD functionality to be pulled directly into Btrfs?

2)
The Btrfs notion of subvolumes and snapshots is very elegant and
provides for a fluid management of the filesystem system data.  It
feels as though each subvolume/snapshot is just folded into the parent
Btrfs volumes' namespace.  Was there any particular reason you elected
to do this?  I can see that it lends itself to allowing snapshots of
snapshots.  If you could elaborate I'd appreciate it.

In practice subvolumes and/or snapshots appear to be implicitly
mounted upon creation (refcount of parent is incremented).  Is this
correct?  For snapshots, this runs counter to mapping the snapshots'
data into the namespace of the origin Btrfs (e.g. with a .snapshot
dir, but this is only useful for read-only snaps).  Having snapshot
namespaces in terms of monolithic subvolumes puts a less intuitive
face on N Btrfs snapshots.  The history of a given file/dir feels to
be lost with this model.

Aside from folding snapshot history into the origin's namespace... It
could be possible to have a mount.btrfs that allows subvolumes and/or
snapshot volumes to be mounted as unique roots?  I'd imagine a bind
mount _could_ provide this too?  Anyway, I'm just interested in
understanding the vision for managing the potentially complex nature
of a Btrfs namespace.

Thanks for doing all this work; I think the Linux community got a much
needed shot in the arm with this Btrfs announcement.

regards,
Mike
