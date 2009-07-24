Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZGXUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZGXUas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZGXUap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:30:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbZGXUaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:30:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com
Cc: lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       vgoyal@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: [PATCH 10/24] io-controller: Export disk time used and nr sectors dipatched through cgroups
Date: Fri, 24 Jul 2009 16:27:40 -0400
Message-Id: <1248467274-32073-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This patch exports some statistics through cgroup interface. Two of the
  statistics currently exported are actual disk time assigned to the cgroup
  and actual number of sectors dispatched to disk on behalf of this cgroup.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++-
 block/elevator-fq.h |   10 ++++++
 2 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index eddb422..c546962 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -15,6 +15,7 @@
 #include <linux/blkdev.h>
 #include "elevator-fq.h"
 #include <linux/blktrace_api.h>
+#include <linux/seq_file.h>
 
 /* Values taken from cfq */
 const int elv_slice_sync = HZ / 10;
@@ -977,13 +978,16 @@ update:
 	}
 }
 
-static void entity_served(struct io_entity *entity, unsigned long served)
+void entity_served(struct io_entity *entity, unsigned long served,
+					unsigned long nr_sectors)
 {
 	struct io_service_tree *st;
 
 	for_each_entity(entity) {
 		st = io_entity_service_tree(entity);
 		entity->service += served;
+		entity->total_service += served;
+		entity->total_sector_service += nr_sectors;
 		BUG_ON(st->wsum == 0);
 		st->vtime += bfq_delta(served, st->wsum);
 		bfq_forget_idle(st);
@@ -1144,6 +1148,66 @@ STORE_FUNCTION(weight, 1, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
+static int io_cgroup_disk_time_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
+{
+	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct hlist_node *n;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	iocg = cgroup_to_io_cgroup(cgroup);
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_service);
+		}
+	}
+	rcu_read_unlock();
+	cgroup_unlock();
+
+	return 0;
+}
+
+static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
+				struct cftype *cftype, struct seq_file *m)
+{
+	struct io_cgroup *iocg;
+	struct io_group *iog;
+	struct hlist_node *n;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	iocg = cgroup_to_io_cgroup(cgroup);
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		/*
+		 * There might be groups which are not functional and
+		 * waiting to be reclaimed upon cgoup deletion.
+		 */
+		if (iog->key) {
+			seq_printf(m, "%u:%u %lu\n", MAJOR(iog->dev),
+					MINOR(iog->dev),
+					iog->entity.total_sector_service);
+		}
+	}
+	rcu_read_unlock();
+	cgroup_unlock();
+
+	return 0;
+}
+
 struct cftype bfqio_files[] = {
 	{
 		.name = "weight",
@@ -1155,6 +1219,14 @@ struct cftype bfqio_files[] = {
 		.read_u64 = io_cgroup_ioprio_class_read,
 		.write_u64 = io_cgroup_ioprio_class_write,
 	},
+	{
+		.name = "disk_time",
+		.read_seq_string = io_cgroup_disk_time_read,
+	},
+	{
+		.name = "disk_sectors",
+		.read_seq_string = io_cgroup_disk_sectors_read,
+	},
 };
 
 static int iocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
@@ -1256,6 +1328,8 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 	struct io_cgroup *iocg;
 	struct io_group *iog, *leaf = NULL, *prev = NULL;
 	gfp_t flags = GFP_ATOMIC |  __GFP_ZERO;
+	unsigned int major, minor;
+	struct backing_dev_info *bdi = &q->backing_dev_info;
 
 	for (; cgroup != NULL; cgroup = cgroup->parent) {
 		iocg = cgroup_to_io_cgroup(cgroup);
@@ -1276,6 +1350,9 @@ io_group_chain_alloc(struct request_queue *q, void *key, struct cgroup *cgroup)
 
 		iog->iocg_id = css_id(&iocg->css);
 
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		iog->dev = MKDEV(major, minor);
+
 		io_group_init_entity(iocg, iog);
 		iog->my_entity = &iog->entity;
 
@@ -1869,7 +1946,7 @@ EXPORT_SYMBOL(elv_del_idle_slice_timer);
 
 static void elv_ioq_served(struct io_queue *ioq, unsigned long served)
 {
-	entity_served(&ioq->entity, served);
+	entity_served(&ioq->entity, served, ioq->nr_sectors);
 }
 
 /*
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index ceae511..b7f9f82 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -147,6 +147,13 @@ struct io_entity {
 	unsigned short ioprio_class, new_ioprio_class;
 
 	int ioprio_changed;
+
+	/*
+	 * Keep track of total service received by this entity. Keep the
+	 * stats both for time slices and number of sectors dispatched
+	 */
+	unsigned long total_service;
+	unsigned long total_sector_service;
 };
 
 /*
@@ -233,6 +240,9 @@ struct io_group {
 	struct rcu_head rcu_head;
 	int deleting;
 	unsigned short iocg_id;
+
+	/* The device MKDEV(major, minor), this group has been created for */
+	dev_t	dev;
 };
 
 /**
-- 
1.6.0.6

