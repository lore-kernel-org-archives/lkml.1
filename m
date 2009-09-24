Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZIXOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZIXOfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZIXOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:35:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZIXOfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:35:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
Date: Thu, 24 Sep 2009 16:35:02 +0200
Message-Id: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

incr_error and error fields of struct cpu_itimer are used when calculating
next timer tick in check_cpu_itimers() and should not be modified without
tsk->sighand->siglock taken.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/itimer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/itimer.c b/kernel/itimer.c
index b03451e..d802883 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -146,6 +146,7 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 {
 	cputime_t cval, nval, cinterval, ninterval;
 	s64 ns_ninterval, ns_nval;
+	u32 error, incr_error;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
 	nval = timeval_to_cputime(&value->it_value);
@@ -153,8 +154,8 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	ninterval = timeval_to_cputime(&value->it_interval);
 	ns_ninterval = timeval_to_ns(&value->it_interval);
 
-	it->incr_error = cputime_sub_ns(ninterval, ns_ninterval);
-	it->error = cputime_sub_ns(nval, ns_nval);
+	error = cputime_sub_ns(nval, ns_nval);
+	incr_error = cputime_sub_ns(ninterval, ns_ninterval);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 
@@ -168,6 +169,8 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	}
 	it->expires = nval;
 	it->incr = ninterval;
+	it->error = error;
+	it->incr_error = incr_error;
 	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
 			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
 
-- 
1.6.2.5

