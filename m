Return-Path: <linux-kernel-owner+w=401wt.eu-S934643AbYDQJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643AbYDQJid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbYDQJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbYDQJZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/48] [GFS2] Allocate gfs2_rgrpd from slab memory
Date: Thu, 17 Apr 2008 09:38:46 +0100
Message-Id: <12084215891940-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <120842158797-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch moves the gfs2_rgrpd structure to its own slab
memory.  This makes it easier to control and monitor, and
yields less memory fragmentation.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 9c7765c..053e2eb 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -89,6 +89,12 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_bufdata_cachep)
 		goto fail;
 
+	gfs2_rgrpd_cachep = kmem_cache_create("gfs2_rgrpd",
+					      sizeof(struct gfs2_rgrpd),
+					      0, 0, NULL);
+	if (!gfs2_rgrpd_cachep)
+		goto fail;
+
 	error = register_filesystem(&gfs2_fs_type);
 	if (error)
 		goto fail;
@@ -108,6 +114,9 @@ fail_unregister:
 fail:
 	gfs2_glock_exit();
 
+	if (gfs2_rgrpd_cachep)
+		kmem_cache_destroy(gfs2_rgrpd_cachep);
+
 	if (gfs2_bufdata_cachep)
 		kmem_cache_destroy(gfs2_bufdata_cachep);
 
@@ -133,6 +142,7 @@ static void __exit exit_gfs2_fs(void)
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
 
+	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
 	kmem_cache_destroy(gfs2_inode_cachep);
 	kmem_cache_destroy(gfs2_glock_cachep);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7b9d6f1..dc7e83e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -353,7 +353,7 @@ static void clear_rgrpdi(struct gfs2_sbd *sdp)
 		}
 
 		kfree(rgd->rd_bits);
-		kfree(rgd);
+		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
 }
 
@@ -516,7 +516,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 		return error;
 	}
 
-	rgd = kzalloc(sizeof(struct gfs2_rgrpd), GFP_NOFS);
+	rgd = kmem_cache_zalloc(gfs2_rgrpd_cachep, GFP_NOFS);
 	error = -ENOMEM;
 	if (!rgd)
 		return error;
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 424a077..fe9c28e 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -25,6 +25,7 @@
 struct kmem_cache *gfs2_glock_cachep __read_mostly;
 struct kmem_cache *gfs2_inode_cachep __read_mostly;
 struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
+struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 28938a4..ac0c567 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -147,6 +147,7 @@ gfs2_io_error_bh_i((sdp), (bh), __FUNCTION__, __FILE__, __LINE__);
 extern struct kmem_cache *gfs2_glock_cachep;
 extern struct kmem_cache *gfs2_inode_cachep;
 extern struct kmem_cache *gfs2_bufdata_cachep;
+extern struct kmem_cache *gfs2_rgrpd_cachep;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 					   unsigned int *p)
-- 
1.5.1.2

