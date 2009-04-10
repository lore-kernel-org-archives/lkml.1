Return-Path: <linux-kernel-owner+w=401wt.eu-S937823AbZDJCo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937823AbZDJCo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936234AbZDJCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:39:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49993 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936209AbZDJCjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vwd7Aanpiy7E3xBBxNykY2uLh7eg1ButeCW8718dYxPT2Q0JXnMCakh1fbUT8Mesr4
         cBYMyy3oVWkPoEgYsSjI2Q6fEGqGzs8QmUgk5MvXgRF/nIlJ/easT8IVrwZXd518MZXX
         udEH0ZqSe1Qm1sBwnd9QK2917L2OVnUXIkkbg=
Date: Fri, 10 Apr 2009 06:39:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/30] cr: deal with fs_struct
Message-ID: <20090410023912.GX27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dump umask, root, pwd.

root, pwd are dumped as names returned by d_path.

FIXME, FIXME, FIXME: think through what to do with overmount
and vfsmount themselves!!!

FIXME: restore root, pwd, tsk->fs itself

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cr.h  |   12 +++
 kernel/cr/Makefile  |    1 
 kernel/cr/cpt-sys.c |    6 +
 kernel/cr/cr-fs.c   |  194 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/cr/cr-task.c |    2 
 kernel/cr/cr.h      |    4 +
 6 files changed, 219 insertions(+)

--- a/include/linux/cr.h
+++ b/include/linux/cr.h
@@ -41,6 +41,7 @@ struct cr_object_header {
 #define CR_OBJ_PID		10
 #define CR_OBJ_FILES_STRUCT	11
 #define CR_OBJ_FD		12
+#define CR_OBJ_FS_STRUCT	13
 	__u32	cr_type;	/* object type */
 	__u32	cr_len;		/* object length in bytes including header */
 } __packed;
@@ -61,6 +62,7 @@ struct cr_image_task_struct {
 	cr_pos_t	cr_pos_real_parent;
 	cr_pos_t	cr_pos_mm;
 	cr_pos_t	cr_pos_pids[3];
+	cr_pos_t	cr_pos_fs;
 	cr_pos_t	cr_pos_files;
 	cr_pos_t	cr_pos_nsproxy;
 
@@ -231,6 +233,16 @@ struct cr_image_vma_content {
 	/* __u8 cr_data[cr_nr_pages * cr_page_size]; */
 } __packed;
 
+struct cr_image_fs_struct {
+	struct cr_object_header cr_hdr;
+
+	__u32		cr_umask;
+	__u32		cr_root_len;
+	__u32		cr_pwd_len;
+	/* __u8 cr_root[cr_root_len] */
+	/* __u8 cr_pwd[cr_pwd_len] */
+} __packed;
+
 struct cr_image_files_struct {
 	struct cr_object_header cr_hdr;
 } __packed;
--- a/kernel/cr/Makefile
+++ b/kernel/cr/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_CR) += cr.o
 cr-y := cpt-sys.o rst-sys.o
 cr-y += cr-context.o
 cr-y += cr-file.o
+cr-y += cr-fs.o
 cr-y += cr-mm.o
 cr-y += cr-nsproxy.o
 cr-y += cr-pid.o
