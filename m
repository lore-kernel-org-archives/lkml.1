Return-Path: <linux-kernel-owner+w=401wt.eu-S1763123AbZLPWzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763123AbZLPWzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbZLPWzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:55:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbZLPWzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:55:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 1/4] cfq-iosced: Remove the check for same cfq group from allow_merge
Date: Wed, 16 Dec 2009 17:52:57 -0500
Message-Id: <1261003980-10115-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o allow_merge() already checks if submitting task is pointing to same cfqq
  as rq has been queued in. If everything is fine, we should not be having
  a task in one cgroup and having a pointer to cfqq in other cgroup.

  Well I guess in some situations it can happen and that is, when a random
  IO queue has been moved into root cgroup for group_isolation=0. In
  this case, tasks's cgroup/group is different from where actually cfqq is,
  but this is intentional and in this case merging should be allowed.

  The second situation is where due to close cooperator patches, multiple
  processes can be sharing a cfqq. If everything implemented right, we should
  not end up in a situation where tasks from different processes in different
  groups are sharing the same cfqq as we allow merging of cooperating queues
  only if they are in same group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2f8046..a0e5347 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1513,9 +1513,6 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
-	/* Deny merge if bio and rq don't belong to same cfq group */
-	if ((RQ_CFQQ(rq))->cfqg != cfq_get_cfqg(cfqd, 0))
-		return false;
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
-- 
1.6.2.5

