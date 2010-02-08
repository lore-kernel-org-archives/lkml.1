Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0BHJyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:54:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0BHJyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:54:05 -0500
Date: Mon, 8 Feb 2010 04:52:02 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Miles Lane <miles.lane@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, akpm@linux-foundation.org
Message-Id: <20100208095530.3612.7843.sendpatchset@localhost.localdomain>
In-Reply-To: <20100208095518.3612.73574.sendpatchset@localhost.localdomain>
References: <20100208095518.3612.73574.sendpatchset@localhost.localdomain>
Subject: [Patch 2/2] block: add sysfs lockdep class for iosched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Similar to the previous PM case, in iosched, we hold an s_active
lock to store "scheduler", meanwhile we want to remove "iosched/*"
files.

This patch depends on the previous one. I tested it on my machine,
it fixes the problem.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>

---
 block/blk-sysfs.c     |  120 +++++++++++++++----------------------------------
 include/linux/sysfs.h |    1 +
 2 files changed, 38 insertions(+), 83 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8606c95..f863d4d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -6,6 +6,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/sysfs.h>
 
 #include "blk.h"
 
@@ -254,105 +255,58 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	return ret;
 }
 
-static struct queue_sysfs_entry queue_requests_entry = {
-	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_requests_show,
-	.store = queue_requests_store,
-};
-
-static struct queue_sysfs_entry queue_ra_entry = {
-	.attr = {.name = "read_ahead_kb", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_ra_show,
-	.store = queue_ra_store,
-};
+#define queue_sysfs_rw_attr(_name, _filename)			\
+static struct queue_sysfs_entry _name##_entry = {		\
+	.attr = {						\
+		.name = _filename,				\
+		.mode = S_IRUGO | S_IWUSR,			\
+		.class = SYSFS_ATTR_IOSCHED,			\
+	},							\
+	.show = _name##_show,					\
+	.store = _name##_store,					\
+}
 
-static struct queue_sysfs_entry queue_max_sectors_entry = {
-	.attr = {.name = "max_sectors_kb", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_max_sectors_show,
-	.store = queue_max_sectors_store,
-};
+#define queue_sysfs_ro_attr(_name, _filename)			\
+static struct queue_sysfs_entry _name##_entry = {		\
+	.attr = {						\
+		.name = _filename,				\
+		.mode = S_IRUGO,				\
+		.class = SYSFS_ATTR_IOSCHED,			\
+	},							\
+	.show = _name##_show,					\
+}
 
-static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
-	.attr = {.name = "max_hw_sectors_kb", .mode = S_IRUGO },
-	.show = queue_max_hw_sectors_show,
-};
 
-static struct queue_sysfs_entry queue_iosched_entry = {
-	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
-	.show = elv_iosched_show,
-	.store = elv_iosched_store,
-};
+queue_sysfs_rw_attr(queue_requests, "nr_requests");
+queue_sysfs_rw_attr(queue_ra, "read_ahead_kb");
+queue_sysfs_rw_attr(queue_max_sectors, "max_sectors_kb");
+queue_sysfs_ro_attr(queue_max_hw_sectors, "max_hw_sectors_kb");
+queue_sysfs_rw_attr(elv_iosched, "scheduler");
+queue_sysfs_ro_attr(queue_logical_block_size, "logical_block_size");
 
 static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.attr = {.name = "hw_sector_size", .mode = S_IRUGO },
 	.show = queue_logical_block_size_show,
 };
 
-static struct queue_sysfs_entry queue_logical_block_size_entry = {
-	.attr = {.name = "logical_block_size", .mode = S_IRUGO },
-	.show = queue_logical_block_size_show,
-};
-
-static struct queue_sysfs_entry queue_physical_block_size_entry = {
-	.attr = {.name = "physical_block_size", .mode = S_IRUGO },
-	.show = queue_physical_block_size_show,
-};
+queue_sysfs_ro_attr(queue_physical_block_size, "physical_block_size");
+queue_sysfs_ro_attr(queue_io_min, "minimum_io_size");
+queue_sysfs_ro_attr(queue_io_opt, "optimal_io_size");
+queue_sysfs_ro_attr(queue_discard_granularity, "discard_granularity");
+queue_sysfs_ro_attr(queue_discard_max, "discard_max_bytes");
+queue_sysfs_ro_attr(queue_discard_zeroes_data, "discard_zeroes_data");
 
-static struct queue_sysfs_entry queue_io_min_entry = {
-	.attr = {.name = "minimum_io_size", .mode = S_IRUGO },
-	.show = queue_io_min_show,
-};
-
-static struct queue_sysfs_entry queue_io_opt_entry = {
-	.attr = {.name = "optimal_io_size", .mode = S_IRUGO },
-	.show = queue_io_opt_show,
-};
-
-static struct queue_sysfs_entry queue_discard_granularity_entry = {
-	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
-	.show = queue_discard_granularity_show,
-};
-
-static struct queue_sysfs_entry queue_discard_max_entry = {
-	.attr = {.name = "discard_max_bytes", .mode = S_IRUGO },
-	.show = queue_discard_max_show,
-};
-
-static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
-	.attr = {.name = "discard_zeroes_data", .mode = S_IRUGO },
-	.show = queue_discard_zeroes_data_show,
-};
-
-static struct queue_sysfs_entry queue_nonrot_entry = {
-	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_nonrot_show,
-	.store = queue_nonrot_store,
-};
-
-static struct queue_sysfs_entry queue_nomerges_entry = {
-	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_nomerges_show,
-	.store = queue_nomerges_store,
-};
-
-static struct queue_sysfs_entry queue_rq_affinity_entry = {
-	.attr = {.name = "rq_affinity", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_rq_affinity_show,
-	.store = queue_rq_affinity_store,
-};
-
-static struct queue_sysfs_entry queue_iostats_entry = {
-	.attr = {.name = "iostats", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_iostats_show,
-	.store = queue_iostats_store,
-};
+queue_sysfs_rw_attr(queue_nonrot, "rotational");
+queue_sysfs_rw_attr(queue_nomerges, "nomerges");
+queue_sysfs_rw_attr(queue_rq_affinity, "rq_affinity");
+queue_sysfs_rw_attr(queue_iostats, "iostats");
 
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
-	&queue_iosched_entry.attr,
+	&elv_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
 	&queue_physical_block_size_entry.attr,
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2b91b74..3a91008 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -23,6 +23,7 @@ struct module;
 enum sysfs_attr_lock_class {
 	SYSFS_ATTR_NORMAL,
 	SYSFS_ATTR_PM_CONTROL,
+	SYSFS_ATTR_IOSCHED,
 	SYSFS_NR_CLASSES,
 };
 
-- 
1.5.5.6

