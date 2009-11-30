Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZK3DBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZK3DBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZK3DBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZK3DAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 16/21] blkio: Propagate cgroup weight updation to cfq groups
Date: Sun, 29 Nov 2009 21:59:23 -0500
Message-Id: <1259549968-10369-17-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Propagate blkio cgroup weight updation to associated cfq groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |    7 +++++++
 block/cfq-iosched.c |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4ef78d3..179ddfa 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -16,6 +16,7 @@
 #include "blk-cgroup.h"
 
 extern void cfq_unlink_blkio_group(void *, struct blkio_group *);
+extern void cfq_update_blkio_group_weight(struct blkio_group *, unsigned int);
 
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 
@@ -116,12 +117,18 @@ static int
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
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d076d01..a9fea9e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -924,6 +924,12 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
+void
+cfq_update_blkio_group_weight(struct blkio_group *blkg, unsigned int weight)
+{
+	cfqg_of_blkg(blkg)->weight = weight;
+}
+
 static struct cfq_group *
 cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 {
-- 
1.6.2.5

