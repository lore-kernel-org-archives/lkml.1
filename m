Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbYAUKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbYAUKU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbYAUKDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbYAUKDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:14 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 49/58] [GFS2] Fix problems relating to execution of files on GFS2
Date: Mon, 21 Jan 2008 09:22:07 +0000
Message-Id: <12009074263736-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074243427-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
 <12009074192015-git-send-email-swhiteho@redhat.com>
 <12009074213460-git-send-email-swhiteho@redhat.com>
 <12009074221447-git-send-email-swhiteho@redhat.com>
 <12009074243427-git-send-email-swhiteho@redhat.com>
Message-Id: <b526ae07f31beb4a17525805f3dfff25465dd02f.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch fixes a couple of problems which affected the execution of files
on GFS2. The first is that there was a corner case where inodes were not
always uptodate at the point at which permissions checks were being carried
out, this was resulting in refusal of execute permission, but only on the
first lookup, subsequent requests worked correctly. The second was a problem
relating to incorrect updating of file sizes which was introduced with the
write_begin/end code for GFS2 a little while back.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index e16ad81..37406a3 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -848,14 +848,11 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
 
-	if (likely(ret >= 0)) {
-		copied = ret;
-		if  ((pos + copied) > inode->i_size) {
-			di = (struct gfs2_dinode *)dibh->b_data;
-			ip->i_di.di_size = inode->i_size;
-			di->di_size = cpu_to_be64(inode->i_size);
-			mark_inode_dirty(inode);
-		}
+	if (likely(ret >= 0) && (inode->i_size > ip->i_di.di_size)) {
+		di = (struct gfs2_dinode *)dibh->b_data;
+		ip->i_di.di_size = inode->i_size;
+		di->di_size = cpu_to_be64(inode->i_size);
+		mark_inode_dirty(inode);
 	}
 
 	if (inode == sdp->sd_rindex)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 291f0c7..8386ab3 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -113,8 +113,18 @@ static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
 	if (inode && IS_ERR(inode))
 		return ERR_PTR(PTR_ERR(inode));
 
-	if (inode)
+	if (inode) {
+		struct gfs2_glock *gl = GFS2_I(inode)->i_gl;
+		struct gfs2_holder gh;
+		int error;
+		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+		if (error) {
+			iput(inode);
+			return ERR_PTR(error);
+		}
+		gfs2_glock_dq_uninit(&gh);
 		return d_splice_alias(inode, dentry);
+	}
 	d_add(dentry, inode);
 
 	return NULL;
-- 
1.5.1.2

