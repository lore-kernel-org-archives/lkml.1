Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZEDQrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZEDQrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZEDQrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:47:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbZEDQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:47:45 -0400
Subject: [PATCH] perf_counter: x86: fixup nmi_watchdog vs perf_counter
 boo-boo
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 18:47:44 +0200
Message-Id: <1241455664.7620.4938.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the global num_counters, since its easy to confuse with
x86_pmu.num_counters. 

Invert the atomic_inc_not_zero() test so that we will indeed detect the
first activation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

