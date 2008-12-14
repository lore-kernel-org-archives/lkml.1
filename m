Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYLNE7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYLNE7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 23:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYLNE7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 23:59:09 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56344 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYLNE7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 23:59:07 -0500
Date: Sun, 14 Dec 2008 10:28:28 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, vatsa@linux.vnet.ibm.com,
       cfriesen@nortel.com, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH]: sched: Fix compile errors introduced by new group
	scheduler interface
Message-ID: <20081214045828.GD4268@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20081210194048.464111787@chello.nl> <20081212093148.GL25106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081212093148.GL25106@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> applied to tip/sched/core, thanks Peter!
> 

Also needs this to build,


sched: Fix compile errors introduced by new group scheduler interface

commit e642daa433a5ea1599965576dcea70dcc0a36608 introduces

kernel/sched.c: In function ‘cpu_nice_write’:
kernel/sched.c:8505: error: implicit declaration of function ‘sched_group_set_nice’
kernel/sched.c:8505: error: implicit declaration of function ‘cgroup_tg’
kernel/sched.c: In function ‘cpu_nice_read’:
kernel/sched.c:8510: error: implicit declaration of function ‘sched_group_nice’
kernel/sched.c: At top level:
kernel/sched.c:8822: error: static declaration of ‘sched_group_set_nice’ follows non-static declaration
kernel/sched.c:8505: error: previous implicit declaration of ‘sched_group_set_nice’ was here
kernel/sched.c:8833: error: static declaration of ‘sched_group_nice’ follows non-static declaration
kernel/sched.c:8510: error: previous implicit declaration of ‘sched_group_nice’ was here
kernel/sched.c:9103: error: conflicting types for ‘cgroup_tg’
kernel/sched.c:8505: error: previous implicit declaration of ‘cgroup_tg’ was here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel/sched.o] Error 2

Fix those.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 kernel/sched.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-12-12 16:18:54.000000000 +0530
+++ linux-2.6/kernel/sched.c	2008-12-12 16:21:36.000000000 +0530
@@ -8499,16 +8499,7 @@ static inline void unregister_fair_sched
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
 
-static int cpu_nice_write(struct cgroup *cgrp, struct cftype *cftype,
-			  s64 niceval)
-{
-	return sched_group_set_nice(cgroup_tg(cgrp), niceval);
-}
 
-static s64 cpu_nice_read(struct cgroup *cgrp, struct cftype *cftype)
-{
-	return sched_group_nice(cgroup_tg(cgrp));
-}
 #else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
@@ -9169,6 +9160,17 @@ static u64 cpu_weight_read_u64(struct cg
 
 	return (u64) tg->weight;
 }
+
+static int cpu_nice_write(struct cgroup *cgrp, struct cftype *cftype,
+			  s64 niceval)
+{
+	return sched_group_set_nice(cgroup_tg(cgrp), niceval);
+}
+
+static s64 cpu_nice_read(struct cgroup *cgrp, struct cftype *cftype)
+{
+	return sched_group_nice(cgroup_tg(cgrp));
+}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED


-- 
regards,
Dhaval
