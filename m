Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZKLXqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZKLXqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZKLXqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:46:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZKLXqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:46:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 13/16] blkio: Provide some isolation between groups
Date: Thu, 12 Nov 2009 18:32:33 -0500
Message-Id: <1258068756-10766-14-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Do not allow following three operations across groups for isolation.
	- selection of co-operating queues
	- preemtpions across groups
	- request merging across groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 24640f1..6081efe 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1432,6 +1432,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	/* Deny merge if bio and rq don't belong to same cfq group */
+	if ((RQ_CFQQ(rq))->cfqg != cfq_get_cfqg(cfqd, 0))
+		return false;
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
@@ -1677,6 +1680,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfqq)
 		return NULL;
 
+	/* If new queue belongs to different cfq_group, don't choose it */
+	if (cur_cfqq->cfqg != cfqq->cfqg)
+		return NULL;
+
 	/*
 	 * It only makes sense to merge sync queues.
 	 */
@@ -2945,6 +2952,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
+	if (new_cfqq->cfqg != cfqq->cfqg)
+		return false;
+
 	if (cfq_slice_used(cfqq))
 		return true;
 
-- 
1.6.2.5

