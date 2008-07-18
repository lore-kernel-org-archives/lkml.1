Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbYGRCmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbYGRCmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYGRClu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:41:50 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:21042
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760327AbYGRCls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:41:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANeff0jLO9AP/2dsb2JhbACvdg
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="343549821"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 7/7] autofs4 - remove unused ioctls
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 10:37:52 +0800
Message-ID: <20080718023751.12802.96268.stgit@raven.themaw.net>
In-Reply-To: <20080718023651.12802.59107.stgit@raven.themaw.net>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctls AUTOFS_IOC_TOGGLEREGHOST and AUTOFS_IOC_ASKREGHOST were
added several years ago but what they were intended for has never
been implemented (as far as I'm aware noone uses them) so remove them.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c        |   68 +---------------------------------------------
 fs/compat_ioctl.c        |    2 -
 include/linux/auto_fs4.h |    2 -
 3 files changed, 1 insertions(+), 71 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 9c39fa7..b1536c1 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -25,7 +25,6 @@ static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
@@ -36,7 +35,7 @@ const struct file_operations autofs4_root_operations = {
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_root_readdir,
+	.readdir	= dcache_readdir,
 	.ioctl		= autofs4_root_ioctl,
 };
 
@@ -71,28 +70,6 @@ const struct inode_operations autofs4_dir_inode_operations = {
 	.rmdir		= autofs4_dir_rmdir,
 };
 
-static int autofs4_root_readdir(struct file *file, void *dirent,
-				filldir_t filldir)
-{
-	struct autofs_sb_info *sbi = autofs4_sbi(file->f_path.dentry->d_sb);
-	int oz_mode = autofs4_oz_mode(sbi);
-
-	DPRINTK("called, filp->f_pos = %lld", file->f_pos);
-
-	/*
-	 * Don't set reghost flag if:
-	 * 1) f_pos is larger than zero -- we've already been here.
-	 * 2) we haven't even enabled reghosting in the 1st place.
-	 * 3) this is the daemon doing a readdir
-	 */
-	if (oz_mode && file->f_pos == 0 && sbi->reghost_enabled)
-		sbi->needs_reghost = 1;
-
-	DPRINTK("needs_reghost = %d", sbi->needs_reghost);
-
-	return dcache_readdir(file, dirent, filldir);
-}
-
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -865,44 +842,6 @@ static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user
 }
 
 /*
- * Tells the daemon whether we need to reghost or not. Also, clears
- * the reghost_needed flag.
- */
-static inline int autofs4_ask_reghost(struct autofs_sb_info *sbi, int __user *p)
-{
-	int status;
-
-	DPRINTK("returning %d", sbi->needs_reghost);
-
-	status = put_user(sbi->needs_reghost, p);
-	if (status)
-		return status;
-
-	sbi->needs_reghost = 0;
-	return 0;
-}
-
-/*
- * Enable / Disable reghosting ioctl() operation
- */
-static inline int autofs4_toggle_reghost(struct autofs_sb_info *sbi, int __user *p)
-{
-	int status;
-	int val;
-
-	status = get_user(val, p);
-
-	DPRINTK("reghost = %d", val);
-
-	if (status)
-		return status;
-
-	/* turn on/off reghosting, with the val */
-	sbi->reghost_enabled = val;
-	return 0;
-}
-
-/*
 * Tells the daemon whether it can umount the autofs mount.
 */
 static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
@@ -966,11 +905,6 @@ static int autofs4_root_ioctl(struct inode *inode, struct file *filp,
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs4_get_set_timeout(sbi, p);
 
-	case AUTOFS_IOC_TOGGLEREGHOST:
-		return autofs4_toggle_reghost(sbi, p);
-	case AUTOFS_IOC_ASKREGHOST:
-		return autofs4_ask_reghost(sbi, p);
-
 	case AUTOFS_IOC_ASKUMOUNT:
 		return autofs4_ask_umount(filp->f_path.mnt, p);
 
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 44e9f05..c6663c5 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2290,8 +2290,6 @@ COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOVER)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE_MULTI)
 COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOSUBVER)
-COMPATIBLE_IOCTL(AUTOFS_IOC_ASKREGHOST)
-COMPATIBLE_IOCTL(AUTOFS_IOC_TOGGLEREGHOST)
 COMPATIBLE_IOCTL(AUTOFS_IOC_ASKUMOUNT)
 /* Raw devices */
 COMPATIBLE_IOCTL(RAW_SETBIND)
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index 31a2954..b785c6f 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -98,8 +98,6 @@ union autofs_v5_packet_union {
 #define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
-#define AUTOFS_IOC_ASKREGHOST           _IOR(0x93,0x68,int)
-#define AUTOFS_IOC_TOGGLEREGHOST        _IOR(0x93,0x69,int)
 #define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
 
 
