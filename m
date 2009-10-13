Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZJMIr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZJMIr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbZJMIr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:47:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:46757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbZJMIrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:47:53 -0400
Date: Tue, 13 Oct 2009 08:46:36 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD42A0D.7050104@jp.fujitsu.com>
References: <4AD42A0D.7050104@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] perf_event, x86, mce: Use TRACE_EVENT() for MCE logging
Message-ID: <tip-8968f9d3dc23d9a1821d97c6f11e72a59382e56c@git.kernel.org>
Git-Commit-ID: 8968f9d3dc23d9a1821d97c6f11e72a59382e56c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 08:46:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8968f9d3dc23d9a1821d97c6f11e72a59382e56c
Gitweb:     http://git.kernel.org/tip/8968f9d3dc23d9a1821d97c6f11e72a59382e56c
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Tue, 13 Oct 2009 16:19:41 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 09:43:38 +0200

perf_event, x86, mce: Use TRACE_EVENT() for MCE logging

This approach is the first baby step towards solving many of the
structural problems the x86 MCE logging code is having today:

 - It has a private ring-buffer implementation that has a number
   of limitations and has been historically fragile and buggy.

 - It is using a quirky /dev/mcelog ioctl driven ABI that is MCE
   specific. /dev/mcelog is not part of any larger logging
   framework and hence has remained on the fringes for many years.

 - The MCE logging code is still very unclean partly due to its ABI
   limitations. Fields are being reused for multiple purposes, and
   the whole message structure is limited and x86 specific to begin
   with.

All in one, the x86 tree would like to move away from this private
implementation of an event logging facility to a broader framework.

By using perf events we gain the following advantages:

 - Multiple user-space agents can access MCE events. We can have an
   mcelog daemon running but also a system-wide tracer capturing
   important events in flight-recorder mode.

 - Sampling support: the kernel and the user-space call-chain of MCE
   events can be stored and analyzed as well. This way actual patterns
   of bad behavior can be matched to precisely what kind of activity
   happened in the kernel (and/or in the app) around that moment in
   time.

 - Coupling with other hardware and software events: the PMU can track a
   number of other anomalies - monitoring software might chose to
   monitor those plus the MCE events as well - in one coherent stream of
   events.

 - Discovery of MCE sources - tracepoints are enumerated and tools can
   act upon the existence (or non-existence) of various channels of MCE
   information.

 - Filtering support: we just subscribe to and act upon the events we
   are interested in. Then even on a per event source basis there's
   in-kernel filter expressions available that can restrict the amount
   of data that hits the event channel.

 - Arbitrary deep per cpu buffering of events - we can buffer 32
   entries or we can buffer as much as we want, as long as we have
   the RAM.

 - An NMI-safe ring-buffer implementation - mappable to user-space.

 - Built-in support for timestamping of events, PID markers, CPU
   markers, etc.

 - A rich ABI accessible over system call interface. Per cpu, per task
   and per workload monitoring of MCE events can be done this way. The
   ABI itself has a nice, meaningful structure.

 - Extensible ABI: new fields can be added without breaking tooling.
   New tracepoints can be added as the hardware side evolves. There's
   various parsers that can be used.

 - Lots of scheduling/buffering/batching modes of operandi for MCE
   events. poll() support. mmap() support. read() support. You name it.

 - Rich tooling support: even without any MCE specific extensions added
   the 'perf' tool today offers various views of MCE data: perf report,
   perf stat, perf trace can all be used to view logged MCE events and
   perhaps correlate them to certain user-space usage patterns. But it
   can be used directly as well, for user-space agents and policy action
   in mcelog, etc.

With this we hope to achieve significant code cleanup and feature
improvements in the MCE code, and we hope to be able to drop the
/dev/mcelog facility in the end.

This patch is just a plain dumb dump of mce_log() records to
the tracepoints / perf events framework - a first proof of
concept step.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <4AD42A0D.7050104@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++
 include/trace/events/mce.h       |   69 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..39caea3 100644
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
 
+	/* Emit the trace record: */
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
