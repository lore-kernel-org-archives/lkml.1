Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXI1SOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXI1SOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbXI1SNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:13:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41423 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbXI1SNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:13:43 -0400
Subject: [RFC][PATCH 1/8] get mount write in __dentry_open()
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 28 Sep 2007 11:13:30 -0700
Message-Id: <20070928181330.27B367AC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The first three patches here fix actual bugs.  I think
the last two will reduce the chance for any future bugs
to creep in.  RFC for now.

--

This is a bug fix for the r/o bind mount patch set.

We need to ensure taking a mnt write on the mnt
referenced by any new struct file.  

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/open.c~get-write-in-__dentry_open fs/open.c
--- lxc/fs/open.c~get-write-in-__dentry_open	2007-09-28 11:03:18.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-28 11:03:18.000000000 -0700
@@ -778,9 +778,15 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = mnt_want_write(mnt);
 		if (error)
 			goto cleanup_file;
+
+		error = get_write_access(inode);
+		if (error) {
+			mnt_drop_write(mnt);
+			goto cleanup_file;
+		}
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -820,8 +826,10 @@ static struct file *__dentry_open(struct
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE)
+	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		mnt_drop_write(mnt);
+	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
_
