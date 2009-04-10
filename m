Return-Path: <linux-kernel-owner+w=401wt.eu-S938018AbZDJCsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938018AbZDJCsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbZDJClF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:41:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:40971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935976AbZDJClD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tj7rNdCMbkzRgNlt9trcJaeKDEKT74LG6tVSk/rILm/wgXYS3cCSoUKKJ12a7Fo6ud
         AA+YkaU6gvIwFzlL/lg2X64LNE4dJSEF0g0D3ccLz0CHz9nPTTT+HJCyCCPLMukzI48S
         veLiz70iCZgk6zb2zwYTX9+rg32xd6dLKi9lc=
Date: Fri, 10 Apr 2009 06:41:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/30] cr: ipc_ns
Message-ID: <20090410024106.GE27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create/restore ipc_ns as an object, restore sysctl values.

FIXME: restoration of sysctls is buggy as-is, values should be written
	at the very last moment
FIXME: actual restoration of IPC objects.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/cr.h     |   14 +++++
 kernel/cr/Kconfig      |    1 
 kernel/cr/Makefile     |    1 
 kernel/cr/cpt-sys.c    |    6 ++
 kernel/cr/cr-ipc.c     |  132 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/cr/cr-nsproxy.c |    6 ++
 kernel/cr/cr.h         |   27 ++++++++++
 7 files changed, 187 insertions(+)

--- a/include/linux/cr.h
+++ b/include/linux/cr.h
@@ -52,6 +52,7 @@ struct cr_object_header {
 #define CR_OBJ_NET_NS		21
 #define CR_OBJ_SOCK		22
 #define CR_OBJ_TTY		23
+#define CR_OBJ_IPC_NS		24
 	__u32	cr_type;	/* object type */
 	__u32	cr_len;		/* object length in bytes including header */
 } __packed;
