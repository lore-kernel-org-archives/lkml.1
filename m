Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZFJJir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZFJJir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZFJJiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40272 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZFJJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:37:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/24] GFS2: Something nonlinear this way comes!
Date: Wed, 10 Jun 2009 09:30:44 +0100
Message-Id: <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason GFS2 has been missing support for non-linear
mappings. This patch fixes that, and also avoids taking any
locks for mmap in the O_NOATIME case. In fact we don't actually need
to take the lock here at all - just doing file_accessed() would be
enough, but we have to take the lock eventually and this helps
it hit disk (and thus be seen by other nodes) faster.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 5d82e91..0ee7bd2 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -425,33 +425,36 @@ static struct vm_operations_struct gfs2_vm_ops = {
 	.page_mkwrite = gfs2_page_mkwrite,
 };
 
-
 /**
  * gfs2_mmap -
  * @file: The file to map
  * @vma: The VMA which described the mapping
  *
- * Returns: 0 or error code
+ * There is no need to get a lock here unless we should be updating
+ * atime. We ignore any locking errors since the only consequence is
+ * a missed atime update (which will just be deferred until later).
+ *
+ * Returns: 0
  */
 
 static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	struct gfs2_holder i_gh;
-	int error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &i_gh);
-	error = gfs2_glock_nq(&i_gh);
-	if (error) {
-		gfs2_holder_uninit(&i_gh);
-		return error;
-	}
+	if (!(file->f_flags & O_NOATIME)) {
+		struct gfs2_holder i_gh;
+		int error;
 
+		gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
+		error = gfs2_glock_nq(&i_gh);
+		file_accessed(file);
+		if (error == 0)
+			gfs2_glock_dq_uninit(&i_gh);
+	}
 	vma->vm_ops = &gfs2_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 
-	gfs2_glock_dq_uninit(&i_gh);
-
-	return error;
+	return 0;
 }
 
 /**
-- 
1.6.0.6

