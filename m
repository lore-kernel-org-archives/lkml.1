Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZLVOmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZLVOmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZLVOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:42:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:35599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZLVOmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:42:01 -0500
Subject: [PATCH] sched:
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, efault@gmx.de
In-Reply-To: <1261463382.2923.1.camel@localhost>
References: <1261441037.3273.254.camel@localhost>
	 <1261471720.4937.9.camel@laptop>  <1261463382.2923.1.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 15:41:22 +0100
Message-ID: <1261492882.4937.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As demonstrated by Eric, we really need to call __set_task_cpu() early
in the fork() path to properly initialize the various task state --
specifically the cgroup state through set_task_rq().

[ we could probably fix this by explicitly calling __set_task_cpu() from
  sched_fork(), but lets try that for the next cycle and simply revert
  to the old behaviour for now. ]

Reported-by: Eric Paris <eparis@redhat.com>
Tested-by: Eric Paris <eparis@redhat.com>, 
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2067,11 +2067,10 @@ void set_task_cpu(struct task_struct *p,
 
 	trace_sched_migrate_task(p, new_cpu);
 
-	if (task_cpu(p) == new_cpu)
-		return;
-
-	p->se.nr_migrations++;
-	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	if (task_cpu(p) != new_cpu) {
+		p->se.nr_migrations++;
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	}
 
 	__set_task_cpu(p, new_cpu);
 }


