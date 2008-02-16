Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYBPTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYBPTMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYBPTMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:12:23 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58414 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbYBPTMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:12:22 -0500
Date: Sat, 16 Feb 2008 14:12:05 -0500
Message-Id: <200802161912.m1GJC5Gt031939@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>, jblunck@suse.de,
       hch@infradead.org
Subject: [PATCH -mmotm] fs/sysfs/file.c d_path fix
Cc: linux-kernel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using mmotm-2008-02-15-11-03, I get

  CC      fs/sysfs/file.o
fs/sysfs/file.c: In function 'sysfs_open_file':
fs/sysfs/file.c:334: warning: passing argument 1 of 'd_path' from incompatible pointer type
fs/sysfs/file.c:334: warning: passing argument 2 of 'd_path' from incompatible pointer type
fs/sysfs/file.c:334: warning: passing argument 3 of 'd_path' makes integer from pointer without a cast
fs/sysfs/file.c:334: error: too many arguments to function 'd_path'
make[2]: *** [fs/sysfs/file.o] Error 1
make[1]: *** [fs/sysfs] Error 2
make: *** [fs] Error 2

The following small patch fixes it for me.

Cheers,
Erez.


Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 02223e2..a57b024 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -329,9 +329,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_ops *ops;
 	int error = -EACCES;
 	char *p;
+	struct path sysfs_path;
 
-	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
-		   sizeof(last_sysfs_file));
+	sysfs_path.dentry = file->f_dentry;
+	sysfs_path.mnt = sysfs_mount;
+	p = d_path(&sysfs_path, last_sysfs_file, sizeof(last_sysfs_file));
 	if (p)
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
