Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXFLUR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXFLUR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXFLURT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:17:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60500 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbXFLURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:17:18 -0400
Date: Tue, 12 Jun 2007 16:14:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070612201439.GI28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <170fa0d20706121253v62d13f70p3694eeab1852092a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20706121253v62d13f70p3694eeab1852092a@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:53:03PM -0400, Mike Snitzer wrote:
> On 6/12/07, Chris Mason <chris.mason@oracle.com> wrote:
> >Hello everyone,
> >
> >After the last FS summit, I started working on a new filesystem that
> >maintains checksums of all file data and metadata.  Many thanks to Zach
> >Brown for his ideas, and to Dave Chinner for his help on
> >benchmarking analysis.
> 
> Chris,
> 
> Given the substantial work that you've already put into btrfs and the
> direction you're Todo list details; it feels as though Btrfs will
> quickly provide the features that only Sun's ZFS provides.
> 
> Looking at your Btrfs benchmark and design pages it is clear that
> you're motivation is a filesystem that addresses modern concerns
> (performance that doesn't degrade over time, online fsck, fast offline
> fsck, data/metadata checksums, unlimited snapshots, efficient remote
> mirroring, etc).  There is still much "Todo" but you've made very
> impressive progress for the first announcement!
> 
> I have some management oriented questions/comments.
> 
> 1)
> Regarding the direction of Btrfs as it relates to integration with DM.
> The allocation policies, the ease of configuring DM-based
> striping/mirroring, management of large pools of storage all seems to
> indicate that Btrfs will manage the physical spindles internally.
> This is very ZFS-ish (ZFS pools) so I'd like to understand where you
> see Btrfs going in this area.

There's quite a lot of hand waving in that section.  What I'd like to do
is work closely with the LVM/DM/MD maintainers and come up with
something that leverages what linux already does.  I don't want to
rewrite LVM into the FS, but I do want to make better use of info about
the underlying storage.

> 
> Your initial benchmarks were all done ontop of a single disk with an
> LVM stack yet your roadmap/todo and design speaks to a tighter
> integration of the volume management features.  So long term is
> traditional LVM/MD functionality to be pulled directly into Btrfs?
> 
> 2)
> The Btrfs notion of subvolumes and snapshots is very elegant and
> provides for a fluid management of the filesystem system data.  It
> feels as though each subvolume/snapshot is just folded into the parent
> Btrfs volumes' namespace.  Was there any particular reason you elected
> to do this?  I can see that it lends itself to allowing snapshots of
> snapshots.  If you could elaborate I'd appreciate it.
> 
Yes, I wanted snapshots to be writable and resnapshottable.  It also
lowers the complexity to keep each snapshot as a subvolume/tree.

subvolumes are only slightly more expensive than a directory.  So, even
though a subvolume is a large grained unit for a snapshot, you can get
around this by just making more subvolumes.

> In practice subvolumes and/or snapshots appear to be implicitly
> mounted upon creation (refcount of parent is incremented).  Is this
> correct?  For snapshots, this runs counter to mapping the snapshots'
> data into the namespace of the origin Btrfs (e.g. with a .snapshot
> dir, but this is only useful for read-only snaps).  Having snapshot
> namespaces in terms of monolithic subvolumes puts a less intuitive
> face on N Btrfs snapshots.  The history of a given file/dir feels to
> be lost with this model.

That's somewhat true, the disk format does have enough information to
show you that history, but cleanly expressing it to the user is a
daunting task.

> 
> Aside from folding snapshot history into the origin's namespace... It
> could be possible to have a mount.btrfs that allows subvolumes and/or
> snapshot volumes to be mounted as unique roots?  I'd imagine a bind
> mount _could_ provide this too?  Anyway, I'm just interested in
> understanding the vision for managing the potentially complex nature
> of a Btrfs namespace.

One option is to put the real btrfs root into some directory in
(/sys/fs/btrfs/$device?) and then use tools in userland to mount -o bind
outside of that.  I wanted to wait to get fancy until I had a better
idea of how people would use the feature.
> 
> Thanks for doing all this work; I think the Linux community got a much
> needed shot in the arm with this Btrfs announcement.
> 

Thanks for the comments.

-chris
