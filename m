Return-Path: <linux-kernel-owner+w=401wt.eu-S1762439AbYDAVJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439AbYDAVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761206AbYDAVHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45594 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761095AbYDAVHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:48 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/14 VFS/Unionfs updates/fixes/cleanups
Date: Tue,  1 Apr 2008 17:06:42 -0400
Message-Id: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  Two of the
patches are VFS changes (and one of those two is rather minor).  There are
two major changes to Unionfs in this release:

1. Based on recommendations we've received while at LSF'08, we've changed
   Unionfs to use the vm_operations->fault method, instead of
   address_space_operations.  This makes unionfs's code smaller, runs faster
   (reduce memory pressure), and removes a number of potential races.  This
   change is significant, but is only an internal implementation change: it
   shouldn't change any user-visible behavior.  (Note: this change was
   inspired in part by Junjiro Okajima's work and suggestions -- thank you.)

   This change required some workarounds to VFS deficiencies for filesystems
   that want to use vm_ops->fault instead of address_space_operations.  In
   the next few weeks we'll be submitting patches that try to address these
   small deficiencies more cleanly.  One of those changes was necessary now
   (patch 02 of this patchset which exports vfs_splice* helpers).

2. Unionfs now implements a "delete-all" policy.  This means that if an
   object (e.g., a regular file) exists in multiple writable branches,
   unionfs will attempt to delete all instances of the same object, not just
   the first one it finds.  This helps to reduce the total number of
   whiteouts that unionfs has to create, and saves on the number of inodes
   consumed.  Of course, if a branch is marked or mounted read-only, then
   unionfs won't delete an object there, and only then will it fall back to
   creating a whiteout.  Since most users use only one writable branch in
   the unionfs, this change will probably affect only a small subset of
   people.  (Note: unionfs-odf already implements this delete-all policy, so
   this change here helps to synchronize the behavior of the two releases.)

These patches were tested (where appropriate) on 2.6.25-rc7, MM (mmotm
stamp-2008-04-01-02-39), as well as the backports to
2.6.{24,23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  Also tested with
LTP-full-20080229 and with a continuous parallel kernel compile (while
forcing cache flushing, manipulating lower branches, etc.).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (14):
      VFS: export release_open_intent as GPL symbol, not regular symbol
      VFS: rename do_splice_to/from to vfs_splice_* and export symbols
      Unionfs: implement splice_read/write methods directly
      Unionfs: implement vm_operations->fault
      Unionfs: lock our dentry in file operations
      Unionfs: reduce number of whiteouts by deleting all instances of files
      Unionfs: don't copy parent inode times in setattr
      Unionfs: use __func__ instead of __FUNCTION__
      Unionfs: use noinline_for_stack
      Unionfs: document reasons for opaque directories
      Unionfs: display mount point name along with generation number
      Unionfs: do not over-decrement lower superblock refs on remount
      Unionfs: don't purge lower sb data on remount
      Unionfs: update lower mnts on rmdir with copyup

 Documentation/filesystems/unionfs/concepts.txt |   61 ++++
 fs/namei.c                                     |    2 
 fs/splice.c                                    |   20 -
 fs/unionfs/commonfops.c                        |   32 --
 fs/unionfs/dentry.c                            |   13 
 fs/unionfs/dirfops.c                           |   18 -
 fs/unionfs/file.c                              |  203 +++++++++++++--
 fs/unionfs/inode.c                             |    3 
 fs/unionfs/lookup.c                            |   10 
 fs/unionfs/main.c                              |    7 
 fs/unionfs/mmap.c                              |  338 +++----------------------
 fs/unionfs/super.c                             |   38 +-
 fs/unionfs/union.h                             |   25 +
 fs/unionfs/unlink.c                            |  109 +++++---
 include/linux/splice.h                         |    5 
 15 files changed, 447 insertions(+), 437 deletions(-)

Thanks.
---
Erez Zadok
ezk@cs.sunysb.edu
