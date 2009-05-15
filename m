Return-Path: <linux-kernel-owner+w=401wt.eu-S1763085AbZEOOq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763085AbZEOOq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762511AbZEOOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:44:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:55962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762507AbZEOOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:44:54 -0400
Date: Fri, 15 May 2009 14:44:20 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
References: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: allow arch to supply event misc flags and instruction pointer
Message-ID: <tip-9d23a90a67261e73b2fcac04d8ca963c6b496afb@git.kernel.org>
Git-Commit-ID: 9d23a90a67261e73b2fcac04d8ca963c6b496afb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:44:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d23a90a67261e73b2fcac04d8ca963c6b496afb
Gitweb:     http://git.kernel.org/tip/9d23a90a67261e73b2fcac04d8ca963c6b496afb
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 14 May 2009 21:48:08 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 16:38:56 +0200

perf_counter: allow arch to supply event misc flags and instruction pointer

At present the values we put in overflow events for the misc
flags indicating processor mode and the instruction pointer are
obtained using the standard user_mode() and
instruction_pointer() functions. Those functions tell you where
the performance monitor interrupt was taken, which might not be
exactly where the counter overflow occurred, for example
because interrupts were disabled at the point where the
overflow occurred, or because the processor had many
instructions in flight and chose to complete some more
instructions beyond the one that caused the counter overflow.

Some architectures (e.g. powerpc) can supply more precise
information about where the counter overflow occurred and the
processor mode at that point.  This introduces new functions,
perf_misc_flags() and perf_instruction_pointer(), which arch
code can override to provide more precise information if
available.  They have default implementations which are
identical to the existing code.

This also adds a new misc flag value,
PERF_EVENT_MISC_HYPERVISOR, for the case where a counter
overflow occurred in the hypervisor.  We encode the processor
mode in the 2 bits previously used to indicate user or kernel
mode; the values for user and kernel mode are unchanged and
hypervisor mode is indicated by both bits being set.

[ Impact: generalize perfcounter core facilities ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <18956.1272.818511.561835@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   11 ++++++++++-
 kernel/perf_counter.c        |    5 ++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 004b6e1..c8c1dfc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -215,8 +215,11 @@ struct perf_counter_mmap_page {
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
@@ -596,6 +599,12 @@ extern int sysctl_perf_counter_mlock;
 
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
index 728a595..57840a9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2042,11 +2042,10 @@ static void perf_counter_output(struct perf_counter *counter,
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
