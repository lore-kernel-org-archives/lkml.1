Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZEOIrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZEOIrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761624AbZEOIob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:44:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:57248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761643AbZEOIoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:44:30 -0400
Date: Fri, 15 May 2009 08:43:48 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Disallow interval of 1
Message-ID: <tip-1c80f4b598d9b075a2a0be694e28be93a6702bcc@git.kernel.org>
Git-Commit-ID: 1c80f4b598d9b075a2a0be694e28be93a6702bcc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:43:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c80f4b598d9b075a2a0be694e28be93a6702bcc
Gitweb:     http://git.kernel.org/tip/1c80f4b598d9b075a2a0be694e28be93a6702bcc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 15 May 2009 08:25:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:05 +0200

perf_counter: x86: Disallow interval of 1

On certain CPUs i have observed a stuck PMU if interval was set to
1 and NMIs were used. The PMU had PMC0 set in MSR_CORE_PERF_GLOBAL_STATUS,
but it was not possible to ack it via MSR_CORE_PERF_GLOBAL_OVF_CTRL,
and the NMI loop got stuck infinitely.

[ Impact: fix rare hangs during high perfcounter load ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 1dcf670..46a82d1 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -473,6 +473,11 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 		left += period;
 		atomic64_set(&hwc->period_left, left);
 	}
+	/*
+	 * Quirk: certain CPUs dont like it if just 1 event is left:
+	 */
+	if (unlikely(left < 2))
+		left = 2;
 
 	per_cpu(prev_left[idx], smp_processor_id()) = left;
 
