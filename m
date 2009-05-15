Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZEOIrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZEOIrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZEOIoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:44:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761551AbZEOIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:44:14 -0400
Date: Fri, 15 May 2009 08:43:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Robustify interrupt handling
Message-ID: <tip-a4016a79fcbd139e7378944c0d86a39fdbc70ecc@git.kernel.org>
Git-Commit-ID: a4016a79fcbd139e7378944c0d86a39fdbc70ecc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:43:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4016a79fcbd139e7378944c0d86a39fdbc70ecc
Gitweb:     http://git.kernel.org/tip/a4016a79fcbd139e7378944c0d86a39fdbc70ecc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 May 2009 14:52:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:03 +0200

perf_counter: x86: Robustify interrupt handling

Two consecutive NMIs could daze and confuse the machine when the
first would handle the overflow of both counters.

[ Impact: fix false-positive syslog messages under multi-session profiling ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 313638c..1dcf670 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -783,6 +783,10 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
+
+		if (counter->hw_event.nmi != nmi)
+			goto next;
+
 		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
 			goto next;
@@ -869,7 +873,6 @@ perf_counter_nmi_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int ret;
 
 	if (!atomic_read(&active_counters))
 		return NOTIFY_DONE;
@@ -886,9 +889,16 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	regs = args->regs;
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	ret = x86_pmu.handle_irq(regs, 1);
+	/*
+	 * Can't rely on the handled return value to say it was our NMI, two
+	 * counters could trigger 'simultaneously' raising two back-to-back NMIs.
+	 *
+	 * If the first NMI handles both, the latter will be empty and daze
+	 * the CPU.
+	 */
+	x86_pmu.handle_irq(regs, 1);
 
-	return ret ? NOTIFY_STOP : NOTIFY_OK;
+	return NOTIFY_STOP;
 }
 
 static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
