Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbYDQJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbYDQJ4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763102AbYDQJ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbYDQJ0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:53 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Josef Bacik <jbacik@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 48/48] [GFS2] fix GFP_KERNEL misuses
Date: Thu, 17 Apr 2008 09:39:24 +0100
Message-Id: <12084216681989-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216662161-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
 <12084216511207-git-send-email-swhiteho@redhat.com>
 <12084216533319-git-send-email-swhiteho@redhat.com>
 <12084216553542-git-send-email-swhiteho@redhat.com>
 <1208421657826-git-send-email-swhiteho@redhat.com>
 <12084216593910-git-send-email-swhiteho@redhat.com>
 <12084216611008-git-send-email-swhiteho@redhat.com>
 <12084216641014-git-send-email-swhiteho@redhat.com>
 <12084216662161-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@redhat.com>

There are several places where GFP_KERNEL allocations happen under a glock,
which will result in hangs if we're under memory pressure and go to re-enter the
fs in order to flush stuff out.  This patch changes the culprits to GFS_NOFS to
keep this problem from happening.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 1047a8c..3e9bd46 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -116,7 +116,7 @@ static int acl_get(struct gfs2_inode *ip, int access, struct posix_acl **acl,
 		goto out;
 
 	er.er_data_len = GFS2_EA_DATA_LEN(el->el_ea);
-	er.er_data = kmalloc(er.er_data_len, GFP_KERNEL);
+	er.er_data = kmalloc(er.er_data_len, GFP_NOFS);
 	error = -ENOMEM;
 	if (!er.er_data)
 		goto out;
@@ -222,7 +222,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 		return error;
 	}
 
-	clone = posix_acl_clone(acl, GFP_KERNEL);
+	clone = posix_acl_clone(acl, GFP_NOFS);
 	error = -ENOMEM;
 	if (!clone)
 		goto out;
@@ -272,7 +272,7 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 	if (!acl)
 		return gfs2_setattr_simple(ip, attr);
 
-	clone = posix_acl_clone(acl, GFP_KERNEL);
+	clone = posix_acl_clone(acl, GFP_NOFS);
 	error = -ENOMEM;
 	if (!clone)
 		goto out;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 94070ad..eed040d 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1089,7 +1089,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 
 	/*  Allocate both the "from" and "to" buffers in one big chunk  */
 
-	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_KERNEL | __GFP_NOFAIL);
+	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_NOFS | __GFP_NOFAIL);
 
 	for (block = dip->i_di.di_size >> sdp->sd_hash_bsize_shift; block--;) {
 		error = gfs2_dir_read_data(dip, (char *)buf,
@@ -1378,7 +1378,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	hash = gfs2_dir_offset2hash(*offset);
 	index = hash >> (32 - dip->i_depth);
 
-	lp = kmalloc(sdp->sd_hash_bsize, GFP_KERNEL);
+	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
 	if (!lp)
 		return -ENOMEM;
 
@@ -1443,7 +1443,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 
 	error = -ENOMEM;
 	/* 96 is max number of dirents which can be stuffed into an inode */
-	darr = kmalloc(96 * sizeof(struct gfs2_dirent *), GFP_KERNEL);
+	darr = kmalloc(96 * sizeof(struct gfs2_dirent *), GFP_NOFS);
 	if (darr) {
 		g.pdent = darr;
 		g.offset = 0;
@@ -1789,7 +1789,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 		return -EIO;
 	}
 
-	lp = kmalloc(sdp->sd_hash_bsize, GFP_KERNEL);
+	lp = kmalloc(sdp->sd_hash_bsize, GFP_NOFS);
 	if (!lp)
 		return -ENOMEM;
 
@@ -1864,7 +1864,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 
-	ht = kzalloc(size, GFP_KERNEL);
+	ht = kzalloc(size, GFP_NOFS);
 	if (!ht)
 		return -ENOMEM;
 
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 8175592..e3f76f4 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -448,7 +448,7 @@ static int ea_get_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 	unsigned int x;
 	int error = 0;
 
-	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_KERNEL);
+	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_NOFS);
 	if (!bh)
 		return -ENOMEM;
 
