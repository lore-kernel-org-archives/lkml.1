Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbXJZT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbXJZT0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763637AbXJZT0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:26:03 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52770 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761830AbXJZTZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:25:58 -0400
Date: Fri, 26 Oct 2007 15:25:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [RFC PATCH 1/2] Remove highmem.h include from pagemap.h
Message-ID: <20071026192549.GA9214@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There has been a long-standing wart in linux/swap.h where it uses
page_cache_release and release_pages without declaring them by
including linux/pagemap.h.  There is this scary comment to warn off
anyone foolish enough to try to fix this:

       /* only sparc can not include linux/pagemap.h in this file
        * so leave page_cache_release and release_pages undeclared... */

This has caused problems for a number of people including:
     akpm - http://www.ussg.iu.edu/hypermail/linux/kernel/0708.3/0446.html
     	"Oh that damn thing again.  It's a regular source of
     	include breakage."
     ppc - http://patchwork.ozlabs.org/linuxppc/patch?id=12288
     UML - http://www.mail-archive.com/user-mode-linux-devel@lists.sourceforge.net/msg05095.html

What happens with sparc, when this include is added, is a linux/mm.h ->
linux/mm.h recursion: 
     linux/mm.h -> asm/pgtable.h -> linux/swap.h -> linux/pagemap.h ->
linux/highmem.h -> linux/mm.h
leaving various things that live in mm.h undefined in highmem.h.

sparc is unique in the asm/pgtable.h -> linux/swap.h inclusion.  This
looks correct, as pgtable.h uses swp_entry_t, which is defined in
swap.h, so maybe the other arches should do the same.  Adding this to
the UML pgtable.h causes the same build breakage.

All of the links in the recursion above look reasonable, except for
linux/pagemap.h -> linux/highmem.h, which is the point of attack for
this fix.

linux/pagemap.h uses nothing from linux/highmem.h, so doesn't need to
include it.  However, there are a number of files which use stuff from
highmem.h, don't include it, but do include pagemap.h.  This patch
removes the linux/pagemap.h -> linux/highmem.h inclusion and adds a
linux/highmem.h include to every file in the tree which now needs one.

