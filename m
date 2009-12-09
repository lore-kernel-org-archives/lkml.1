Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZLIJnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZLIJnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZLIJnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:43:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbZLIJm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:42:58 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 3/6] cpu-timers: return true old increase value in timer_settime()
Date: Wed,  9 Dec 2009 10:39:55 +0100
Message-Id: <1260351598-4203-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 84589e9..4716c8c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -675,7 +675,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, val;
+	union cpu_time_count old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -706,6 +706,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	BUG_ON(!irqs_disabled());
 
 	ret = 0;
+	old_incr = timer->it.cpu.incr;
 	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
@@ -821,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
  out:
 	if (old) {
 		sample_to_timespec(timer->it_clock,
-				   timer->it.cpu.incr, &old->it_interval);
+				   old_incr, &old->it_interval);
 	}
 	return ret;
 }
-- 
1.6.2.5

