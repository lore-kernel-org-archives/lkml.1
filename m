Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbYDCHSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbYDCHSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbYDCHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:18:28 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34491 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760527AbYDCHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:18:26 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Satoshi UCHIDA'" <s-uchida@ap.jp.nec.com>,
       "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>		<008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
Subject: [RFC][patch 12/12][CFQ-cgroup] entry/remove active cfq_data
Date: Thu, 3 Apr 2008 16:18:10 +0900
Message-Id: <006901c8955a$df18d140$9d4a73c0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwARhoqAAAB5fuA=
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch controls whether cfq_data is active or not.
When cfq_data is not active and active cfq_queue is inserted into cfq_data,
cfq_data is activated.
When cfq_data is active and active cfq_queue is not exist,
cfq_data is deactivated.

The new cfq optional operations:
The "cfq_add_cfqq_opt_fn" defines a function that runs an additional process
when active queue is inserted into cfq_data.

The "cfq_del_cfqq_opt_fn" defines a function that runs an additional process
when active queue is removed in cfq_data.

      Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

---
 block/cfq-cgroup.c          |   28 ++++++++++++++++++++++++++++
 block/cfq-iosched.c         |    6 ++++++
 include/linux/cfq-iosched.h |    4 ++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index 27a9a7a..f868f4f 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -741,6 +741,32 @@ static int cfq_cgroup_active_data_check(struct cfq_data *cfqd)
 	return (cfqd->cfqmd->active_data == cfqd);
 }
 
+static void cfq_cgroup_add_cfqd_rr(struct cfq_data *cfqd)
+{
+	if (!cfq_cfqd_on_rr(cfqd)) {
+		cfq_mark_cfqd_on_rr(cfqd);
+		cfqd->cfqmd->busy_data++;
+
+		cfq_cgroup_service_tree_add(cfqd, 0);
+	}
+}
+
+
+static void cfq_cgroup_del_cfqd_rr(struct cfq_data *cfqd)
+{
+	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
+		struct cfq_meta_data *cfqdd = cfqd->cfqmd;
+		BUG_ON(!cfq_cfqd_on_rr(cfqd));
+		cfq_clear_cfqd_on_rr(cfqd);
+		if (!RB_EMPTY_NODE(&cfqd->rb_node)) {
+			cfq_rb_erase(&cfqd->rb_node,
+				     &cfqdd->service_tree);
+		}
+		BUG_ON(!cfqdd->busy_data);
+		cfqdd->busy_data--;
+	}	
+}
+
 struct cfq_ops opt = {
 	.cfq_init_queue_fn = __cfq_cgroup_init_queue,
 	.cfq_exit_queue_fn = __cfq_cgroup_exit_data,
@@ -749,4 +775,6 @@ struct cfq_ops opt = {
 	.cfq_completed_request_after_fn = cfq_cgroup_completed_request_after,
 	.cfq_empty_fn = cfq_cgroup_queue_empty,
 	.cfq_active_check_fn = cfq_cgroup_active_data_check,
+	.cfq_add_cfqq_opt_fn =  cfq_cgroup_add_cfqd_rr,
+	.cfq_del_cfqq_opt_fn =  cfq_cgroup_del_cfqd_rr,
 };
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 505e425..8f5227f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -492,6 +492,9 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfqd->busy_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
+
+	if (opt.cfq_add_cfqq_opt_fn)
+		opt.cfq_add_cfqq_opt_fn(cfqd);
 }
 
 /*
@@ -508,6 +511,9 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+
+	if (opt.cfq_del_cfqq_opt_fn)
+		opt.cfq_del_cfqq_opt_fn(cfqd);
 }
 
 /*
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
index 63d2545..ed35050 100644
--- a/include/linux/cfq-iosched.h
+++ b/include/linux/cfq-iosched.h
@@ -161,6 +161,8 @@ typedef int (cfq_dispatch_requests_fn)(struct cfq_data *, int);
 typedef int (cfq_completed_request_after_fn)(struct cfq_data *);
 typedef int (cfq_active_check_fn)(struct cfq_data *);
 typedef int (cfq_empty_fn)(struct cfq_data *);
+typedef void (cfq_add_cfqq_opt_fn)(struct cfq_data *);
+typedef void (cfq_del_cfqq_opt_fn)(struct cfq_data *);
 
 struct cfq_ops
 {
@@ -171,6 +173,8 @@ struct cfq_ops
 	cfq_completed_request_after_fn *cfq_completed_request_after_fn;
 	cfq_active_check_fn *cfq_active_check_fn;
 	cfq_empty_fn *cfq_empty_fn;
+	cfq_add_cfqq_opt_fn *cfq_add_cfqq_opt_fn;
+	cfq_del_cfqq_opt_fn *cfq_del_cfqq_opt_fn;
 };
 
 extern struct cfq_ops opt;
-- 
1.5.4.1


