Return-Path: <linux-kernel-owner+w=401wt.eu-S1761182AbYDCHMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbYDCHMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbYDCHMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:12:40 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39674 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYDCHMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:12:39 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Satoshi UCHIDA'" <s-uchida@ap.jp.nec.com>,
       "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>		<008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
Subject: [RFC][patch 2/11][CFQ-cgroup] Move header file
Date: Thu, 3 Apr 2008 16:12:27 +0900
Message-Id: <005f01c8955a$13144570$393cd050$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwARhoqAAABE0pA=
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some data structure into header file
(include/linux/cfq-iosched.h).

      Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

---
 block/cfq-iosched.c         |   60 +------------------------------------
 include/linux/cfq-iosched.h |   70 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 59 deletions(-)
 create mode 100644 include/linux/cfq-iosched.h

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0f962ec..c1f9da9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -11,6 +11,7 @@
 #include <linux/elevator.h>
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
+#include <linux/cfq-iosched.h>
 
 /*
  * tunables
@@ -58,65 +59,6 @@ static struct completion *ioc_gone;
 
 #define sample_valid(samples)	((samples) > 80)
 
-/*
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
-	int hw_tag;
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
 
 /*
  * Per process-grouping structure
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
new file mode 100644
index 0000000..cce3993
--- /dev/null
+++ b/include/linux/cfq-iosched.h
@@ -0,0 +1,70 @@
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
+	int hw_tag;
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
1.5.4.1


