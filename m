Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXBEOXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXBEOXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXBEOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:23:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbXBEOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:23:07 -0500
Subject: [GFS2] Clean up/speed up readdir [27/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:31:09 +0000
Message-Id: <1170685869.11001.325.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61133418ca162e7685eb8f04b063852689963473 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 17 Jan 2007 15:09:20 +0000
Subject: [PATCH] [GFS2] Clean up/speed up readdir

This removes the extra filldir callback which gfs2 was using to
enclose an attempt at readahead for inodes during readdir. The
code was too complicated and also hurts performance badly in the
case that the getdents64/readdir call isn't being followed by
stat() and it wasn't even getting it right all the time when it
was.

As a result, on my test box an "ls" of a directory containing 250000
files fell from about 7mins (freshly mounted, so nothing cached) to
between about 15 to 25 seconds. When the directory content was cached,
the time taken fell from about 3mins to about 4 or 5 seconds.

Interestingly in the cached case, running "ls -l" once reduced the time
taken for subsequent runs of "ls" to about 6 secs even without this
patch. Now it turns out that there was a special case of glocks being
used for prefetching the metadata, but because of the timeouts for these
locks (set to 10 secs) the metadata was being timed out before it was
being used and this the prefetch code was constantly trying to prefetch
the same data over and over.

Calling "ls -l" meant that the inodes were brought into memory and once
the inodes are cached, the glocks are not disposed of until the inodes
are pushed out of the cache, thus extending the lifetime of the glocks,
and thus bringing down the time for subsequent runs of "ls"
considerably.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 0fdcb77..0eceb05 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1198,12 +1198,11 @@ static int compare_dents(const void *a, const void *b)
  */
 
 static int do_filldir_main(struct gfs2_inode *dip, u64 *offset,
-			   void *opaque, gfs2_filldir_t filldir,
+			   void *opaque, filldir_t filldir,
 			   const struct gfs2_dirent **darr, u32 entries,
 			   int *copied)
 {
 	const struct gfs2_dirent *dent, *dent_next;
-	struct gfs2_inum_host inum;
 	u64 off, off_next;
 	unsigned int x, y;
 	int run = 0;
@@ -1240,11 +1239,9 @@ static int do_filldir_main(struct gfs2_inode *dip, u64 *offset,
 			*offset = off;
 		}
 
-		gfs2_inum_in(&inum, (char *)&dent->de_inum);
-
 		error = filldir(opaque, (const char *)(dent + 1),
 				be16_to_cpu(dent->de_name_len),
-				off, &inum,
+				off, be64_to_cpu(dent->de_inum.no_addr),
 				be16_to_cpu(dent->de_type));
 		if (error)
 			return 1;
@@ -1262,8 +1259,8 @@ static int do_filldir_main(struct gfs2_inode *dip, u64 *offset,
 }
 
 static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
-			      gfs2_filldir_t filldir, int *copied,
-			      unsigned *depth, u64 leaf_no)
+			      filldir_t filldir, int *copied, unsigned *depth,
+			      u64 leaf_no)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *bh;
@@ -1343,7 +1340,7 @@ out:
  */
 
 static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
-		      gfs2_filldir_t filldir)
+		      filldir_t filldir)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1402,7 +1399,7 @@ out:
 }
 
 int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
-		  gfs2_filldir_t filldir)
+		  filldir_t filldir)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	struct dirent_gather g;
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index b21b336..48fe890 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -16,30 +16,13 @@ struct inode;
 struct gfs2_inode;
 struct gfs2_inum;
 
-/**
- * gfs2_filldir_t - Report a directory entry to the caller of gfs2_dir_read()
- * @opaque: opaque data used by the function
- * @name: the name of the directory entry
- * @length: the length of the name
- * @offset: the entry's offset in the directory
- * @inum: the inode number the entry points to
- * @type: the type of inode the entry points to
- *
- * Returns: 0 on success, 1 if buffer full
- */
-
-typedef int (*gfs2_filldir_t) (void *opaque,
-			      const char *name, unsigned int length,
-			      u64 offset,
-			      struct gfs2_inum_host *inum, unsigned int type);
-
 int gfs2_dir_search(struct inode *dir, const struct qstr *filename,
 		    struct gfs2_inum_host *inum, unsigned int *type);
 int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
 		 const struct gfs2_inum_host *inum, unsigned int type);
 int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *filename);
-int gfs2_dir_read(struct inode *inode, u64 * offset, void *opaque,
-		  gfs2_filldir_t filldir);
+int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
+		  filldir_t filldir);
 int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 		   struct gfs2_inum_host *new_inum, unsigned int new_type);
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4381469..fb1960b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -971,8 +971,6 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh = gl->gl_req_gh;
 
