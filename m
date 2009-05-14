Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZENLsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZENLsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbZENLsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:48:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40191 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531AbZENLsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:48:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
Date: Thu, 14 May 2009 21:48:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3 v2] perf_counter: allow arch to supply event misc flags and instruction pointer
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present the values we put in overflow events for the misc flags
indicating processor mode and the instruction pointer are obtained
using the standard user_mode() and instruction_pointer() functions.
Those functions tell you where the performance monitor interrupt
was taken, which might not be exactly where the counter overflow
occurred, for example because interrupts were disabled at the point
where the overflow occurred, or because the processor had many
instructions in flight and chose to complete some more instructions
beyond the one that caused the counter overflow.

Some architectures (e.g. powerpc) can supply more precise information
about where the counter overflow occurred and the processor mode at
that point.  This introduces new functions, perf_misc_flags() and
perf_instruction_pointer(), which arch code can override to provide
more precise information if available.  They have default implementations
which are identical to the existing code.

This also adds a new misc flag value, PERF_EVENT_MISC_HYPERVISOR, for
the case where a counter overflow occurred in the hypervisor.  We
encode the processor mode in the 2 bits previously used to indicate
user or kernel mode; the values for user and kernel mode are unchanged
and hypervisor mode is indicated by both bits being set.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Patches 1/3 and 3/3 of this series are unchanged.  Ingo, do you need
me to repost them?

 include/linux/perf_counter.h |   11 ++++++++++-
 kernel/perf_counter.c        |    5 ++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 614f921..8ddde14 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -210,8 +210,11 @@ struct perf_counter_mmap_page {
 	__u32   data_head;		/* head in the data section */
 };
 
+#define PERF_EVENT_MISC_CPUMODE_MASK	(3 << 0)
+#define PERF_EVENT_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_EVENT_MISC_KERNEL		(1 << 0)
-#define PERF_EVENT_MISC_USER		(1 << 1)
+#define PERF_EVENT_MISC_USER		(2 << 0)
+#define PERF_EVENT_MISC_HYPERVISOR	(3 << 0)
 #define PERF_EVENT_MISC_OVERFLOW	(1 << 2)
 
 struct perf_event_header {
@@ -588,6 +591,12 @@ extern int sysctl_perf_counter_mlock;
 
 extern void perf_counter_init(void);
 
+#ifndef perf_misc_flags
+#define perf_misc_flags(regs)	(user_mode(regs) ? PERF_EVENT_MISC_USER : \
+				 PERF_EVENT_MISC_KERNEL)
+#define perf_instruction_pointer(regs)	instruction_pointer(regs)
+#endif
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ff166c1..89568de 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1978,11 +1978,10 @@ static void perf_counter_output(struct perf_counter *counter,
 	header.size = sizeof(header);
 
 	header.misc = PERF_EVENT_MISC_OVERFLOW;
-	header.misc |= user_mode(regs) ?
-		PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
+	header.misc |= perf_misc_flags(regs);
 
 	if (record_type & PERF_RECORD_IP) {
-		ip = instruction_pointer(regs);
+		ip = perf_instruction_pointer(regs);
 		header.type |= PERF_RECORD_IP;
 		header.size += sizeof(ip);
 	}
