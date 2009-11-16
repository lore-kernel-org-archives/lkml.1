Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZKPA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZKPA1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZKPA1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZKPA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 06/12] smbfs: do compat_ioctl handling in place
Date: Mon, 16 Nov 2009 00:27:01 +0000
Message-Id: <1258331227-1694-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Vzmc89LgW0u19z6LOcZO+7VuzBOs8rKJew0d
 l6auxFb0VWEDZDFUKphrb2QKEfo1YYBu1xKRpL+XpbENu8HFfN
 xc4KS20et3NFQkFmMw0Lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling SMB_IOC_GETMOUNTUID emulation directly in smbfs avoids
extra code in fs/compat_ioctl.c and can be optimized away by
the compiler in architectures where SMB_IOC_GETMOUNTUID and
COMPAT_SMB_IOC_GETMOUNTUID are identical.

As a positive side-effect, this pushes the BKL into the
ioctl method.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 fs/compat_ioctl.c |   25 -------------------------
 fs/smbfs/dir.c    |    5 ++++-
 fs/smbfs/file.c   |    3 ++-
 fs/smbfs/ioctl.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/smbfs/proto.h  |    3 ++-
 5 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 376d907..a762fb1 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -520,25 +520,6 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
 
 #endif /* CONFIG_BLOCK */
 
-static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
-			compat_uid_t __user *argp)
-{
-	mm_segment_t old_fs = get_fs();
-	__kernel_uid_t kuid;
-	int err;
-
-	cmd = SMB_IOC_GETMOUNTUID;
-
-	set_fs(KERNEL_DS);
-	err = sys_ioctl(fd, cmd, (unsigned long)&kuid);
-	set_fs(old_fs);
-
-	if (err >= 0)
-		err = put_user(kuid, argp);
-
-	return err;
-}
-
 /* Bluetooth ioctls */
 #define HCIUARTSETPROTO	_IOW('U', 200, int)
 #define HCIUARTGETPROTO	_IOR('U', 201, int)
@@ -1264,8 +1245,6 @@ COMPATIBLE_IOCTL(OSS_GETVERSION)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
 COMPATIBLE_IOCTL(RAW_GETBIND)
-/* SMB ioctls which do not need any translations */
-COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
 /* Watchdog */
 COMPATIBLE_IOCTL(WDIOC_GETSUPPORT)
 COMPATIBLE_IOCTL(WDIOC_GETSTATUS)
@@ -1543,10 +1522,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case MTIOCPOS32:
 		return mt_ioctl_trans(fd, cmd, argp);
 #endif
-	/* One SMB ioctl needs translations. */
-#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
-	case SMB_IOC_GETMOUNTUID_32:
-		return do_smb_getmountuid(fd, cmd, argp);
 	/* Serial */
 	case TIOCGSERIAL:
 	case TIOCSSERIAL:
diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 3e4803b..9607ff1 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -39,7 +39,10 @@ const struct file_operations smb_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
-	.ioctl		= smb_ioctl,
+	.unlocked_ioctl	= smb_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= smb_ioctl,
+#endif
 	.open		= smb_dir_open,
 };
 
diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index 92d5e8f..02f2bf8 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -438,7 +438,8 @@ const struct file_operations smb_file_operations =
 	.aio_read	= smb_file_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= smb_file_aio_write,
-	.ioctl		= smb_ioctl,
+	.unlocked_ioctl	= smb_ioctl,
+	.compat_ioctl	= smb_ioctl,
 	.mmap		= smb_file_mmap,
 	.open		= smb_file_open,
 	.release	= smb_file_release,
diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
index dbae1f8..0c28305 100644
--- a/fs/smbfs/ioctl.c
+++ b/fs/smbfs/ioctl.c
@@ -14,6 +14,8 @@
 #include <linux/mm.h>
 #include <linux/highuid.h>
 #include <linux/net.h>
+#include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <linux/smb_fs.h>
 #include <linux/smb_mount.h>
@@ -22,11 +24,9 @@
 
 #include "proto.h"
 
-int
-smb_ioctl(struct inode *inode, struct file *filp,
-	  unsigned int cmd, unsigned long arg)
+static long
+smb_locked_ioctl(struct smb_sb_info *server, unsigned int cmd, void __user *arg)
 {
-	struct smb_sb_info *server = server_from_inode(inode);
 	struct smb_conn_opt opt;
 	int result = -EINVAL;
 
@@ -65,3 +65,43 @@ smb_ioctl(struct inode *inode, struct file *filp,
 
 	return result;
 }
+
+long
+smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct smb_sb_info *server;
+	int ret;
+
+	lock_kernel();
+	server = server_from_inode(filp->f_path.dentry->d_inode);
+	ret = smb_locked_ioctl(server, cmd, (void __user *)arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_SMB_IOC_GETMOUNTUID _IOR('u', 1, compat_uid_t)
+long
+smb_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct smb_sb_info *server;
+	void __user *argp = compat_ptr(arg);
+	int ret;
+
+	lock_kernel();
+	server = server_from_inode(filp->f_path.dentry->d_inode);
+	if (cmd == COMPAT_SMB_IOC_GETMOUNTUID &&
+	    sizeof (compat_uid_t) < sizeof (__kernel_old_uid_t)) {
+		uid_t uid = server->mnt->mounted_uid;
+		if (uid > 65535)
+			uid = (compat_uid_t)overflowuid;
+		ret = put_user(uid, (compat_uid_t __user *) argp);
+	} else {
+		ret = smb_locked_ioctl(server, cmd, argp);
+	}
+	unlock_kernel();
+
+	return ret;
+}
+#endif
diff --git a/fs/smbfs/proto.h b/fs/smbfs/proto.h
index 03f456c..34bc708 100644
--- a/fs/smbfs/proto.h
+++ b/fs/smbfs/proto.h
@@ -67,7 +67,8 @@ extern const struct address_space_operations smb_file_aops;
 extern const struct file_operations smb_file_operations;
 extern const struct inode_operations smb_file_inode_operations;
 /* ioctl.c */
-extern int smb_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+extern long smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+extern long smb_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 /* smbiod.c */
 extern void smbiod_wake_up(void);
 extern int smbiod_register_server(struct smb_sb_info *server);
-- 
1.6.3.3

