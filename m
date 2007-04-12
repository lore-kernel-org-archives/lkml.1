Return-Path: <linux-kernel-owner+w=401wt.eu-S1161499AbXDLCvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161499AbXDLCvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbXDLCvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161499AbXDLCvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=oatGJ+8/8Iefm7a63gvCmd9LCo7bR2uizJgEG1F/cuhbKaDfJ/mm1F2py6uDVTtF4xmzNZ4FDSXrPBNSz8Z0OpcC3coT936xbubkDmMKM37PIBmYghCs5+nmCi3/cC08JXbiaQuGRFe3XhrYadfSm2Wz6roiA7OLAORKrje/vd8=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 0/17] fs: cleanup single page synchronous read interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin recently changed the read_cache_page interface to be
synchronous, which is pretty much what the file systems want anyway.  Turns
out that they have more in common than that, though, and some of them want
to be able to get an uptodate *locked* page.  Many of them want a kmapped
page, which is uptodate and unlocked, and they all have their own individual
helper functions to achieve this.

Since the helper functions are so similar, this patch just combines them
into a small number of simple library functions, which call read_cache_page
(renamed to __read_cache_page because it now returns a locked page).  The
immediate result is a vast reduction in the number of fs-specific helper
functions.  The secondary goal is to reduce the number of places the page
lock is taken, and eliminate a lot of PageUptodate and PageError checks.

The file systems that still use PageChecked now have checker functions that
return an error if the page is corrupted or has some other error.  This
simplifies the logic since the checker function is not part of any helper
function anymore.

Compile tested on x86_64.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

 drivers/mtd/devices/block2mtd.c          |   28 +------
 fs/afs/dir.c                             |   56 +++-----------
 fs/afs/mntpt.c                           |   10 --
 fs/cramfs/inode.c                        |    3 
 fs/ext2/dir.c                            |   82 ++++++++-------------
 fs/freevxfs/vxfs_extern.h                |    1 
 fs/freevxfs/vxfs_inode.c                 |    2 
 fs/freevxfs/vxfs_lookup.c                |    4 -
 fs/freevxfs/vxfs_subr.c                  |   33 --------
 fs/hfs/bnode.c                           |    4 -
 fs/hfsplus/bnode.c                       |    4 -
 fs/jffs2/fs.c                            |   27 -------
 fs/jffs2/gc.c                            |   15 ++-
 fs/jfs/jfs_metapage.c                    |    5 -
 fs/minix/dir.c                           |   59 ++++-----------
 fs/ntfs/aops.h                           |   67 -----------------
 fs/ntfs/bitmap.c                         |    8 +-
 fs/ntfs/dir.c                            |   65 ++++++-----------
 fs/ntfs/index.c                          |   12 +--
 fs/ntfs/lcnalloc.c                       |    6 -
 fs/ntfs/logfile.c                        |   12 +--
 fs/ntfs/mft.c                            |   53 +++++--------
 fs/ntfs/super.c                          |   38 ++++-----
 fs/ntfs/usnjrnl.c                        |    4 -
 fs/partitions/check.c                    |   14 +--
 fs/reiser4/plugin/file/tail_conversion.c |    8 --
 fs/reiser4/plugin/item/extent_file_ops.c |    9 --
 fs/reiserfs/xattr.c                      |   48 ++----------
 fs/sysv/dir.c                            |   19 +---
 fs/ufs/balloc.c                          |    8 +-
 fs/ufs/dir.c                             |   90 +++++++++--------------
 fs/ufs/truncate.c                        |    8 +-
 fs/ufs/util.c                            |   52 -------------
 fs/ufs/util.h                            |   10 --
 include/linux/pagemap.h                  |   53 ++++++++++++-
 mm/filemap.c                             |  118 +++++++------------------------
 36 files changed, 315 insertions(+), 720 deletions(-)