---
 arch/parisc/kernel/cache.c           |    1 +
 drivers/block/rd.c                   |    1 +
 drivers/dma/iovlock.c                |    1 +
 drivers/media/video/ivtv/ivtv-udma.c |    1 +
 drivers/net/e1000/e1000_main.c       |    1 +
 drivers/net/e1000e/netdev.c          |    1 +
 fs/9p/vfs_addr.c                     |    1 +
 fs/affs/file.c                       |    1 +
 fs/affs/symlink.c                    |    1 +
 fs/afs/dir.c                         |    1 +
 fs/afs/fsclient.c                    |    1 +
 fs/afs/mntpt.c                       |    1 +
 fs/afs/rxrpc.c                       |    1 +
 fs/afs/write.c                       |    1 +
 fs/cifs/file.c                       |    1 +
 fs/cifs/inode.c                      |    1 +
 fs/coda/symlink.c                    |    1 +
 fs/cramfs/inode.c                    |    1 +
 fs/dlm/lowcomms.c                    |    1 +
 fs/ecryptfs/mmap.c                   |    1 +
 fs/ecryptfs/read_write.c             |    1 +
 fs/efs/symlink.c                     |    1 +
 fs/ext2/dir.c                        |    1 +
 fs/ext2/namei.c                      |    1 +
 fs/ext3/inode.c                      |    1 +
 fs/ext4/extents.c                    |    1 +
 fs/ext4/inode.c                      |    1 +
 fs/freevxfs/vxfs_immed.c             |    1 +
 fs/freevxfs/vxfs_subr.c              |    1 +
 fs/fuse/dev.c                        |    1 +
 fs/gfs2/bmap.c                       |    1 +
 fs/gfs2/lops.c                       |    1 +
 fs/gfs2/ops_address.c                |    1 +
 fs/gfs2/ops_file.c                   |    1 +
 fs/hfs/bnode.c                       |    1 +
 fs/hfs/btree.c                       |    1 +
 fs/hfsplus/bitmap.c                  |    1 +
 fs/hfsplus/bnode.c                   |    1 +
 fs/hfsplus/btree.c                   |    1 +
 fs/hostfs/hostfs_kern.c              |    1 +
 fs/hpfs/namei.c                      |    1 +
 fs/isofs/compress.c                  |    1 +
 fs/isofs/rock.c                      |    1 +
 fs/jbd/journal.c                     |    1 +
 fs/jbd2/journal.c                    |    1 +
 fs/jffs2/fs.c                        |    1 +
 fs/jfs/super.c                       |    1 +
 fs/libfs.c                           |    1 +
 fs/minix/namei.c                     |    1 +
 fs/namei.c                           |    1 +
 fs/ncpfs/dir.c                       |    1 +
 fs/ncpfs/mmap.c                      |    1 +
 fs/ncpfs/symlink.c                   |    1 +
 fs/nfs/dir.c                         |    1 +
 fs/nfs/nfs2xdr.c                     |    1 +
 fs/nfs/nfs3xdr.c                     |    1 +
 fs/nfs/nfs4proc.c                    |    1 +
 fs/nfs/nfs4xdr.c                     |    1 +
 fs/nfs/read.c                        |    1 +
 fs/nfs/symlink.c                     |    1 +
 fs/nfs/write.c                       |    1 +
 fs/ntfs/aops.c                       |    1 +
 fs/ntfs/file.c                       |    1 +
 fs/ocfs2/symlink.c                   |    1 +
 fs/reiserfs/ioctl.c                  |    1 +
 fs/reiserfs/stree.c                  |    1 +
 fs/reiserfs/tail_conversion.c        |    1 +
 fs/reiserfs/xattr.c                  |    1 +
 fs/romfs/inode.c                     |    1 +
 fs/smbfs/cache.c                     |    1 +
 fs/smbfs/dir.c                       |    1 +
 fs/smbfs/file.c                      |    1 +
 fs/splice.c                          |    1 +
 fs/sysv/namei.c                      |    1 +
 fs/udf/file.c                        |    1 +
 fs/udf/inode.c                       |    1 +
 fs/udf/symlink.c                     |    1 +
 fs/ufs/dir.c                         |    1 +
 fs/ufs/namei.c                       |    1 +
 include/linux/pagemap.h              |    1 -
 mm/filemap.c                         |    1 +
 mm/filemap_xip.c                     |    1 +
 mm/page-writeback.c                  |    1 +
 mm/page_alloc.c                      |    1 +
 mm/rmap.c                            |    1 +
 mm/swapfile.c                        |    1 +
 net/sunrpc/auth_gss/gss_krb5_wrap.c  |    1 +
 net/sunrpc/socklib.c                 |    1 +
 net/sunrpc/xdr.c                     |    1 +
 89 files changed, 88 insertions(+), 1 deletion(-)

Index: linux-2.6.17/include/linux/pagemap.h
===================================================================
--- linux-2.6.17.orig/include/linux/pagemap.h	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/include/linux/pagemap.h	2007-10-26 13:36:29.000000000 -0400
@@ -7,7 +7,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/list.h>
-#include <linux/highmem.h>
 #include <linux/compiler.h>
 #include <asm/uaccess.h>
 #include <linux/gfp.h>
Index: linux-2.6.17/fs/ext2/dir.c
===================================================================
--- linux-2.6.17.orig/fs/ext2/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ext2/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -25,6 +25,7 @@
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/highmem.h>
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
Index: linux-2.6.17/fs/ext2/namei.c
===================================================================
--- linux-2.6.17.orig/fs/ext2/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ext2/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -31,6 +31,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
Index: linux-2.6.17/fs/isofs/rock.c
===================================================================
--- linux-2.6.17.orig/fs/isofs/rock.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/isofs/rock.c	2007-10-26 13:36:29.000000000 -0400
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
+#include <linux/highmem.h>
 
 #include "isofs.h"
 #include "rock.h"
