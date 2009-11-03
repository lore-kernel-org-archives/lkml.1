Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZKCXqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZKCXqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZKCXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:46:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZKCXox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 09/20] blkio: Porpogate blkio cgroup weight or ioprio class updation to cfq groups
Date: Tue,  3 Nov 2009 18:43:46 -0500
Message-Id: <1257291837-6246-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o If a user decides the change the weight or ioprio class of a cgroup, this
  information needs to be passed on to io controlling policy module also so
  that new information can take effect.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |   16 ++++++++++++++++
 block/cfq-iosched.c |   18 ++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7bde5c4..0d52a2c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -13,6 +13,10 @@
 #include <linux/ioprio.h>
 #include "blk-cgroup.h"
 
+extern void cfq_update_blkio_group_weight(struct blkio_group *, unsigned int);
+extern void cfq_update_blkio_group_ioprio_class(struct blkio_group *,
+		unsigned short);
+
 struct blkio_cgroup blkio_root_cgroup = {
 	.weight = BLKIO_WEIGHT_DEFAULT,
 	.ioprio_class = IOPRIO_CLASS_BE,
@@ -75,12 +79,18 @@ static int
 blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 {
 	struct blkio_cgroup *blkcg;
+	struct blkio_group *blkg;
+	struct hlist_node *n;
 
 	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
 		return -EINVAL;
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	spin_lock_irq(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+		cfq_update_blkio_group_weight(blkg, blkcg->weight);
+	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
 
@@ -88,12 +98,18 @@ static int blkiocg_ioprio_class_write(struct cgroup *cgroup,
 					struct cftype *cftype, u64 val)
 {
 	struct blkio_cgroup *blkcg;
+	struct blkio_group *blkg;
+	struct hlist_node *n;
 
 	if (val < IOPRIO_CLASS_RT || val > IOPRIO_CLASS_IDLE)
 		return -EINVAL;
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	spin_lock_irq(&blkcg->lock);
 	blkcg->ioprio_class = (unsigned int)val;
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+		cfq_update_blkio_group_weight(blkg, blkcg->weight);
+	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4481917..3c0fa1b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -464,6 +464,24 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 	rcu_read_unlock();
 	return cfqg;
 }
+
+void
+cfq_update_blkio_group_weight(struct blkio_group *blkg, unsigned int weight)
+{
+	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+
+	cfqg->entity.weight = weight;
+}
+
+void cfq_update_blkio_group_ioprio_class(struct blkio_group *blkg,
+					unsigned short ioprio_class)
+{
+	struct cfq_group *cfqg = cfqg_of_blkg(blkg);
+
+	cfqg->entity.ioprio_class = ioprio_class;
+	smp_wmb();
+	cfqg->entity.ioprio_class_changed = 1;
+}
 #else /* CONFIG_CFQ_GROUP_IOSCHED */
 #define for_each_entity(entity)	\
 	for (; entity != NULL; entity = NULL)
-- 
1.6.2.5

