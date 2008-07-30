Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYG3CrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYG3CrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYG3Cod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46275 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYG3Co0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:26 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu
Subject: [GIT PULL -mm] 00/19 fsstack+Unionfs updates/fixes/cleanups
Date: Tue, 29 Jul 2008 22:43:30 -0400
Message-Id: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs, and one for
fsstack.  This series includes four types of changes:

1. Fold in Hugh Dickins's fsstack_copy_inode_size fix.  Since it depends on
   code in unionfs, I'm temporarily folding this patch into my tree.  I'll
   extract it into a separate patch which can be applied cleanly against
   2.6.27-rc in the next few days.

2. Assorted fixes to adderess VFS API changes in 2.6.26/2.6.27-rc1:
   ->symlink, ->permission, nameidata intent flags changed, and
   kmem_cache_create prototype changed.

3. Extracted all whiteout related code into a separate file, and cleaned it
   up a lot.  Now the main unionfs code calls somewhat generic functions
   such as "check if there's a whiteout" or "create a whiteout" and the
   like.  Once Bharata whiteout code makes it in, it would be easy to make
   unionfs use filesystem-native whiteout support.

4. Reworked much of the lookup code in unionfs to ensure that we have a
   vfsmount at every lookup stage, esp. when crossing directories.  In
   particular, started using vfs_path_lookup instead of lookup_one_len.
   These changes are a first but important step towards getting rid of all
   vfs_* calls within unionfs in preparation for having Miklos's path_*
   calls.

There were also a few smaller bug fixes: memleak (also from Hugh Dickins),
some cache coherency fixes, and a fix to an LTP/rename13 regression.

These patches were tested (where appropriate) on v2.6.27-rc1, MM, as well as
the backports to 2.6.{26,25,24,23,22,21,20,19,18,9} on ext2/3/4, xfs,
reiserfs, nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and squashfs (where
available).  Also tested with LTP-full-20080630 and with a continuous
parallel kernel compile (while forcing cache flushing, manipulating lower
branches, etc.).  See http://unionfs.filesystems.org/ to download
back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (18):
      Unionfs: simplify the macros used to get/set the dentry start/end branches
      Unionfs: move a rename helper closer to rename code
      Unionfs: create and consolidate helpers to iput lower objects
      Unionfs: create and consolidate helpers to path-put lower objects
      Unionfs: simplify stale-inode detection code
      Unionfs: overhaul whiteout code
      Unionfs: lookup overhaul using vfs_path_lookup
      Unionfs: free lower paths array when destroying dentry's private data
      Unionfs: cache coherency fixes
      Unionfs: remove old lookup code
      Unionfs: update maintainers
      Unionfs: update copyrights
      Unionfs: minor checkpatch fixes
      Unionfs: properly hash newly created inodes
      Unionfs: symlink no longer takes a mode parameter
      Unionfs: permission no longer takes a nameidata parameter
      Unionfs: LOOKUP_ACCESS intent no longer exists
      Unionfs: use new kmem_cache_create constructor prototype

Hugh Dickins (1):
      LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a

 MAINTAINERS              |    3 
 fs/stack.c               |   58 ++-
 fs/unionfs/Makefile      |    2 
 fs/unionfs/commonfops.c  |   32 -
 fs/unionfs/copyup.c      |   45 +-
 fs/unionfs/debug.c       |    8 
 fs/unionfs/dentry.c      |  123 +++----
 fs/unionfs/dirfops.c     |   28 -
 fs/unionfs/dirhelper.c   |  130 -------
 fs/unionfs/fanout.h      |  158 ++++++---
 fs/unionfs/file.c        |    6 
 fs/unionfs/inode.c       |  225 ++-----------
 fs/unionfs/lookup.c      |  769 ++++++++++++++++++++---------------------------
 fs/unionfs/main.c        |   40 --
 fs/unionfs/mmap.c        |    6 
 fs/unionfs/rdstate.c     |    6 
 fs/unionfs/rename.c      |  206 ++++--------
 fs/unionfs/sioq.c        |   26 -
 fs/unionfs/sioq.h        |    7 
 fs/unionfs/subr.c        |  209 ------------
 fs/unionfs/super.c       |   22 -
 fs/unionfs/union.h       |   58 +--
 fs/unionfs/unlink.c      |   28 -
 fs/unionfs/whiteout.c    |  577 +++++++++++++++++++++++++++++++++++
 fs/unionfs/xattr.c       |    6 
 include/linux/fs_stack.h |    3 
 include/linux/union_fs.h |    6 
 27 files changed, 1384 insertions(+), 1403 deletions(-)

Thanks.
---
Erez Zadok
ezk@cs.sunysb.edu
