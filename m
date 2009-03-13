Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZCMNCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZCMNCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbZCMNBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZCMNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:01:32 -0400
Date: Fri, 13 Mar 2009 13:01:06 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.384074618@chello.nl>
References: <20090313112301.384074618@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add comment to barrier
Message-ID: <tip-1b1646b16f983a880163afb9efd296de01c7d854@git.kernel.org>
Git-Commit-ID: 1b1646b16f983a880163afb9efd296de01c7d854
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b1646b16f983a880163afb9efd296de01c7d854
Gitweb:     http://git.kernel.org/tip/1b1646b16f983a880163afb9efd296de01c7d854
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:30 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:59:08 +0100

perf_counter: add comment to barrier

We need to ensure the enabled=0 write happens before we
start disabling the actual counters, so that a pcm_amd_enable()
will not enable one underneath us.

I think the race is impossible anyway, we always balance the
ops within any one context and perform enable() with IRQs disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.384074618@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 1cedc34..a2e3b76 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -247,6 +247,10 @@ static u64 pmc_amd_save_disable_all(void)
 
 	enabled = cpuc->enabled;
 	cpuc->enabled = 0;
+	/*
+	 * ensure we write the disable before we start disabling the
+	 * counters proper, so that pcm_amd_enable() does the right thing.
+	 */
 	barrier();
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
