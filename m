Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753451AbYLRDxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYLRDxX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 22:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYLRDxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 22:53:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:57936 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYLRDxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 22:53:08 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm] nilfs2: fix gc failure on volumes keeping numerous snapshots
Date: Thu, 18 Dec 2008 12:50:22 +0900
Message-Id: <1229572222-22247-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves the following failure of nilfs2 cleaner daemon:

 nilfs_cleanerd[20670]: cannot clean segments: No such file or directory
 nilfs_cleanerd[20670]: shutdown

When creating thousands of snapshots, the cleaner daemon had rarely
died as above due to an error returned from the kernel code.

After applying the recent patch which fixed memory allocation problems
in ioctl (Message-Id: <20081215.155840.105124170.ryusuke@osrg.net>),
the problem gets more frequent.

It turned out to be a bug of nilfs_ioctl_wrap_copy function and one of
its callback routines to read out information of snapshots; if the
nilfs_ioctl_wrap_copy function divided a large read request into
multiple requests, the second and later requests have failed since a
restart position on snapshot meta data was not properly set forward.

It's a deficiency of the callback interface that cannot pass the
restart position among multiple requests.  This patch fixes the issue
by allowing nilfs_ioctl_wrap_copy and snapshot read functions to
exchange a position argument.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   24 ++++++++++++++----------
 fs/nilfs2/cpfile.h |    2 +-
 fs/nilfs2/ioctl.c  |   38 +++++++++++++++++++++++---------------
 3 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 991633a..3ac0bb4 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -422,20 +422,20 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
 	return ret;
 }
 
-static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
+static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 					  struct nilfs_cpinfo *ci, size_t nci)
 {
 	struct buffer_head *bh;
 	struct nilfs_cpfile_header *header;
 	struct nilfs_checkpoint *cp;
-	__u64 curr, next;
+	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
 	int n, ret;
 
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
-	if (cno == 0) {
+	if (curr == 0) {
 		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 		if (ret < 0)
 			goto out;
@@ -448,8 +448,11 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 			ret = 0;
 			goto out;
 		}
-	} else
-		curr = cno;
+	} else if (unlikely(curr == ~(__u64)0)) {
+		ret = 0;
+		goto out;
+	}
+
 	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
 	if (ret < 0)
@@ -461,7 +464,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
 		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 		if (next == 0) {
-			curr = next;
+			curr = ~(__u64)0; /* Terminator */
 			n++;
 			break;
 		}
@@ -480,6 +483,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
 	}
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(bh);
+	*cnop = curr;
 	ret = n;
 
  out:
@@ -494,15 +498,15 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
  * @ci:
  * @nci:
  */
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile,
-				__u64 cno, int mode,
+
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 				struct nilfs_cpinfo *ci, size_t nci)
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
 	case NILFS_SNAPSHOT:
-		return nilfs_cpfile_do_get_ssinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index f097e90..1a8a100 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -39,7 +39,7 @@ int nilfs_cpfile_delete_checkpoint(struct inode *, __u64);
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
 int nilfs_cpfile_is_snapshot(struct inode *, __u64);
 int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64, int,
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int,
 				struct nilfs_cpinfo *, size_t);
 
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 5ce06a0..d9e3990 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -37,13 +37,14 @@
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
 				 ssize_t (*dofunc)(struct the_nilfs *,
-						   int, int,
+						   __u64 *, int,
 						   void *, size_t, size_t))
 {
 	void *buf;
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
+	__u64 pos, ppos;
 
 	if (argv->v_nmembs == 0)
 		return 0;
@@ -58,6 +59,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 
 	ret = 0;
 	total = 0;
+	pos = argv->v_index;
 	for (i = 0; i < argv->v_nmembs; i += n) {
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
@@ -68,8 +70,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 			ret = -EFAULT;
 			break;
 		}
-		nr = (*dofunc)(nilfs, argv->v_index + i, argv->v_flags, buf,
-			       argv->v_size, n);
+		ppos = pos;
+		nr = (*dofunc)(nilfs, &pos, argv->v_flags, buf, argv->v_size,
+			       n);
 		if (nr < 0) {
 			ret = nr;
 			break;
@@ -82,6 +85,10 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 			break;
 		}
 		total += nr;
+		if ((size_t)nr < n)
+			break;
+		if (pos == ppos)
+			pos += n;
 	}
 	argv->v_nmembs = total;
 
@@ -138,10 +145,10 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, index, flags, buf,
+	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
 				       nmembs);
 }
 
@@ -186,10 +193,10 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, index, buf, nmembs);
+	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
 }
 
 static int nilfs_ioctl_get_suinfo(struct inode *inode, struct file *filp,
@@ -233,7 +240,7 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			 void *buf, size_t size, size_t nmembs)
 {
 	return nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -262,7 +269,7 @@ static int nilfs_ioctl_get_vinfo(struct inode *inode, struct file *filp,
 }
 
 static ssize_t
-nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
@@ -341,7 +348,7 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 }
 
 static ssize_t
-nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			   void *buf, size_t size, size_t nmembs)
 {
 	struct inode *inode;
@@ -413,7 +420,7 @@ static inline int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, int index,
+nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, __u64 *posp,
 				  int flags, void *buf, size_t size,
 				  size_t nmembs)
 {
@@ -439,7 +446,7 @@ static inline int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			      void *buf, size_t size, size_t nmembs)
 {
 	int ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -456,8 +463,9 @@ static inline int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, int index, int flags,
-				 void *buf, size_t size, size_t nmembs)
+nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, __u64 *posp,
+				 int flags, void *buf, size_t size,
+				 size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
 	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
@@ -506,7 +514,7 @@ static inline int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 }
 
 static ssize_t
-nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			     void *buf, size_t size, size_t nmembs)
 {
 	struct nilfs_sb_info *sbi = nilfs_get_writer(nilfs);
-- 
1.5.6.5

