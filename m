Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYKLIgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYKLIgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYKLIf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:35:57 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45541 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYKLIfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:35:55 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'SUGAWARA Tomoyoshi'" <tom-sugawara@ap.jp.nec.com>,
       <menage@google.com>, <balbir@linux.vnet.ibm.com>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
In-Reply-To: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
Subject: [PATCH][cfq-cgroups][06/12] Add siblings tree control for driver data(cfq_driver_data).
Date: Wed, 12 Nov 2008 17:27:40 +0900
Message-ID: <001301c944a0$869ef3f0$93dcdbd0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAanQw
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch adds a tree control for siblings of driver data(cfq_driver_data).
  This tree controls cfq data(cfq_data) for same device, and is used mainly 
  when a new device is registered or a existed device is unregistered.


    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>

---
 block/cfq-cgroup.c          |  114 +++++++++++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c         |   50 +++++++++++++++---
 include/linux/cfq-iosched.h |   27 ++++++++++
 3 files changed, 182 insertions(+), 9 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index 733980d..ce35af2 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -17,6 +17,7 @@
 
 #define CFQ_CGROUP_MAX_IOPRIO		(7)
 
+static struct cfq_ops cfq_cgroup_op;
 
 struct cfq_cgroup {
 	struct cgroup_subsys_state css;
@@ -36,6 +37,70 @@ static inline struct cfq_cgroup *task_to_cfq_cgroup(struct task_struct *tsk)
 }
 
 
+/*
+ * Add device or cgroup data functions.
+ */
+static void cfq_cgroup_init_driver_data_opt(struct cfq_driver_data *cfqdd,
+					      struct cfq_data *cfqd)
+{
+	cfqdd->sibling_tree = RB_ROOT;
+	cfqdd->siblings = 0;
+}
+
+static void cfq_driver_sibling_tree_add(struct cfq_driver_data *cfqdd,
+					     struct cfq_data *cfqd)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+
+	BUG_ON(!RB_EMPTY_NODE(&cfqd->sib_node));
+
+	p = &cfqdd->sibling_tree.rb_node;
+
+	while (*p) {
+		struct cfq_data *__cfqd;
+		struct rb_node **n;
+
+		parent = *p;
+		__cfqd = rb_entry(parent, struct cfq_data, sib_node);
+
+		if (cfqd < __cfqd)
+			n = &(*p)->rb_left;
+		else
+			n = &(*p)->rb_right;
+		p = n;
+	}
+
+	rb_link_node(&cfqd->sib_node, parent, p);
+	rb_insert_color(&cfqd->sib_node, &cfqdd->sibling_tree);
+	cfqdd->siblings++;
+	cfqd->cfqdd = cfqdd;
+}
+
+static struct cfq_data *
+__cfq_cgroup_init_queue(struct request_queue *q, struct cfq_driver_data *cfqdd)
+{
+	struct cfq_data *cfqd = cfq_init_cfq_data(q, cfqdd, &cfq_cgroup_op);
+
+	if (!cfqd)
+		return NULL;
+
+	RB_CLEAR_NODE(&cfqd->sib_node);
+
+	cfq_driver_sibling_tree_add(cfqd->cfqdd, cfqd);
+
+	return cfqd;
+}
+
+static void *cfq_cgroup_init_queue(struct request_queue *q)
+{
+	struct cfq_data *cfqd = NULL;
+
+	cfqd = __cfq_cgroup_init_queue(q, NULL);
+
+	return cfqd;
+}
+
 static struct cgroup_subsys_state *
 cfq_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -56,11 +121,53 @@ cfq_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	return &cfqc->css;
 }
 
+
+/*
+ * Remove device or cgroup data functions.
+ */
+static void cfq_cgroup_erase_driver_siblings(struct cfq_driver_data *cfqdd,
+						 struct cfq_data *cfqd)
+{
+	rb_erase(&cfqd->sib_node, &cfqdd->sibling_tree);
+	cfqdd->siblings--;
+}
+
+static void cfq_exit_device_group(struct cfq_driver_data *cfqdd)
+{
+	struct rb_node *p, *n;
+	struct cfq_data *cfqd;
+
+	p =  rb_first(&cfqdd->sibling_tree);
+
+	while (p) {
+		n = rb_next(p);
+		cfqd = rb_entry(p, struct cfq_data, sib_node);
+
+		cfq_cgroup_erase_driver_siblings(cfqdd, cfqd);
+		cfq_free_cfq_data(cfqd);
+
+		p = n;
+	}
+}
+
+static void cfq_cgroup_exit_queue(elevator_t *e)
+{
+	struct cfq_data *cfqd = e->elevator_data;
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+
+	cfq_exit_device_group(cfqdd);
+	kfree(cfqdd);
+}
+
 static void cfq_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	kfree(cgroup_to_cfq_cgroup(cont));
 }
 
+
+/*
+ * cgroupfs parts below -->
+ */
 static ssize_t cfq_cgroup_read(struct cgroup *cont, struct cftype *cft,
 			       struct file *file, char __user *userbuf,
 			       size_t nbytes, loff_t *ppos)
@@ -154,6 +261,7 @@ static int cfq_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
 }
 
