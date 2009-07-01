Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZGAUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZGAUl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbZGAUk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:40:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbZGAUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:40:55 -0400
Date: Wed, 1 Jul 2009 20:40:21 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
References: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter: Ignore the nmi call frames in the x86-64 backtraces
Message-ID: <tip-0406ca6d8e849d9dd027c8cb6791448e81411aef@git.kernel.org>
Git-Commit-ID: 0406ca6d8e849d9dd027c8cb6791448e81411aef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 20:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0406ca6d8e849d9dd027c8cb6791448e81411aef
Gitweb:     http://git.kernel.org/tip/0406ca6d8e849d9dd027c8cb6791448e81411aef
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 1 Jul 2009 21:02:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 22:37:23 +0200

perf_counter: Ignore the nmi call frames in the x86-64 backtraces

About every callchains recorded with perf record are filled up
including the internal perfcounter nmi frame:

 perf_callchain
 perf_counter_overflow
 intel_pmu_handle_irq
 perf_counter_nmi_handler
 notifier_call_chain
 atomic_notifier_call_chain
 notify_die
 do_nmi
 nmi

We want ignore this frame as it's not interesting for
instrumentation. To solve this, we simply ignore every frames
from nmi context.

New example of "perf report -s sym -c" after this patch:

9.59%  [k] search_by_key
             4.88%
                search_by_key
                reiserfs_read_locked_inode
                reiserfs_iget
                reiserfs_lookup
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                vfs_fstatat
                vfs_lstat
                sys_newlstat
                system_call_fastpath
                __lxstat
                0x406fb1

             3.19%
                search_by_key
                search_by_entry_key
                reiserfs_find_entry
                reiserfs_lookup
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                vfs_fstatat
                vfs_lstat
                sys_newlstat
                system_call_fastpath
                __lxstat
                0x406fb1
[...]

For now this patch only solves the problem in x86-64.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/stacktrace.h  |    2 ++
 arch/x86/kernel/cpu/perf_counter.c |    8 +++++++-
 arch/x86/kernel/dumpstack_32.c     |    6 ++++++
 arch/x86/kernel/dumpstack_64.c     |   22 +++++++++++++++-------
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index f517944..cf86a5e 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -3,6 +3,8 @@
 
 extern int kstack_depth_to_print;
 
+int x86_is_stack_id(int id, char *name);
+
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4cf4ce..36c3dc7 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1561,6 +1561,7 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, nmi_entry);
+static DEFINE_PER_CPU(int, in_nmi_frame);
 
 
 static void
@@ -1576,7 +1577,9 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	/* Process all stacks: */
+	per_cpu(in_nmi_frame, smp_processor_id()) =
+			x86_is_stack_id(NMI_STACK, name);
+
 	return 0;
 }
 
@@ -1584,6 +1587,9 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
+	if (per_cpu(in_nmi_frame, smp_processor_id()))
+		return;
+
 	if (reliable)
 		callchain_store(entry, addr);
 }
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index d593cd1..bca5fba 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -19,6 +19,12 @@
 
 #include "dumpstack.h"
 
+/* Just a stub for now */
+int x86_is_stack_id(int id, char *name)
+{
+	return 0;
+}
+
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index d35db59..54b0a32 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -19,10 +19,8 @@
 
 #include "dumpstack.h"
 
-static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
-{
-	static char ids[][8] = {
+
+static char x86_stack_ids[][8] = {
 		[DEBUG_STACK - 1] = "#DB",
 		[NMI_STACK - 1] = "NMI",
 		[DOUBLEFAULT_STACK - 1] = "#DF",
@@ -33,6 +31,15 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
 #endif
 	};
+
+int x86_is_stack_id(int id, char *name)
+{
+	return x86_stack_ids[id - 1] == name;
+}
+
+static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
+					unsigned *usedp, char **idp)
+{
 	unsigned k;
 
 	/*
@@ -61,7 +68,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			if (*usedp & (1U << k))
 				break;
 			*usedp |= 1U << k;
-			*idp = ids[k];
+			*idp = x86_stack_ids[k];
 			return (unsigned long *)end;
 		}
 		/*
@@ -81,12 +88,13 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 			do {
 				++j;
 				end -= EXCEPTION_STKSZ;
-				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
+				x86_stack_ids[j][4] = '1' +
+						(j - N_EXCEPTION_STACKS);
 			} while (stack < end - EXCEPTION_STKSZ);
 			if (*usedp & (1U << j))
 				break;
 			*usedp |= 1U << j;
-			*idp = ids[j];
+			*idp = x86_stack_ids[j];
 			return (unsigned long *)end;
 		}
 #endif
