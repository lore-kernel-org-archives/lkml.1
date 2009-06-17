Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbZFQIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbZFQIqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764803AbZFQIqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:46:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:51496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764415AbZFQIqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:46:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/4QQMf5sH43cRXOeT3ctwznQPefsd9YzZz2zk+mk
	R3ErPbbIsLRfAH
Subject: [patch 1/2] Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK
 scheduling policy flag, fourth try
From: Mike Galbraith <efault@gmx.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090616164742.GA21385@tango.0pointer.de>
References: <20090615152714.GA29092@tango.0pointer.de>
	 <1245143108.6038.10.camel@marge.simson.net>
	 <20090616164742.GA21385@tango.0pointer.de>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:46:01 +0200
Message-Id: <1245228361.18329.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 18:47 +0200, Lennart Poettering wrote:
> On Tue, 16.06.09 11:05, Mike Galbraith (efault@gmx.de) wrote:
> 
> > I think it's cleaner to keep reset_on_fork functionality separate.
> > Thoughts on the below?
> 
> Looks good to me!

OK, I'll submit then, splitting cleanup from functionality addition.

commit 58e1710a8a525e0fb1f4c608d5f73377fb56c893
Author: Mike Galbraith <efault@gmx.de>
Date:   Wed Jun 17 10:16:26 2009 +0200

    sched: SCHED_RESET_ON_FORK cleanup.
    
    Make SCHED_RESET_ON_FORK sched_fork() bits a self-contained unlikely code path.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Lennart Poettering <mzxreary@0pointer.de>
    LKML-Reference: <new-submission>
---
 kernel/sched.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 095892c..3c27e44 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2613,28 +2613,30 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	set_task_cpu(p, cpu);
 
 	/*
-	 * Revert to default priority/policy on fork if requested. Make sure we
-	 * do not leak PI boosting priority to the child.
+	 * Make sure we do not leak PI boosting priority to the child.
 	 */
-	if (current->sched_reset_on_fork &&
-			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
-		p->policy = SCHED_NORMAL;
+	p->prio = current->normal_prio;
 
-	if (current->sched_reset_on_fork &&
-			(current->normal_prio < DEFAULT_PRIO))
-		p->prio = DEFAULT_PRIO;
-	else
-		p->prio = current->normal_prio;
+	/*
+	 * Revert to default priority/policy on fork if requested.
+	 */
+	if (unlikely(p->sched_reset_on_fork)) {
+		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
+			p->policy = SCHED_NORMAL;
+
+		if (p->normal_prio < DEFAULT_PRIO)
+			p->prio = DEFAULT_PRIO;
+
+		/*
+		 * We don't need the reset flag anymore after the fork. It has
+		 * fulfilled its duty:
+		 */
+		p->sched_reset_on_fork = 0;
+	}
 
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
-	/*
-	 * We don't need the reset flag anymore after the fork. It has
-	 * fulfilled its duty:
-	 */
-	p->sched_reset_on_fork = 0;
-
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));