Index: linux-2.6.17/fs/jbd/journal.c
===================================================================
--- linux-2.6.17.orig/fs/jbd/journal.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/jbd/journal.c	2007-10-26 13:36:29.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
Index: linux-2.6.17/fs/libfs.c
===================================================================
--- linux-2.6.17.orig/fs/libfs.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/libfs.c	2007-10-26 13:36:29.000000000 -0400
@@ -9,6 +9,7 @@
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 #include <linux/exportfs.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 
Index: linux-2.6.17/fs/namei.c
===================================================================
--- linux-2.6.17.orig/fs/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -30,6 +30,7 @@
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
+#include <linux/highmem.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
Index: linux-2.6.17/fs/reiserfs/ioctl.c
===================================================================
--- linux-2.6.17.orig/fs/reiserfs/ioctl.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/reiserfs/ioctl.c	2007-10-26 13:36:29.000000000 -0400
@@ -10,6 +10,7 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/compat.h>
+#include <linux/highmem.h>
 
 static int reiserfs_unpack(struct inode *inode, struct file *filp);
 
Index: linux-2.6.17/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.17.orig/fs/reiserfs/stree.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/reiserfs/stree.c	2007-10-26 13:36:29.000000000 -0400
@@ -55,6 +55,7 @@
 #include <linux/reiserfs_fs.h>
 #include <linux/buffer_head.h>
 #include <linux/quotaops.h>
+#include <linux/highmem.h>
 
 /* Does the buffer contain a disk block which is in the tree. */
 inline int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
Index: linux-2.6.17/fs/reiserfs/tail_conversion.c
===================================================================
--- linux-2.6.17.orig/fs/reiserfs/tail_conversion.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/reiserfs/tail_conversion.c	2007-10-26 13:36:29.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/reiserfs_fs.h>
+#include <linux/highmem.h>
 
 /* access to tail : when one is going to read tail it must make sure, that is not running.
  direct2indirect and indirect2direct can not run concurrently */
Index: linux-2.6.17/fs/splice.c
===================================================================
--- linux-2.6.17.orig/fs/splice.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/splice.c	2007-10-26 13:36:29.000000000 -0400
@@ -29,6 +29,7 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 #include <linux/security.h>
+#include <linux/highmem.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
Index: linux-2.6.17/mm/rmap.c
===================================================================
--- linux-2.6.17.orig/mm/rmap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/rmap.c	2007-10-26 13:36:29.000000000 -0400
@@ -49,6 +49,7 @@
 #include <linux/rcupdate.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/highmem.h>
 
 #include <asm/tlbflush.h>
 
Index: linux-2.6.17/fs/hfs/bnode.c
===================================================================
--- linux-2.6.17.orig/fs/hfs/bnode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hfs/bnode.c	2007-10-26 13:36:29.000000000 -0400
@@ -10,6 +10,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/highmem.h>
 
 #include "btree.h"
 
Index: linux-2.6.17/fs/hfs/btree.c
===================================================================
--- linux-2.6.17.orig/fs/hfs/btree.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hfs/btree.c	2007-10-26 13:36:29.000000000 -0400
@@ -10,6 +10,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/log2.h>
+#include <linux/highmem.h>
 
 #include "btree.h"
 
Index: linux-2.6.17/arch/parisc/kernel/cache.c
===================================================================
--- linux-2.6.17.orig/arch/parisc/kernel/cache.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/arch/parisc/kernel/cache.c	2007-10-26 13:36:29.000000000 -0400
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/sched.h>
+#include <linux/highmem.h>
 #include <asm/pdc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
Index: linux-2.6.17/drivers/block/rd.c
===================================================================
--- linux-2.6.17.orig/drivers/block/rd.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/drivers/block/rd.c	2007-10-26 13:36:29.000000000 -0400
@@ -56,6 +56,7 @@
 #include <linux/backing-dev.h>
 #include <linux/blkpg.h>
 #include <linux/writeback.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 
Index: linux-2.6.17/drivers/dma/iovlock.c
===================================================================
--- linux-2.6.17.orig/drivers/dma/iovlock.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/drivers/dma/iovlock.c	2007-10-26 13:36:29.000000000 -0400
@@ -27,6 +27,7 @@
 
 #include <linux/dmaengine.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <net/tcp.h> /* for memcpy_toiovec */
 #include <asm/io.h>
 #include <asm/uaccess.h>
