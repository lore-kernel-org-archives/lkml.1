Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZD2NGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZD2NGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZD2NFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:05:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbZD2NFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:05:05 -0400
Date: Wed, 29 Apr 2009 13:04:16 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-6-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-6-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: protect per-cpu variables with compile barriers only
Message-ID: <tip-527e26af3741a2168986d8b82653ffe173891324@git.kernel.org>
Git-Commit-ID: 527e26af3741a2168986d8b82653ffe173891324
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:04:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  527e26af3741a2168986d8b82653ffe173891324
Gitweb:     http://git.kernel.org/tip/527e26af3741a2168986d8b82653ffe173891324
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:02 +0200

perf_counter, x86: protect per-cpu variables with compile barriers only

Per-cpu variables needn't to be protected with cpu barriers
(smp_wmb()). Protection is only needed for preemption on the same cpu
(rescheduling or the nmi handler). This can be done using a compiler
barrier only.

[ Impact: micro-optimization ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-6-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 75a0903..ad663d5 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -673,7 +673,7 @@ try_generic:
 	/*
 	 * Make it visible before enabling the hw:
 	 */
-	smp_wmb();
+	barrier();
 
 	__hw_perf_counter_set_period(counter, hwc, idx);
 	__pmc_generic_enable(counter, hwc, idx);
@@ -745,7 +745,7 @@ static void pmc_generic_disable(struct perf_counter *counter)
 	 * Make sure the cleared pointer becomes visible before we
 	 * (potentially) free the counter:
 	 */
-	smp_wmb();
+	barrier();
 
 	/*
 	 * Drain the remaining delta count out of a counter
