Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXJDHJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXJDHJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJDHJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:09:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXJDHI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:08:59 -0400
Date: Thu, 4 Oct 2007 08:08:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Casey Dahlin <cjdahlin@ncsu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Code style fix for open_exec
Message-ID: <20071004070857.GB21481@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Casey Dahlin <cjdahlin@ncsu.edu>, linux-kernel@vger.kernel.org
References: <47045299.2000601@ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47045299.2000601@ncsu.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 10:40:25PM -0400, Casey Dahlin wrote:
> From d2a6c5d29dc34cfea892124ab72b4eb55d2f8a80 Mon Sep 17 00:00:00 2001
> From: Casey Dahlin <cjdahlin@ncsu.edu>
> Date: Wed, 3 Oct 2007 22:01:49 -0400
> Subject: [PATCH] Code style fix for open_exec
> 
> Fix a horribly mangled 5 level indent and severe abuse of goto in the 
> open_exec
> function.

While the function is not nice your version makes it even worse.

Try this one instead which has been in my pending testing tree for a while:



Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-09-16 20:29:01.000000000 +0200
+++ linux-2.6/fs/exec.c	2007-09-16 20:29:56.000000000 +0200
@@ -669,41 +669,55 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
+/**
+ * open_exec - open file for execution
+ * @name:	filename to open
+ *
+ * Open the file pointed to by @filename in the current namespace
+ * for execution.  Error out if the file is not a regular file or
+ * this mount does not allow executing files on it.
+ */
 struct file *open_exec(const char *name)
 {
 	struct nameidata nd;
-	int err;
 	struct file *file;
+	int err;
 
-	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd, FMODE_READ|FMODE_EXEC);
-	file = ERR_PTR(err);
+	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd,
+				FMODE_READ|FMODE_EXEC);
+	if (unlikely(err))
+		goto out;
 
-	if (!err) {
-		struct inode *inode = nd.dentry->d_inode;
-		file = ERR_PTR(-EACCES);
-		if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
-		    S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
-			file = ERR_PTR(err);
-			if (!err) {
-				file = nameidata_to_filp(&nd, O_RDONLY);
-				if (!IS_ERR(file)) {
-					err = deny_write_access(file);
-					if (err) {
-						fput(file);
-						file = ERR_PTR(err);
-					}
-				}
-out:
-				return file;
-			}
-		}
-		release_open_intent(&nd);
-		path_release(&nd);
+	err = -EACCES;
+	if (unlikely(nd.mnt->mnt_flags & MNT_NOEXEC))
+		goto out_path_release;
+	if (unlikely(!S_ISREG(nd.dentry->d_inode->i_mode)))
+		goto out_path_release;
+
+	err = vfs_permission(&nd, MAY_EXEC);
+	if (unlikely(err))
+		goto out_path_release;
+
+	file = nameidata_to_filp(&nd, O_RDONLY);
+	if (unlikely(IS_ERR(file))) {
+		err = PTR_ERR(file);
+		goto out;
+	}
+
+	err = deny_write_access(file);
+	if (unlikely(err)) {
+		fput(file);
+		goto out;
 	}
-	goto out;
-}
 
+	return file;
+
+ out_path_release:
+	release_open_intent(&nd);
+	path_release(&nd);
+ out:
+	return ERR_PTR(err);
+}
 EXPORT_SYMBOL(open_exec);
 
 int kernel_read(struct file *file, unsigned long offset,
