Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZLBPwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZLBPwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZLBPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:52:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZLBPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:52:14 -0500
Date: Wed, 2 Dec 2009 10:50:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, czoccolo@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 07/21] blkio: Introduce per cfq group weights and
	vdisktime calculations
Message-ID: <20091202155027.GG31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <1259549968-10369-8-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259549968-10369-8-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:59:14PM -0500, Vivek Goyal wrote:
> o Bring in the per cfq group weight and how vdisktime is calculated for the
>   group. Also bring in the functionality of updating the min_vdisktime of
>   the group service tree.
> 

Reposting this patch to make use of newly introduced rb_entry_cfqg().


o Bring in the per cfq group weight and how vdisktime is calculated for the
  group. Also bring in the functionality of updating the min_vdisktime of
  the group service tree.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    9 ++++++-
 block/cfq-iosched.c   |   62 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 2 deletions(-)

Index: linux10/block/cfq-iosched.c
===================================================================
--- linux10.orig/block/cfq-iosched.c	2009-12-02 10:47:17.000000000 -0500
+++ linux10/block/cfq-iosched.c	2009-12-02 10:47:53.000000000 -0500
@@ -13,6 +13,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include "blk-cgroup.h"
 
 /*
  * tunables
@@ -49,6 +50,7 @@ static const int cfq_hist_divisor = 4;
 
 #define CFQ_SLICE_SCALE		(5)
 #define CFQ_HW_QUEUE_MIN	(5)
+#define CFQ_SERVICE_SHIFT       12
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
@@ -79,6 +81,7 @@ struct cfq_rb_root {
 	struct rb_node *left;
 	unsigned count;
 	u64 min_vdisktime;
+	struct rb_node *active;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
 
@@ -163,6 +166,7 @@ struct cfq_group {
 
 	/* group service_tree key */
 	u64 vdisktime;
+	unsigned int weight;
 	bool on_st;
 
 	/* number of cfqq currently on this group */
@@ -434,6 +438,51 @@ cfq_prio_to_slice(struct cfq_data *cfqd,
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
+static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+{
+	u64 d = delta << CFQ_SERVICE_SHIFT;
+
+	d = d * BLKIO_WEIGHT_DEFAULT;
+	do_div(d, cfqg->weight);
+	return d;
+}
+
+static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta > 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta < 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static void update_min_vdisktime(struct cfq_rb_root *st)
+{
+	u64 vdisktime = st->min_vdisktime;
+	struct cfq_group *cfqg;
+
+	if (st->active) {
+		cfqg = rb_entry_cfqg(st->active);
+		vdisktime = cfqg->vdisktime;
+	}
+
+	if (st->left) {
+		cfqg = rb_entry_cfqg(st->left);
+		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
+	}
+
+	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+}
+
 /*
  * get averaged number of queues of RT/BE priority.
  * average is updated, with a formula that gives more weight to higher numbers,
@@ -739,8 +788,12 @@ cfq_group_service_tree_del(struct cfq_da
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
+	if (st->active == &cfqg->rb_node)
+		st->active = NULL;
+
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
+
 	/* If there are other cfq queues under this group, don't delete it */
 	if (cfqg->nr_cfqq)
 		return;
@@ -1659,10 +1712,14 @@ static void choose_service_tree(struct c
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_group *cfqg;
 
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	return cfq_rb_first_group(st);
+	cfqg = cfq_rb_first_group(st);
+	st->active = &cfqg->rb_node;
+	update_min_vdisktime(st);
+	return cfqg;
 }
 
 static void cfq_choose_cfqg(struct cfq_data *cfqd)
@@ -3155,6 +3212,9 @@ static void *cfq_init_queue(struct reque
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	/* Give preference to root group over other groups */
+	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
 	 * zeroed cfqd on alloc), but better be safe in case someone decides
Index: linux10/block/Kconfig.iosched
===================================================================
--- linux10.orig/block/Kconfig.iosched	2009-12-02 10:47:22.000000000 -0500
+++ linux10/block/Kconfig.iosched	2009-12-02 10:47:24.000000000 -0500
@@ -23,7 +23,6 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
-	select BLK_CGROUP
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
@@ -33,6 +32,14 @@ config IOSCHED_CFQ
 
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
