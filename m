Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbZFOInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbZFOInp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbZFOIna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:43:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54148 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600AbZFOIn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:43:29 -0400
Date: Mon, 15 Jun 2009 10:36:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
Message-ID: <20090615103659.45c39df1@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklist_lock is not needed to protect find_task_by_vpid() nor
same_thread_group() and if we replace thread_group_leader() by
has_group_leader_pid() we can just use RCU lock to protect some process
timers/clocks checks.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..029b442 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
 	if (pid == 0)
 		return 0;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : thread_group_leader(p))) {
+		   same_thread_group(p, current) : has_group_leader_pid(p))) {
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
@@ -412,7 +412,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 			p = current->group_leader;
 		} else {
 			p = find_task_by_vpid(pid);
-			if (p && !thread_group_leader(p))
+			if (p && !has_group_leader_pid(p))
 				p = NULL;
 		}
 	}
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

