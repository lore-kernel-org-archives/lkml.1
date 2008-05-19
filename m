Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYESFx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYESFx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYESFxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:53:49 -0400
Received: from verein.lst.de ([213.95.11.210]:60040 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYESFxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:53:48 -0400
Date: Mon, 19 May 2008 07:53:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] vfs: open_exec cleanup
Message-ID: <20080519055334.GA14902@lst.de>
References: <20080513201813.GA5869@joi> <1211148109-16149-1-git-send-email-marcin.slusarz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211148109-16149-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 12:01:49AM +0200, Marcin Slusarz wrote:
> open_exec is needlessly indented, calls ERR_PTR with 0 argument
> (which is not valid errno) and jumps into middle of function
> just to return value.
> So clean it up a bit.

Still looks rather messy.  See below for a better version.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-05-19 07:45:18.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-05-19 07:53:17.000000000 +0200
@@ -654,38 +654,40 @@ EXPORT_SYMBOL(setup_arg_pages);
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
+	if (err)
+		goto out;
 
-	if (!err) {
-		struct inode *inode = nd.path.dentry->d_inode;
-		file = ERR_PTR(-EACCES);
-		if (S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
-			file = ERR_PTR(err);
-			if (!err) {
-				file = nameidata_to_filp(&nd,
-							O_RDONLY|O_LARGEFILE);
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
-		path_put(&nd.path);
+	err = -EACCES;
+	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
+		goto out_path_put;
+
+	err = vfs_permission(&nd, MAY_EXEC);
+	if (err)
+		goto out_path_put;
+
+	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
+	if (IS_ERR(file))
+		return file;
+
+	err = deny_write_access(file);
+	if (err) {
+		fput(file);
+		goto out;
 	}
-	goto out;
-}
 
+	return file;
+
+ out_path_put:
+	release_open_intent(&nd);
+	path_put(&nd.path);
+ out:
+	return ERR_PTR(err);
+}
 EXPORT_SYMBOL(open_exec);
 
 int kernel_read(struct file *file, unsigned long offset,

