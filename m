Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbXKZQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbXKZQto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbXKZQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:48:47 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53069 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbXKZQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:48:46 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 06/16] Unionfs: handle whiteouts more efficiently in filldir
Date: Mon, 26 Nov 2007 11:44:03 -0500
Message-Id: <11960954551789-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we cache a dirent for file "foo", and then it gets deleted, then we look
for a ".wh.foo" whiteout entry in the same dirent cache.  But our dirent
cache strips the ".wh." prefix, thus looking for an entry named "foo" whose
filldir_node->whiteout should be 1 instead of 0.  In that case, don't
display  an incorrect printk  message that the file system may be corrupt,
but set that filldir_node->whiteout to 1.

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dirfops.c   |   13 ++++++++++---
 fs/unionfs/dirhelper.c |    2 +-
 fs/unionfs/rdstate.c   |   11 +++++++----
 fs/unionfs/union.h     |    3 ++-
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 5276cb3..88df635 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -53,10 +53,17 @@ static int unionfs_filldir(void *dirent, const char *name, int namelen,
 		is_wh_entry = 1;
 	}
 
-	found = find_filldir_node(buf->rdstate, name, namelen);
-
-	if (found)
+	found = find_filldir_node(buf->rdstate, name, namelen, is_wh_entry);
+
+	if (found) {
+		/*
+		 * If we had non-whiteout entry in dir cache, then mark it
+		 * as a whiteout and but leave it in the dir cache.
+		 */
+		if (is_wh_entry && !found->whiteout)
+			found->whiteout = is_wh_entry;
 		goto out;
+	}
 
 	/* if 'name' isn't a whiteout, filldir it. */
 	if (!is_wh_entry) {
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 7a28444..2e52fc3 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -158,7 +158,7 @@ static int readdir_util_callback(void *dirent, const char *name, int namelen,
 		whiteout = 1;
 	}
 
-	found = find_filldir_node(buf->rdstate, name, namelen);
+	found = find_filldir_node(buf->rdstate, name, namelen, whiteout);
 	/* If it was found in the table there was a previous whiteout. */
 	if (found)
 		goto out;
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index bdf335d..7ba1e1a 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -188,7 +188,8 @@ void free_rdstate(struct unionfs_dir_state *state)
 }
 
 struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
-				       const char *name, int namelen)
+				       const char *name, int namelen,
+				       int is_whiteout)
 {
 	int index;
 	unsigned int hash;
@@ -215,10 +216,12 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 			found = 1;
 
 			/*
-			 * if the duplicate is in this branch, then the file
-			 * system is corrupted.
+			 * if a duplicate is found in this branch, and is
+			 * not due to the caller looking for an entry to
+			 * whiteout, then the file system may be corrupted.
 			 */
-			if (unlikely(cursor->bindex == rdstate->bindex))
+			if (unlikely(!is_whiteout &&
+				     cursor->bindex == rdstate->bindex))
 				printk(KERN_ERR "unionfs: filldir: possible "
 				       "I/O error: a file is duplicated "
 				       "in the same branch %d: %s\n",
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index f61e32d..283b085 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -223,7 +223,8 @@ extern int add_filldir_node(struct unionfs_dir_state *rdstate,
 			    const char *name, int namelen, int bindex,
 			    int whiteout);
 extern struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
-					      const char *name, int namelen);
+					      const char *name, int namelen,
+					      int is_whiteout);
 
 extern struct dentry **alloc_new_dentries(int objs);
 extern struct unionfs_data *alloc_new_data(int objs);
-- 
1.5.2.2

