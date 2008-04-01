Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYDCRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYDCRKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYDCRJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:09:49 -0400
Received: from lazybastard.de ([212.112.238.170]:35967 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYDCRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:09:48 -0400
Message-Id: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [patch 0/15] LogFS take five
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add LogFS, a scalable flash filesystem.

Patch is split into individual files for review.  Several details
will surely raise eyebrows and likely require changes:
- Using two page flags where only one is generally available for
  filesystems.  One of the flags is necessary to deal with a deadlock
  when writepage() sends a locked page for writing.  Details can be
  found in readwrite.c, around the definition of PG_pre_locked.
  Added Nick Piggin to Cc: for that detail.
- Caching in the mtd layer.  This should likely be moved into
  drivers/mtd/mtdcore.c.
  David Woodhouse on Cc: for this.
- An not-quite-polished btree library that should get some more polish
  and move to lib/btree.c.  Unless someone else has better code
  already.

Checkpatch.pl spits out two errors.  Neither of these looks like a
clear-cut case to me.  If someone has a good suggestion for either
one, I'll happily follow that.

And it is currently reasonably simple to run into a deadlock when
using logfs on a block device.  The problem appears to be the block
layer allocating memory for its cache without GFP_NOFS, so that under
memory pressure logfs writes through block layer may recurse back to
logfs writes.  Not entirely sure who is to blame for this bug and how to
solve it.

Added Jens Axboe for this detail.


Motivation 1:

Linux currently has 1-2 flash filesystems to choose from, JFFS2 and
YAFFS.  The latter has never made a serious attempt of kernel
integration, which may disqualify it to some.

The two main problems of JFFS2 are memory consumption and mount time.
Unlike most filesystems, there is no tree structure of any sorts on
the medium, so the complete medium needs to be scanned at mount time
and a tree structure kept in-memory while the filesystem is mounted.
With bigger devices, both mount time and memory consumption increase
linearly.

JFFS2 has recently gained summary support, which helps reduce mount
time by a constant factor.  Linear scalability remains.  YAFFS
appears to be better by a constant factor, yet still scales linearly.

LogFS has an on-medium tree, fairly similar to Ext2 in structure, so
mount times are O(1).  In absolute terms, the OLPC system has mount
times of ~3.3s for JFFS2 and ~60ms for LogFS.


Motivation 2:

Flash is becoming increasingly common in standard PC hardware.  Nearly
a dozen different manufacturers have announced Solid State Disks
(SSDs), the OLPC and the Intel Classmate no longer contain hard disks
and ASUS announced a flash-only Laptop series for regular consumers.
And that doesn't even mention the ubiquitous USB-Sticks, SD-Cards,
etc.

Flash behaves significantly different to hard disks.  In order to use
flash, the current standard practice is to add an emulation layer and
an old-fashioned hard disk filesystem.  As can be expected, this is
eating up some of the benefits flash can offer over hard disks.

In principle it is possible to achieve better performance with a flash
filesystem than with the current emulated approach.  In practice our
current flash filesystems are not even near that theoretical goal.
LogFS in its current state is already closer.


Signed-off-by: Joern Engel <joern@logfs.org>

 fs/Kconfig           |   17 
 fs/Makefile          |    1 
 fs/logfs/Makefile    |   14 
 fs/logfs/compr.c     |   95 ++
 fs/logfs/dev_bdev.c  |  146 ++++
 fs/logfs/dev_mtd.c   |  406 ++++++++++++
 fs/logfs/dir.c       |  765 ++++++++++++++++++++++++
 fs/logfs/file.c      |  236 +++++++
 fs/logfs/gc.c        |  729 ++++++++++++++++++++++
 fs/logfs/inode.c     |  575 ++++++++++++++++++
 fs/logfs/journal.c   |  805 +++++++++++++++++++++++++
 fs/logfs/logfs.h     |  555 +++++++++++++++++
 fs/logfs/logfs_abi.h |  523 ++++++++++++++++
 fs/logfs/memtree.c   |  405 ++++++++++++
 fs/logfs/readwrite.c | 1618 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/logfs/segment.c   |  595 ++++++++++++++++++
 fs/logfs/super.c     |  375 +++++++++++
 17 files changed, 7860 insertions(+)

