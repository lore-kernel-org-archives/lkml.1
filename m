Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZL2Fm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZL2Fm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZL2Fm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:42:58 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:50083 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZL2Fm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:42:57 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, zohar@us.ibm.com, jmorris@namei.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH] pipe, call path_put() after put_filp() in the error path
Date: Tue, 29 Dec 2009 14:42:49 +0900
Message-Id: <1262065369-19741-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 6c21a7f "LSM: imbed ima calls in the security hooks"
which moves the ima_file_free() call within security_file_free()
brought a problem into pipe.c.
In the error path of pipe(2), the allocated resources are freed by
path_put() and put_filp() (in this order). Since security_file_free()
refers f_dentry and ima_file_free() refers f_dentry->d_inode, path_put()
should be called after put_filp().

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/pipe.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 37ba29f..90b543d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1004,9 +1004,10 @@ struct file *create_write_pipe(int flags)
 
 void free_write_pipe(struct file *f)
 {
+	struct path path = f->f_path;
 	free_pipe_info(f->f_dentry->d_inode);
-	path_put(&f->f_path);
 	put_filp(f);
+	path_put(&path);
 }
 
 struct file *create_read_pipe(struct file *wrf, int flags)
@@ -1028,6 +1029,7 @@ int do_pipe_flags(int *fd, int flags)
 	struct file *fw, *fr;
 	int error;
 	int fdw, fdr;
+	struct path path;
 
 	if (flags & ~(O_CLOEXEC | O_NONBLOCK))
 		return -EINVAL;
@@ -1061,8 +1063,9 @@ int do_pipe_flags(int *fd, int flags)
  err_fdr:
 	put_unused_fd(fdr);
  err_read_pipe:
-	path_put(&fr->f_path);
+	path = fr->f_path;
 	put_filp(fr);
+	path_put(&path);
  err_write_pipe:
 	free_write_pipe(fw);
 	return error;
-- 
1.6.1.284.g5dc13

