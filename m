Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbZFQNnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbZFQNnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZFQNm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:42:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZFQNm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:42:58 -0400
Date: Wed, 17 Jun 2009 15:36:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] posix_cpu_timers_exit_group: do not use
 thread_group_cputimer()
Message-ID: <20090617153637.3342988c@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the process exits we don't have to run new cputimer nor use running one
(as it not accounts when tsk->exit_state != 0) to get process CPU times.
As there is only one thread we can just use CPU times fields form task
and signal structs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..e33a21c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -521,11 +521,12 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	struct task_cputime cputime;
+	struct signal_struct *const sig = tsk->signal;
 
-	thread_group_cputimer(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
+		       cputime_add(tsk->utime, sig->utime),
+		       cputime_add(tsk->stime, sig->stime),
+		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
-- 
1.5.5.6

