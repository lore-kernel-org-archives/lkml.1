Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYJWCgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYJWCgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYJWCfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:35:43 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:44454
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbYJWCfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:35:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIx//0h8qQJT/2dsb2JhbAC5MQiHBIJMCHo
X-IronPort-AV: E=Sophos;i="4.33,468,1220198400"; 
   d="scan'208";a="341660427"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 5/6] autofs4 - improve parameter usage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Date: Thu, 23 Oct 2008 10:35:38 +0800
Message-ID: <20081023023538.4508.63914.stgit@raven.themaw.net>
In-Reply-To: <20081023023513.4508.54940.stgit@raven.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter usage in the device node ioctl code uses arg1 and arg2
as parameter names. This patch redefines the parameter names to reflect
what they actually are in an effort to make the code more readable.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---

 fs/autofs4/dev-ioctl.c         |   54 +++++++++++++++--------------
 include/linux/auto_dev-ioctl.h |   75 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 29 deletions(-)


diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 5a35502..9b78be9 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -159,7 +159,7 @@ static int autofs_dev_ioctl_protover(struct file *fp,
 				     struct autofs_sb_info *sbi,
 				     struct autofs_dev_ioctl *param)
 {
-	param->arg1 = sbi->version;
+	param->protover.version = sbi->version;
 	return 0;
 }
 
@@ -168,7 +168,7 @@ static int autofs_dev_ioctl_protosubver(struct file *fp,
 					struct autofs_sb_info *sbi,
 					struct autofs_dev_ioctl *param)
 {
-	param->arg1 = sbi->sub_version;
+	param->protosubver.sub_version = sbi->sub_version;
 	return 0;
 }
 
