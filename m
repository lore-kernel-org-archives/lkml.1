Return-Path: <linux-kernel-owner+w=401wt.eu-S934333AbZJNW10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333AbZJNW10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbZJNW1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:27:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:9075 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbZJNW1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SMLVq8a468EcM8wJ3MFINhZC2++cYBU0I/rcTFgop3IOm4Z8zCtJlUUHCfHl0lKq0F
         ZxEPY4qQiKN3paTzQatGVj6lEw2mTp88xby+wxvgIo7aZw+AtE++Buhsnu2zx6E3KAbm
         O/l86oYr7rpLELEtJdmIljwlkTjg7TxrjQHeo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] kill-the-bkl/reiserfs: definitely drop the bkl from reiserfs_ioctl()
Date: Thu, 15 Oct 2009 00:26:06 +0200
Message-Id: <1255559167-5554-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
References: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reiserfs ioctl path doesn't need the big kernel lock anymore , now
that the filesystem synchronizes through its own lock.

We can then turn reiserfs_ioctl() into an unlocked_ioctl callback.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/dir.c           |    2 +-
 fs/reiserfs/file.c          |    2 +-
 fs/reiserfs/ioctl.c         |   11 +++--------
 include/linux/reiserfs_fs.h |    3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 17f31ad..c094f58 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -20,7 +20,7 @@ const struct file_operations reiserfs_dir_operations = {
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 9f43666..da2dba0 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -284,7 +284,7 @@ static ssize_t reiserfs_file_write(struct file *file,	/* the file we are going t
 const struct file_operations reiserfs_file_operations = {
 	.read = do_sync_read,
 	.write = reiserfs_file_write,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index e30e8be..ace7745 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -20,9 +20,9 @@
  *  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
  *  3) That's all for a while ...
  */
-int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		   unsigned long arg)
+long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 	int err = 0;
 
@@ -132,9 +132,6 @@ setversion_out:
 long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case REISERFS_IOC32_UNPACK:
@@ -156,9 +153,7 @@ long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 		return -ENOIOCTLCMD;
 	}
 
-	ret = reiserfs_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-
-	return ret;
+	return reiserfs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
 
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index a498d92..a05b4a2 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2314,8 +2314,7 @@ __u32 r5_hash(const signed char *msg, int len);
 #define SPARE_SPACE 500
 
 /* prototypes from ioctl.c */
-int reiserfs_ioctl(struct inode *inode, struct file *filp,
-		   unsigned int cmd, unsigned long arg);
+long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 int reiserfs_unpack(struct inode *inode, struct file *filp);
-- 
1.6.2.3

