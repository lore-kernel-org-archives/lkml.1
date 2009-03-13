Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZCMNJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZCMNJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbZCMNIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:08:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:36748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759119AbZCMNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:08:14 -0400
Date: Fri, 13 Mar 2009 13:07:19 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.770243471@chello.nl>
References: <20090313112301.770243471@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: provide major/minor page fault software events
Message-ID: <tip-07904cb8292bad6c020a1a3de499a58969da1624@git.kernel.org>
Git-Commit-ID: 07904cb8292bad6c020a1a3de499a58969da1624
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07904cb8292bad6c020a1a3de499a58969da1624
Gitweb:     http://git.kernel.org/tip/07904cb8292bad6c020a1a3de499a58969da1624
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:34 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:02:45 +0100

perf_counter: provide major/minor page fault software events

Provide separate sw counters for major and minor page faults.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.770243471@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/mm/fault.c      |    5 ++++-
 arch/x86/mm/fault.c          |    7 +++++--
 include/linux/perf_counter.h |    4 +++-
 kernel/perf_counter.c        |   22 +++++++++-------------
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index b044dc7..de37a3a 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -324,6 +324,7 @@ good_area:
 	}
 	if (ret & VM_FAULT_MAJOR) {
 		current->maj_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
 #ifdef CONFIG_PPC_SMLPAR
 		if (firmware_has_feature(FW_FEATURE_CMO)) {
 			preempt_disable();
@@ -331,8 +332,10 @@ good_area:
 			preempt_enable();
 		}
 #endif
-	} else
+	} else {
 		current->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 	up_read(&mm->mmap_sem);
 	return 0;
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c872575..f2d3324 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1140,10 +1140,13 @@ good_area:
 		return;
 	}
 
-	if (fault & VM_FAULT_MAJOR)
+	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-	else
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
+	} else {
 		tsk->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 
 	check_v8086_mode(regs, address, tsk);
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3fefc3b..4b14a8e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -49,8 +49,10 @@ enum hw_event_types {
 	PERF_COUNT_PAGE_FAULTS		= -3,
 	PERF_COUNT_CONTEXT_SWITCHES	= -4,
 	PERF_COUNT_CPU_MIGRATIONS	= -5,
+	PERF_COUNT_PAGE_FAULTS_MIN	= -6,
+	PERF_COUNT_PAGE_FAULTS_MAJ	= -7,
 
-	PERF_SW_EVENTS_MIN		= -6,
+	PERF_SW_EVENTS_MIN		= -8,
 };
 
 /*
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 1773c5d..68950a3 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1503,6 +1503,12 @@ static void perf_swcounter_disable(struct perf_counter *counter)
 	perf_swcounter_update(counter);
 }
 
+static const struct hw_perf_counter_ops perf_ops_generic = {
+	.enable		= perf_swcounter_enable,
+	.disable	= perf_swcounter_disable,
+	.read		= perf_swcounter_read,
+};
+
 /*
  * Software counter: cpu wall time clock
  */
@@ -1604,16 +1610,6 @@ static const struct hw_perf_counter_ops perf_ops_task_clock = {
 };
 
 /*
- * Software counter: page faults
- */
-
-static const struct hw_perf_counter_ops perf_ops_page_faults = {
-	.enable		= perf_swcounter_enable,
-	.disable	= perf_swcounter_disable,
-	.read		= perf_swcounter_read,
-};
-
-/*
  * Software counter: context switches
  */
 
@@ -1753,9 +1749,9 @@ sw_perf_counter_init(struct perf_counter *counter)
 			hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
-		if (!(counter->hw_event.exclude_user ||
-		      counter->hw_event.exclude_kernel))
-			hw_ops = &perf_ops_page_faults;
+	case PERF_COUNT_PAGE_FAULTS_MIN:
+	case PERF_COUNT_PAGE_FAULTS_MAJ:
+		hw_ops = &perf_ops_generic;
 		break;
 	case PERF_COUNT_CONTEXT_SWITCHES:
 		if (!counter->hw_event.exclude_kernel)
