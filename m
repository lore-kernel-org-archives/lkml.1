Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYCQUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYCQUF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYCQUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:02:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51451 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYCQUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:20 -0400
Message-Id: <20080317200159.072705368@szeredi.hu>
References: <20080317200053.447640802@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 21:01:04 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 11/11] unprivileged mounts: copy mount ownership on namespace cloning
Content-Disposition: inline; filename=unprivileged-mounts-clone-inherit-owner.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Mount ownership wasn't copied on CLONE_NEWNS.  Noticed by Al Viro.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |    7 ++++++-
 fs/pnode.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-17 20:55:53.000000000 +0100
+++ linux/fs/namespace.c	2008-03-17 20:55:53.000000000 +0100
@@ -585,6 +585,11 @@ static struct vfsmount *clone_mnt(struct
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt;
 
+	if ((flag & CL_COPYUSER) && (old->mnt_flags & MNT_USER)) {
+		owner = old->mnt_uid;
+		flag |= CL_SETUSER;
+	}
+
 	if (flag & CL_SETUSER) {
 		int err = reserve_user_mount();
 		if (err)
@@ -2141,7 +2146,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
-					CL_COPY_ALL | CL_EXPIRE, 0);
+				 CL_COPY_ALL | CL_EXPIRE | CL_COPYUSER, 0);
 	if (IS_ERR(new_ns->root)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-03-17 20:55:52.000000000 +0100
+++ linux/fs/pnode.h	2008-03-17 20:55:53.000000000 +0100
@@ -24,6 +24,7 @@
 #define CL_PRIVATE 		0x20
 #define CL_SETUSER		0x40
 #define CL_NOSUID		0x80
+#define CL_COPYUSER		0x100
 
 void set_mnt_shared(struct vfsmount *);
 void clear_mnt_shared(struct vfsmount *);

--
