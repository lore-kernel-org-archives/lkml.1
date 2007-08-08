Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXHHQRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXHHQRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765338AbXHHQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:16:35 -0400
Received: from lazybastard.de ([212.112.238.170]:55376 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763797AbXHHQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:16:33 -0400
Date: Wed, 8 Aug 2007 18:12:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: LogFS take five
Message-ID: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It has been a while, mainly because I found a bunch of races and didn't
want to publish anything before those were fixed.  Patch is still
against 2.6.21 and just for review.


Add LogFS, a scalable flash filesystem.


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

Signed-off-by: Jörn Engel <joern@logfs.org>
 fs/Kconfig            |   26 +
 fs/Makefile           |    1 
 fs/logfs/Locking      |   48 ++
 fs/logfs/Makefile     |   13 
 fs/logfs/compr.c      |   95 ++++
 fs/logfs/dir.c        |  761 ++++++++++++++++++++++++++++++++
 fs/logfs/file.c       |  176 +++++++
 fs/logfs/gc.c         |  404 +++++++++++++++++
 fs/logfs/inode.c      |  514 +++++++++++++++++++++
 fs/logfs/journal.c    |  737 +++++++++++++++++++++++++++++++
 fs/logfs/logfs.h      |  445 ++++++++++++++++++
 fs/logfs/memtree.c    |  258 ++++++++++
 fs/logfs/progs/fsck.c |  318 +++++++++++++
 fs/logfs/readwrite.c  | 1185 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/logfs/segment.c    |  602 +++++++++++++++++++++++++
 fs/logfs/super.c      |  569 ++++++++++++++++++++++++
 include/linux/Kbuild  |    1 
 include/linux/logfs.h |  500 +++++++++++++++++++++
 18 files changed, 6653 insertions(+)


Changed since Take 4:
o depend on MTD
o use LOGFS_BLOCKSHIFT in logfs_index
o #define EOF to 512
o moved BUILD_BUG_ON() into an inline function
o declare completion futility on the stack
o 64bit nanoseconds time format
o created logfs_compare_inode()
o created struct logfs_device_ops
o truncate() to zero sets embedded flag
o unwrap logfs_memcpy()
o add FS_READONLY flag to superblock
o create blockdev_device_ops
  This one still needs some infrastructure and testing.
o Fixed several data corruption bugs:
  - races between creat/unlink/rename and file write
  - logfs_is_valid ignoring on-disk state
  - logfs_rewrite forgetting to write inode
  All of them were harmless unless the system crashed at an inconvenient
time.
o Run one round of GC right after mount
  Fixes a rare deadlock bug.
o removed inode comparisions - they had 0% hit rate


Unchanged:
o convert #define's to enums.
  Afaics one of those has to be cast to u8, the other has to go through
  cpu_to_be64.  I don't see how enums are an advantage under such circumstances
  and Thomas didn't seem to be sure either.
o generic function for logfs_type()
o generic helper for logfs_prepare_write()
o removed EOF
o error handling
o move rootdir generation back to mkfs
o replace kmap() with kmap_atomic()
  Quite intrusive and I'm not happy with my current approach yet.
o document logfs_new_meta_inode()
o Use KMEM_CACHE() helper for kmem_cache_create()
o read object header first, then read or read&uncompress object data
o shrink inodes to 200 bytes
o remove global mutex in segment.c
o forbid file creation above mkfs limits
o add ifile_levels and data_levels options to mkfs


Won't happen (unless I get convinced to do otherwise):
o lowercase LOGFS_SUPER and LOGFS_INODE
  These simply match the common pattern used is many Linux filesystems.
o remove "extern"
  For structures, this keyword actually serves a purpose and makes sense.
  On the other hand, it is completely bogus for functions and I won't be
  bullied into adding bogus crud either.
o Move fs/logfs/Locking to Documentation/
  At least JFFS2 has such documentation in its own directory as well.
  I can see good arguments for either side and no strong consensus.  While
  I ultimately just don't case, doing nothing is a good option in cases
  of great uncertainty.
o change (void*) to "proper" cast
  Neither variant is much better than the other.  I'm open for suggestions
  to completely remove the casts, though.
o Change LOGFS_BUG() and LOGFS_BUG_ON() to inline functions
  These are macros for very much the same reasons BUG() and BUG_ON() are.
