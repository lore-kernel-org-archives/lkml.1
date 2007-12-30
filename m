Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbXL3AU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbXL3AU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 19:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXL3AUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 19:20:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXL3AUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 19:20:46 -0500
Date: Sat, 29 Dec 2007 16:20:25 -0800
Message-Id: <200712300020.lBU0KPcr010209@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: [PATCH] security: remove security_sb_post_mountroot hook
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The security_sb_post_mountroot() hook is long-since obsolete, and is
fundamentally broken: it is never invoked if someone uses initramfs.
This is particularly damaging, because the existence of this hook has
been used as motivation for not using initramfs.

Stephen Smalley confirmed on 2007-07-19 that this hook was originally
used by SELinux but can now be safely removed:

     http://marc.info/?l=linux-kernel&m=118485683612916&w=2

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/security.h |    8 --------
 init/do_mounts.c         |    1 -
 security/dummy.c         |    6 ------
 security/security.c      |    5 -----
 4 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ac05083..21185bc 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -243,9 +243,6 @@ struct request_sock;
  *	@mnt contains the mounted file system.
  *	@flags contains the new filesystem flags.
  *	@data contains the filesystem-specific data.
- * @sb_post_mountroot:
- *	Update the security module's state when the root filesystem is mounted.
- *	This hook is only called if the mount was successful.
  * @sb_post_addmount:
  *	Update the security module's state when a filesystem is mounted.
  *	This hook is called any time a mount is successfully grafetd to
@@ -1235,7 +1232,6 @@ struct security_operations {
 	void (*sb_umount_busy) (struct vfsmount * mnt);
 	void (*sb_post_remount) (struct vfsmount * mnt,
 				 unsigned long flags, void *data);
-	void (*sb_post_mountroot) (void);
 	void (*sb_post_addmount) (struct vfsmount * mnt,
 				  struct nameidata * mountpoint_nd);
 	int (*sb_pivotroot) (struct nameidata * old_nd,
@@ -1495,7 +1491,6 @@ int security_sb_umount(struct vfsmount *mnt, int flags);
 void security_sb_umount_close(struct vfsmount *mnt);
 void security_sb_umount_busy(struct vfsmount *mnt);
 void security_sb_post_remount(struct vfsmount *mnt, unsigned long flags, void *data);
-void security_sb_post_mountroot(void);
 void security_sb_post_addmount(struct vfsmount *mnt, struct nameidata *mountpoint_nd);
 int security_sb_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd);
 void security_sb_post_pivotroot(struct nameidata *old_nd, struct nameidata *new_nd);
@@ -1777,9 +1772,6 @@ static inline void security_sb_post_remount (struct vfsmount *mnt,
 					     unsigned long flags, void *data)
 { }
 
-static inline void security_sb_post_mountroot (void)
-{ }
-
 static inline void security_sb_post_addmount (struct vfsmount *mnt,
 					      struct nameidata *mountpoint_nd)
 { }
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 4efa1e5..31b2185 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -470,6 +470,5 @@ void __init prepare_namespace(void)
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
-	security_sb_post_mountroot();
 }
 
diff --git a/security/dummy.c b/security/dummy.c
index 3ccfbbe..1c5ab2b 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -225,11 +225,6 @@ static void dummy_sb_post_remount (struct vfsmount *mnt, unsigned long flags,
 }
 
 
-static void dummy_sb_post_mountroot (void)
-{
-	return;
-}
-
 static void dummy_sb_post_addmount (struct vfsmount *mnt, struct nameidata *nd)
 {
 	return;
@@ -994,7 +989,6 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, sb_umount_close);
 	set_to_dummy_if_null(ops, sb_umount_busy);
 	set_to_dummy_if_null(ops, sb_post_remount);
-	set_to_dummy_if_null(ops, sb_post_mountroot);
 	set_to_dummy_if_null(ops, sb_post_addmount);
 	set_to_dummy_if_null(ops, sb_pivotroot);
 	set_to_dummy_if_null(ops, sb_post_pivotroot);
diff --git a/security/security.c b/security/security.c
index 0e1f1f1..fb6767b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -288,11 +288,6 @@ void security_sb_post_remount(struct vfsmount *mnt, unsigned long flags, void *d
 	security_ops->sb_post_remount(mnt, flags, data);
 }
 
-void security_sb_post_mountroot(void)
-{
-	security_ops->sb_post_mountroot();
-}
-
 void security_sb_post_addmount(struct vfsmount *mnt, struct nameidata *mountpoint_nd)
 {
 	security_ops->sb_post_addmount(mnt, mountpoint_nd);
-- 
1.5.3.6

