Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZKMRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZKMRnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZKMRng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:43:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZKMRk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:40:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 12/16] blkio: Provide some isolation between groups
Date: Fri, 13 Nov 2009 12:40:11 -0500
Message-Id: <1258134015-21632-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
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
index 4e1c673..21121ce 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1449,6 +1449,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	/* Deny merge if bio and rq don't belong to same cfq group */
+	if ((RQ_CFQQ(rq))->cfqg != cfq_get_cfqg(cfqd, 0))
+		return false;
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
@@ -1694,6 +1697,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfqq)
 		return NULL;
 
+	/* If new queue belongs to different cfq_group, don't choose it */
+	if (cur_cfqq->cfqg != cfqq->cfqg)
+		return NULL;
+
 	/*
 	 * It only makes sense to merge sync queues.
 	 */
@@ -2962,6 +2969,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
+	if (new_cfqq->cfqg != cfqq->cfqg)
+		return false;
+
 	if (cfq_slice_used(cfqq))
 		return true;
 
-- 
1.6.2.5

