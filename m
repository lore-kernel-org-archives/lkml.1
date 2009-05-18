Return-Path: <linux-kernel-owner+w=401wt.eu-S1751127AbZERECa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbZERECa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 00:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZERECV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 00:02:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34843 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZERECV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 00:02:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18960.56772.869734.304631@drongo.ozlabs.ibm.com>
Date: Mon, 18 May 2009 14:02:12 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: perf_counter: powerpc: initialize cpuhw pointer before use
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e35ad38 ("perf_counter: Rework the perf counter
disable/enable") added code to the powerpc hw_perf_enable (renamed
from hw_perf_restore) to test cpuhw->disabled and return immediately
if it is not set (i.e. if the PMU is already enabled).

Unfortunately the test got added before cpuhw was initialized,
resulting in an oops the first time hw_perf_enable got called.
This fixes it by moving the initialization of cpuhw to before
cpuhw->disabled is tested.

[ Impact: fix oops-causing bug on powerpc ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 6baae5a..fe21b24 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -450,12 +450,11 @@ void hw_perf_enable(void)
 	int idx;
 
 	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	if (!cpuhw->disabled) {
 		local_irq_restore(flags);
 		return;
 	}
-
-	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	cpuhw->disabled = 0;
 
 	/*
