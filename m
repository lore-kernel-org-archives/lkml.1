Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZEDReu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZEDReu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbZEDReb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:34:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:54704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004AbZEDRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:34:29 -0400
Date: Mon, 4 May 2009 17:33:43 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1241455664.7620.4938.camel@twins>
References: <1241455664.7620.4938.camel@twins>
Subject: [tip:perfcounters/core] perf_counter: x86: fixup nmi_watchdog vs perf_counter boo-boo
Message-ID: <tip-ba77813a2a22d631fe5bc0bf1ec0d11350544b70@git.kernel.org>
Git-Commit-ID: ba77813a2a22d631fe5bc0bf1ec0d11350544b70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 17:33:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba77813a2a22d631fe5bc0bf1ec0d11350544b70
Gitweb:     http://git.kernel.org/tip/ba77813a2a22d631fe5bc0bf1ec0d11350544b70
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 4 May 2009 18:47:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 19:30:29 +0200

perf_counter: x86: fixup nmi_watchdog vs perf_counter boo-boo

Invert the atomic_inc_not_zero() test so that we will indeed detect the
first activation.

Also rename the global num_counters, since its easy to confuse with
x86_pmu.num_counters.

[ Impact: fix non-working perfcounters on AMD CPUs, cleanup ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241455664.7620.4938.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4c0cc9..196b58f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -171,7 +171,7 @@ again:
 	return new_raw_count;
 }
 
-static atomic_t num_counters;
+static atomic_t active_counters;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
 static bool reserve_pmc_hardware(void)
@@ -224,7 +224,7 @@ static void release_pmc_hardware(void)
 
 static void hw_perf_counter_destroy(struct perf_counter *counter)
 {
-	if (atomic_dec_and_mutex_lock(&num_counters, &pmc_reserve_mutex)) {
+	if (atomic_dec_and_mutex_lock(&active_counters, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
@@ -248,12 +248,12 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 		return -ENODEV;
 
 	err = 0;
-	if (atomic_inc_not_zero(&num_counters)) {
+	if (!atomic_inc_not_zero(&active_counters)) {
 		mutex_lock(&pmc_reserve_mutex);
-		if (atomic_read(&num_counters) == 0 && !reserve_pmc_hardware())
+		if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
 			err = -EBUSY;
 		else
-			atomic_inc(&num_counters);
+			atomic_inc(&active_counters);
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 	if (err)
@@ -280,7 +280,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (capable(CAP_SYS_ADMIN) && hw_event->nmi)
 		hwc->nmi = 1;
 
-	hwc->irq_period		= hw_event->irq_period;
+	hwc->irq_period	= hw_event->irq_period;
 	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > x86_pmu.max_period)
 		hwc->irq_period = x86_pmu.max_period;
 
@@ -871,7 +871,7 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	struct pt_regs *regs;
 	int ret;
 
-	if (!atomic_read(&num_counters))
+	if (!atomic_read(&active_counters))
 		return NOTIFY_DONE;
 
 	switch (cmd) {
