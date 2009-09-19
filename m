Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZISRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZISRBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZISRBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:01:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZISRBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:01:41 -0400
Date: Sat, 19 Sep 2009 17:01:20 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       arjan@infradead.org, tglx@linutronix.de, mingo@elte.hu,
       len.brown@intel.com
In-Reply-To: <20090919133533.139c2a46@infradead.org>
References: <20090919133533.139c2a46@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] tracing, x86, cpuidle: Move the end point of a C state in the power tracer
Message-ID: <tip-288f023e708efd89d77ce9acf977a33a623ae83d@git.kernel.org>
Git-Commit-ID: 288f023e708efd89d77ce9acf977a33a623ae83d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 17:01:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  288f023e708efd89d77ce9acf977a33a623ae83d
Gitweb:     http://git.kernel.org/tip/288f023e708efd89d77ce9acf977a33a623ae83d
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 19 Sep 2009 13:35:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 18:57:52 +0200

tracing, x86, cpuidle: Move the end point of a C state in the power tracer

The "end of a C state" trace point currently happens before
the code runs that corrects the TSC for having stopped during idle.

The result of this is that the timestamp of the end-of-C-state event
is garbage on cpus where the TSC stops during idle.

This patch moves the end point of the C state to after the timekeeping
engine of the kernel has been corrected.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090919133533.139c2a46@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/process.c |    3 ---
 drivers/cpuidle/cpuidle.c |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7b60e39..847ab41 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -309,7 +309,6 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(0);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -377,7 +376,6 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
-	trace_power_end(0);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
@@ -394,7 +392,6 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(0);
 	} else
 		local_irq_enable();
 }
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8504a21..ad41f19 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -17,6 +17,7 @@
 #include <linux/cpuidle.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <trace/events/power.h>
 
 #include "cpuidle.h"
 
@@ -91,6 +92,7 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
+	trace_power_end(0);
 }
 
 /**
