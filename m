Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbXIYVfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbXIYVfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXIYVfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:35:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15077 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXIYVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CwbM9yXL4OYmFT/B42ZTtArQY0NB02i/lD6yP1nr+p9Ottx7u86lHvHmQE4dDFQsMvcoB+CTzgYj7kS3zcI2fSJFL2Q3hoPygJjwI00w5qcH5yaSr1YgRpIteymz5jQh7B5t1i3B8OxgW9QxtcKmHog+xWLyqxpGGuPO3R/DC6U=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 25 Sep 2007 23:35:27 +0200
Message-Id: <1190756127.18744.23.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


humm... I think, it'd be safer to have something like the following
change in place.

The thing is that __pick_next_entity() must never be called when
first_fair(cfs_rq) == NULL. It wouldn't be a problem, should 'run_node'
be the very first field of 'struct sched_entity' (and it's the second).

The 'nr_running != 0' check is _not_ enough, due to the fact that
'current' is not within the tree. Generic paths are ok (e.g. schedule()
as put_prev_task() is called previously)... I'm more worried about e.g.
migration_call() -> CPU_DEAD_FROZEN -> migrate_dead_tasks()... if
'current' == rq->idle, no problems.. if it's one of the SCHED_NORMAL
tasks (or imagine, some other use-cases in the future -- i.e. we should
not make outer world dependent on internal details of sched_fair class)
-- it may be "Houston, we've got a problem" case.

it's +16 bytes to the ".text". Another variant is to make 'run_node' the
first data member of 'struct sched_entity' but an additional check (se !
= NULL) is still needed in pick_next_entity().

what do you think?


---
 diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index dae714a..33b2376 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -563,9 +563,12 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
-
-	set_next_entity(cfs_rq, se);
+	struct sched_entity *se = NULL;
+	
+	if (first_fair(cfs_rq)) {
+		se = __pick_next_entity(cfs_rq);
+		set_next_entity(cfs_rq, se);
+	}
 
 	return se;
 }

---


