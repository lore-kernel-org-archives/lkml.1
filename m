Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbZKCXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbZKCXoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZKCXoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZKCXoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 15/20] blkio: Take care of preemptions across groups
Date: Tue,  3 Nov 2009 18:43:52 -0500
Message-Id: <1257291837-6246-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Additional preemption checks for groups where we travel up the hierarchy
  and see if one queue should preempt other or not.

o Also prevents preemption across groups in some cases to provide isolation
  between groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 87b1799..98dbead 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2636,6 +2636,36 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
+static bool cfq_should_preempt_group(struct cfq_data *cfqd,
+		struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
+{
+	struct cfq_entity *cfqe = &cfqq->entity;
+	struct cfq_entity *new_cfqe = &new_cfqq->entity;
+
+	if (cfqq_to_cfqg(cfqq) != &cfqd->root_group)
+		cfqe = parent_entity(&cfqq->entity);
+
+	if (cfqq_to_cfqg(new_cfqq) != &cfqd->root_group)
+		new_cfqe = parent_entity(&new_cfqq->entity);
+
+	/*
+	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
+	 */
+
+	if (new_cfqe->ioprio_class == IOPRIO_CLASS_RT
+	    && cfqe->ioprio_class != IOPRIO_CLASS_RT)
+		return true;
+	/*
+	 * Allow an BE request to pre-empt an ongoing IDLE clas timeslice.
+	 */
+
+	if (new_cfqe->ioprio_class == IOPRIO_CLASS_BE
+	    && cfqe->ioprio_class == IOPRIO_CLASS_IDLE)
+		return true;
+
+	return false;
+}
+
 /*
  * Check if new_cfqq should preempt the currently active queue. Return 0 for
  * no or if we aren't sure, a 1 will cause a preempt.
@@ -2666,6 +2696,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
 		return true;
 
+	if (cfqq_to_cfqg(new_cfqq) != cfqq_to_cfqg(cfqq))
+		return cfq_should_preempt_group(cfqd, cfqq, new_cfqq);
+
 	/*
 	 * So both queues are sync. Let the new request get disk time if
 	 * it's a metadata request and the current queue is doing regular IO.
-- 
1.6.2.5

