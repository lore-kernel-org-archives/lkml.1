Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZISLgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZISLgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbZISLgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:36:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:50795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbZISLga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:36:30 -0400
Date: Sat, 19 Sep 2009 13:35:33 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] trace: Move the end point of a C state in the power tracer
Message-ID: <20090919133533.139c2a46@infradead.org>
In-Reply-To: <20090919133410.7b23e270@infradead.org>
References: <20090919133410.7b23e270@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c1ffb79a8e87501ccaf269517566f438220f1c49 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 13:09:16 +0200
Subject: [PATCH] trace: Move the end point of a C state in the power tracer

The "end of a C state" trace point currently happens before
the code runs that corrects the TSC for having stopped during idle.
The result of this is that the timestamp of the end-of-C-state event
is garbage on cpus where the TSC stops during idle.

This patch moves the end point of the C state to after the timekeeping
engine of the kernel has been corrected.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/process.c |    3 ---
 drivers/cpuidle/cpuidle.c |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 98e9cac..230d054 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -299,7 +299,6 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(0);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -367,7 +366,6 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
-	trace_power_end(0);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
@@ -384,7 +382,6 @@ static void mwait_idle(void)
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
-- 
1.6.0.6

 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
