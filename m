Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXA1MRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXA1MRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXA1MRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:17:48 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:30523 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752423AbXA1MRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:17:47 -0500
Subject: [PATCH 8/7] fs: free_write_pipe() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070128115118.837777000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
Content-Type: text/plain
Date: Sun, 28 Jan 2007 13:16:51 +0100
Message-Id: <1169986611.10987.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

file_kill() has to look at the file's inode (for the barrier logic),
hence make sure we free the inode before the file.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/pipe.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux/fs/pipe.c
===================================================================
--- linux.orig/fs/pipe.c
+++ linux/fs/pipe.c
@@ -945,12 +945,17 @@ struct file *create_write_pipe(void)
 	return ERR_PTR(err);
 }
 
-void free_write_pipe(struct file *f)
+void free_write_pipe(struct file *file)
 {
-	free_pipe_info(f->f_dentry->d_inode);
-	dput(f->f_path.dentry);
-	mntput(f->f_path.mnt);
-	put_filp(f);
+	struct dentry *dentry = file->f_path.dentry;
+	struct vfsmount *mnt = file->f_path.mnt;
+
+	free_pipe_info(file->f_dentry->d_inode);
+	file->f_path.dentry = NULL;
+	file->f_path.mnt = NULL;
+	put_filp(file);
+	dput(dentry);
+	mntput(mnt);
 }
 
 struct file *create_read_pipe(struct file *wrf)


