Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZJMHUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZJMHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933614AbZJMHUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:20:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41916 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258AbZJMHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:20:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD42A0D.7050104@jp.fujitsu.com>
Date: Tue, 13 Oct 2009 16:19:41 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] x86, mce: use of TRACE_EVENT for mce
References: <4AC96391.1060001@jp.fujitsu.com> <1255072482.5228.157.camel@yhuang-dev.sh.intel.com> <4ACEE5E0.3050701@jp.fujitsu.com> <1255074286.5228.163.camel@yhuang-dev.sh.intel.com> <4ACEF4D9.9090600@jp.fujitsu.com> <1255079484.5228.201.camel@yhuang-dev.sh.intel.com> <4AD3E731.7080900@jp.fujitsu.com> <1255404495.6047.298.camel@yhuang-dev.sh.intel.com> <4AD41793.9020400@jp.fujitsu.com> <1255414771.6047.405.camel@yhuang-dev.sh.intel.com> <20091013062939.GA8484@elte.hu>
In-Reply-To: <20091013062939.GA8484@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
> 
>> I have talked with Ingo about this patch. But he has different idea 
>> about MCE log ring buffer and he didn't want to merge the patch even 
>> as an urgent bug fixes. It seems that another re-post can not convince 
>> him.
> 
> Correct. The fixes are beyond what we can do in .32 - and for .33 i 
> outlined (with a patch) that we should be using not just the ftrace 
> ring-buffer (like your patch did) but perf events to expose MCE events.
> 
> That brings MCE events to a whole new level of functionality.
> 
> Event injection support would be an interesting new addition to 
> kernel/perf_event.c: non-MCE user-space wants to inject events as well - 
> both to simulate rare events, and to define their own user-space events.
> 
> Is there any technical reason why we wouldnt want to take this far 
> superior approach?
> 
> 	Ingo

We could have more aggressive discussion if there is a real patch.
This is an example.


Thanks,
H.Seto

===

Subject: [PATCH] [RFC] x86, mce: trial use of TRACE_EVENT for mce

(As a response to "x86: mce: New MCE logging design" from Ingo)

Just forward record to trace buffer.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++
 include/trace/events/mce.h       |   69 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/mce.h

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..2d563cd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,9 @@
 
 #include "mce-internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mce.h>
+
 int mce_disabled __read_mostly;
 
 #define MISC_MCELOG_MINOR	227
@@ -141,6 +144,9 @@ void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
 
+	/* Forward record to trace buffer for several use */
+	trace_mce_record(mce);
+
 	mce->finished = 0;
 	wmb();
 	for (;;) {
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
new file mode 100644
index 0000000..7eee778
--- /dev/null
+++ b/include/trace/events/mce.h
@@ -0,0 +1,69 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mce
+
+#if !defined(_TRACE_MCE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MCE_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+#include <asm/mce.h>
+
+TRACE_EVENT(mce_record,
+
+	TP_PROTO(struct mce *m),
+
+	TP_ARGS(m),
+
+	TP_STRUCT__entry(
+		__field(	u64,		mcgcap		)
+		__field(	u64,		mcgstatus	)
+		__field(	u8,		bank		)
+		__field(	u64,		status		)
+		__field(	u64,		addr		)
+		__field(	u64,		misc		)
+		__field(	u64,		ip		)
+		__field(	u8,		cs		)
+		__field(	u64,		tsc		)
+		__field(	u64,		walltime	)
+		__field(	u32,		cpu		)
+		__field(	u32,		cpuid		)
+		__field(	u32,		apicid		)
+		__field(	u32,		socketid	)
+		__field(	u8,		cpuvendor	)
+	),
+
+	TP_fast_assign(
+		__entry->mcgcap		= m->mcgcap;
+		__entry->mcgstatus	= m->mcgstatus;
+		__entry->bank		= m->bank;
+		__entry->status		= m->status;
+		__entry->addr		= m->addr;
+		__entry->misc		= m->misc;
+		__entry->ip		= m->ip;
+		__entry->cs		= m->cs;
+		__entry->tsc		= m->tsc;
+		__entry->walltime	= m->time;
+		__entry->cpu		= m->extcpu;
+		__entry->cpuid		= m->cpuid;
+		__entry->apicid		= m->apicid;
+		__entry->socketid	= m->socketid;
+		__entry->cpuvendor	= m->cpuvendor;
+	),
+
+	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+		__entry->cpu,
+		__entry->mcgcap, __entry->mcgstatus,
+		__entry->bank, __entry->status,
+		__entry->addr, __entry->misc,
+		__entry->cs, __entry->ip,
+		__entry->tsc,
+		__entry->cpuvendor, __entry->cpuid,
+		__entry->walltime,
+		__entry->socketid,
+		__entry->apicid)
+);
+
+#endif /* _TRACE_MCE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.4.4


