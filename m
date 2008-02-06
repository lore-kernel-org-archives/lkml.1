Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbYBFXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbYBFXQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764199AbYBFXLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:11:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763215AbYBFXLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:11:44 -0500
Message-ID: <47AA3EAA.9080204@redhat.com>
Date: Wed, 06 Feb 2008 17:11:38 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com> <20080206143457.03e8741d.akpm@linux-foundation.org>
In-Reply-To: <20080206143457.03e8741d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(updated with comments about the noinlines, and a fix for
 an >80 char line)

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
@@ -1295,8 +1295,9 @@ out_unlock:
 
 /*
  * recursively change the type of the mountpoint.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_change_type(struct nameidata *nd, int flag)
+static noinline int do_change_type(struct nameidata *nd, int flag)
 {
 	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
@@ -1319,8 +1320,10 @@ static int do_change_type(struct nameida
 
 /*
  * do loopback mount.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static noinline int do_loopback(struct nameidata *nd, char *old_name,
+				int recurse)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
@@ -1386,8 +1389,9 @@ static int change_mount_flags(struct vfs
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_remount(struct nameidata *nd, int flags, int mnt_flags,
+static noinline int do_remount(struct nameidata *nd, int flags, int mnt_flags,
 		      void *data)
 {
 	int err;
@@ -1425,7 +1429,10 @@ static inline int tree_contains_unbindab
 	return 0;
 }
 
-static int do_move_mount(struct nameidata *nd, char *old_name)
+/*
+ * noinline this do_mount helper to save do_mount stack space.
+ */
+static noinline int do_move_mount(struct nameidata *nd, char *old_name)
 {
 	struct nameidata old_nd, parent_nd;
 	struct vfsmount *p;
@@ -1504,8 +1511,9 @@ out:
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_new_mount(struct nameidata *nd, char *type, int flags,
+static noinline int do_new_mount(struct nameidata *nd, char *type, int flags,
 			int mnt_flags, char *name, void *data)
 {
 	struct vfsmount *mnt;

