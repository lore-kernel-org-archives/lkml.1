Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXFMMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXFMMER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbXFMMED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:04:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54898 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbXFMMEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:04:01 -0400
Date: Wed, 13 Jun 2007 08:00:37 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, snitzer@gmail.com
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613120037.GA28279@think.oraclecorp.com>
References: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:45:28AM -0400, Albert Cahalan wrote:
> Neat! It's great to see somebody else waking up to the idea that
> storage media is NOT to be trusted.
> 
> Judging by the design paper, it looks like your structs have some
> alignment problems.

Actual defs are all packed, but I may still shuffle around the structs
to optimize alignment.  The keys are fixed, although I may make the u32
in the middle smaller.

> 
> The usual wishlist:
> 
> * inode-to-pathnames mapping

This one I'll code, it will help with inode link count verification.  I
want to be able to detect at run time that an inode with a link count of
zero is still actually in a directory. So there will be back pointers
from the inode to the directory.

Also, the incremental backup code will be able to walk the btree to find
inodes that have changed, and the backpointers will help make a list of
file names that need to be rsync'd or whatever.

> * a subvolume that is a single file (disk image, database, etc.)

subvolumes can be made that have a single file in them, but they have to
be directories right now.  Doing otherwise would complicate mounts and
other management tools (inside the btree, it doesn't really matter).

> * directory indexes to better support Wine and Samba
> * secure delete via destruction of per-file or per-block random crypto keys

I'd rather keep secure delete as a userland problem (or a layered FS
problem).  When you take backups and other copies of the file into
account, it's a bigger problem than btrfs wants to tackle right now.

> * fast (seekless) access to normal-sized SE Linux data

acls and xattrs will adjacent to the inode in the tree.  Most of the
time it'll be seekless.

> * atomic creation of copy-on-write directory trees

Do you mean something more fine grained than the current snapshotting
system?

> * immutable bits like UFS has

I'll do the ext2 chattr calls.

> * hole punch ability

Hole punching isn't harder or easier in btrfs than most other
filesystems that support holes.  It's largely a VM issue.

> * insert/delete ability (add/remove a chunk in the middle of a file)

The disk format makes this O(extent records past the chunk).  It's
possible to code but it would not be optimized.

-chris

