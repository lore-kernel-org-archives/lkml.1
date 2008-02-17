Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYBQDBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYBQDBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYBQC6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36327 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYBQC6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:11 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 16/17] Unionfs: use the new path_put
Date: Sat, 16 Feb 2008 21:57:25 -0500
Message-Id: <1203217054264-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c  |    2 +-
 fs/unionfs/super.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 4bc2c66..3585b29 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -371,7 +371,7 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		if (err) {
 			printk(KERN_ERR "unionfs: lower directory "
 			       "'%s' is not a valid branch\n", name);
-			path_release(&nd);
+			path_put(&nd.path);
 			goto out;
 		}
 
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index b71fc2a..773623e 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -234,7 +234,7 @@ static noinline int do_remount_mode_option(char *optarg, int cur_branches,
 		if (nd.mnt == new_lower_paths[idx].mnt &&
 		    nd.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		err = -ENOENT;	/* err may have been reset above */
 		printk(KERN_ERR "unionfs: branch \"%s\" "
@@ -277,7 +277,7 @@ static noinline int do_remount_del_option(char *optarg, int cur_branches,
 		if (nd.mnt == new_lower_paths[idx].mnt &&
 		    nd.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -296,7 +296,7 @@ static noinline int do_remount_del_option(char *optarg, int cur_branches,
 	 * new_data and new_lower_paths one to the left.  Finally, adjust
 	 * cur_branches.
 	 */
-	pathput(&new_lower_paths[idx]);
+	path_put(&new_lower_paths[idx]);
 
 	if (idx < cur_branches - 1) {
 		/* if idx==cur_branches-1, we delete last branch: easy */
@@ -361,7 +361,7 @@ static noinline int do_remount_add_option(char *optarg, int cur_branches,
 		if (nd.mnt == new_lower_paths[idx].mnt &&
 		    nd.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -408,7 +408,7 @@ found_insertion_point:
 	if (err) {
 		printk(KERN_ERR "unionfs: lower directory "
 		       "\"%s\" is not a valid branch\n", optarg);
-		path_release(&nd);
+		path_put(&nd.path);
 		goto out;
 	}
 
@@ -818,7 +818,7 @@ out_release:
 	/* no need to cleanup/release anything in tmp_data */
 	if (tmp_lower_paths)
 		for (i = 0; i < new_branches; i++)
-			pathput(&tmp_lower_paths[i]);
+			path_put(&tmp_lower_paths[i]);
 out_free:
 	kfree(tmp_lower_paths);
 	kfree(tmp_data);
-- 
1.5.2.2

