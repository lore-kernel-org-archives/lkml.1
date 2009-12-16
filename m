Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZLPJQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZLPJQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932182AbZLPJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:16:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbZLPJQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:16:25 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] fix cpu hotplug test failures on powerpc
Date: Wed, 16 Dec 2009 17:15:57 +0800
Message-Id: <1260954957-1518-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <4B289955.2010705@in.ibm.com>
References: <4B289955.2010705@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin found cpu hotplug test failures on powerpc, which made kernel
hangs on his POWER box. This is addressed in
http://marc.info/?l=linux-kernel&m=126052886204649&w=2

commit 6ad4c18(sched: Fix balance vs hotplug race), switches to
cpu_active_mask, but at some specific situation, kernel may cause
some cpu inactive but online.

In some powerpc machine, hotplug cpu0 is allowed. If cpu0 is the
last alive cpu, when we tried to offline cpu0, we'll inactive cpu0
in cpu_down(), after goes into __cpu_down(), kernel found num_online_cpus
is 1, returned -EBUSY but cpu0 is not changed back to active. So
cpu0 is inactive but online.

The fix is to set cpu inactive when we're going to bring down the specific
cpu in _cpu_down().

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Tested-by: Sachin Sant <sachinp@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/cpu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 291ac58..a1e7165 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -ENOMEM;
 
 	cpu_hotplug_begin();
+	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -280,8 +281,6 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	set_cpu_active(cpu, false);
-
 	/*
 	 * Make sure the all cpus did the reschedule and are not
 	 * using stale version of the cpu_active_mask.
@@ -387,12 +386,6 @@ int disable_nonboot_cpus(void)
 	 */
 	cpumask_clear(frozen_cpus);
 
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		set_cpu_active(cpu, false);
-	}
-
 	synchronize_sched();
 
 	printk("Disabling non-boot CPUs ...\n");
