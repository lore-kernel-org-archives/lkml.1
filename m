Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbXFMRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbXFMRAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXFMRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:00:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52849 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbXFMRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:00:42 -0400
Date: Wed, 13 Jun 2007 12:57:06 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, snitzer@gmail.com
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613165706.GF28279@think.oraclecorp.com>
References: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com> <20070613120037.GA28279@think.oraclecorp.com> <787b0d920706130914l676a24cau62525e90a90b5839@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706130914l676a24cau62525e90a90b5839@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:14:40PM -0400, Albert Cahalan wrote:
> On 6/13/07, Chris Mason <chris.mason@oracle.com> wrote:
> >On Wed, Jun 13, 2007 at 01:45:28AM -0400, Albert Cahalan wrote:
> 
> >> The usual wishlist:
> >>
> >> * inode-to-pathnames mapping
> >
> >This one I'll code, it will help with inode link count verification.  I
> >want to be able to detect at run time that an inode with a link count of
> >zero is still actually in a directory. So there will be back pointers
> >from the inode to the directory.
> 
> Great, but fsck improvement wasn't on my mind. This is
> a desirable feature for the NFS server, and for regular users.
> Think about a backup program trying to maintain hard links.

Sure, it'll be there either way ;)

> 
> >Also, the incremental backup code will be able to walk the btree to find
> >inodes that have changed, and the backpointers will help make a list of
> >file names that need to be rsync'd or whatever.
> >
> >> * a subvolume that is a single file (disk image, database, etc.)
> >
> >subvolumes can be made that have a single file in them, but they have to
> >be directories right now.  Doing otherwise would complicate mounts and
> >other management tools (inside the btree, it doesn't really matter).
> 
> Bummer. As I understand it, ZFS provides this. :-)

Grin, when the pain of typing cd subvol is btrfs' biggest worry, I'll be
doing very well.

> 
> >> * directory indexes to better support Wine and Samba
> >> * secure delete via destruction of per-file or per-block random crypto 
> >keys
> >
> >I'd rather keep secure delete as a userland problem (or a layered FS
> >problem).  When you take backups and other copies of the file into
> >account, it's a bigger problem than btrfs wants to tackle right now.
> 
> It can't be a userland problem if you allow disk blocks to move.
> Volume resizing, logging/journalling, etc. -- they combine to make
> the userland solution essentially impossible. (one could wipe the
> whole partition, or maybe fill ALL space on the volume)

Right about here is where I would insert a long story about ecryptfs, or
encryption solutions that happen all in userland.  At any rate, it is
outside the scope of v1.0, even though I definitely agree it is an
important problem for some people.

> >> * atomic creation of copy-on-write directory trees
> >
> >Do you mean something more fine grained than the current snapshotting
> >system?
> 
> I believe so. Example: I have a linux-2.6 directory. It's not
> a mount point or anything special like that. I want to copy
> it to a new directory called wip, without actually copying
> all the blocks. To all the normal POSIX API stuff, this copy
> should look like the result of "cp -a", not hard links.

This would be a snapshot, which has to be done on a subvolume right now.
It is not as nice as being able to pick a random directory, but I've
only been able to get this far by limiting the feature scope
significantly.  What I did do was make subvolumes very cheap...just make
a bunch of them.

Keep in mind that if you implement a cow directory tree without a
snapshot, and you don't want to duplicate any blocks in the cow, you're
going to have fun with inode numbers.

-chris

