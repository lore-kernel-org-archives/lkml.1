Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbZIDH7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbZIDH7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933243AbZIDH66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:58:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051AbZIDH6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:58:53 -0400
Date: Fri, 4 Sep 2009 07:58:31 GMT
From: "tip-bot for markus.t.metzger@intel.com" <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090902140615.305889000@intel.com>
References: <20090902140615.305889000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] x86, perf_counter, bts: Correct pointer-to-u64 casts
Message-ID: <tip-596da17f94c103348ebe04129c00d536ea0e80e2@git.kernel.org>
Git-Commit-ID: 596da17f94c103348ebe04129c00d536ea0e80e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 07:58:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  596da17f94c103348ebe04129c00d536ea0e80e2
Gitweb:     http://git.kernel.org/tip/596da17f94c103348ebe04129c00d536ea0e80e2
Author:     markus.t.metzger@intel.com <markus.t.metzger@intel.com>
AuthorDate: Wed, 2 Sep 2009 16:04:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 09:26:39 +0200

x86, perf_counter, bts: Correct pointer-to-u64 casts

On 32bit, pointers in the DS AREA configuration are cast to
u64. The current (long) cast to avoid compiler warnings results
in a signed 64bit address.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090902140615.305889000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2f41874..3776b0b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -726,7 +726,8 @@ static inline void init_debug_store_on_cpu(int cpu)
 		return;
 
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA,
-		     (u32)((u64)(long)ds), (u32)((u64)(long)ds >> 32));
+		     (u32)((u64)(unsigned long)ds),
+		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
 static inline void fini_debug_store_on_cpu(int cpu)
@@ -757,7 +758,7 @@ static void release_bts_hardware(void)
 
 		per_cpu(cpu_hw_counters, cpu).ds = NULL;
 
-		kfree((void *)(long)ds->bts_buffer_base);
+		kfree((void *)(unsigned long)ds->bts_buffer_base);
 		kfree(ds);
 	}
 
@@ -788,7 +789,7 @@ static int reserve_bts_hardware(void)
 			break;
 		}
 
-		ds->bts_buffer_base = (u64)(long)buffer;
+		ds->bts_buffer_base = (u64)(unsigned long)buffer;
 		ds->bts_index = ds->bts_buffer_base;
 		ds->bts_absolute_maximum =
 			ds->bts_buffer_base + BTS_BUFFER_SIZE;
@@ -1491,7 +1492,7 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
 	};
 	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
 	unsigned long orig_ip = data->regs->ip;
-	u64 at;
+	struct bts_record *at, *top;
 
 	if (!counter)
 		return;
@@ -1499,19 +1500,18 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
 	if (!ds)
 		return;
 
-	for (at = ds->bts_buffer_base;
-	     at < ds->bts_index;
-	     at += sizeof(struct bts_record)) {
-		struct bts_record *rec = (struct bts_record *)(long)at;
+	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
+	top = (struct bts_record *)(unsigned long)ds->bts_index;
 
-		data->regs->ip	= rec->from;
-		data->addr	= rec->to;
+	ds->bts_index = ds->bts_buffer_base;
+
+	for (; at < top; at++) {
+		data->regs->ip	= at->from;
+		data->addr	= at->to;
 
 		perf_counter_output(counter, 1, data);
 	}
 
-	ds->bts_index = ds->bts_buffer_base;
-
 	data->regs->ip	= orig_ip;
 	data->addr	= 0;
 
