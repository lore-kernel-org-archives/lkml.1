Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbYKLIdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbYKLIdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYKLIdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:33:40 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44897 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYKLIdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:33:39 -0500
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
Subject: [PATCH][cfq-cgroups][01/12] Move basic strcture variable to header file.
Date: Wed, 12 Nov 2008 17:23:30 +0900
Message-ID: <000e01c9449f$f2160cf0$d64226d0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAP8Lw
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 The "cfq_data" structure and few definition are moved into header file.


    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>

---
 block/cfq-iosched.c         |   68 +-------------------------------------
 include/linux/cfq-iosched.h |   77 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 67 deletions(-)
 create mode 100644 include/linux/cfq-iosched.h

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..024d392 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -12,6 +12,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include <linux/cfq-iosched.h>
 
 /*
  * tunables
@@ -62,73 +63,6 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 #define sample_valid(samples)	((samples) > 80)
 
 /*
- * Most of our rbtree usage is for sorting with min extraction, so
- * if we cache the leftmost node we don't have to walk down the tree
- * to find it. Idea borrowed from Ingo Molnars CFS scheduler. We should
- * move this into the elevator for the rq sorting as well.
- */
-struct cfq_rb_root {
-	struct rb_root rb;
-	struct rb_node *left;
-};
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
-
-/*
- * Per block device queue structure
- */
-struct cfq_data {
-	struct request_queue *queue;
-
-	/*
-	 * rr list of queues with requests and the count of them
-	 */
-	struct cfq_rb_root service_tree;
-	unsigned int busy_queues;
-
-	int rq_in_driver;
-	int sync_flight;
-
-	/*
-	 * queue-depth detection
-	 */
-	int rq_queued;
-	int hw_tag;
-	int hw_tag_samples;
-	int rq_in_driver_peak;
-
-	/*
-	 * idle window management
-	 */
-	struct timer_list idle_slice_timer;
-	struct work_struct unplug_work;
-
-	struct cfq_queue *active_queue;
-	struct cfq_io_context *active_cic;
-
-	/*
-	 * async queue for each priority case
-	 */
-	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
-	struct cfq_queue *async_idle_cfqq;
-
-	sector_t last_position;
-	unsigned long last_end_request;
-
-	/*
-	 * tunables, see top of file
-	 */
-	unsigned int cfq_quantum;
-	unsigned int cfq_fifo_expire[2];
-	unsigned int cfq_back_penalty;
-	unsigned int cfq_back_max;
-	unsigned int cfq_slice[2];
-	unsigned int cfq_slice_async_rq;
-	unsigned int cfq_slice_idle;
-
-	struct list_head cic_list;
-};
-
-/*
  * Per process-grouping structure
  */
 struct cfq_queue {
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
new file mode 100644
index 0000000..adb2410
--- /dev/null
+++ b/include/linux/cfq-iosched.h
@@ -0,0 +1,77 @@
+#ifndef _LINUX_CFQ_IOSCHED_H
+#define _LINUX_CFQ_IOSCHED_H
+
+#include <linux/rbtree.h>
+#include <linux/list.h>
+
+struct request_queue;
+struct cfq_io_context;
+
+/*
+ * Most of our rbtree usage is for sorting with min extraction, so
+ * if we cache the leftmost node we don't have to walk down the tree
+ * to find it. Idea borrowed from Ingo Molnars CFS scheduler. We should
+ * move this into the elevator for the rq sorting as well.
+ */
+struct cfq_rb_root {
+	struct rb_root rb;
+	struct rb_node *left;
+};
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
+
+/*
+ * Per block device queue structure
+ */
+struct cfq_data {
+	struct request_queue *queue;
+
+	/*
+	 * rr list of queues with requests and the count of them
+	 */
+	struct cfq_rb_root service_tree;
+	unsigned int busy_queues;
+
+	int rq_in_driver;
+	int sync_flight;
+
+	/*
+	 * queue-depth detection
+	 */
+	int rq_queued;
+	int hw_tag;
+	int hw_tag_samples;
+	int rq_in_driver_peak;
+
+	/*
+	 * idle window management
+	 */
+	struct timer_list idle_slice_timer;
+	struct work_struct unplug_work;
+
+	struct cfq_queue *active_queue;
+	struct cfq_io_context *active_cic;
+
+	/*
+	 * async queue for each priority case
+	 */
+	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
+	struct cfq_queue *async_idle_cfqq;
+
+	sector_t last_position;
+	unsigned long last_end_request;
+
+	/*
+	 * tunables, see top of file
+	 */
+	unsigned int cfq_quantum;
+	unsigned int cfq_fifo_expire[2];
+	unsigned int cfq_back_penalty;
+	unsigned int cfq_back_max;
+	unsigned int cfq_slice[2];
+	unsigned int cfq_slice_async_rq;
+	unsigned int cfq_slice_idle;
+
+	struct list_head cic_list;
+};
+
+#endif  /* _LINUX_CFQ_IOSCHED_H */
-- 
1.5.6.5


