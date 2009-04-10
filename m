Return-Path: <linux-kernel-owner+w=401wt.eu-S937880AbZDJCqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937880AbZDJCqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936657AbZDJCkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:40:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38283 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936673AbZDJCkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BhVCJTDipHa5q34iAPdufLEEaz6loWpYRWD1JdJM15nNfaP4aBoyar6uqNCQnetAhz
         KCoBS+Ie6meCLUWnVqNmM0DDhYN5HeU/omOJkbphFtAe1vHrcUO+dDnj8dxTdpfYr6qi
         N9b+XIVzJgK70l3anQQsX6vY1zlVGk+Ky9MZk=
Date: Fri, 10 Apr 2009 06:40:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/30] cr: mount namespace
Message-ID: <20090410024004.GA27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is one big FIXME:
	What to do with overmounted files?
	What to do with mounts at all, who should restore them?

just restore something to not oops on task exit

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/namespace.c                |   22 ++++++--
 include/linux/cr.h            |    6 ++
 include/linux/mnt_namespace.h |    1 
 kernel/cr/Makefile            |    1 
 kernel/cr/cpt-sys.c           |    6 ++
 kernel/cr/cr-mnt.c            |  108 ++++++++++++++++++++++++++++++++++++++++++
 kernel/cr/cr-nsproxy.c        |    2 
 kernel/cr/cr.h                |    4 +
 8 files changed, 144 insertions(+), 6 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1970,6 +1970,21 @@ dput_out:
 	return retval;
 }
 
+struct mnt_namespace *alloc_mnt_ns(void)
+{
+	struct mnt_namespace *mnt_ns;
+
+	mnt_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
+	if (mnt_ns) {
+		atomic_set(&mnt_ns->count, 1);
+		mnt_ns->root = NULL;
+		INIT_LIST_HEAD(&mnt_ns->list);
+		init_waitqueue_head(&mnt_ns->poll);
+		mnt_ns->event = 0;
+	}
+	return mnt_ns;
+}
+
 /*
  * Allocate a new namespace structure and populate it with contents
  * copied from the namespace of the passed in task structure.
@@ -1981,15 +1996,10 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	struct vfsmount *rootmnt = NULL, *pwdmnt = NULL;
 	struct vfsmount *p, *q;
 
-	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
+	new_ns = alloc_mnt_ns();
 	if (!new_ns)
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&new_ns->count, 1);
-	INIT_LIST_HEAD(&new_ns->list);
-	init_waitqueue_head(&new_ns->poll);
-	new_ns->event = 0;
-
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
--- a/include/linux/cr.h
+++ b/include/linux/cr.h
@@ -48,6 +48,7 @@ struct cr_object_header {
 #define CR_OBJ_GROUP_INFO	17
 #define CR_OBJ_USER_STRUCT	18
 #define CR_OBJ_USER_NS		19
+#define CR_OBJ_MNT_NS		20
 	__u32	cr_type;	/* object type */
 	__u32	cr_len;		/* object length in bytes including header */
 } __packed;
@@ -176,6 +177,7 @@ struct cr_image_nsproxy {
 	struct cr_object_header cr_hdr;
 
 	cr_pos_t	cr_pos_uts_ns;
+	cr_pos_t	cr_pos_mnt_ns;
 	cr_pos_t	cr_pos_pid_ns;
 } __packed;
 
@@ -190,6 +192,10 @@ struct cr_image_uts_ns {
 	__u8		cr_domainname[64];
 } __packed;
 
