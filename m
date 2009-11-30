Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZK3DB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZK3DB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZK3DB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZK3DAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 06/21] blkio: Introduce blkio controller cgroup interface
Date: Sun, 29 Nov 2009 21:59:13 -0500
Message-Id: <1259549968-10369-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This is basic implementation of blkio controller cgroup interface. This is
  the common interface visible to user space and should be used by different
  IO control policies as we implement those.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig                 |   13 +++
 block/Kconfig.iosched         |    1 +
 block/Makefile                |    1 +
 block/blk-cgroup.c            |  177 +++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h            |   58 +++++++++++++
 include/linux/cgroup_subsys.h |    6 ++
 include/linux/iocontext.h     |    4 +
 7 files changed, 260 insertions(+), 0 deletions(-)
 create mode 100644 block/blk-cgroup.c
 create mode 100644 block/blk-cgroup.h

diff --git a/block/Kconfig b/block/Kconfig
index 9be0b56..6ba1a8e 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -77,6 +77,19 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_CGROUP
+	bool
+	depends on CGROUPS
+	default n
+	---help---
+	Generic block IO controller cgroup interface. This is the common
+	cgroup interface which should be used by various IO controlling
+	policies.
+
+	Currently, CFQ IO scheduler uses it to recognize task groups and
+	control disk bandwidth allocation (proportional time slice allocation)
+	to such task groups.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 8bd1051..be0280d 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -23,6 +23,7 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
+	select BLK_CGROUP
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
diff --git a/block/Makefile b/block/Makefile
index 7914108..cb2d515 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-iopoll.o ioctl.o genhd.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
+obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
new file mode 100644
index 0000000..4f6afd7
--- /dev/null
+++ b/block/blk-cgroup.c
@@ -0,0 +1,177 @@
+/*
+ * Common Block IO controller cgroup interface
+ *
+ * Based on ideas and code from CFQ, CFS and BFQ:
+ * Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
+ *
+ * Copyright (C) 2008 Fabio Checconi <fabio@gandalf.sssup.it>
+ *		      Paolo Valente <paolo.valente@unimore.it>
+ *
+ * Copyright (C) 2009 Vivek Goyal <vgoyal@redhat.com>
+ * 	              Nauman Rafique <nauman@google.com>
+ */
+#include <linux/ioprio.h>
+#include "blk-cgroup.h"
+
+struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
+
+struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
+{
+	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
+			    struct blkio_cgroup, css);
+}
+
+void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+				struct blkio_group *blkg, void *key)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkcg->lock, flags);
+	rcu_assign_pointer(blkg->key, key);
+	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
+	spin_unlock_irqrestore(&blkcg->lock, flags);
+}
+
+int blkiocg_del_blkio_group(struct blkio_group *blkg)
+{
+	/* Implemented later */
+	return 0;
+}
+
+/* called under rcu_read_lock(). */
+struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
+{
+	struct blkio_group *blkg;
+	struct hlist_node *n;
+	void *__key;
+
+	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		__key = blkg->key;
+		if (__key == key)
+			return blkg;
+	}
+
+	return NULL;
+}
+
+#define SHOW_FUNCTION(__VAR)						\
+static u64 blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
+				       struct cftype *cftype)		\
+{									\
+	struct blkio_cgroup *blkcg;					\
+									\
+	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
+	return (u64)blkcg->__VAR;					\
+}
+
+SHOW_FUNCTION(weight);
+#undef SHOW_FUNCTION
+
+static int
+blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
+{
+	struct blkio_cgroup *blkcg;
+
+	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
+		return -EINVAL;
+
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	blkcg->weight = (unsigned int)val;
+	return 0;
+}
+
+struct cftype blkio_files[] = {
+	{
+		.name = "weight",
+		.read_u64 = blkiocg_weight_read,
+		.write_u64 = blkiocg_weight_write,
+	},
+};
+
+static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	return cgroup_add_files(cgroup, subsys, blkio_files,
+				ARRAY_SIZE(blkio_files));
+}
+
+static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+
+	free_css_id(&blkio_subsys, &blkcg->css);
+	kfree(blkcg);
+}
+
+static struct cgroup_subsys_state *
+blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg, *parent_blkcg;
+
+	if (!cgroup->parent) {
+		blkcg = &blkio_root_cgroup;
+		goto done;
+	}
+
+	/* Currently we do not support hierarchy deeper than two level (0,1) */
+	parent_blkcg = cgroup_to_blkio_cgroup(cgroup->parent);
+	if (css_depth(&parent_blkcg->css) > 0)
+		return ERR_PTR(-EINVAL);
+
+	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
+	if (!blkcg)
+		return ERR_PTR(-ENOMEM);
+
+	blkcg->weight = BLKIO_WEIGHT_DEFAULT;
+done:
+	spin_lock_init(&blkcg->lock);
+	INIT_HLIST_HEAD(&blkcg->blkg_list);
+
+	return &blkcg->css;
+}
+
+/*
+ * We cannot support shared io contexts, as we have no mean to support
+ * two tasks with the same ioc in two different groups without major rework
+ * of the main cic data structures.  For now we allow a task to change
+ * its cgroup only if it's the only owner of its ioc.
+ */
+static int blkiocg_can_attach(struct cgroup_subsys *subsys,
+				struct cgroup *cgroup, struct task_struct *tsk,
+				bool threadgroup)
+{
+	struct io_context *ioc;
+	int ret = 0;
+
+	/* task_lock() is needed to avoid races with exit_io_context() */
+	task_lock(tsk);
+	ioc = tsk->io_context;
+	if (ioc && atomic_read(&ioc->nr_tasks) > 1)
+		ret = -EINVAL;
+	task_unlock(tsk);
+
+	return ret;
+}
+
+static void blkiocg_attach(struct cgroup_subsys *subsys, struct cgroup *cgroup,
+				struct cgroup *prev, struct task_struct *tsk,
+				bool threadgroup)
+{
+	struct io_context *ioc;
+
+	task_lock(tsk);
+	ioc = tsk->io_context;
+	if (ioc)
+		ioc->cgroup_changed = 1;
+	task_unlock(tsk);
+}
+
+struct cgroup_subsys blkio_subsys = {
+	.name = "blkio",
+	.create = blkiocg_create,
+	.can_attach = blkiocg_can_attach,
+	.attach = blkiocg_attach,
+	.destroy = blkiocg_destroy,
+	.populate = blkiocg_populate,
+	.subsys_id = blkio_subsys_id,
+	.use_id = 1,
+};
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
new file mode 100644
index 0000000..ba5703f
--- /dev/null
+++ b/block/blk-cgroup.h
@@ -0,0 +1,58 @@
+#ifndef _BLK_CGROUP_H
+#define _BLK_CGROUP_H
+/*
+ * Common Block IO controller cgroup interface
+ *
+ * Based on ideas and code from CFQ, CFS and BFQ:
+ * Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
+ *
+ * Copyright (C) 2008 Fabio Checconi <fabio@gandalf.sssup.it>
+ *		      Paolo Valente <paolo.valente@unimore.it>
+ *
+ * Copyright (C) 2009 Vivek Goyal <vgoyal@redhat.com>
+ * 	              Nauman Rafique <nauman@google.com>
+ */
+
+#include <linux/cgroup.h>
+
+struct blkio_cgroup {
+	struct cgroup_subsys_state css;
+	unsigned int weight;
+	spinlock_t lock;
+	struct hlist_head blkg_list;
+};
+
+struct blkio_group {
+	/* An rcu protected unique identifier for the group */
+	void *key;
+	struct hlist_node blkcg_node;
+};
+
+#define BLKIO_WEIGHT_MIN	100
+#define BLKIO_WEIGHT_MAX	1000
+#define BLKIO_WEIGHT_DEFAULT	500
+
+#ifdef CONFIG_BLK_CGROUP
+extern struct blkio_cgroup blkio_root_cgroup;
+extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
+extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+				struct blkio_group *blkg, void *key);
+extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
+extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
+						void *key);
+#else
+static inline struct blkio_cgroup *
+cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
+
+static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+			struct blkio_group *blkg, void *key)
+{
+}
+
+static inline int
+blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
+
+static inline struct blkio_group *
+blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
+#endif
+#endif /* _BLK_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 9c8d31b..ccefff0 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -60,3 +60,9 @@ SUBSYS(net_cls)
 #endif
 
 /* */
+
+#ifdef CONFIG_BLK_CGROUP
+SUBSYS(blkio)
+#endif
+
+/* */
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index eb73632..d61b0b8 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -68,6 +68,10 @@ struct io_context {
 	unsigned short ioprio;
 	unsigned short ioprio_changed;
 
+#ifdef CONFIG_BLK_CGROUP
+	unsigned short cgroup_changed;
+#endif
+
 	/*
 	 * For request batching
 	 */
-- 
1.6.2.5

