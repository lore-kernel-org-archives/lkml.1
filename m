Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYF0JGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYF0JGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYF0JG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:06:28 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:27378 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYF0JG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:06:27 -0400
Date: Fri, 27 Jun 2008 11:05:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
       swhiteho@redhat.com, sfrench@samba.org, vandrove@vc.cvut.cz
Subject: [PATCH] Remove BKL from remote_llseek v2
Message-ID: <20080627090524.GA2250@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Jun 2008 08:58:05.0860 (UTC) FILETIME=[E9DD8640:01C8D833]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove BKL from remote_llseek v2

Andrew, can you please consider this patch for -mm? 
I sent it to Jonathan earlier, but he ignored it.

It passed review by a few folks in the v1 form.

Thanks,

-Andi

---


- Replace remote_llseek with generic_file_llseek_unlocked (to force compilation 
failures in all users)
- Change all users to either use generic_file_llseek_unlocked directly or 
take the BKL around. I changed the file systems who don't use the BKL
for anything (CIFS, GFS) to call it directly. NCPFS and SMBFS and NFS
take the BKL, but explicitely in their own source now.

I moved them all over in a single patch to avoid unbisectable sections.

Open problem: 32bit kernels can corrupt fpos because its modification
is not atomic, but they can do that anyways because there's other paths who 
modify it without BKL.

Do we need a special lock for the pos/f_version = 0 checks? 

Trond says the NFS BKL is likely not needed, but keep it for now
until his full audit.

v2: Use generic_file_llseek_unlocked instead of remote_llseek_unlocked
    and factor duplicated code (suggested by hch)

Cc: Trond.Myklebust@netapp.com
Cc: swhiteho@redhat.com
Cc: sfrench@samba.org
Cc: vandrove@vc.cvut.cz

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/cifs/cifsfs.c   |    2 +-
 fs/gfs2/ops_file.c |    4 ++--
 fs/ncpfs/file.c    |   12 +++++++++++-
 fs/nfs/file.c      |    6 +++++-
 fs/read_write.c    |   38 +++++++++++---------------------------
 fs/smbfs/file.c    |   11 ++++++++++-
 include/linux/fs.h |    3 ++-
 7 files changed, 42 insertions(+), 34 deletions(-)

Index: linux/fs/cifs/cifsfs.c
===================================================================
--- linux.orig/fs/cifs/cifsfs.c
+++ linux/fs/cifs/cifsfs.c
@@ -613,7 +613,7 @@ static loff_t cifs_llseek(struct file *f
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return remote_llseek(file, offset, origin);
+	return generic_file_llseek_unlocked(file, offset, origin);
 }
 
 struct file_system_type cifs_fs_type = {
Index: linux/fs/gfs2/ops_file.c
===================================================================
--- linux.orig/fs/gfs2/ops_file.c
+++ linux/fs/gfs2/ops_file.c
@@ -62,11 +62,11 @@ static loff_t gfs2_llseek(struct file *f
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = remote_llseek(file, offset, origin);
+			error = generic_file_llseek_unlocked(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 	} else
-		error = remote_llseek(file, offset, origin);
+		error = generic_file_llseek_unlocked(file, offset, origin);
 
 	return error;
 }
Index: linux/fs/ncpfs/file.c
===================================================================
--- linux.orig/fs/ncpfs/file.c
+++ linux/fs/ncpfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 #include "ncplib_kernel.h"
@@ -281,9 +282,18 @@ static int ncp_release(struct inode *ino
 	return 0;
 }
 
+static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret;
+	lock_kernel();
+	ret = generic_file_llseek_unlocked(file, offset, origin);
+	unlock_kernel();
+	return ret;
+}
+
 const struct file_operations ncp_file_operations =
 {
-	.llseek		= remote_llseek,
+	.llseek 	= ncp_remote_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
 	.ioctl		= ncp_ioctl,
Index: linux/fs/read_write.c
===================================================================
--- linux.orig/fs/read_write.c
+++ linux/fs/read_write.c
@@ -31,12 +31,12 @@ const struct file_operations generic_ro_
 
 EXPORT_SYMBOL(generic_ro_fops);
 
-loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
+loff_t
+generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 	struct inode *inode = file->f_mapping->host;
 
-	mutex_lock(&inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
 			offset += inode->i_size;
@@ -46,42 +46,26 @@ loff_t generic_file_llseek(struct file *
 	}
 	retval = -EINVAL;
 	if (offset>=0 && offset<=inode->i_sb->s_maxbytes) {
+		/* Special lock needed here? */
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
 		}
 		retval = offset;
 	}
-	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
+EXPORT_SYMBOL(generic_file_llseek_unlocked);
 
-EXPORT_SYMBOL(generic_file_llseek);
-
-loff_t remote_llseek(struct file *file, loff_t offset, int origin)
+loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
-	loff_t retval;
-
-	lock_kernel();
-	switch (origin) {
-		case SEEK_END:
-			offset += i_size_read(file->f_path.dentry->d_inode);
-			break;
-		case SEEK_CUR:
-			offset += file->f_pos;
-	}
-	retval = -EINVAL;
-	if (offset>=0 && offset<=file->f_path.dentry->d_inode->i_sb->s_maxbytes) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
-			file->f_version = 0;
-		}
-		retval = offset;
-	}
-	unlock_kernel();
-	return retval;
+	loff_t n;
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
+	n = generic_file_llseek_unlocked(file, offset, origin);
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	return n;
 }
-EXPORT_SYMBOL(remote_llseek);
+EXPORT_SYMBOL(generic_file_llseek);
 
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
 {
Index: linux/fs/smbfs/file.c
===================================================================
--- linux.orig/fs/smbfs/file.c
+++ linux/fs/smbfs/file.c
@@ -422,9 +422,18 @@ smb_file_permission(struct inode *inode,
 	return error;
 }
 
+static loff_t smb_remote_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret;
+	lock_kernel();
+	ret = generic_file_llseek_unlocked(file, offset, origin);
+	unlock_kernel();
+	return ret;
+}
+
 const struct file_operations smb_file_operations =
 {
-	.llseek		= remote_llseek,
+	.llseek 	= smb_remote_llseek,
 	.read		= do_sync_read,
 	.aio_read	= smb_file_aio_read,
 	.write		= do_sync_write,
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -1871,7 +1871,8 @@ extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
+extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
+			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
Index: linux/fs/nfs/file.c
===================================================================
--- linux.orig/fs/nfs/file.c
+++ linux/fs/nfs/file.c
@@ -170,6 +170,7 @@ force_reval:
 
 static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 {
+	loff_t loff;
 	/* origin == SEEK_END => we must revalidate the cached file length */
 	if (origin == SEEK_END) {
 		struct inode *inode = filp->f_mapping->host;
@@ -177,7 +178,10 @@ static loff_t nfs_file_llseek(struct fil
 		if (retval < 0)
 			return (loff_t)retval;
 	}
-	return remote_llseek(filp, offset, origin);
+	lock_kernel();	/* BKL needed? */
+	loff = generic_file_llseek_unlocked(filp, offset, origin);
+	unlock_kernel();
+	return loff;
 }
 
 /*