+
 struct cgroup_subsys cfq_subsys = {
 	.name = "cfq",
 	.create = cfq_cgroup_create,
@@ -280,9 +388,15 @@ static struct elevator_type iosched_cfq_cgroup = {
 	.elevator_owner	= THIS_MODULE,
 };
 
+static struct cfq_ops cfq_cgroup_op = {
+	.cfq_init_driver_data_opt_fn	= cfq_cgroup_init_driver_data_opt,
+};
+
 static int __init cfq_cgroup_init(void)
 {
 	iosched_cfq_cgroup.ops = iosched_cfq.ops;
+	iosched_cfq_cgroup.ops.elevator_init_fn = cfq_cgroup_init_queue;
+	iosched_cfq_cgroup.ops.elevator_exit_fn = cfq_cgroup_exit_queue;
 
 	elv_register(&iosched_cfq_cgroup);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e105827..fd1ed0c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -62,6 +62,8 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 
 #define sample_valid(samples)	((samples) > 80)
 
+static struct cfq_ops cfq_op;
+
 /*
  * Per process-grouping structure
  */
@@ -2133,9 +2135,8 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
 		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
-static void cfq_exit_queue(elevator_t *e)
+void cfq_free_cfq_data(struct cfq_data *cfqd)
 {
-	struct cfq_data *cfqd = e->elevator_data;
 	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
 	struct request_queue *q = cfqdd->queue;
 
@@ -2160,12 +2161,21 @@ static void cfq_exit_queue(elevator_t *e)
 
 	cfq_shutdown_timer_wq(cfqdd);
 
-	kfree(cfqdd);
 	kfree(cfqd);
 }
 
+static void cfq_exit_queue(elevator_t *e)
+{
+	struct cfq_data *cfqd = e->elevator_data;
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+
+	cfq_free_cfq_data(cfqd);
+	kfree(cfqdd);
+}
+
 static struct cfq_driver_data *
-cfq_init_driver_data(struct request_queue *q, struct cfq_data *cfqd)
+cfq_init_driver_data(struct request_queue *q, struct cfq_data *cfqd,
+			struct cfq_ops *op)
 {
 	struct cfq_driver_data *cfqdd;
 
@@ -2186,10 +2196,16 @@ cfq_init_driver_data(struct request_queue *q, struct cfq_data *cfqd)
 
 	cfqdd->hw_tag = 1;
 
+	/* module dependend initialization */
+	cfqdd->op = op;
+	if (op->cfq_init_driver_data_opt_fn)
+		op->cfq_init_driver_data_opt_fn(cfqdd, cfqd);
+
 	return cfqdd;
 }
 
-static void *cfq_init_queue(struct request_queue *q)
+struct cfq_data *cfq_init_cfq_data(struct request_queue *q,
+			struct cfq_driver_data *cfqdd, struct cfq_ops *op)
 {
 	struct cfq_data *cfqd;
 
@@ -2197,10 +2213,14 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (!cfqd)
 		return NULL;
 
-	cfqd->cfqdd = cfq_init_driver_data(q, cfqd);
-	if (!cfqd->cfqdd) {
-		kfree(cfqd);
-		return NULL;
+	if (cfqdd)
+		cfqd->cfqdd = cfqdd;
+	else {
+		cfqd->cfqdd = cfq_init_driver_data(q, cfqd, op);
+		if (!cfqd->cfqdd) {
+			kfree(cfqd);
+			return NULL;
+		}
 	}
 
 	cfqd->service_tree = CFQ_RB_ROOT;
@@ -2219,6 +2239,15 @@ static void *cfq_init_queue(struct request_queue *q)
 	return cfqd;
 }
 
+static void *cfq_init_queue(struct request_queue *q)
+{
+	struct cfq_data *cfqd = NULL;
+
+	cfqd = cfq_init_cfq_data(q, NULL, &cfq_op);
+
+	return cfqd;
+}
+
 static void cfq_slab_kill(void)
 {
 	/*
@@ -2358,6 +2387,9 @@ struct elevator_type iosched_cfq = {
 	.elevator_owner =	THIS_MODULE,
 };
 
+static struct cfq_ops cfq_op = {
+};
+
 static int __init cfq_init(void)
 {
 	/*
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
index a28ef00..22d1aed 100644
--- a/include/linux/cfq-iosched.h
+++ b/include/linux/cfq-iosched.h
@@ -6,6 +6,7 @@
 
 struct request_queue;
 struct cfq_io_context;
+struct cfq_ops;
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -46,6 +47,14 @@ struct cfq_driver_data {
 
 	sector_t last_position;
 	unsigned long last_end_request;
+
+	struct cfq_ops *op;
+
+#ifdef CONFIG_IOSCHED_CFQ_CGROUP
+	/* device siblings */
+	struct rb_root sibling_tree;
+	unsigned int siblings;
+#endif
 };
 
 /*
@@ -80,8 +89,26 @@ struct cfq_data {
 	struct list_head cic_list;
 
 	struct cfq_driver_data *cfqdd;
+
+#ifdef CONFIG_IOSCHED_CFQ_CGROUP
+	/* sibling_tree member for cfq_meta_data */
+	struct rb_node sib_node;
+#endif
+};
+
+/*
+ * Module depended optional operations.
+ */
+typedef void (cfq_init_driver_data_opt_fn)(struct cfq_driver_data *,
+						struct cfq_data *);
+struct cfq_ops {
+	cfq_init_driver_data_opt_fn *cfq_init_driver_data_opt_fn;
 };
 
+
 extern struct elevator_type iosched_cfq;
+extern struct cfq_data *cfq_init_cfq_data(struct request_queue *,
+				struct cfq_driver_data *, struct cfq_ops *);
+extern void cfq_free_cfq_data(struct cfq_data *cfqd);
 
 #endif  /* _LINUX_CFQ_IOSCHED_H */
-- 
1.5.6.5


