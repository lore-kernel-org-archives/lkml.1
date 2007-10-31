Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbXJaNAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbXJaNAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXJaNAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:00:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbXJaNAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:00:24 -0400
Date: Wed, 31 Oct 2007 08:59:47 -0400
Message-Id: <200710311259.l9VCxlEA003584@dantu.rdu.redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: sfrench@samba.org, akpm@linux-foundation.org
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] smbfs: fix debug builds
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some warnings with SMBFS_DEBUG_* builds. This patch makes it so
that builds with -Werror don't fail.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/smbfs/file.c   |    7 ++++---
 fs/smbfs/inode.c  |    2 +-
 fs/smbfs/proc.c   |    2 +-
 fs/smbfs/smbiod.c |    2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index f5d14ce..efbe29a 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -234,7 +234,7 @@ smb_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 
 	VERBOSE("before read, size=%ld, flags=%x, atime=%ld\n",
 		(long)dentry->d_inode->i_size,
-		dentry->d_inode->i_flags, dentry->d_inode->i_atime);
+		dentry->d_inode->i_flags, dentry->d_inode->i_atime.tv_sec);
 
 	status = generic_file_aio_read(iocb, iov, nr_segs, pos);
 out:
@@ -269,7 +269,7 @@ smb_file_splice_read(struct file *file, loff_t *ppos,
 	struct dentry *dentry = file->f_path.dentry;
 	ssize_t status;
 
-	VERBOSE("file %s/%s, pos=%Ld, count=%d\n",
+	VERBOSE("file %s/%s, pos=%Ld, count=%lu\n",
 		DENTRY_PATH(dentry), *ppos, count);
 
 	status = smb_revalidate_inode(dentry);
@@ -363,7 +363,8 @@ smb_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		result = generic_file_aio_write(iocb, iov, nr_segs, pos);
 		VERBOSE("pos=%ld, size=%ld, mtime=%ld, atime=%ld\n",
 			(long) file->f_pos, (long) dentry->d_inode->i_size,
-			dentry->d_inode->i_mtime, dentry->d_inode->i_atime);
+			dentry->d_inode->i_mtime.tv_sec,
+			dentry->d_inode->i_atime.tv_sec);
 	}
 out:
 	return result;
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index ab51775..9416ead 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -536,7 +536,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 
 	/* Allocate the global temp buffer and some superblock helper structs */
 	/* FIXME: move these to the smb_sb_info struct */
-	VERBOSE("alloc chunk = %d\n", sizeof(struct smb_ops) +
+	VERBOSE("alloc chunk = %lu\n", sizeof(struct smb_ops) +
 		sizeof(struct smb_mount_data_kernel));
 	mem = kmalloc(sizeof(struct smb_ops) +
 		      sizeof(struct smb_mount_data_kernel), GFP_KERNEL);
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index feac460..d517a27 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -2593,7 +2593,7 @@ smb_proc_getattr_ff(struct smb_sb_info *server, struct dentry *dentry,
 	fattr->f_mtime.tv_sec = date_dos2unix(server, date, time);
 	fattr->f_mtime.tv_nsec = 0;
 	VERBOSE("name=%s, date=%x, time=%x, mtime=%ld\n",
-		mask, date, time, fattr->f_mtime);
+		mask, date, time, fattr->f_mtime.tv_sec);
 	fattr->f_size = DVAL(req->rq_data, 12);
 	/* ULONG allocation size */
 	fattr->attr = WVAL(req->rq_data, 20);
diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
index 283c572..fae8e85 100644
--- a/fs/smbfs/smbiod.c
+++ b/fs/smbfs/smbiod.c
@@ -227,7 +227,7 @@ int smbiod_retry(struct smb_sb_info *server)
 		printk(KERN_ERR "smb_retry: signal failed [%d]\n", result);
 		goto out;
 	}
-	VERBOSE("signalled pid %d\n", pid);
+	VERBOSE("signalled pid %d\n", pid_nr(pid));
 
 	/* FIXME: The retried requests should perhaps get a "time boost". */
 
-- 
1.5.2.1

