Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZDBMF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZDBMF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZDBMEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:04:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:51762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbZDBMEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:04:47 -0400
Date: Thu, 2 Apr 2009 12:04:08 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090402091319.493101305@chello.nl>
References: <20090402091319.493101305@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add more context information
Message-ID: <tip-13c47e37b33167d9784ffbb2c921f65279665dd7@git.kernel.org>
Git-Commit-ID: 13c47e37b33167d9784ffbb2c921f65279665dd7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 12:04:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13c47e37b33167d9784ffbb2c921f65279665dd7
Gitweb:     http://git.kernel.org/tip/13c47e37b33167d9784ffbb2c921f65279665dd7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Apr 2009 11:12:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 13:53:00 +0200

perf_counter: add more context information

Put in counts to tell which ips belong to what context.

  -----
   | |  hv
   | --
nr | |  kernel
   | --
   | |  user
  -----

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090402091319.493101305@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    9 +++++++++
 include/linux/perf_counter.h       |    4 ++--
 kernel/perf_counter.c              |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2a946a1..c74e20d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1088,6 +1088,7 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	unsigned long bp;
 	char *stack;
+	int nr = entry->nr;
 
 	callchain_store(entry, instruction_pointer(regs));
 
@@ -1099,6 +1100,8 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 #endif
 
 	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, entry);
+
+	entry->kernel = entry->nr - nr;
 }
 
 
@@ -1128,6 +1131,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
 	struct stack_frame frame;
 	const void __user *fp;
+	int nr = entry->nr;
 
 	regs = (struct pt_regs *)current->thread.sp0 - 1;
 	fp   = (void __user *)regs->bp;
@@ -1147,6 +1151,8 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		callchain_store(entry, frame.return_address);
 		fp = frame.next_fp;
 	}
+
+	entry->user = entry->nr - nr;
 }
 
 static void
@@ -1182,6 +1188,9 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 		entry = &__get_cpu_var(irq_entry);
 
 	entry->nr = 0;
+	entry->hv = 0;
+	entry->kernel = 0;
+	entry->user = 0;
 
 	perf_do_callchain(regs, entry);
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5428ba1..90cce0c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -513,10 +513,10 @@ extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
-#define MAX_STACK_DEPTH		255
+#define MAX_STACK_DEPTH		254
 
 struct perf_callchain_entry {
-	u64	nr;
+	u32	nr, hv, kernel, user;
 	u64	ip[MAX_STACK_DEPTH];
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 9bcab10..f105a6e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1819,7 +1819,7 @@ void perf_counter_output(struct perf_counter *counter,
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
-			callchain_size = (1 + callchain->nr) * sizeof(u64);
+			callchain_size = (2 + callchain->nr) * sizeof(u64);
 
 			header.type |= __PERF_EVENT_CALLCHAIN;
 			header.size += callchain_size;
