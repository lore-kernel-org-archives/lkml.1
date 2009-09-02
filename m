Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZIBOGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZIBOGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIBOGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:06:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:8341 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZIBOGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:06:18 -0400
Content-Type: multipart/mixed; boundary="===============0045646435=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,318,1249282800"; 
   d="scan'208";a="444915905"
Message-Id: <20090902140615.305889000@intel.com>
References: <20090902140445.125358000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 16:04:47 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 2/3] x86, perf_counter, bts: correct pointer-to-u64 casts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0045646435==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.perf_counter.correct_pointer_to_u64_casts.patch

On 32bit, pointers in the DS AREA configuration are cast to u64. The
current (long) cast to avoid compiler warnings results in a signed
64bit address.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   24 	12 +	12 -	0 !
 1 files changed, 12 insertions(+), 12 deletions(-)

Index: b/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -726,7 +726,8 @@ static inline void init_debug_store_on_c
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
@@ -1491,7 +1492,7 @@ static void intel_pmu_drain_bts_buffer(s
 	};
 	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
 	unsigned long orig_ip = data->regs->ip;
-	u64 at;
+	struct bts_record *at, *top;
 
 	if (!counter)
 		return;
@@ -1499,19 +1500,18 @@ static void intel_pmu_drain_bts_buffer(s
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
 

-- 

--===============0045646435==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============0045646435==--
