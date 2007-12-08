Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbXLHUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbXLHUq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXLHUqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:46:38 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34856 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbXLHUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:46:33 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/2] Unionfs: cleanup/consolidate branch-mode parsing code
Date: Sat,  8 Dec 2007 15:46:04 -0500
Message-Id: <1197146768587-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1197146765464-git-send-email-ezk@cs.sunysb.edu>
References: <1197146765464-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also a bug fix: disallow unrecognized branch modes at mount time, instead of
defaulting to "rw".

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c  |   44 ++++++++++++++++++++++----------------------
 fs/unionfs/super.c |   12 ++++++++----
 fs/unionfs/union.h |    3 +--
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ffb0da1..22aa6e6 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -256,30 +256,21 @@ static int is_branch_overlap(struct dentry *dent1, struct dentry *dent2)
 }
 
 /*
- * Parse branch mode helper function
+ * Parse "ro" or "rw" options, but default to "rw" if no mode options was
+ * specified.  Fill the mode bits in @perms.  If encounter an unknown
+ * string, return -EINVAL.  Otherwise return 0.
  */
-int __parse_branch_mode(const char *name)
+int parse_branch_mode(const char *name, int *perms)
 {
-	if (!name)
+	if (!name || !strcmp(name, "rw")) {
+		*perms = MAY_READ | MAY_WRITE;
 		return 0;
-	if (!strcmp(name, "ro"))
-		return MAY_READ;
-	if (!strcmp(name, "rw"))
-		return (MAY_READ | MAY_WRITE);
-	return 0;
-}
-
-/*
- * Parse "ro" or "rw" options, but default to "rw" of no mode options
- * was specified.
- */
-int parse_branch_mode(const char *name)
-{
-	int perms = __parse_branch_mode(name);
-
-	if (perms == 0)
-		perms = MAY_READ | MAY_WRITE;
-	return perms;
+	}
+	if (!strcmp(name, "ro")) {
+		*perms = MAY_READ;
+		return 0;
+	}
+	return -EINVAL;
 }
 
 /*
@@ -350,8 +341,17 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		if (mode)
 			*mode++ = '\0';
 
-		perms = parse_branch_mode(mode);
+		err = parse_branch_mode(mode, &perms);
+		if (err) {
+			printk(KERN_ERR "unionfs: invalid mode \"%s\" for "
+			       "branch %d\n", mode, bindex);
+			goto out;
+		}
+		/* ensure that leftmost branch is writeable */
 		if (!bindex && !(perms & MAY_WRITE)) {
+			printk(KERN_ERR "unionfs: leftmost branch cannot be "
+			       "read-only (use \"-o ro\" to create a "
+			       "read-only union)\n");
 			err = -EINVAL;
 			goto out;
 		}
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 88f77d7..d9cf2a7 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -181,8 +181,8 @@ static noinline int do_remount_mode_option(char *optarg, int cur_branches,
 		goto out;
 	}
 	*modename++ = '\0';
-	perms = __parse_branch_mode(modename);
-	if (perms == 0) {
+	err = parse_branch_mode(modename, &perms);
+	if (err) {
 		printk(KERN_ERR "unionfs: invalid mode \"%s\" for \"%s\"\n",
 		       modename, optarg);
 		goto out;
@@ -350,13 +350,17 @@ found_insertion_point:
 		modename = strchr(new_branch, '=');
 	if (modename)
 		*modename++ = '\0';
-	perms = parse_branch_mode(modename);
-
 	if (!new_branch || !*new_branch) {
 		printk(KERN_ERR "unionfs: null new branch\n");
 		err = -EINVAL;
 		goto out;
 	}
+	err = parse_branch_mode(modename, &perms);
+	if (err) {
+		printk(KERN_ERR "unionfs: invalid mode \"%s\" for "
+		       "branch \"%s\"\n", modename, new_branch);
+		goto out;
+	}
 	err = path_lookup(new_branch, LOOKUP_FOLLOW, &nd);
 	if (err) {
 		printk(KERN_ERR "unionfs: error accessing "
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 283b085..20bff7b 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -474,8 +474,7 @@ static inline int is_robranch(const struct dentry *dentry)
  */
 extern char *alloc_whname(const char *name, int len);
 extern int check_branch(struct nameidata *nd);
-extern int __parse_branch_mode(const char *name);
-extern int parse_branch_mode(const char *name);
+extern int parse_branch_mode(const char *name, int *perms);
 
 /*
  * These two functions are here because it is kind of daft to copy and paste
-- 
1.5.2.2