@@ -313,13 +313,13 @@ static int autofs_dev_ioctl_openmount(struct file *fp,
 	int err, fd;
 
 	/* param->path has already been checked */
-	if (!param->arg1)
+	if (!param->openmount.devid)
 		return -EINVAL;
 
 	param->ioctlfd = -1;
 
 	path = param->path;
-	devid = param->arg1;
+	devid = param->openmount.devid;
 
 	err = 0;
 	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
@@ -351,7 +351,7 @@ static int autofs_dev_ioctl_ready(struct file *fp,
 {
 	autofs_wqt_t token;
 
-	token = (autofs_wqt_t) param->arg1;
+	token = (autofs_wqt_t) param->ready.token;
 	return autofs4_wait_release(sbi, token, 0);
 }
 
@@ -366,8 +366,8 @@ static int autofs_dev_ioctl_fail(struct file *fp,
 	autofs_wqt_t token;
 	int status;
 
-	token = (autofs_wqt_t) param->arg1;
-	status = param->arg2 ? param->arg2 : -ENOENT;
+	token = (autofs_wqt_t) param->fail.token;
+	status = param->fail.status ? param->fail.status : -ENOENT;
 	return autofs4_wait_release(sbi, token, status);
 }
 
@@ -390,10 +390,10 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 	int pipefd;
 	int err = 0;
 
-	if (param->arg1 == -1)
+	if (param->setpipefd.pipefd == -1)
 		return -EINVAL;
 
-	pipefd = param->arg1;
+	pipefd = param->setpipefd.pipefd;
 
 	mutex_lock(&sbi->wq_mutex);
 	if (!sbi->catatonic) {
@@ -435,8 +435,8 @@ static int autofs_dev_ioctl_timeout(struct file *fp,
 {
 	unsigned long timeout;
 
-	timeout = param->arg1;
-	param->arg1 = sbi->exp_timeout / HZ;
+	timeout = param->timeout.timeout;
+	param->timeout.timeout = sbi->exp_timeout / HZ;
 	sbi->exp_timeout = timeout * HZ;
 	return 0;
 }
@@ -467,7 +467,7 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 	path = param->path;
 	devid = sbi->sb->s_dev;
 
-	param->arg1 = param->arg2 = -1;
+	param->requester.uid = param->requester.gid = -1;
 
 	/* Get nameidata of the parent directory */
 	err = path_lookup(path, LOOKUP_PARENT, &nd);
@@ -483,8 +483,8 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 		err = 0;
 		autofs4_expire_wait(nd.path.dentry);
 		spin_lock(&sbi->fs_lock);
-		param->arg1 = ino->uid;
-		param->arg2 = ino->gid;
+		param->requester.uid = ino->uid;
+		param->requester.gid = ino->gid;
 		spin_unlock(&sbi->fs_lock);
 	}
 
@@ -507,7 +507,7 @@ static int autofs_dev_ioctl_expire(struct file *fp,
 	int err = -EAGAIN;
 	int how;
 
-	how = param->arg1;
+	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
 	if (autofs_type_trigger(sbi->type))
@@ -543,9 +543,9 @@ static int autofs_dev_ioctl_askumount(struct file *fp,
 				      struct autofs_sb_info *sbi,
 				      struct autofs_dev_ioctl *param)
 {
-	param->arg1 = 0;
+	param->askumount.may_umount = 0;
 	if (may_umount(fp->f_path.mnt))
-		param->arg1 = 1;
+		param->askumount.may_umount = 1;
 	return 0;
 }
 
@@ -578,6 +578,7 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 	struct nameidata nd;
 	const char *path;
 	unsigned int type;
+	unsigned int devid, magic;
 	int err = -ENOENT;
 
 	if (param->size <= sizeof(*param)) {
@@ -586,10 +587,10 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 	}
 
 	path = param->path;
-	type = param->arg1;
+	type = param->ismountpoint.in.type;
 
-	param->arg1 = 0;
-	param->arg2 = 0;
+	param->ismountpoint.out.devid = devid = 0;
+	param->ismountpoint.out.magic = magic = 0;
 
 	if (!fp || param->ioctlfd == -1) {
 		if (autofs_type_any(type)) {
@@ -600,7 +601,7 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 				goto out;
 
 			sb = nd.path.dentry->d_sb;
-			param->arg1 = new_encode_dev(sb->s_dev);
+			devid = new_encode_dev(sb->s_dev);
 		} else {
 			struct autofs_info *ino;
 
@@ -613,14 +614,14 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 				goto out_release;
 
 			ino = autofs4_dentry_ino(nd.path.dentry);
-			param->arg1 = autofs4_get_dev(ino->sbi);
+			devid = autofs4_get_dev(ino->sbi);
 		}
 
 		err = 0;
 		if (nd.path.dentry->d_inode &&
 		    nd.path.mnt->mnt_root == nd.path.dentry) {
 			err = 1;
-			param->arg2 = nd.path.dentry->d_inode->i_sb->s_magic;
+			magic = nd.path.dentry->d_inode->i_sb->s_magic;
 		}
 	} else {
 		dev_t devid = new_encode_dev(sbi->sb->s_dev);
@@ -633,18 +634,21 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 		if (err)
 			goto out_release;
 
-		param->arg1 = autofs4_get_dev(sbi);
+		devid = autofs4_get_dev(sbi);
 
 		err = have_submounts(nd.path.dentry);
 
 		if (nd.path.mnt->mnt_mountpoint != nd.path.mnt->mnt_root) {
 			if (follow_down(&nd.path.mnt, &nd.path.dentry)) {
 				struct inode *inode = nd.path.dentry->d_inode;
-				param->arg2 = inode->i_sb->s_magic;
+				magic = inode->i_sb->s_magic;
 			}
 		}
 	}
 
+	param->ismountpoint.out.devid = devid;
+	param->ismountpoint.out.magic = magic;
+
 out_release:
 	path_put(&nd.path);
 out:
diff --git a/include/linux/auto_dev-ioctl.h b/include/linux/auto_dev-ioctl.h
index f4d05cc..91a7739 100644
--- a/include/linux/auto_dev-ioctl.h
+++ b/include/linux/auto_dev-ioctl.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_AUTO_DEV_IOCTL_H
 #define _LINUX_AUTO_DEV_IOCTL_H
 
+#include <linux/string.h>
 #include <linux/types.h>
 
 #define AUTOFS_DEVICE_NAME		"autofs"
@@ -25,6 +26,60 @@
  * An ioctl interface for autofs mount point control.
  */
 
+struct args_protover {
+	__u32	version;
+};
+
+struct args_protosubver {
+	__u32	sub_version;
+};
+
+struct args_openmount {
+	__u32	devid;
+};
+
+struct args_ready {
+	__u32	token;
+};
+
+struct args_fail {
+	__u32	token;
+	__s32	status;
+};
+
+struct args_setpipefd {
+	__s32	pipefd;
+};
+
+struct args_timeout {
+	__u64	timeout;
+};
+
+struct args_requester {
+	__u32	uid;
+	__u32	gid;
+};
+
+struct args_expire {
+	__u32	how;
+};
+
+struct args_askumount {
+	__u32	may_umount;
+};
+
+struct args_ismountpoint {
+	union {
+		struct args_in {
+			__u32	type;
+		} in;
+		struct args_out {
+			__u32	devid;
+			__u32	magic;
+		} out;
+	};
+};
+
 /*
  * All the ioctls use this structure.
  * When sending a path size must account for the total length
@@ -39,20 +94,32 @@ struct autofs_dev_ioctl {
 				 * including this struct */
 	__s32 ioctlfd;		/* automount command fd */
 
-	__u32 arg1;		/* Command parameters */
-	__u32 arg2;
+	/* Command parameters */
+
+	union {
+		struct args_protover		protover;
+		struct args_protosubver		protosubver;
+		struct args_openmount		openmount;
+		struct args_ready		ready;
+		struct args_fail		fail;
+		struct args_setpipefd		setpipefd;
+		struct args_timeout		timeout;
+		struct args_requester		requester;
+		struct args_expire		expire;
+		struct args_askumount		askumount;
+		struct args_ismountpoint	ismountpoint;
+	};
 
 	char path[0];
 };
 
 static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
 {
+	memset(in, 0, sizeof(struct autofs_dev_ioctl));
 	in->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
 	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
 	in->size = sizeof(struct autofs_dev_ioctl);
 	in->ioctlfd = -1;
-	in->arg1 = 0;
-	in->arg2 = 0;
 	return;
 }
 