+struct cr_image_mnt_ns {
+	struct cr_object_header cr_hdr;
+} __packed;
+
 struct cr_image_pid_ns {
 	struct cr_object_header cr_hdr;
 
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -24,6 +24,7 @@ struct proc_mounts {
 
 struct fs_struct;
 
+struct mnt_namespace *alloc_mnt_ns(void);
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
 extern void __put_mnt_ns(struct mnt_namespace *ns);
--- a/kernel/cr/Makefile
+++ b/kernel/cr/Makefile
@@ -5,6 +5,7 @@ cr-y += cr-cred.o
 cr-y += cr-file.o
 cr-y += cr-fs.o
 cr-y += cr-mm.o
+cr-y += cr-mnt.o
 cr-y += cr-nsproxy.o
 cr-y += cr-pid.o
 cr-y += cr-signal.o
--- a/kernel/cr/cpt-sys.c
+++ b/kernel/cr/cpt-sys.c
@@ -71,6 +71,9 @@ static int cr_collect(struct cr_context *ctx)
 	rv = cr_collect_all_uts_ns(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_collect_all_mnt_ns(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_collect_all_pid_ns(ctx);
 	if (rv < 0)
 		return rv;
@@ -158,6 +161,9 @@ static int cr_dump(struct cr_context *ctx)
 	rv = cr_dump_all_cred(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_dump_all_mnt_ns(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_dump_all_file(ctx);
 	if (rv < 0)
 		return rv;
new file mode 100644
--- /dev/null
+++ b/kernel/cr/cr-mnt.c
@@ -0,0 +1,108 @@
+/* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
+#include <linux/fs.h>
+#include <linux/mnt_namespace.h>
+
+#include <linux/cr.h>
+#include "cr.h"
+
+static int cr_collect_mnt_ns(struct cr_context *ctx, struct mnt_namespace *mnt_ns)
+{
+	int rv;
+
+	rv = cr_collect_object(ctx, mnt_ns, CR_CTX_MNT_NS);
+	printk("collect mnt_ns %p: rv %d\n", mnt_ns, rv);
+	return rv;
+}
+
+int cr_collect_all_mnt_ns(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_NSPROXY) {
+		struct nsproxy *nsproxy = obj->o_obj;
+
+		rv = cr_collect_mnt_ns(ctx, nsproxy->mnt_ns);
+		if (rv < 0)
+			return rv;
+	}
+	for_each_cr_object(ctx, obj, CR_CTX_MNT_NS) {
+		struct mnt_namespace *mnt_ns = obj->o_obj;
+		unsigned int cnt = atomic_read(&mnt_ns->count);
+
+		if (obj->o_count != cnt) {
+			printk("%s: mnt_ns %p has external references %lu:%u\n", __func__, mnt_ns, obj->o_count, cnt);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int cr_dump_mnt_ns(struct cr_context *ctx, struct cr_object *obj)
+{
+	struct mnt_namespace *mnt_ns = obj->o_obj;
+	struct cr_image_mnt_ns *i;
+	int rv;
+
+	printk("dump mnt_ns %p\n", mnt_ns);
+
+	i = cr_prepare_image(CR_OBJ_MNT_NS, sizeof(*i));
+	if (!i)
+		return -ENOMEM;
+
+	obj->o_pos = ctx->cr_dump_file->f_pos;
+	rv = cr_write(ctx, i, sizeof(*i));
+	kfree(i);
+	return rv;
+}
+
+int cr_dump_all_mnt_ns(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_MNT_NS) {
+		rv = cr_dump_mnt_ns(ctx, obj);
+		if (rv < 0)
+			return rv;
+	}
+	return 0;
+}
+
+int cr_restore_mnt_ns(struct cr_context *ctx, loff_t pos)
+{
+	struct cr_image_mnt_ns *i;
+	struct mnt_namespace *mnt_ns;
+	struct cr_object *obj;
+	int rv;
+
+	i = kzalloc(sizeof(*i), GFP_KERNEL);
+	if (!i)
+		return -ENOMEM;
+	rv = cr_pread(ctx, i, sizeof(*i), pos);
+	if (rv < 0) {
+		kfree(i);
+		return rv;
+	}
+	if (i->cr_hdr.cr_type != CR_OBJ_MNT_NS) {
+		kfree(i);
+		return -EINVAL;
+	}
+
+	mnt_ns = alloc_mnt_ns();
+	if (!mnt_ns) {
+		kfree(i);
+		return -ENOMEM;
+	}
+	kfree(i);
+
+	obj = cr_object_create(mnt_ns);
+	if (!obj) {
+		kfree(mnt_ns);
+		return -ENOMEM;
+	}
+	obj->o_pos = pos;
+	list_add(&obj->o_list, &ctx->cr_obj[CR_CTX_MNT_NS]);
+	printk("restore mnt_ns %p, pos %lld\n", mnt_ns, (long long)pos);
+	return 0;
+}
--- a/kernel/cr/cr-nsproxy.c
+++ b/kernel/cr/cr-nsproxy.c
@@ -59,6 +59,8 @@ static int cr_dump_nsproxy(struct cr_context *ctx, struct cr_object *obj)
 
 	tmp = cr_find_obj_by_ptr(ctx, nsproxy->uts_ns, CR_CTX_UTS_NS);
 	i->cr_pos_uts_ns = tmp->o_pos;
+	tmp = cr_find_obj_by_ptr(ctx, nsproxy->mnt_ns, CR_CTX_MNT_NS);
+	i->cr_pos_mnt_ns = tmp->o_pos;
 	tmp = cr_find_obj_by_ptr(ctx, nsproxy->pid_ns, CR_CTX_PID_NS);
 	i->cr_pos_pid_ns = tmp->o_pos;
 
--- a/kernel/cr/cr.h
+++ b/kernel/cr/cr.h
@@ -28,6 +28,7 @@ enum cr_context_obj_type {
 	CR_CTX_FS_STRUCT,
 	CR_CTX_GROUP_INFO,
 	CR_CTX_MM_STRUCT,
+	CR_CTX_MNT_NS,
 	CR_CTX_NSPROXY,
 	CR_CTX_PID,
 	CR_CTX_PID_NS,
@@ -95,6 +96,7 @@ int cr_collect_all_file(struct cr_context *ctx);
 int cr_collect_all_fs_struct(struct cr_context *ctx);
 int cr_collect_all_group_info(struct cr_context *ctx);
 int cr_collect_all_mm_struct(struct cr_context *ctx);
+int cr_collect_all_mnt_ns(struct cr_context *ctx);
 int cr_collect_all_nsproxy(struct cr_context *ctx);
 int cr_collect_all_pid_ns(struct cr_context *ctx);
 int cr_collect_all_pid(struct cr_context *ctx);
@@ -111,6 +113,7 @@ int cr_dump_all_file(struct cr_context *ctx);
 int cr_dump_all_fs_struct(struct cr_context *ctx);
 int cr_dump_all_group_info(struct cr_context *ctx);
 int cr_dump_all_mm_struct(struct cr_context *ctx);
+int cr_dump_all_mnt_ns(struct cr_context *ctx);
 int cr_dump_all_nsproxy(struct cr_context *ctx);
 int cr_dump_all_pid_ns(struct cr_context *ctx);
 int cr_dump_all_pid(struct cr_context *ctx);
@@ -127,6 +130,7 @@ int cr_restore_file(struct cr_context *ctx, loff_t pos);
 int cr_restore_fs_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_group_info(struct cr_context *ctx, loff_t pos);
 int cr_restore_mm_struct(struct cr_context *ctx, loff_t pos);
+int cr_restore_mnt_ns(struct cr_context *ctx, loff_t pos);
 int cr_restore_nsproxy(struct cr_context *ctx, loff_t pos);
 int cr_restore_pid_ns(struct cr_context *ctx, loff_t pos);
 int cr_restore_pid(struct cr_context *ctx, struct cr_image_task_struct *i);