-	clear_bit(GLF_PREFETCH, &gl->gl_flags);
-
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
 	gfs2_assert_warn(sdp, !ret);
@@ -1227,8 +1225,6 @@ restart:
 		}
 	}
 
-	clear_bit(GLF_PREFETCH, &gl->gl_flags);
-
 	return error;
 }
 
@@ -1320,36 +1316,6 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	spin_unlock(&gl->gl_spin);
 }
 
-/**
- * gfs2_glock_prefetch - Try to prefetch a glock
- * @gl: the glock
- * @state: the state to prefetch in
- * @flags: flags passed to go_xmote_th()
- *
- */
-
-static void gfs2_glock_prefetch(struct gfs2_glock *gl, unsigned int state,
-				int flags)
-{
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-
-	spin_lock(&gl->gl_spin);
-
-	if (test_bit(GLF_LOCK, &gl->gl_flags) || !list_empty(&gl->gl_holders) ||
-	    !list_empty(&gl->gl_waiters1) || !list_empty(&gl->gl_waiters2) ||
-	    !list_empty(&gl->gl_waiters3) ||
-	    relaxed_state_ok(gl->gl_state, state, flags)) {
-		spin_unlock(&gl->gl_spin);
-		return;
-	}
-
-	set_bit(GLF_PREFETCH, &gl->gl_flags);
-	set_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
-
-	glops->go_xmote_th(gl, state, flags);
-}
-
 static void greedy_work(struct work_struct *work)
 {
 	struct greedy *gr = container_of(work, struct greedy, gr_work.work);
@@ -1618,34 +1584,6 @@ void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
 }
 
 /**
- * gfs2_glock_prefetch_num - prefetch a glock based on lock number
- * @sdp: the filesystem
- * @number: the lock number
- * @glops: the glock operations for the type of glock
- * @state: the state to acquire the glock in
- * @flags: modifier flags for the aquisition
- *
- * Returns: errno
- */
-
-void gfs2_glock_prefetch_num(struct gfs2_sbd *sdp, u64 number,
-			     const struct gfs2_glock_operations *glops,
-			     unsigned int state, int flags)
-{
-	struct gfs2_glock *gl;
-	int error;
-
-	if (atomic_read(&sdp->sd_reclaim_count) <
-	    gfs2_tune_get(sdp, gt_reclaim_limit)) {
-		error = gfs2_glock_get(sdp, number, glops, CREATE, &gl);
-		if (!error) {
-			gfs2_glock_prefetch(gl, state, flags);
-			gfs2_glock_put(gl);
-		}
-	}
-}
-
-/**
  * gfs2_lvb_hold - attach a LVB from a glock
  * @gl: The glock in question
  *
@@ -1781,15 +1719,11 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 
 static int demote_ok(struct gfs2_glock *gl)
 {
-	struct gfs2_sbd *sdp = gl->gl_sbd;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	int demote = 1;
 
 	if (test_bit(GLF_STICKY, &gl->gl_flags))
 		demote = 0;
-	else if (test_bit(GLF_PREFETCH, &gl->gl_flags))
-		demote = time_after_eq(jiffies, gl->gl_stamp +
-				    gfs2_tune_get(sdp, gt_prefetch_secs) * HZ);
 	else if (glops->go_demote_ok)
 		demote = glops->go_demote_ok(gl);
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index fb39108..bde02a7 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -103,10 +103,6 @@ int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
 
-void gfs2_glock_prefetch_num(struct gfs2_sbd *sdp, u64 number,
-			     const struct gfs2_glock_operations *glops,
-			     unsigned int state, int flags);
-
 /**
  * gfs2_glock_nq_init - intialize a holder and enqueue it on a glock
  * @gl: the glock
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 734421e..8075870 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -147,7 +147,6 @@ struct gfs2_holder {
 enum {
 	GLF_LOCK		= 1,
 	GLF_STICKY		= 2,
-	GLF_PREFETCH		= 3,
 	GLF_DIRTY		= 5,
 	GLF_SKIP_WAITERS2	= 6,
 	GLF_GREEDY		= 7,
@@ -425,7 +424,6 @@ struct gfs2_tune {
 	unsigned int gt_complain_secs;
 	unsigned int gt_reclaim_limit; /* Max num of glocks in reclaim list */
 	unsigned int gt_entries_per_readdir;
-	unsigned int gt_prefetch_secs; /* Usage window for prefetched glocks */
 	unsigned int gt_greedy_default;
 	unsigned int gt_greedy_quantum;
 	unsigned int gt_greedy_max;
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index 6ea979c..fbf5506 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -113,13 +113,12 @@ struct get_name_filldir {
 	char *name;
 };
 
