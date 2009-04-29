Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZD2K43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZD2K43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZD2KvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:42674 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbZD2KvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:11 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KIUZGQ-04-0X3-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/29] x86/perfcounters: protect per-cpu variables with compile barriers only
Date: Wed, 29 Apr 2009 12:47:02 +0200
Message-ID: <1241002046-8832-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0289 (UTC) FILETIME=[5B966390:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-cpu variables needn't to be protected with cpu barriers
(smp_wmb()). Protection is only needed for preemption on the same cpu
(rescheduling or the nmi handler). This can be done using a compiler
barrier only.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.6.1.3


