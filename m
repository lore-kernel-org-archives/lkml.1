Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYBFWOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYBFWOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBFWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:14:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbYBFWOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:14:05 -0500
Message-ID: <47AA3126.8090102@redhat.com>
Date: Wed, 06 Feb 2008 16:13:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] reduce large do_mount stack usage with noinlines
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_mount() uses a whopping 616 bytes of stack on x86_64 in 
2.6.24-mm1, largely thanks to gcc inlining the various helper 
functions.

noinlining these can slim it down a lot; on my box this patch
gets it down to 168, which is mostly the struct nameidata nd;
left on the stack.

These functions are called only as do_mount() helpers;
none of them should be in any path that would see a performance
benefit from inlining...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24-mm1/fs/namespace.c
===================================================================
--- linux-2.6.24-mm1.orig/fs/namespace.c
+++ linux-2.6.24-mm1/fs/namespace.c
@@ -1296,7 +1296,7 @@ out_unlock:
 /*
  * recursively change the type of the mountpoint.
  */
-static int do_change_type(struct nameidata *nd, int flag)
+static noinline int do_change_type(struct nameidata *nd, int flag)
 {
 	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
@@ -1320,7 +1320,7 @@ static int do_change_type(struct nameida
 /*
  * do loopback mount.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static noinline int do_loopback(struct nameidata *nd, char *old_name, int recurse)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
@@ -1387,7 +1387,7 @@ static int change_mount_flags(struct vfs
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
  */
-static int do_remount(struct nameidata *nd, int flags, int mnt_flags,
+static noinline int do_remount(struct nameidata *nd, int flags, int mnt_flags,
 		      void *data)
 {
 	int err;
@@ -1425,7 +1425,7 @@ static inline int tree_contains_unbindab
 	return 0;
 }
 
-static int do_move_mount(struct nameidata *nd, char *old_name)
+static noinline int do_move_mount(struct nameidata *nd, char *old_name)
 {
 	struct nameidata old_nd, parent_nd;
 	struct vfsmount *p;
@@ -1505,7 +1505,7 @@ out:
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
  */
-static int do_new_mount(struct nameidata *nd, char *type, int flags,
+static noinline int do_new_mount(struct nameidata *nd, char *type, int flags,
 			int mnt_flags, char *name, void *data)
 {
 	struct vfsmount *mnt;