@@ -1206,7 +1206,7 @@ static int ea_acl_chmod_unstuffed(struct gfs2_inode *ip,
 	unsigned int x;
 	int error;
 
-	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_KERNEL);
+	bh = kcalloc(nptrs, sizeof(struct buffer_head *), GFP_NOFS);
 	if (!bh)
 		return -ENOMEM;
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index dcae2aa..3a9ef52 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1231,7 +1231,7 @@ int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
 
 	x = ip->i_di.di_size + 1;
 	if (x > *len) {
-		*buf = kmalloc(x, GFP_KERNEL);
+		*buf = kmalloc(x, GFP_NOFS);
 		if (!*buf) {
 			error = -ENOMEM;
 			goto out_brelse;
diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index 53a6ab3..cf7ea8a 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -165,7 +165,7 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 {
 	struct gdlm_lock *lp;
 
-	lp = kzalloc(sizeof(struct gdlm_lock), GFP_KERNEL);
+	lp = kzalloc(sizeof(struct gdlm_lock), GFP_NOFS);
 	if (!lp)
 		return -ENOMEM;
 
@@ -383,7 +383,7 @@ static int gdlm_add_lvb(struct gdlm_lock *lp)
 {
 	char *lvb;
 
-	lvb = kzalloc(GDLM_LVB_SIZE, GFP_KERNEL);
+	lvb = kzalloc(GDLM_LVB_SIZE, GFP_NOFS);
 	if (!lvb)
 		return -ENOMEM;
 
diff --git a/fs/gfs2/locking/nolock/main.c b/fs/gfs2/locking/nolock/main.c
index d3b8ce6..284a5ec 100644
--- a/fs/gfs2/locking/nolock/main.c
+++ b/fs/gfs2/locking/nolock/main.c
@@ -140,7 +140,7 @@ static int nolock_hold_lvb(void *lock, char **lvbp)
 	struct nolock_lockspace *nl = lock;
 	int error = 0;
 
-	*lvbp = kzalloc(nl->nl_lvb_size, GFP_KERNEL);
+	*lvbp = kzalloc(nl->nl_lvb_size, GFP_NOFS);
 	if (!*lvbp)
 		error = -ENOMEM;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c71f781..56aaf91 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -94,7 +94,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	struct gfs2_quota_data *qd;
 	int error;
 
-	qd = kzalloc(sizeof(struct gfs2_quota_data), GFP_KERNEL);
+	qd = kzalloc(sizeof(struct gfs2_quota_data), GFP_NOFS);
 	if (!qd)
 		return -ENOMEM;
 
@@ -690,7 +690,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	gfs2_write_calc_reserv(ip, sizeof(struct gfs2_quota),
 			      &data_blocks, &ind_blocks);
 
-	ghs = kcalloc(num_qd, sizeof(struct gfs2_holder), GFP_KERNEL);
+	ghs = kcalloc(num_qd, sizeof(struct gfs2_holder), GFP_NOFS);
 	if (!ghs)
 		return -ENOMEM;
 
@@ -1118,12 +1118,12 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 	error = -ENOMEM;
 
 	sdp->sd_quota_bitmap = kcalloc(sdp->sd_quota_chunks,
-				       sizeof(unsigned char *), GFP_KERNEL);
+				       sizeof(unsigned char *), GFP_NOFS);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
 	for (x = 0; x < sdp->sd_quota_chunks; x++) {
-		sdp->sd_quota_bitmap[x] = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		sdp->sd_quota_bitmap[x] = kzalloc(PAGE_SIZE, GFP_NOFS);
 		if (!sdp->sd_quota_bitmap[x])
 			goto fail;
 	}
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 06dcdc0..2888e4b 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -68,7 +68,7 @@ int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where)
 		return 0;
 	}
 
-	rr = kmalloc(sizeof(struct gfs2_revoke_replay), GFP_KERNEL);
+	rr = kmalloc(sizeof(struct gfs2_revoke_replay), GFP_NOFS);
 	if (!rr)
 		return -ENOMEM;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 88497b0..7aeacbc 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -210,7 +210,7 @@ int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	struct page *page;
 	struct bio *bio;
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_NOFS);
 	if (unlikely(!page))
 		return -ENOBUFS;
 
@@ -218,7 +218,7 @@ int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	ClearPageDirty(page);
 	lock_page(page);
 
-	bio = bio_alloc(GFP_KERNEL, 1);
+	bio = bio_alloc(GFP_NOFS, 1);
 	if (unlikely(!bio)) {
 		__free_page(page);
 		return -ENOBUFS;
-- 
1.5.1.2