--- a/kernel/cr/cpt-sys.c
+++ b/kernel/cr/cpt-sys.c
@@ -83,6 +83,9 @@ static int cr_collect(struct cr_context *ctx)
 	rv = cr_collect_all_file(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_collect_all_fs_struct(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_collect_all_pid(ctx);
 	if (rv < 0)
 		return rv;
@@ -131,6 +134,9 @@ static int cr_dump(struct cr_context *ctx)
 	rv = cr_dump_all_files_struct(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_dump_all_fs_struct(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_dump_all_uts_ns(ctx);
 	if (rv < 0)
 		return rv;
new file mode 100644
--- /dev/null
+++ b/kernel/cr/cr-fs.c
@@ -0,0 +1,194 @@
+/* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
+#include <linux/dcache.h>
+#include <linux/fs.h>
+#include <linux/fs_struct.h>
+#include <linux/sched.h>
+
+#include <linux/cr.h>
+#include "cr.h"
+
+static int cr_collect_fs_struct(struct cr_context *ctx, struct fs_struct *fs)
+{
+	int rv;
+
+	rv = cr_collect_object(ctx, fs, CR_CTX_FS_STRUCT);
+	printk("collect fs_struct %p: rv %d\n", fs, rv);
+	return rv;
+}
+
+int cr_collect_all_fs_struct(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_TASK_STRUCT) {
+		struct task_struct *tsk = obj->o_obj;
+
+		rv = cr_collect_fs_struct(ctx, tsk->fs);
+		if (rv < 0)
+			return rv;
+	}
+	for_each_cr_object(ctx, obj, CR_CTX_FS_STRUCT) {
+		struct fs_struct *fs = obj->o_obj;
+		unsigned int cnt = fs->users;
+
+		if (obj->o_count != cnt) {
+			printk("%s: fs_struct %p has external references %lu:%u\n", __func__, fs, obj->o_count, cnt);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int cr_dump_fs_struct(struct cr_context *ctx, struct cr_object *obj)
+{
+	struct fs_struct *fs = obj->o_obj;
+	struct cr_image_fs_struct *i;
+	char *buf_root, *name_root, *buf_pwd, *name_pwd;
+	int rv;
+
+	i = cr_prepare_image(CR_OBJ_FS_STRUCT, sizeof(*i));
+	if (!i)
+		return -ENOMEM;
+
+	i->cr_umask = fs->umask;
+
+	buf_root = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf_root) {
+		kfree(i);
+		return -ENOMEM;
+	}
+	name_root = d_path(&fs->root, buf_root, PAGE_SIZE);
+	if (IS_ERR(name_root)) {
+		kfree(buf_root);
+		kfree(i);
+		return PTR_ERR(name_root);
+	}
+	i->cr_root_len = buf_root + PAGE_SIZE - 1 - name_root;
+	i->cr_hdr.cr_len += i->cr_root_len;
+
+	buf_pwd = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf_pwd) {
+		kfree(buf_root);
+		kfree(i);
+		return -ENOMEM;
+	}
+	name_pwd = d_path(&fs->pwd, buf_pwd, PAGE_SIZE);
+	if (IS_ERR(name_pwd)) {
+		kfree(buf_pwd);
+		kfree(buf_root);
+		kfree(i);
+		return PTR_ERR(name_pwd);
+	}
+	i->cr_pwd_len = buf_pwd + PAGE_SIZE - 1 - name_pwd;
+	i->cr_hdr.cr_len += i->cr_pwd_len;
+
+	obj->o_pos = ctx->cr_dump_file->f_pos;
+	rv = cr_write(ctx, i, sizeof(*i));
+	if (rv < 0) {
+		kfree(buf_pwd);
+		kfree(buf_root);
+		kfree(i);
+		return rv;
+	}
+	rv = cr_write(ctx, name_root, i->cr_root_len);
+	if (rv < 0) {
+		kfree(buf_pwd);
+		kfree(buf_root);
+		kfree(i);
+		return rv;
+	}
+	rv = cr_write(ctx, name_pwd, i->cr_pwd_len);
+	if (rv < 0) {
+		kfree(buf_pwd);
+		kfree(buf_root);
+		kfree(i);
+		return rv;
+	}
+	printk("dump fs_struct %p: umask %03o, root '%.*s', pwd '%.*s'\n", fs, fs->umask, i->cr_root_len, name_root, i->cr_pwd_len, name_pwd);
+
+	kfree(buf_pwd);
+	kfree(buf_root);
+	kfree(i);
+	return 0;
+}
+
+int cr_dump_all_fs_struct(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_FS_STRUCT) {
+		rv = cr_dump_fs_struct(ctx, obj);
+		if (rv < 0)
+			return rv;
+	}
+	return 0;
+}
+
+int cr_restore_fs_struct(struct cr_context *ctx, loff_t pos)
+{
+	struct cr_image_fs_struct *i, *tmp;
+	struct fs_struct *fs;
+	struct cr_object *obj;
+	char *cr_root, *cr_pwd;
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
+	if (i->cr_hdr.cr_type != CR_OBJ_FS_STRUCT) {
+		kfree(i);
+		return -EINVAL;
+	}
+	tmp = i;
+	i = krealloc(i, sizeof(*i) + i->cr_root_len + i->cr_pwd_len + 2, GFP_KERNEL);
+	if (!i) {
+		kfree(tmp);
+		return -ENOMEM;
+	}
+
+	cr_root = (char *)(i + 1);
+	rv = cr_pread(ctx, cr_root, i->cr_root_len, pos + sizeof(*i));
+	if (rv < 0) {
+		kfree(i);
+		return rv;
+	}
+	cr_root[i->cr_root_len] = '\0';
+
+	cr_pwd = cr_root + i->cr_root_len + 1;
+	rv = cr_pread(ctx, cr_pwd, i->cr_pwd_len, pos + sizeof(*i) + i->cr_root_len);
+	if (rv < 0) {
+		kfree(i);
+		return rv;
+	}
+	cr_pwd[i->cr_pwd_len] = '\0';
+
+	fs = kmem_cache_zalloc(fs_cachep, GFP_KERNEL);
+	if (!fs) {
+		kfree(i);
+		return -ENOMEM;
+	}
+	fs->users = 1;
+	fs->in_exec = 0;
+	rwlock_init(&fs->lock);
+
+	fs->umask = i->cr_umask;
+
+	obj = cr_object_create(fs);
+	if (!obj) {
+		kmem_cache_free(fs_cachep, fs);
+		kfree(i);
+		return -ENOMEM;
+	}
+	obj->o_pos = pos;
+	list_add(&obj->o_list, &ctx->cr_obj[CR_CTX_FS_STRUCT]);
+	printk("restore fs_struct %p, pos = %lld: umask %03o, root '%s', pwd '%s'\n", fs, (long long)pos, fs->umask, cr_root, cr_pwd);
+	kfree(i);
+	return 0;
+}
--- a/kernel/cr/cr-task.c
+++ b/kernel/cr/cr-task.c
@@ -127,6 +127,8 @@ static int cr_dump_task_struct(struct cr_context *ctx, struct cr_object *obj)
 		i->cr_pos_pids[2] = tmp->o_pos;
 	else
 		i->cr_pos_pids[2] = CR_POS_UNDEF;
+	tmp = cr_find_obj_by_ptr(ctx, tsk->fs, CR_CTX_FS_STRUCT);
+	i->cr_pos_fs = tmp->o_pos;
 	tmp = cr_find_obj_by_ptr(ctx, tsk->files, CR_CTX_FILES_STRUCT);
 	i->cr_pos_files = tmp->o_pos;
 
--- a/kernel/cr/cr.h
+++ b/kernel/cr/cr.h
@@ -24,6 +24,7 @@ struct cr_object {
 enum cr_context_obj_type {
 	CR_CTX_FILE,
 	CR_CTX_FILES_STRUCT,
+	CR_CTX_FS_STRUCT,
 	CR_CTX_MM_STRUCT,
 	CR_CTX_NSPROXY,
 	CR_CTX_PID,
@@ -73,6 +74,7 @@ static inline void __user *cr_restore_ptr(__u64 ptr)
 
 int cr_collect_all_files_struct(struct cr_context *ctx);
 int cr_collect_all_file(struct cr_context *ctx);
+int cr_collect_all_fs_struct(struct cr_context *ctx);
 int cr_collect_all_mm_struct(struct cr_context *ctx);
 int cr_collect_all_nsproxy(struct cr_context *ctx);
 int cr_collect_all_pid_ns(struct cr_context *ctx);
@@ -82,6 +84,7 @@ int cr_collect_all_uts_ns(struct cr_context *ctx);
 
 int cr_dump_all_files_struct(struct cr_context *ctx);
 int cr_dump_all_file(struct cr_context *ctx);
+int cr_dump_all_fs_struct(struct cr_context *ctx);
 int cr_dump_all_mm_struct(struct cr_context *ctx);
 int cr_dump_all_nsproxy(struct cr_context *ctx);
 int cr_dump_all_pid_ns(struct cr_context *ctx);
@@ -91,6 +94,7 @@ int cr_dump_all_uts_ns(struct cr_context *ctx);
 
 int cr_restore_files_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_file(struct cr_context *ctx, loff_t pos);
+int cr_restore_fs_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_mm_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_nsproxy(struct cr_context *ctx, loff_t pos);
 int cr_restore_pid_ns(struct cr_context *ctx, loff_t pos);
