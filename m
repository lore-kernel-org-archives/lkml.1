Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYGIWc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYGIWc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYGIWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:32:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:55874 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYGIWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FqZlA9UPYoh5LoqoSq/hYYlYSIZGShZogTn9cXy5xm2wGQSNc8poMqx0Hi0KGJQEFa
         YzfshGX91MbxWlxQlPK0wdJhDtZWFjw/5ixKo6q8oQ6ynRWLk+NOk5tkNmLlVk1njs8x
         agGxw9R7XT2Np7RkO0p2xyp72S1UXkKGo2gTQ=
Subject: Re: [BUG] CFS vs cpu hotplug
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: miaox@cn.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 00:32:40 +0200
Message-Id: <1215642760.5310.12.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, while looking at this code again...


Ingo,

I think we may have a race between try_to_wake_up() and migrate_live_tasks() -> move_task_off_dead_cpu()
when the later one may end up looping endlessly.


Subject: sched: prevent a potentially endless loop in move_task_off_dead_cpu()

Interrupts are enabled on other CPUs when migration_call(CPU_DEAD, ...) is called so we may get a race
between try_to_wake_up() and migrate_live_tasks() -> move_task_off_dead_cpu(). The former one may push
a task out of a dead CPU causing the later one to loop endlessly.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 94ead43..9397b87 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5621,8 +5621,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
-	if (task_cpu(p) != src_cpu)
+	if (task_cpu(p) != src_cpu) {
+		ret = 1;
 		goto out;
+	}
 	/* Affinity changed (again). */
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;

---

