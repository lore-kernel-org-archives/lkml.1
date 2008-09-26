Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYIZM5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYIZM5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYIZMyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57610 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYIZMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/12] GFS2: high time to take some time over atime
Date: Fri, 26 Sep 2008 13:00:53 +0100
Message-Id: <1222430455-4632-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-10-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-10-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, we've used the same scheme as GFS1 for atime. This has failed
since atime is a per vfsmnt flag, not a per fs flag and as such the
"noatime" flag was not getting passed down to the filesystems. This
patch removes all the "special casing" around atime updates and we
simply use the VFS's atime code.

The net result is that GFS2 will now support all the same atime related
mount options of any other filesystem on a per-vfsmnt basis. We do lose
the "lazy atime" updates, but we gain "relatime". We could add lazy
atime to the VFS at a later date, if there is a requirement for that
variant still - I suspect relatime will be enough.

Also we lose about 100 lines of code after this patch has been applied,
and I have a suspicion that it will speed things up a bit, even when
atime is "on". So it seems like a nice clean up as well.

>From a user perspective, everything stays the same except the loss of
the per-fs atime quantum tweekable (ought to be per-vfsmnt at the very
least, and to be honest I don't think anybody ever used it) and that a
number of options which were ignored before now work correctly.

Please let me know if you've got any comments. I'm pushing this out
early so that you can all see what my plans are.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 806e1eb..c962283 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1580,8 +1580,6 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
 		*p++ = 'a';
 	if (flags & GL_EXACT)
 		*p++ = 'E';
-	if (flags & GL_ATIME)
-		*p++ = 'a';
 	if (flags & GL_NOCACHE)
 		*p++ = 'c';
 	if (test_bit(HIF_HOLDER, &iflags))
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 971d92a..695c6b1 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -24,7 +24,6 @@
 #define GL_ASYNC		0x00000040
 #define GL_EXACT		0x00000080
 #define GL_SKIP			0x00000100
-#define GL_ATIME		0x00000200
 #define GL_NOCACHE		0x00000400
 
 #define GLR_TRYFAILED		13
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b2c5784..f1ed3a1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -420,7 +420,6 @@ struct gfs2_tune {
 	unsigned int gt_quota_scale_den; /* Denominator */
 	unsigned int gt_quota_cache_secs;
 	unsigned int gt_quota_quantum; /* Secs between syncs to quota file */
-	unsigned int gt_atime_quantum; /* Min secs between atime updates */
 	unsigned int gt_new_files_jdata;
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
 	unsigned int gt_stall_secs; /* Detects trouble! */
@@ -433,7 +432,6 @@ enum {
 	SDF_JOURNAL_CHECKED	= 0,
 	SDF_JOURNAL_LIVE	= 1,
 	SDF_SHUTDOWN		= 2,
-	SDF_NOATIME		= 3,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c8a959c..7cee695 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -18,6 +18,7 @@
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
 #include <linux/security.h>
+#include <linux/time.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -249,6 +250,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	struct gfs2_dinode_host *di = &ip->i_di;
 	const struct gfs2_dinode *str = buf;
+	struct timespec atime;
 	u16 height, depth;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
@@ -275,8 +277,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	di->di_size = be64_to_cpu(str->di_size);
 	i_size_write(&ip->i_inode, di->di_size);
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
-	ip->i_inode.i_atime.tv_sec = be64_to_cpu(str->di_atime);
-	ip->i_inode.i_atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
+	atime.tv_sec = be64_to_cpu(str->di_atime);
+	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
+	if (timespec_compare(&ip->i_inode.i_atime, &atime) < 0)
+		ip->i_inode.i_atime = atime;
 	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
 	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
 	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
@@ -1157,8 +1161,8 @@ int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
 	unsigned int x;
 	int error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &i_gh);
-	error = gfs2_glock_nq_atime(&i_gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &i_gh);
+	error = gfs2_glock_nq(&i_gh);
 	if (error) {
 		gfs2_holder_uninit(&i_gh);
 		return error;
@@ -1193,101 +1197,6 @@ out:
 	return error;
 }
 
-/**
- * gfs2_glock_nq_atime - Acquire a hold on an inode's glock, and
- *       conditionally update the inode's atime
- * @gh: the holder to acquire
- *
- * Tests atime (access time) for gfs2_read, gfs2_readdir and gfs2_mmap
- * Update if the difference between the current time and the inode's current
- * atime is greater than an interval specified at mount.
- *
- * Returns: errno
- */
-
-int gfs2_glock_nq_atime(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct gfs2_inode *ip = gl->gl_object;
-	s64 quantum = gfs2_tune_get(sdp, gt_atime_quantum);
-	unsigned int state;
-	int flags;
-	int error;
-	struct timespec tv = CURRENT_TIME;
-
-	if (gfs2_assert_warn(sdp, gh->gh_flags & GL_ATIME) ||
-	    gfs2_assert_warn(sdp, !(gh->gh_flags & GL_ASYNC)) ||
-	    gfs2_assert_warn(sdp, gl->gl_ops == &gfs2_inode_glops))
-		return -EINVAL;
-
-	state = gh->gh_state;
-	flags = gh->gh_flags;
-
-	error = gfs2_glock_nq(gh);
-	if (error)
-		return error;
-
-	if (test_bit(SDF_NOATIME, &sdp->sd_flags) ||
-	    (sdp->sd_vfs->s_flags & MS_RDONLY))
-		return 0;
-
-	if (tv.tv_sec - ip->i_inode.i_atime.tv_sec >= quantum) {
-		gfs2_glock_dq(gh);
-		gfs2_holder_reinit(LM_ST_EXCLUSIVE, gh->gh_flags & ~LM_FLAG_ANY,
-				   gh);
-		error = gfs2_glock_nq(gh);
-		if (error)
-			return error;
-
-		/* Verify that atime hasn't been updated while we were
-		   trying to get exclusive lock. */
-
-		tv = CURRENT_TIME;
-		if (tv.tv_sec - ip->i_inode.i_atime.tv_sec >= quantum) {
-			struct buffer_head *dibh;
-			struct gfs2_dinode *di;
-
-			error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-			if (error == -EROFS)
-				return 0;
-			if (error)
-				goto fail;
-
-			error = gfs2_meta_inode_buffer(ip, &dibh);
-			if (error)
-				goto fail_end_trans;
-
-			ip->i_inode.i_atime = tv;
-
-			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-			di = (struct gfs2_dinode *)dibh->b_data;
-			di->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
-			di->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
-			brelse(dibh);
-
-			gfs2_trans_end(sdp);
-		}
-
-		/* If someone else has asked for the glock,
-		   unlock and let them have it. Then reacquire
-		   in the original state. */
-		if (gfs2_glock_is_blocking(gl)) {
-			gfs2_glock_dq(gh);
-			gfs2_holder_reinit(state, flags, gh);
-			return gfs2_glock_nq(gh);
-		}
-	}
-
-	return 0;
-
-fail_end_trans:
-	gfs2_trans_end(sdp);
-fail:
-	gfs2_glock_dq(gh);
-	return error;
-}
-
 static int
 __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
 {
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index bfd2afc..2d43f69 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -92,7 +92,6 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
 int gfs2_permission(struct inode *inode, int mask);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
-int gfs2_glock_nq_atime(struct gfs2_holder *gh);
 int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
 struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index ae7126a..2756381 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -512,8 +512,8 @@ static int gfs2_readpage(struct file *file, struct page *page)
 	int error;
 
 	unlock_page(page);
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
-	error = gfs2_glock_nq_atime(&gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	error = gfs2_glock_nq(&gh);
 	if (unlikely(error))
 		goto out;
 	error = AOP_TRUNCATED_PAGE;
@@ -594,8 +594,8 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 	struct gfs2_holder gh;
 	int ret;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
-	ret = gfs2_glock_nq_atime(&gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
 	if (unlikely(ret))
 		goto out_uninit;
 	if (!gfs2_is_stuffed(ip))
@@ -636,8 +636,8 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	unsigned to = from + len;
 	struct page *page;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_ATIME, &ip->i_gh);
-	error = gfs2_glock_nq_atime(&ip->i_gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	error = gfs2_glock_nq(&ip->i_gh);
 	if (unlikely(error))
 		goto out_uninit;
 
@@ -1000,8 +1000,8 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	 * unfortunately have the option of only flushing a range like
 	 * the VFS does.
 	 */
-	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, GL_ATIME, &gh);
-	rv = gfs2_glock_nq_atime(&gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, &gh);
+	rv = gfs2_glock_nq(&gh);
 	if (rv)
 		return rv;
 	rv = gfs2_ok_for_dio(ip, rw, offset);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index e9a366d..3a747f8 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -89,8 +89,8 @@ static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
 	u64 offset = file->f_pos;
 	int error;
 
-	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, GL_ATIME, &d_gh);
-	error = gfs2_glock_nq_atime(&d_gh);
+	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+	error = gfs2_glock_nq(&d_gh);
 	if (error) {
 		gfs2_holder_uninit(&d_gh);
 		return error;
@@ -153,8 +153,8 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 	int error;
 	u32 fsflags;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
-	error = gfs2_glock_nq_atime(&gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	error = gfs2_glock_nq(&gh);
 	if (error)
 		return error;
 
@@ -351,8 +351,8 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	struct gfs2_alloc *al;
 	int ret;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_ATIME, &gh);
-	ret = gfs2_glock_nq_atime(&gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
 	if (ret)
 		goto out;
 
@@ -434,8 +434,8 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 	struct gfs2_holder i_gh;
 	int error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &i_gh);
-	error = gfs2_glock_nq_atime(&i_gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &i_gh);
+	error = gfs2_glock_nq(&i_gh);
 	if (error) {
 		gfs2_holder_uninit(&i_gh);
 		return error;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ae35f09..b117fcf 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -70,7 +70,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_quota_scale_den = 1;
 	gt->gt_quota_cache_secs = 300;
 	gt->gt_quota_quantum = 60;
-	gt->gt_atime_quantum = 3600;
 	gt->gt_new_files_jdata = 0;
 	gt->gt_max_readahead = 1 << 18;
 	gt->gt_stall_secs = 600;
@@ -135,22 +134,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	return sdp;
 }
 
-static void init_vfs(struct super_block *sb, unsigned noatime)
-{
-	struct gfs2_sbd *sdp = sb->s_fs_info;
-
-	sb->s_magic = GFS2_MAGIC;
-	sb->s_op = &gfs2_super_ops;
-	sb->s_export_op = &gfs2_export_ops;
-	sb->s_time_gran = 1;
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
-
-	if (sb->s_flags & (MS_NOATIME | MS_NODIRATIME))
-		set_bit(noatime, &sdp->sd_flags);
-
-	/* Don't let the VFS update atimes.  GFS2 handles this itself. */
-	sb->s_flags |= MS_NOATIME | MS_NODIRATIME;
-}
 
 /**
  * gfs2_check_sb - Check superblock
@@ -1100,7 +1083,11 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 		goto fail;
 	}
 
-	init_vfs(sb, SDF_NOATIME);
+	sb->s_magic = GFS2_MAGIC;
+	sb->s_op = &gfs2_super_ops;
+	sb->s_export_op = &gfs2_export_ops;
+	sb->s_time_gran = 1;
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
 	/* Set up the buffer cache and fill in some fake block size values
 	   to allow us to read-in the on-disk superblock. */
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 8f332d2..d5355d9 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -20,6 +20,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
+#include <linux/time.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -38,6 +39,7 @@
 #include "dir.h"
 #include "eattr.h"
 #include "bmap.h"
+#include "meta_io.h"
 
 /**
  * gfs2_write_inode - Make sure the inode is stable on the disk
@@ -50,16 +52,41 @@
 static int gfs2_write_inode(struct inode *inode, int sync)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-
-	/* Check this is a "normal" inode */
-	if (test_bit(GIF_USER, &ip->i_flags)) {
-		if (current->flags & PF_MEMALLOC)
-			return 0;
-		if (sync)
-			gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_holder gh;
+	struct buffer_head *bh;
+	struct timespec atime;
+	struct gfs2_dinode *di;
+	int ret = 0;
+
+	/* Check this is a "normal" inode, etc */
+	if (!test_bit(GIF_USER, &ip->i_flags) ||
+	    (current->flags & PF_MEMALLOC))
+		return 0;
+	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	if (ret)
+		goto do_flush;
+	ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (ret)
+		goto do_unlock;
+	ret = gfs2_meta_inode_buffer(ip, &bh);
+	if (ret == 0) {
+		di = (struct gfs2_dinode *)bh->b_data;
+		atime.tv_sec = be64_to_cpu(di->di_atime);
+		atime.tv_nsec = be32_to_cpu(di->di_atime_nsec);
+		if (timespec_compare(&inode->i_atime, &atime) > 0) {
+			gfs2_trans_add_bh(ip->i_gl, bh, 1);
+			gfs2_dinode_out(ip, bh->b_data);
+		}
+		brelse(bh);
 	}
-
-	return 0;
+	gfs2_trans_end(sdp);
+do_unlock:
+	gfs2_glock_dq_uninit(&gh);
+do_flush:
+	if (sync != 0)
+		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
+	return ret;
 }
 
 /**
@@ -297,14 +324,6 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 		}
 	}
 
-	if (*flags & (MS_NOATIME | MS_NODIRATIME))
-		set_bit(SDF_NOATIME, &sdp->sd_flags);
-	else
-		clear_bit(SDF_NOATIME, &sdp->sd_flags);
-
-	/* Don't let the VFS update atimes.  GFS2 handles this itself. */
-	*flags |= MS_NOATIME | MS_NODIRATIME;
-
 	return error;
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7484655..7e1879f 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -269,14 +269,6 @@ ARGS_ATTR(quota,           "%u\n");
 ARGS_ATTR(suiddir,         "%d\n");
 ARGS_ATTR(data,            "%d\n");
 
-/* one oddball doesn't fit the macro mold */
-static ssize_t noatime_show(struct gfs2_sbd *sdp, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			!!test_bit(SDF_NOATIME, &sdp->sd_flags));
-}
-static struct args_attr args_attr_noatime = __ATTR_RO(noatime);
-
 static struct attribute *args_attrs[] = {
 	&args_attr_lockproto.attr,
 	&args_attr_locktable.attr,
@@ -292,7 +284,6 @@ static struct attribute *args_attrs[] = {
 	&args_attr_quota.attr,
 	&args_attr_suiddir.attr,
 	&args_attr_data.attr,
-	&args_attr_noatime.attr,
 	NULL,
 };
 
@@ -407,7 +398,6 @@ TUNE_ATTR(incore_log_blocks, 0);
 TUNE_ATTR(log_flush_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
 TUNE_ATTR(quota_quantum, 0);
-TUNE_ATTR(atime_quantum, 0);
 TUNE_ATTR(max_readahead, 0);
 TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
@@ -427,7 +417,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_log_flush_secs.attr,
 	&tune_attr_quota_warn_period.attr,
 	&tune_attr_quota_quantum.attr,
-	&tune_attr_atime_quantum.attr,
 	&tune_attr_max_readahead.attr,
 	&tune_attr_complain_secs.attr,
 	&tune_attr_statfs_slow.attr,
-- 
1.5.5.1

