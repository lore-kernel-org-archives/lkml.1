Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZKRPia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZKRPia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZKRPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:38:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:37111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbZKRPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:38:29 -0500
Date: Wed, 18 Nov 2009 15:36:51 GMT
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, oleg@redhat.com,
       tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] itimers: Fix racy writes to cpu_itimer fields
Message-ID: <tip-8747d793fc5c4d3e4decd41d55f6dc24498dd5f5@git.kernel.org>
Git-Commit-ID: 8747d793fc5c4d3e4decd41d55f6dc24498dd5f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8747d793fc5c4d3e4decd41d55f6dc24498dd5f5
Gitweb:     http://git.kernel.org/tip/8747d793fc5c4d3e4decd41d55f6dc24498dd5f5
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 17 Nov 2009 14:14:12 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Nov 2009 16:32:12 +0100

itimers: Fix racy writes to cpu_itimer fields

incr_error and error fields of struct cpu_itimer are used when calculating
next timer tick in check_cpu_itimers() and should not be modified without
tsk->sighand->siglock taken.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
LKML-Reference: <1253802903-979-1-git-send-email-sgruszka@redhat.com> 
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
