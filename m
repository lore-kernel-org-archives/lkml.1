Return-Path: <linux-kernel-owner+w=401wt.eu-S932892AbZKZEft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbZKZEft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 23:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZKZEfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 23:35:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46712 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbZKZEfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 23:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EZYuJIGXQ1/ZyBBwtG9wr4ajvylE+mtYo145aUogDPcNrzXdkh8nh58Qf6Eq+6vnqI
         3In7hqSssCbXjSY4oI7tlb/BJ/LnP+EF2BqsztA6lgR3rTuwfgB/Pw8v1g38HBA+NPcZ
         CLhT5nN7ZLVlOT5/KTexflWXRbdG29MCDkRu0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 3/3] hw-breakpoints: Simplify error handling in breakpoint creation requests
Date: Thu, 26 Nov 2009 05:35:42 +0100
Message-Id: <1259210142-5714-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
References: <1259210142-5714-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the error handling when we create a breakpoint.
We don't need anymore to check the NULL return value corner case
since we have improved perf_event_create_kernel_counter() to
always return an error code in fail case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/ptrace.c                |    8 +-------
 kernel/hw_breakpoint.c                  |    4 ++--
 kernel/trace/trace_ksym.c               |   16 ++++------------
 samples/hw_breakpoint/data_breakpoint.c |    3 ---
 4 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b25f894..75e0cd8 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -657,10 +657,7 @@ restore:
 					       tsk, true);
 		thread->ptrace_bps[i] = NULL;
 
-		if (!bp) { /* incorrect bp, or we have a bug in bp API */
-			rc = -EINVAL;
-			break;
-		}
+		/* Incorrect bp, or we have a bug in bp API */
 		if (IS_ERR(bp)) {
 			rc = PTR_ERR(bp);
 			bp = NULL;
@@ -729,9 +726,6 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 					       tsk,
 					       bp->attr.disabled);
 	}
-
-	if (!bp)
-		return -EIO;
 	/*
 	 * CHECKME: the previous code returned -EIO if the addr wasn't a
 	 * valid task virtual addr. The new one will return -EINVAL in this
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 06d372f..dd3fb4a 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -442,7 +442,7 @@ register_wide_hw_breakpoint(unsigned long addr,
 
 		*pevent = bp;
 
-		if (IS_ERR(bp) || !bp) {
+		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
 			goto fail;
 		}
@@ -453,7 +453,7 @@ register_wide_hw_breakpoint(unsigned long addr,
 fail:
 	for_each_possible_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
-		if (IS_ERR(*pevent) || !*pevent)
+		if (IS_ERR(*pevent))
 			break;
 		unregister_hw_breakpoint(*pevent);
 	}
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 9f040e4..c538b15 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -200,12 +200,9 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	entry->ksym_hbp = register_wide_hw_breakpoint(entry->ksym_addr,
 					entry->len, entry->type,
 					ksym_hbp_handler, true);
+
 	if (IS_ERR(entry->ksym_hbp)) {
-		entry->ksym_hbp = NULL;
 		ret = PTR_ERR(entry->ksym_hbp);
-	}
-
-	if (!entry->ksym_hbp) {
 		printk(KERN_INFO "ksym_tracer request failed. Try again"
 					" later!!\n");
 		goto err;
@@ -332,21 +329,16 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	if (changed) {
 		unregister_wide_hw_breakpoint(entry->ksym_hbp);
 		entry->type = op;
+		ret = 0;
 		if (op > 0) {
 			entry->ksym_hbp =
 				register_wide_hw_breakpoint(entry->ksym_addr,
 					entry->len, entry->type,
 					ksym_hbp_handler, true);
 			if (IS_ERR(entry->ksym_hbp))
-				entry->ksym_hbp = NULL;
-
-			/* modified without problem */
-			if (entry->ksym_hbp) {
-				ret = 0;
+				ret = PTR_ERR(entry->ksym_hbp);
+			else
 				goto out;
-			}
-		} else {
-			ret = 0;
 		}
 		/* Error or "symbol:---" case: drop it */
 		ksym_filter_entry_count--;
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 9506381..ee7f9fb 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -61,9 +61,6 @@ static int __init hw_break_module_init(void)
 	if (IS_ERR(sample_hbp)) {
 		ret = PTR_ERR(sample_hbp);
 		goto fail;
-	} else if (!sample_hbp) {
-		ret = -EINVAL;
-		goto fail;
 	}
 
 	printk(KERN_INFO "HW Breakpoint for %s write installed\n", ksym_name);
-- 
1.6.2.3

