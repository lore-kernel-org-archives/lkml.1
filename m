Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZIUTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZIUTgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZIUTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:36:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZIUTgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:36:20 -0400
Date: Mon, 21 Sep 2009 21:35:47 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: mingo@elte.hu, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
cc: tglx@linutronix.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ib-release-locks-in-the-proper-order
Message-ID: <alpine.LFD.2.00.0909212127191.7919@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider the following patch - originally from Steven Rostedt. 
It solves a problem for rt which is very sensitive to the lock ordering. 
It should have a no impact on non-rt.

The patch applies to current tip/master - but it is fine with me if it 
would be more appropriate for one of the infiniband people to take it.

Thanks

>From e533f2b9ee9b0bd95aaa4c3369e79b350c9895d3 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Mon, 21 Sep 2009 21:23:46 +0200
Subject: [PATCH] ib: release locks in the proper order

RT is very sensitive to the order locks are taken and released
wrt read write locks. We must do

  lock(a);
  lock(b);
  lock(c);

  [...]

  unlock(c);
  unlock(b);
  unlock(a);

otherwise bad things can happen.

Signed-off-by: Ken Cox <jkc@redhat.com>
Signed-off-by: Clark Williams <williams@redhat.com>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/infiniband/core/uverbs_cmd.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 56feab6..5ea66e1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1116,12 +1116,12 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-	put_cq_read(scq);
-	if (rcq != scq)
-		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (rcq != scq)
+		put_cq_read(rcq);
+	put_cq_read(scq);
+	put_pd_read(pd);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1140,14 +1140,14 @@ err_destroy:
 	ib_destroy_qp(qp);
 
 err_put:
-	if (pd)
-		put_pd_read(pd);
-	if (scq)
-		put_cq_read(scq);
-	if (rcq && rcq != scq)
-		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (rcq && rcq != scq)
+		put_cq_read(rcq);
+	if (scq)
+		put_cq_read(scq);
+	if (pd)
+		put_pd_read(pd);
 
 	put_uobj_write(&obj->uevent.uobject);
 	return ret;
-- 
1.6.0.6

