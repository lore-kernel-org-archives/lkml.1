Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYINPJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYINPJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYINPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:09:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43024 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYINPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:09:41 -0400
Date: Sun, 14 Sep 2008 17:09:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080914150923.GB26984@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080914150651.GK12522@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the patch wasnt built on UP i guess - see the fix below.

the wider question is, shouldnt the UP case be just the same as the SMP 
case? Especially the type assymetry struct thread_group_cputime looks 
ugly. (and assymetries like that tend to be a constant source of 
breakage like the one below.)

	Ingo

-------------->
>From 0a8eaa4f9b58759595a1bfe13a1295fdc25ba026 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Sep 2008 17:03:52 +0200
Subject: [PATCH] timers: fix itimer/many thread hang, fix #2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix the UP build:

In file included from arch/x86/kernel/asm-offsets_32.c:9,
                 from arch/x86/kernel/asm-offsets.c:3:
include/linux/sched.h: In function ‘thread_group_cputime_clone_thread’:
include/linux/sched.h:2272: warning: no return statement in function returning non-void
include/linux/sched.h: In function ‘thread_group_cputime_account_user’:
include/linux/sched.h:2284: error: invalid type argument of ‘->’ (have ‘struct task_cputime’)
include/linux/sched.h:2284: error: invalid type argument of ‘->’ (have ‘struct task_cputime’)
include/linux/sched.h: In function ‘thread_group_cputime_account_system’:
include/linux/sched.h:2291: error: invalid type argument of ‘->’ (have ‘struct task_cputime’)
include/linux/sched.h:2291: error: invalid type argument of ‘->’ (have ‘struct task_cputime’)
include/linux/sched.h: In function ‘thread_group_cputime_account_exec_runtime’:
include/linux/sched.h:2298: error: invalid type argument of ‘->’ (have ‘struct task_cputime’)
distcc[14501] ERROR: compile arch/x86/kernel/asm-offsets.c on a/30 failed
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 26d7a5f..ed355f0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2251,6 +2251,7 @@ static inline void thread_group_cputime_free(struct signal_struct *sig)
 static inline int thread_group_cputime_clone_thread(struct task_struct *curr,
 						     struct task_struct *tsk)
 {
+	return 0;
 }
 
 static inline void thread_group_cputime(struct task_struct *tsk,
@@ -2263,21 +2264,21 @@ static inline void thread_group_cputime_account_user(
 	struct thread_group_cputime *tgtimes,
 	cputime_t cputime)
 {
-	tgtimes->totals->utime = cputime_add(tgtimes->totals->utime, cputime);
+	tgtimes->totals.utime = cputime_add(tgtimes->totals.utime, cputime);
 }
 
 static inline void thread_group_cputime_account_system(
 	struct thread_group_cputime *tgtimes,
 	cputime_t cputime)
 {
-	tgtimes->totals->stime = cputime_add(tgtimes->totals->stime, cputime);
+	tgtimes->totals.stime = cputime_add(tgtimes->totals.stime, cputime);
 }
 
 static inline void thread_group_cputime_account_exec_runtime(
 	struct thread_group_cputime *tgtimes,
 	unsigned long long ns)
 {
-	tgtimes->totals->sum_exec_runtime += ns;
+	tgtimes->totals.sum_exec_runtime += ns;
 }
 
 #endif /* CONFIG_SMP */