@@ -180,6 +181,7 @@ struct cr_image_nsproxy {
 	struct cr_object_header cr_hdr;
 
 	cr_pos_t	cr_pos_uts_ns;
+	cr_pos_t	cr_pos_ipc_ns;	/* CR_POS_UNDEF if CONFIG_SYSVIPC=n */
 	cr_pos_t	cr_pos_mnt_ns;
 	cr_pos_t	cr_pos_pid_ns;
 	cr_pos_t	cr_pos_net_ns;	/* CR_POS_UNDEF if CONFIG_NET=n */
@@ -418,4 +420,16 @@ struct cr_image_tty {
 	__u8		cr_low_latency;
 	__u8		cr_ctrl_status;
 } __packed;
+
+struct cr_image_ipc_ns {
+	struct cr_object_header cr_hdr;
+
+	__u32		cr_sem_ctls[4];
+	__u32		cr_msg_ctlmax;
+	__u32		cr_msg_ctlmnb;
+	__u32		cr_msg_ctlmni;
+	__u64		cr_shm_ctlmax;
+	__u64		cr_shm_ctlall;
+	__u32		cr_shm_ctlmni;
+} __packed;
 #endif
--- a/kernel/cr/Kconfig
+++ b/kernel/cr/Kconfig
@@ -1,6 +1,7 @@
 config CR
 	bool "Container checkpoint/restart"
 	depends on DEVPTS_MULTIPLE_INSTANCES
+	depends on IPC_NS || (SYSVIPC = n)
 	depends on NET_NS || (NET = n)
 	depends on PID_NS
 	depends on USER_NS
--- a/kernel/cr/Makefile
+++ b/kernel/cr/Makefile
@@ -4,6 +4,7 @@ cr-y += cr-context.o
 cr-y += cr-cred.o
 cr-y += cr-file.o
 cr-y += cr-fs.o
+cr-y += cr-ipc.o
 cr-y += cr-mm.o
 cr-y += cr-mnt.o
 cr-$(CONFIG_NET) += cr-net.o
--- a/kernel/cr/cpt-sys.c
+++ b/kernel/cr/cpt-sys.c
@@ -71,6 +71,9 @@ static int cr_collect(struct cr_context *ctx)
 	rv = cr_collect_all_uts_ns(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_collect_all_ipc_ns(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_collect_all_mnt_ns(ctx);
 	if (rv < 0)
 		return rv;
@@ -194,6 +197,9 @@ static int cr_dump(struct cr_context *ctx)
 	rv = cr_dump_all_sock(ctx);
 	if (rv < 0)
 		return rv;
+	rv = cr_dump_all_ipc_ns(ctx);
+	if (rv < 0)
+		return rv;
 	rv = cr_dump_all_sighand_struct(ctx);
 	if (rv < 0)
 		return rv;
new file mode 100644
--- /dev/null
+++ b/kernel/cr/cr-ipc.c
@@ -0,0 +1,132 @@
+/* Copyright (C) 2000-2009 Parallels Holdings, Ltd. */
+#include <linux/fs.h>
+#include <linux/ipc_namespace.h>
+#include <linux/nsproxy.h>
+
+#include <linux/cr.h>
+#include "cr.h"
+
+static int cr_collect_ipc_ns(struct cr_context *ctx, struct ipc_namespace *ipc_ns)
+{
+	int rv;
+
+	rv = cr_collect_object(ctx, ipc_ns, CR_CTX_IPC_NS);
+	printk("collect ipc_ns %p: rv %d\n", ipc_ns, rv);
+	return rv;
+}
+
+int cr_collect_all_ipc_ns(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_NSPROXY) {
+		struct nsproxy *nsproxy = obj->o_obj;
+
+		rv = cr_collect_ipc_ns(ctx, nsproxy->ipc_ns);
+		if (rv < 0)
+			return rv;
+	}
+	for_each_cr_object(ctx, obj, CR_CTX_IPC_NS) {
+		struct ipc_namespace *ipc_ns = obj->o_obj;
+		unsigned int cnt = atomic_read(&ipc_ns->count);
+
+		if (obj->o_count != cnt) {
+			printk("%s: ipc_ns %p has external references %lu:%u\n", __func__, ipc_ns, obj->o_count, cnt);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int cr_dump_ipc_ns(struct cr_context *ctx, struct cr_object *obj)
+{
+	struct ipc_namespace *ipc_ns = obj->o_obj;
+	struct cr_image_ipc_ns *i;
+	int rv;
+
+	printk("dump ipc_ns %p\n", ipc_ns);
+
+	i = cr_prepare_image(CR_OBJ_IPC_NS, sizeof(*i));
+	if (!i)
+		return -ENOMEM;
+
+	BUILD_BUG_ON(ARRAY_SIZE(ipc_ns->sem_ctls) != 4);
+	i->cr_sem_ctls[0] = ipc_ns->sem_ctls[0];
+	i->cr_sem_ctls[1] = ipc_ns->sem_ctls[1];
+	i->cr_sem_ctls[2] = ipc_ns->sem_ctls[2];
+	i->cr_sem_ctls[3] = ipc_ns->sem_ctls[3];
+	i->cr_msg_ctlmax = ipc_ns->msg_ctlmax;
+	i->cr_msg_ctlmnb = ipc_ns->msg_ctlmnb;
+	i->cr_msg_ctlmni = ipc_ns->msg_ctlmni;
+	i->cr_shm_ctlmax = ipc_ns->shm_ctlmax;
+	i->cr_shm_ctlall = ipc_ns->shm_ctlall;
+	i->cr_shm_ctlmni = ipc_ns->shm_ctlmni;
+
+	obj->o_pos = ctx->cr_dump_file->f_pos;
+	rv = cr_write(ctx, i, sizeof(*i));
+	kfree(i);
+	return rv;
+}
+
+int cr_dump_all_ipc_ns(struct cr_context *ctx)
+{
+	struct cr_object *obj;
+	int rv;
+
+	for_each_cr_object(ctx, obj, CR_CTX_IPC_NS) {
+		rv = cr_dump_ipc_ns(ctx, obj);
+		if (rv < 0)
+			return rv;
+	}
+	return 0;
+}
+
+int cr_restore_ipc_ns(struct cr_context *ctx, loff_t pos)
+{
+	struct cr_image_ipc_ns *i;
+	struct ipc_namespace *ipc_ns;
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
+	if (i->cr_hdr.cr_type != CR_OBJ_IPC_NS) {
+		kfree(i);
+		return -EINVAL;
+	}
+
+	ipc_ns = create_ipc_ns();
+	if (!ipc_ns) {
+		kfree(i);
+		return -ENOMEM;
+	}
+
+	ipc_ns->sem_ctls[0] = i->cr_sem_ctls[0];
+	ipc_ns->sem_ctls[1] = i->cr_sem_ctls[1];
+	ipc_ns->sem_ctls[2] = i->cr_sem_ctls[2];
+	ipc_ns->sem_ctls[3] = i->cr_sem_ctls[3];
+	ipc_ns->msg_ctlmax = i->cr_msg_ctlmax;
+	ipc_ns->msg_ctlmnb = i->cr_msg_ctlmnb;
+	ipc_ns->msg_ctlmni = i->cr_msg_ctlmni;
+	ipc_ns->shm_ctlmax = i->cr_shm_ctlmax;
+	ipc_ns->shm_ctlall = i->cr_shm_ctlall;
+	ipc_ns->shm_ctlmni = i->cr_shm_ctlmni;
+	kfree(i);
+
+	obj = cr_object_create(ipc_ns);
+	if (!obj) {
+		put_ipc_ns(ipc_ns);
+		return -ENOMEM;
+	}
+	obj->o_pos = pos;
+	list_add(&obj->o_list, &ctx->cr_obj[CR_CTX_IPC_NS]);
+	printk("restore ipc_ns %p, pos %lld\n", ipc_ns, (long long)pos);
+	return 0;
+}
--- a/kernel/cr/cr-nsproxy.c
+++ b/kernel/cr/cr-nsproxy.c
@@ -59,6 +59,12 @@ static int cr_dump_nsproxy(struct cr_context *ctx, struct cr_object *obj)
 
 	tmp = cr_find_obj_by_ptr(ctx, nsproxy->uts_ns, CR_CTX_UTS_NS);
 	i->cr_pos_uts_ns = tmp->o_pos;
+#ifdef CONFIG_SYSVIPC
+	tmp = cr_find_obj_by_ptr(ctx, nsproxy->ipc_ns, CR_CTX_IPC_NS);
+	i->cr_pos_ipc_ns = tmp->o_pos;
+#else
+	i->cr_pos = CR_POS_UNDEF;
+#endif
 	tmp = cr_find_obj_by_ptr(ctx, nsproxy->mnt_ns, CR_CTX_MNT_NS);
 	i->cr_pos_mnt_ns = tmp->o_pos;
 	tmp = cr_find_obj_by_ptr(ctx, nsproxy->pid_ns, CR_CTX_PID_NS);
--- a/kernel/cr/cr.h
+++ b/kernel/cr/cr.h
@@ -28,6 +28,9 @@ enum cr_context_obj_type {
 	CR_CTX_FILES_STRUCT,
 	CR_CTX_FS_STRUCT,
 	CR_CTX_GROUP_INFO,
+#ifdef CONFIG_SYSVIPC
+	CR_CTX_IPC_NS,
+#endif
 	CR_CTX_MM_STRUCT,
 	CR_CTX_MNT_NS,
 #ifdef CONFIG_NET
@@ -103,6 +106,14 @@ int cr_collect_all_files_struct(struct cr_context *ctx);
 int cr_collect_all_file(struct cr_context *ctx);
 int cr_collect_all_fs_struct(struct cr_context *ctx);
 int cr_collect_all_group_info(struct cr_context *ctx);
+#ifdef CONFIG_SYSVIPC
+int cr_collect_all_ipc_ns(struct cr_context *ctx);
+#else
+static inline int cr_collect_all_ipc_ns(struct cr_context *ctx)
+{
+	return 0;
+}
+#endif
 int cr_collect_all_mm_struct(struct cr_context *ctx);
 int cr_collect_all_mnt_ns(struct cr_context *ctx);
 #ifdef CONFIG_NET
@@ -137,6 +148,14 @@ int cr_dump_all_files_struct(struct cr_context *ctx);
 int cr_dump_all_file(struct cr_context *ctx);
 int cr_dump_all_fs_struct(struct cr_context *ctx);
 int cr_dump_all_group_info(struct cr_context *ctx);
+#ifdef CONFIG_SYSVIPC
+int cr_dump_all_ipc_ns(struct cr_context *ctx);
+#else
+static inline int cr_dump_all_ipc_ns(struct cr_context *ctx)
+{
+	return 0;
+}
+#endif
 int cr_dump_all_mm_struct(struct cr_context *ctx);
 int cr_dump_all_mnt_ns(struct cr_context *ctx);
 #ifdef CONFIG_NET
@@ -171,6 +190,14 @@ int cr_restore_files_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_file(struct cr_context *ctx, loff_t pos);
 int cr_restore_fs_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_group_info(struct cr_context *ctx, loff_t pos);
+#ifdef CONFIG_SYSVIPC
+int cr_restore_ipc_ns(struct cr_context *ctx, loff_t pos);
+#else
+static inline int cr_restore_ipc_ns(struct cr_context *ctx, loff_t pos)
+{
+	return 0;
+}
+#endif
 int cr_restore_mm_struct(struct cr_context *ctx, loff_t pos);
 int cr_restore_mnt_ns(struct cr_context *ctx, loff_t pos);
 #ifdef CONFIG_NET
