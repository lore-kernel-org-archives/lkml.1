Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbZEHJqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbZEHJqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZEHJqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:46:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbZEHJqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:46:21 -0400
Message-ID: <4A03FF3C.4020506@cn.fujitsu.com>
Date: Fri, 08 May 2009 17:45:32 +0800
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
Subject: [PATCH] io-controller: Add io group reference handling for request
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

This patch adds io group reference handling when allocating
and removing a request.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 elevator-fq.c |   15 ++++++++++++++-
 elevator-fq.h |    5 +++++
 elevator.c    |    2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 9500619..e6d6712 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1968,11 +1968,24 @@ void elv_fq_set_request_io_group(struct request_queue *q, struct request *rq,
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	BUG_ON(!iog);
 
-	/* Store iog in rq. TODO: take care of referencing */
+	elv_get_iog(iog);
 	rq->iog = iog;
 }
 
 /*
+ * This request has been serviced. Clean up iog info and drop the reference.
+ */
+void elv_fq_unset_request_io_group(struct request *rq)
+{
+	struct io_group *iog = rq->iog;
+
+	if (iog) {
+		rq->iog = NULL;
+		elv_put_iog(iog);
+	}
+}
+
+/*
  * Find/Create the io queue the rq should go in. This is an optimization
  * for the io schedulers (noop, deadline and AS) which maintain only single
  * io queue per cgroup. In this case common layer can just maintain a
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index db3a347..96a28e9 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -512,6 +512,7 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
 extern int io_group_allow_merge(struct request *rq, struct bio *bio);
 extern void elv_fq_set_request_io_group(struct request_queue *q,
 					struct request *rq, struct bio *bio);
+extern void elv_fq_unset_request_io_group(struct request *rq);
 static inline bfq_weight_t iog_weight(struct io_group *iog)
 {
 	return iog->entity.weight;
@@ -571,6 +572,10 @@ static inline void elv_fq_set_request_io_group(struct request_queue *q,
 {
 }
 
+static inline void elv_fq_unset_request_io_group(struct request *rq)
+{
+}
+
 static inline bfq_weight_t iog_weight(struct io_group *iog)
 {
 	/* Just root group is present and weight is immaterial. */
diff --git a/block/elevator.c b/block/elevator.c
index 44c9fad..d75eec7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -992,6 +992,8 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	elv_fq_unset_request_io_group(rq);
+
 	/*
 	 * Optimization for noop, deadline and AS which maintain only single
 	 * ioq per io group