-static int get_name_filldir(void *opaque, const char *name, unsigned int length,
-			    u64 offset, struct gfs2_inum_host *inum,
-			    unsigned int type)
+static int get_name_filldir(void *opaque, const char *name, int length,
+			    loff_t offset, u64 inum, unsigned int type)
 {
-	struct get_name_filldir *gnfd = (struct get_name_filldir *)opaque;
+	struct get_name_filldir *gnfd = opaque;
 
-	if (!gfs2_inum_equal(inum, &gnfd->inum))
+	if (inum != gnfd->inum.no_addr)
 		return 0;
 
 	memcpy(gnfd->name, name, length);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index faa07e4..c996aa7 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -43,15 +43,6 @@
 #include "util.h"
 #include "eaops.h"
 
-/* For regular, non-NFS */
-struct filldir_reg {
-	struct gfs2_sbd *fdr_sbd;
-	int fdr_prefetch;
-
-	filldir_t fdr_filldir;
-	void *fdr_opaque;
-};
-
 /*
  * Most fields left uninitialised to catch anybody who tries to
  * use them. f_flags set to prevent file_accessed() from touching
@@ -128,41 +119,6 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int origin)
 }
 
 /**
- * filldir_func - Report a directory entry to the caller of gfs2_dir_read()
- * @opaque: opaque data used by the function
- * @name: the name of the directory entry
- * @length: the length of the name
- * @offset: the entry's offset in the directory
- * @inum: the inode number the entry points to
- * @type: the type of inode the entry points to
- *
- * Returns: 0 on success, 1 if buffer full
- */
-
-static int filldir_func(void *opaque, const char *name, unsigned int length,
-			u64 offset, struct gfs2_inum_host *inum,
-			unsigned int type)
-{
-	struct filldir_reg *fdr = (struct filldir_reg *)opaque;
-	struct gfs2_sbd *sdp = fdr->fdr_sbd;
-	int error;
-
-	error = fdr->fdr_filldir(fdr->fdr_opaque, name, length, offset,
-				 inum->no_addr, type);
-	if (error)
-		return 1;
-
-	if (fdr->fdr_prefetch && !(length == 1 && *name == '.')) {
-		gfs2_glock_prefetch_num(sdp, inum->no_addr, &gfs2_inode_glops,
-				       LM_ST_SHARED, LM_FLAG_TRY | LM_FLAG_ANY);
-		gfs2_glock_prefetch_num(sdp, inum->no_addr, &gfs2_iopen_glops,
-				       LM_ST_SHARED, LM_FLAG_TRY);
-	}
-
-	return 0;
-}
-
-/**
  * gfs2_readdir - Read directory entries from a directory
  * @file: The directory to read from
  * @dirent: Buffer for dirents
@@ -175,16 +131,10 @@ static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
 	struct inode *dir = file->f_mapping->host;
 	struct gfs2_inode *dip = GFS2_I(dir);
-	struct filldir_reg fdr;
 	struct gfs2_holder d_gh;
 	u64 offset = file->f_pos;
 	int error;
 
-	fdr.fdr_sbd = GFS2_SB(dir);
-	fdr.fdr_prefetch = 1;
-	fdr.fdr_filldir = filldir;
-	fdr.fdr_opaque = dirent;
-
 	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, GL_ATIME, &d_gh);
 	error = gfs2_glock_nq_atime(&d_gh);
 	if (error) {
@@ -192,7 +142,7 @@ static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
 		return error;
 	}
 
-	error = gfs2_dir_read(dir, &offset, &fdr, filldir_func);
+	error = gfs2_dir_read(dir, &offset, dirent, filldir);
 
 	gfs2_glock_dq_uninit(&d_gh);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 43a24f2..100852a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -78,7 +78,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_complain_secs = 10;
 	gt->gt_reclaim_limit = 5000;
 	gt->gt_entries_per_readdir = 32;
-	gt->gt_prefetch_secs = 10;
 	gt->gt_greedy_default = HZ / 10;
 	gt->gt_greedy_quantum = HZ / 40;
 	gt->gt_greedy_max = HZ / 4;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 983eaf1..cd28f08 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -436,7 +436,6 @@ TUNE_ATTR(atime_quantum, 0);
 TUNE_ATTR(max_readahead, 0);
 TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(reclaim_limit, 0);
-TUNE_ATTR(prefetch_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(new_files_directio, 0);
@@ -465,7 +464,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_max_readahead.attr,
 	&tune_attr_complain_secs.attr,
 	&tune_attr_reclaim_limit.attr,
-	&tune_attr_prefetch_secs.attr,
 	&tune_attr_statfs_slow.attr,
 	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_quota_cache_secs.attr,
-- 
1.4.4.2



