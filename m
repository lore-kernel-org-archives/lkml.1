Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbZFJJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbZFJJmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZFJJid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbZFJJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:16 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/24] GFS2: Move gfs2_readlinki into ops_inode.c
Date: Wed, 10 Jun 2009 09:30:58 +0100
Message-Id: <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move gfs2_readlinki into ops_inode.c and make it static

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9b17447..676e750 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1085,63 +1085,7 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	return 0;
 }
 
-/**
- * gfs2_readlinki - return the contents of a symlink
- * @ip: the symlink's inode
- * @buf: a pointer to the buffer to be filled
- * @len: a pointer to the length of @buf
- *
- * If @buf is too small, a piece of memory is kmalloc()ed and needs
- * to be freed by the caller.
- *
- * Returns: errno
- */
-
-int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
-{
-	struct gfs2_holder i_gh;
-	struct buffer_head *dibh;
-	unsigned int x;
-	int error;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &i_gh);
-	error = gfs2_glock_nq(&i_gh);
-	if (error) {
-		gfs2_holder_uninit(&i_gh);
-		return error;
-	}
-
-	if (!ip->i_disksize) {
-		gfs2_consist_inode(ip);
-		error = -EIO;
-		goto out;
-	}
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto out;
-
-	x = ip->i_disksize + 1;
-	if (x > *len) {
-		*buf = kmalloc(x, GFP_NOFS);
-		if (!*buf) {
-			error = -ENOMEM;
-			goto out_brelse;
-		}
-	}
-
-	memcpy(*buf, dibh->b_data + sizeof(struct gfs2_dinode), x);
-	*len = x;
-
-out_brelse:
-	brelse(dibh);
-out:
-	gfs2_glock_dq_uninit(&i_gh);
-	return error;
-}
-
-static int
-__gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
+static int __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
 {
 	struct buffer_head *dibh;
 	int error;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 6cd3928..fc9a08f 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -99,7 +99,6 @@ extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
 extern int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 			  const struct gfs2_inode *ip);
 extern int gfs2_permission(struct inode *inode, int mask);
-extern int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 5dacd64..f607f09 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -938,6 +938,61 @@ out:
 }
 
 /**
+ * gfs2_readlinki - return the contents of a symlink
+ * @ip: the symlink's inode
+ * @buf: a pointer to the buffer to be filled
+ * @len: a pointer to the length of @buf
+ *
+ * If @buf is too small, a piece of memory is kmalloc()ed and needs
+ * to be freed by the caller.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
+{
+	struct gfs2_holder i_gh;
+	struct buffer_head *dibh;
+	unsigned int x;
+	int error;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &i_gh);
+	error = gfs2_glock_nq(&i_gh);
+	if (error) {
+		gfs2_holder_uninit(&i_gh);
+		return error;
+	}
+
+	if (!ip->i_disksize) {
+		gfs2_consist_inode(ip);
+		error = -EIO;
+		goto out;
+	}
+
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error)
+		goto out;
+
+	x = ip->i_disksize + 1;
+	if (x > *len) {
+		*buf = kmalloc(x, GFP_NOFS);
+		if (!*buf) {
+			error = -ENOMEM;
+			goto out_brelse;
+		}
+	}
+
+	memcpy(*buf, dibh->b_data + sizeof(struct gfs2_dinode), x);
+	*len = x;
+
+out_brelse:
+	brelse(dibh);
+out:
+	gfs2_glock_dq_uninit(&i_gh);
+	return error;
+}
+
+/**
  * gfs2_readlink - Read the value of a symlink
  * @dentry: the symlink
  * @buf: the buffer to read the symlink data into
-- 
1.6.0.6