Index: linux-2.6.17/drivers/net/e1000e/netdev.c
===================================================================
--- linux-2.6.17.orig/drivers/net/e1000e/netdev.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/drivers/net/e1000e/netdev.c	2007-10-26 13:36:29.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/if_vlan.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/highmem.h>
 
 #include "e1000.h"
 
Index: linux-2.6.17/fs/9p/vfs_addr.c
===================================================================
--- linux-2.6.17.orig/fs/9p/vfs_addr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/9p/vfs_addr.c	2007-10-26 13:36:29.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/highmem.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
Index: linux-2.6.17/fs/afs/dir.c
===================================================================
--- linux-2.6.17.orig/fs/afs/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/afs/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
Index: linux-2.6.17/fs/afs/mntpt.c
===================================================================
--- linux-2.6.17.orig/fs/afs/mntpt.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/afs/mntpt.c	2007-10-26 13:36:29.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 
Index: linux-2.6.17/fs/afs/write.c
===================================================================
--- linux-2.6.17.orig/fs/afs/write.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/afs/write.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 static int afs_write_back_from_locked_page(struct afs_writeback *wb,
Index: linux-2.6.17/fs/cifs/file.c
===================================================================
--- linux-2.6.17.orig/fs/cifs/file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/cifs/file.c	2007-10-26 13:36:29.000000000 -0400
@@ -30,6 +30,7 @@
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/delay.h>
+#include <linux/highmem.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
Index: linux-2.6.17/fs/cifs/inode.c
===================================================================
--- linux-2.6.17.orig/fs/cifs/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/cifs/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
Index: linux-2.6.17/fs/coda/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/coda/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/coda/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
+#include <linux/highmem.h>
 
 #include <linux/coda.h>
 #include <linux/coda_linux.h>
Index: linux-2.6.17/fs/cramfs/inode.c
===================================================================
--- linux-2.6.17.orig/fs/cramfs/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/cramfs/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/highmem.h>
 #include <asm/semaphore.h>
 
 #include <asm/uaccess.h>
Index: linux-2.6.17/fs/dlm/lowcomms.c
===================================================================
--- linux-2.6.17.orig/fs/dlm/lowcomms.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/dlm/lowcomms.c	2007-10-26 13:36:29.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/sctp.h>
+#include <linux/highmem.h>
 #include <net/sctp/user.h>
 
 #include "dlm_internal.h"
Index: linux-2.6.17/fs/ecryptfs/mmap.c
===================================================================
--- linux-2.6.17.orig/fs/ecryptfs/mmap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ecryptfs/mmap.c	2007-10-26 13:36:29.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 #include "ecryptfs_kernel.h"
 
 struct kmem_cache *ecryptfs_lower_page_cache;
Index: linux-2.6.17/fs/ecryptfs/read_write.c
===================================================================
--- linux-2.6.17.orig/fs/ecryptfs/read_write.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ecryptfs/read_write.c	2007-10-26 13:36:29.000000000 -0400
@@ -22,6 +22,7 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include "ecryptfs_kernel.h"
 
 /**
Index: linux-2.6.17/fs/efs/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/efs/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/efs/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/smp_lock.h>
+#include <linux/highmem.h>
 
 static int efs_symlink_readpage(struct file *file, struct page *page)
 {
Index: linux-2.6.17/fs/ext3/inode.c
===================================================================
--- linux-2.6.17.orig/fs/ext3/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ext3/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/highmem.h>
 #include "xattr.h"
 #include "acl.h"
 
Index: linux-2.6.17/fs/ext4/extents.c
===================================================================
--- linux-2.6.17.orig/fs/ext4/extents.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ext4/extents.c	2007-10-26 13:36:29.000000000 -0400
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/falloc.h>
 #include <linux/ext4_fs_extents.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 
 
Index: linux-2.6.17/fs/ext4/inode.c
===================================================================
--- linux-2.6.17.orig/fs/ext4/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ext4/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/highmem.h>
 #include "xattr.h"
 #include "acl.h"
 
Index: linux-2.6.17/fs/freevxfs/vxfs_immed.c
===================================================================
--- linux-2.6.17.orig/fs/freevxfs/vxfs_immed.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/freevxfs/vxfs_immed.c	2007-10-26 13:36:29.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
+#include <linux/highmem.h>
 
 #include "vxfs.h"
 #include "vxfs_inode.h"
Index: linux-2.6.17/fs/freevxfs/vxfs_subr.c
===================================================================
--- linux-2.6.17.orig/fs/freevxfs/vxfs_subr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/freevxfs/vxfs_subr.c	2007-10-26 13:36:29.000000000 -0400
@@ -35,6 +35,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 #include "vxfs_extern.h"
 
Index: linux-2.6.17/fs/fuse/dev.c
===================================================================
--- linux-2.6.17.orig/fs/fuse/dev.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/fuse/dev.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/uio.h>
 #include <linux/miscdevice.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/file.h>
 #include <linux/slab.h>
 
Index: linux-2.6.17/fs/gfs2/ops_address.c
===================================================================
--- linux-2.6.17.orig/fs/gfs2/ops_address.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/gfs2/ops_address.c	2007-10-26 13:36:29.000000000 -0400
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/highmem.h>
 
 #include "gfs2.h"
 #include "incore.h"
Index: linux-2.6.17/fs/gfs2/ops_file.c
===================================================================
--- linux-2.6.17.orig/fs/gfs2/ops_file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/gfs2/ops_file.c	2007-10-26 13:36:29.000000000 -0400
@@ -21,6 +21,7 @@
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
 #include <linux/writeback.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
Index: linux-2.6.17/fs/hfsplus/bitmap.c
===================================================================
--- linux-2.6.17.orig/fs/hfsplus/bitmap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hfsplus/bitmap.c	2007-10-26 13:36:29.000000000 -0400
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
Index: linux-2.6.17/fs/hfsplus/bnode.c
===================================================================
--- linux-2.6.17.orig/fs/hfsplus/bnode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hfsplus/bnode.c	2007-10-26 13:36:29.000000000 -0400
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/swap.h>
+#include <linux/highmem.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
Index: linux-2.6.17/fs/hfsplus/btree.c
===================================================================
--- linux-2.6.17.orig/fs/hfsplus/btree.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hfsplus/btree.c	2007-10-26 13:36:29.000000000 -0400
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/log2.h>
+#include <linux/highmem.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
Index: linux-2.6.17/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.17.orig/fs/hostfs/hostfs_kern.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hostfs/hostfs_kern.c	2007-10-26 13:36:29.000000000 -0400
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
+#include <linux/highmem.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
Index: linux-2.6.17/fs/jbd2/journal.c
===================================================================
--- linux-2.6.17.orig/fs/jbd2/journal.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/jbd2/journal.c	2007-10-26 13:36:29.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
Index: linux-2.6.17/fs/jffs2/fs.c
===================================================================
--- linux-2.6.17.orig/fs/jffs2/fs.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/jffs2/fs.c	2007-10-26 13:36:29.000000000 -0400
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 #include <linux/crc32.h>
+#include <linux/highmem.h>
 #include "nodelist.h"
 
 static int jffs2_flash_setup(struct jffs2_sb_info *c);
Index: linux-2.6.17/fs/nfs/dir.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -34,6 +34,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/highmem.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
Index: linux-2.6.17/fs/nfs/nfs2xdr.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/nfs2xdr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/nfs2xdr.c	2007-10-26 13:36:29.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/nfs.h>
 #include <linux/nfs2.h>
 #include <linux/nfs_fs.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
Index: linux-2.6.17/fs/nfs/nfs4xdr.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/nfs4xdr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/nfs4xdr.c	2007-10-26 13:36:29.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_idmap.h>
+#include <linux/highmem.h>
 #include "nfs4_fs.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
Index: linux-2.6.17/fs/nfs/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/namei.h>
+#include <linux/highmem.h>
 
 /* Symlink caching in the page cache is even more simplistic
  * and straight-forward than readdir caching.
Index: linux-2.6.17/fs/ntfs/aops.c
===================================================================
--- linux-2.6.17.orig/fs/ntfs/aops.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ntfs/aops.c	2007-10-26 13:36:29.000000000 -0400
@@ -29,6 +29,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/bit_spinlock.h>
+#include <linux/highmem.h>
 
 #include "aops.h"
 #include "attrib.h"
Index: linux-2.6.17/fs/ntfs/file.c
===================================================================
--- linux-2.6.17.orig/fs/ntfs/file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ntfs/file.c	2007-10-26 13:36:29.000000000 -0400
@@ -26,6 +26,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/highmem.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
Index: linux-2.6.17/fs/ocfs2/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/ocfs2/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ocfs2/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/utsname.h>
+#include <linux/highmem.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
Index: linux-2.6.17/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.17.orig/fs/reiserfs/xattr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/reiserfs/xattr.c	2007-10-26 13:36:29.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/xattr.h>
 #include <linux/reiserfs_xattr.h>
 #include <linux/reiserfs_acl.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
 #include <linux/smp_lock.h>
Index: linux-2.6.17/fs/romfs/inode.c
===================================================================
--- linux-2.6.17.orig/fs/romfs/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/romfs/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -75,6 +75,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 
Index: linux-2.6.17/fs/smbfs/cache.c
===================================================================
--- linux-2.6.17.orig/fs/smbfs/cache.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/smbfs/cache.c	2007-10-26 13:36:29.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/smb_fs.h>
 #include <linux/pagemap.h>
 #include <linux/net.h>
+#include <linux/highmem.h>
 
 #include <asm/page.h>
 
Index: linux-2.6.17/fs/smbfs/file.c
===================================================================
--- linux-2.6.17.orig/fs/smbfs/file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/smbfs/file.c	2007-10-26 13:36:29.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/smp_lock.h>
 #include <linux/net.h>
 #include <linux/aio.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
Index: linux-2.6.17/fs/sysv/namei.c
===================================================================
--- linux-2.6.17.orig/fs/sysv/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/sysv/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -13,6 +13,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include "sysv.h"
 
 static int add_nondir(struct dentry *dentry, struct inode *inode)
Index: linux-2.6.17/fs/udf/file.c
===================================================================
--- linux-2.6.17.orig/fs/udf/file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/udf/file.c	2007-10-26 13:36:29.000000000 -0400
@@ -37,6 +37,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/aio.h>
+#include <linux/highmem.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
Index: linux-2.6.17/fs/udf/inode.c
===================================================================
--- linux-2.6.17.orig/fs/udf/inode.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/udf/inode.c	2007-10-26 13:36:29.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
Index: linux-2.6.17/fs/udf/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/udf/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/udf/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/highmem.h>
 #include "udf_i.h"
 
 static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char *to)
Index: linux-2.6.17/mm/filemap.c
===================================================================
--- linux-2.6.17.orig/mm/filemap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/filemap.c	2007-10-26 13:36:29.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/syscalls.h>
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
+#include <linux/highmem.h>
 #include "internal.h"
 
 /*
Index: linux-2.6.17/mm/filemap_xip.c
===================================================================
--- linux-2.6.17.orig/mm/filemap_xip.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/filemap_xip.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/uio.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
+#include <linux/highmem.h>
 #include <asm/tlbflush.h>
 
 /*
Index: linux-2.6.17/mm/page-writeback.c
===================================================================
--- linux-2.6.17.orig/mm/page-writeback.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/page-writeback.c	2007-10-26 13:36:29.000000000 -0400
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/highmem.h>
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
Index: linux-2.6.17/mm/page_alloc.c
===================================================================
--- linux-2.6.17.orig/mm/page_alloc.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/page_alloc.c	2007-10-26 13:36:29.000000000 -0400
@@ -43,6 +43,7 @@
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
+#include <linux/highmem.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
Index: linux-2.6.17/mm/swapfile.c
===================================================================
--- linux-2.6.17.orig/mm/swapfile.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/mm/swapfile.c	2007-10-26 13:36:29.000000000 -0400
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/capability.h>
 #include <linux/syscalls.h>
+#include <linux/highmem.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
Index: linux-2.6.17/net/sunrpc/auth_gss/gss_krb5_wrap.c
===================================================================
--- linux-2.6.17.orig/net/sunrpc/auth_gss/gss_krb5_wrap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/net/sunrpc/auth_gss/gss_krb5_wrap.c	2007-10-26 13:36:29.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/pagemap.h>
 #include <asm/scatterlist.h>
 #include <linux/crypto.h>
+#include <linux/highmem.h>
 
 #ifdef RPC_DEBUG
 # define RPCDBG_FACILITY	RPCDBG_AUTH
Index: linux-2.6.17/net/sunrpc/socklib.c
===================================================================
--- linux-2.6.17.orig/net/sunrpc/socklib.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/net/sunrpc/socklib.c	2007-10-26 13:36:29.000000000 -0400
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/udp.h>
 #include <linux/sunrpc/xdr.h>
+#include <linux/highmem.h>
 
 
 /**
Index: linux-2.6.17/net/sunrpc/xdr.c
===================================================================
--- linux-2.6.17.orig/net/sunrpc/xdr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/net/sunrpc/xdr.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/msg_prot.h>
+#include <linux/highmem.h>
 
 /*
  * XDR functions for basic NFS types
Index: linux-2.6.17/drivers/media/video/ivtv/ivtv-udma.c
===================================================================
--- linux-2.6.17.orig/drivers/media/video/ivtv/ivtv-udma.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/drivers/media/video/ivtv/ivtv-udma.c	2007-10-26 13:36:29.000000000 -0400
@@ -20,6 +20,7 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/highmem.h>
 #include "ivtv-driver.h"
 #include "ivtv-udma.h"
 
Index: linux-2.6.17/drivers/net/e1000/e1000_main.c
===================================================================
--- linux-2.6.17.orig/drivers/net/e1000/e1000_main.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/drivers/net/e1000/e1000_main.c	2007-10-26 13:36:29.000000000 -0400
@@ -27,6 +27,7 @@
 *******************************************************************************/
 
 #include "e1000.h"
+#include <linux/highmem.h>
 #include <net/ip6_checksum.h>
 
 char e1000_driver_name[] = "e1000";
Index: linux-2.6.17/fs/affs/file.c
===================================================================
--- linux-2.6.17.orig/fs/affs/file.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/affs/file.c	2007-10-26 13:36:29.000000000 -0400
@@ -12,6 +12,7 @@
  *  affs regular file handling primitives
  */
 
+#include <linux/highmem.h>
 #include "affs.h"
 
 #if PAGE_SIZE < 4096
Index: linux-2.6.17/fs/affs/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/affs/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/affs/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -8,6 +8,7 @@
  *  affs symlink handling code
  */
 
+#include <linux/highmem.h>
 #include "affs.h"
 
 static int affs_symlink_readpage(struct file *file, struct page *page)
Index: linux-2.6.17/fs/afs/fsclient.c
===================================================================
--- linux-2.6.17.orig/fs/afs/fsclient.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/afs/fsclient.c	2007-10-26 13:36:29.000000000 -0400
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/circ_buf.h>
+#include <linux/highmem.h>
 #include "internal.h"
 #include "afs_fs.h"
 
Index: linux-2.6.17/fs/hpfs/namei.c
===================================================================
--- linux-2.6.17.orig/fs/hpfs/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/hpfs/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -6,6 +6,7 @@
  *  adding & removing files & directories
  */
 #include <linux/sched.h>
+#include <linux/highmem.h>
 #include "hpfs_fn.h"
 
 static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
Index: linux-2.6.17/fs/isofs/compress.c
===================================================================
--- linux-2.6.17.orig/fs/isofs/compress.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/isofs/compress.c	2007-10-26 13:36:29.000000000 -0400
@@ -21,6 +21,7 @@
 
 #include <linux/vmalloc.h>
 #include <linux/zlib.h>
+#include <linux/highmem.h>
 
 #include "isofs.h"
 #include "zisofs.h"
Index: linux-2.6.17/fs/jfs/super.c
===================================================================
--- linux-2.6.17.orig/fs/jfs/super.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/jfs/super.c	2007-10-26 13:36:29.000000000 -0400
@@ -28,6 +28,7 @@
 #include <linux/posix_acl.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 
Index: linux-2.6.17/fs/minix/namei.c
===================================================================
--- linux-2.6.17.orig/fs/minix/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/minix/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -4,6 +4,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#include <linux/highmem.h>
 #include "minix.h"
 
 static int add_nondir(struct dentry *dentry, struct inode *inode)
Index: linux-2.6.17/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.17.orig/fs/ncpfs/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ncpfs/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include <linux/smp_lock.h>
Index: linux-2.6.17/fs/ncpfs/mmap.c
===================================================================
--- linux-2.6.17.orig/fs/ncpfs/mmap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ncpfs/mmap.c	2007-10-26 13:36:29.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/fcntl.h>
 #include <linux/ncp_fs.h>
+#include <linux/highmem.h>
 
 #include "ncplib_kernel.h"
 #include <asm/uaccess.h>
Index: linux-2.6.17/fs/ncpfs/symlink.c
===================================================================
--- linux-2.6.17.orig/fs/ncpfs/symlink.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ncpfs/symlink.c	2007-10-26 13:36:29.000000000 -0400
@@ -29,6 +29,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/stat.h>
+#include <linux/highmem.h>
 #include "ncplib_kernel.h"
 
 
Index: linux-2.6.17/fs/nfs/nfs3xdr.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/nfs3xdr.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/nfs3xdr.c	2007-10-26 13:36:29.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/nfs3.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfsacl.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
Index: linux-2.6.17/fs/nfs/nfs4proc.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/nfs4proc.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/nfs4proc.c	2007-10-26 13:36:29.000000000 -0400
@@ -48,6 +48,7 @@
 #include <linux/smp_lock.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/highmem.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
Index: linux-2.6.17/fs/nfs/read.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/read.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/read.c	2007-10-26 13:36:29.000000000 -0400
@@ -19,6 +19,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
 #include <linux/smp_lock.h>
+#include <linux/highmem.h>
 
 #include <asm/system.h>
 
Index: linux-2.6.17/fs/nfs/write.c
===================================================================
--- linux-2.6.17.orig/fs/nfs/write.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/nfs/write.c	2007-10-26 13:36:29.000000000 -0400
@@ -19,6 +19,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 
Index: linux-2.6.17/fs/smbfs/dir.c
===================================================================
--- linux-2.6.17.orig/fs/smbfs/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/smbfs/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/smb_fs.h>
 #include <linux/smb_mount.h>
 #include <linux/smbno.h>
+#include <linux/highmem.h>
 
 #include "smb_debug.h"
 #include "proto.h"
Index: linux-2.6.17/fs/ufs/dir.c
===================================================================
--- linux-2.6.17.orig/fs/ufs/dir.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ufs/dir.c	2007-10-26 13:36:29.000000000 -0400
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
 #include <linux/swap.h>
+#include <linux/highmem.h>
 
 #include "ufs.h"
 #include "swab.h"
Index: linux-2.6.17/fs/ufs/namei.c
===================================================================
--- linux-2.6.17.orig/fs/ufs/namei.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/ufs/namei.c	2007-10-26 13:36:29.000000000 -0400
@@ -31,6 +31,7 @@
 #include <linux/fs.h>
 #include <linux/ufs_fs.h>
 #include <linux/smp_lock.h>
+#include <linux/highmem.h>
 #include "ufs.h"
 #include "util.h"
 
Index: linux-2.6.17/fs/afs/rxrpc.c
===================================================================
--- linux-2.6.17.orig/fs/afs/rxrpc.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/afs/rxrpc.c	2007-10-26 13:36:29.000000000 -0400
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/highmem.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <rxrpc/packet.h>
Index: linux-2.6.17/fs/gfs2/bmap.c
===================================================================
--- linux-2.6.17.orig/fs/gfs2/bmap.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/gfs2/bmap.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
+#include <linux/highmem.h>
 
 #include "gfs2.h"
 #include "incore.h"
Index: linux-2.6.17/fs/gfs2/lops.c
===================================================================
--- linux-2.6.17.orig/fs/gfs2/lops.c	2007-10-26 13:34:44.000000000 -0400
+++ linux-2.6.17/fs/gfs2/lops.c	2007-10-26 13:36:29.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/highmem.h>
 
 #include "gfs2.h"
 #include "incore.h"
