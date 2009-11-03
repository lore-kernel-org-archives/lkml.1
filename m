Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZKCXrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZKCXrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZKCXrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:47:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZKCXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 06/20] blkio: Introduce cgroup interface
Date: Tue,  3 Nov 2009 18:43:43 -0500
Message-Id: <1257291837-6246-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This is basic blkio controller cgroup interface. This is the common interface
  which will be used by applications to control IO as it flows through IO stack.

o There are some places where it is assumed that only one policy implemented
  by CFQ is there hence things have been hardcoded. Once we have one more
  policy implmented, we need to introduce some dynamic infrastructure like
  registration of policy and get rid of hardcoded calls.

o Some parts of this code have been taken from BFQ patches.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig                 |   13 +++
 block/Kconfig.iosched         |    8 ++
 block/Makefile                |    1 +
 block/blk-cgroup.c            |  199 +++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h            |   38 ++++++++
 block/cfq-iosched.c           |   15 ++--
 include/linux/cgroup_subsys.h |    6 ++
 include/linux/iocontext.h     |    4 +
 8 files changed, 277 insertions(+), 7 deletions(-)
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
index 7e803fc..a521c69 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -40,6 +40,14 @@ config IOSCHED_CFQ
 	  working environment, suitable for desktop systems.
 	  This is the default I/O scheduler.
 
+config CFQ_GROUP_IOSCHED
+	bool "CFQ Group Scheduling support"
+	depends on IOSCHED_CFQ && CGROUPS
+	select BLK_CGROUP
+	default n
+	---help---
+	  Enable group IO scheduling in CFQ.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/Makefile b/block/Makefile
index ba74ca6..16334c9 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-iopoll.o ioctl.o genhd.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
+obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
new file mode 100644
index 0000000..7bde5c4
--- /dev/null
+++ b/block/blk-cgroup.c
@@ -0,0 +1,199 @@
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
+struct blkio_cgroup blkio_root_cgroup = {
+	.weight = BLKIO_WEIGHT_DEFAULT,
+	.ioprio_class = IOPRIO_CLASS_BE,
+};
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
+SHOW_FUNCTION(ioprio_class);
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
+static int blkiocg_ioprio_class_write(struct cgroup *cgroup,
+					struct cftype *cftype, u64 val)
+{
+	struct blkio_cgroup *blkcg;
+
+	if (val < IOPRIO_CLASS_RT || val > IOPRIO_CLASS_IDLE)
+		return -EINVAL;
+
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	blkcg->ioprio_class = (unsigned int)val;
+	return 0;
+}
+
+struct cftype blkio_files[] = {
+	{
+		.name = "weight",
+		.read_u64 = blkiocg_weight_read,
+		.write_u64 = blkiocg_weight_write,
+	},
+	{
+		.name = "ioprio_class",
+		.read_u64 = blkiocg_ioprio_class_read,
+		.write_u64 = blkiocg_ioprio_class_write,
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
+done:
+	spin_lock_init(&blkcg->lock);
+	INIT_HLIST_HEAD(&blkcg->blkg_list);
+	blkcg->weight = BLKIO_WEIGHT_DEFAULT;
+	blkcg->ioprio_class = IOPRIO_CLASS_BE;
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
index 0000000..49ca84b
--- /dev/null
+++ b/block/blk-cgroup.h
@@ -0,0 +1,38 @@
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
+	unsigned short ioprio_class;
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
+struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
+void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
+				struct blkio_group *blkg, void *key);
+int blkiocg_del_blkio_group(struct blkio_group *blkg);
+struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 323ed12..bc99163 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -12,6 +12,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include "blk-cgroup.h"
 
 /*
  * tunables
@@ -29,9 +30,6 @@ static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 
 #define IO_IOPRIO_CLASSES	3
-#define CFQ_WEIGHT_MIN		100
-#define CFQ_WEIGHT_MAX		1000
-#define CFQ_WEIGHT_DEFAULT	500
 #define CFQ_SERVICE_SHIFT       12
 
 /*
@@ -139,6 +137,9 @@ struct cfq_queue {
 /* Per cgroup grouping structure */
 struct cfq_group {
 	struct cfq_sched_data sched_data;
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	struct blkio_group blkg;
+#endif
 };
 
 /*
@@ -296,7 +297,7 @@ cfq_delta_fair(unsigned long delta, struct cfq_entity *cfqe)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
-	return cfq_delta(d, CFQ_WEIGHT_DEFAULT, cfqe->weight);
+	return cfq_delta(d, BLKIO_WEIGHT_DEFAULT, cfqe->weight);
 }
 
 static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
@@ -338,7 +339,7 @@ static inline unsigned int cfq_ioprio_to_weight(int ioprio)
 {
 	WARN_ON(ioprio < 0 || ioprio >= IOPRIO_BE_NR);
 	/* Map prio 7 - 0 to weights 200 to 900 */
-	return CFQ_WEIGHT_DEFAULT + (CFQ_WEIGHT_DEFAULT/5 * (4 - ioprio));
+	return BLKIO_WEIGHT_DEFAULT + (BLKIO_WEIGHT_DEFAULT/5 * (4 - ioprio));
 }
 
 static inline int
@@ -346,9 +347,9 @@ cfq_weight_slice(struct cfq_data *cfqd, int sync, unsigned int weight)
 {
 	const int base_slice = cfqd->cfq_slice[sync];
 
-	WARN_ON(weight > CFQ_WEIGHT_MAX);
+	WARN_ON(weight > BLKIO_WEIGHT_MAX);
 
-	return cfq_delta(base_slice, weight, CFQ_WEIGHT_DEFAULT);
+	return cfq_delta(base_slice, weight, BLKIO_WEIGHT_DEFAULT);
 }
 
 static inline int rq_in_driver(struct cfq_data *cfqd)
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
index 4da4a75..5357d5c 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -73,6 +73,10 @@ struct io_context {
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

