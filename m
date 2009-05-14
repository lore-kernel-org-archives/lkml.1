Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbZENBwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbZENBwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZENBwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:52:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbZENBwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:52:09 -0400
Message-ID: <4A0B7911.6080005@cn.fujitsu.com>
Date: Thu, 14 May 2009 09:51:13 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513155900.GA15623@redhat.com>
In-Reply-To: <20090513155900.GA15623@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> 
> Hi Gui,
> 
> It might make sense to also store the device name or device major and
> minor number in io_group while creating the io group. This will help us
> to display io.disk_time and io.disk_sector statistics per device instead
> of aggregate.
> 
> I am attaching a patch I was playing around with to display per device
> statistics instead of aggregate one. So if user has specified the per
> device rule.
> 
> Thanks
> Vivek
> 
> 
> o Currently the statistics exported through cgroup are aggregate of statistics
>   on all devices for that cgroup. Instead of aggregate, make these per device.

Hi Vivek,

Actually, I did it also.
FYI

Examples:
# cat io.disk_time
dev:/dev/hdb time:4421
dev:others time:3741

# cat io.disk_sectors
dev:/dev/hdb sectors:585696
dev:others sectors:2664

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |  104 +++++++++++++++++++++++---------------------------
 1 files changed, 48 insertions(+), 56 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 7c95d55..1620074 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1162,90 +1162,82 @@ STORE_FUNCTION(weight, 0, WEIGHT_MAX);
 STORE_FUNCTION(ioprio_class, IOPRIO_CLASS_RT, IOPRIO_CLASS_IDLE);
 #undef STORE_FUNCTION
 
-/*
- * traverse through all the io_groups associated with this cgroup and calculate
- * the aggr disk time received by all the groups on respective disks.
- */
-static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
+static int io_cgroup_disk_time_read(struct cgroup *cgroup,
+				    struct cftype *cftype,
+				    struct seq_file *m)
 {
+	struct io_cgroup *iocg;
 	struct io_group *iog;
 	struct hlist_node *n;
-	u64 disk_time = 0;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
-		/*
-		 * There might be groups which are not functional and
-		 * waiting to be reclaimed upon cgoup deletion.
-		 */
-		if (rcu_dereference(iog->key))
-			disk_time += iog->entity.total_service;
-	}
-	rcu_read_unlock();
-
-	return disk_time;
-}
+	struct policy_node *pn;
+	unsigned int other, time;
 
-static u64 io_cgroup_disk_time_read(struct cgroup *cgroup,
-					struct cftype *cftype)
-{
-	struct io_cgroup *iocg;
-	u64 ret;
+	other = 0;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
 
 	iocg = cgroup_to_io_cgroup(cgroup);
 	spin_lock_irq(&iocg->lock);
-	ret = jiffies_to_msecs(calculate_aggr_disk_time(iocg));
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		if (iog->key != NULL) {
+			pn = policy_search_node(iocg, iog->key);
+			if (pn) {
+				time = jiffies_to_msecs(iog->entity.
+							total_service);
+				seq_printf(m, "dev:%s time:%u\n",
+					   pn->dev_name, time);
+			} else {
+				other += jiffies_to_msecs(iog->entity.
+							  total_service);
+			}
+		}
+	}
+	seq_printf(m, "dev:others time:%u\n", other);
+
 	spin_unlock_irq(&iocg->lock);
 
 	cgroup_unlock();
 
-	return ret;
+	return 0;
 }
 
-/*
- * traverse through all the io_groups associated with this cgroup and calculate
- * the aggr number of sectors transferred by all the groups on respective disks.
- */
-static u64 calculate_aggr_disk_sectors(struct io_cgroup *iocg)
+static int io_cgroup_disk_sectors_read(struct cgroup *cgroup,
+				       struct cftype *cftype,
+				       struct seq_file *m)
 {
+	struct io_cgroup *iocg;
 	struct io_group *iog;
 	struct hlist_node *n;
-	u64 disk_sectors = 0;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
-		/*
-		 * There might be groups which are not functional and
-		 * waiting to be reclaimed upon cgoup deletion.
-		 */
-		if (rcu_dereference(iog->key))
-			disk_sectors += iog->entity.total_sector_service;
-	}
-	rcu_read_unlock();
+	struct policy_node *pn;
+	u64 other = 0;
 
-	return disk_sectors;
-}
-
-static u64 io_cgroup_disk_sectors_read(struct cgroup *cgroup,
-					struct cftype *cftype)
-{
-	struct io_cgroup *iocg;
-	u64 ret;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
 
 	iocg = cgroup_to_io_cgroup(cgroup);
 	spin_lock_irq(&iocg->lock);
-	ret = calculate_aggr_disk_sectors(iocg);
+	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
+		if (iog->key) {
+			pn = policy_search_node(iocg, iog->key);
+			if (pn) {
+				seq_printf(m, "dev:%s sectors:%lu\n",
+					   pn->dev_name,
+					   iog->entity.total_sector_service);
+			} else {
+				other += iog->entity.total_sector_service;
+			}
+		}
+	}
+
+	seq_printf(m, "dev:others sectors:%llu\n", other);
+
 	spin_unlock_irq(&iocg->lock);
 
 	cgroup_unlock();
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -1783,11 +1775,11 @@ struct cftype bfqio_files[] = {
 	},
 	{
 		.name = "disk_time",
-		.read_u64 = io_cgroup_disk_time_read,
+		.read_seq_string = io_cgroup_disk_time_read,
 	},
 	{
 		.name = "disk_sectors",
-		.read_u64 = io_cgroup_disk_sectors_read,
+		.read_seq_string = io_cgroup_disk_sectors_read,
 	},
 };
 
-- 
1.5.4.rc3


