Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZFLImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZFLImB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZFLIkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:40:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51404 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906AbZFLIkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:40:49 -0400
Date: Fri, 12 Jun 2009 10:34:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
Message-ID: <20090612103412.3c490e3e@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklist_lock is not needed to protect find_task_by_vpid() nor
thread_group_leader() nor same_thread_group() , use rcu_read_lock() instead.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..1fadd2f 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
 	if (pid == 0)
 		return 0;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return error;
 }
@@ -398,7 +398,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	new_timer->it.cpu.incr.sched = 0;
 	new_timer->it.cpu.expires.sched = 0;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
 		if (pid == 0) {
 			p = current;
@@ -422,7 +422,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	} else {
 		ret = -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return ret;
 }
-- 
1.5.5.6

