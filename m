Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZK3DCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZK3DCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZK3DBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZK3DAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 20/21] blkio: Wait on sync-noidle queue even if rq_noidle = 1
Date: Sun, 29 Nov 2009 21:59:27 -0500
Message-Id: <1259549968-10369-21-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o rq_noidle() is supposed to tell cfq that do not expect a request after this
  one, hence don't idle. But this does not seem to work very well. For example
  for direct random readers, rq_noidle = 1 but there is next request coming
  after this. Not idling, leads to a group not getting its share even if
  group_isolation=1.

o The right solution for this issue is to scan the higher layers and set
  right flag (WRITE_SYNC or WRITE_ODIRECT). For the time being, this single
  line fix helps. This should not have any significant impact when we are
  not using cgroups. I will later figure out IO paths in higher layer and
  fix it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e87f0d1..8b528de 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3316,7 +3316,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			 * only if we processed at least one !rq_noidle request
 			 */
 			if (cfqd->serving_type == SYNC_WORKLOAD
-			    || cfqd->noidle_tree_requires_idle)
+			    || cfqd->noidle_tree_requires_idle
+			    || cfqq->cfqg->nr_cfqq == 1)
 				cfq_arm_slice_timer(cfqd);
 		}
 	}
-- 
1.6.2.5

