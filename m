Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZL3Jbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZL3Jbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZL3Jbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:57457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZL3Jbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:31:44 -0500
Date: Wed, 30 Dec 2009 09:30:53 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <4B3AF19E.1010201@cn.fujitsu.com>
References: <4B3AF19E.1010201@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ksym_tracer: Fix to make the tracer work
Message-ID: <tip-88f7a890d74137ab0d126a5d65679cd620f1a289@git.kernel.org>
Git-Commit-ID: 88f7a890d74137ab0d126a5d65679cd620f1a289
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88f7a890d74137ab0d126a5d65679cd620f1a289
Gitweb:     http://git.kernel.org/tip/88f7a890d74137ab0d126a5d65679cd620f1a289
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 30 Dec 2009 14:22:22 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 07:50:47 +0100

ksym_tracer: Fix to make the tracer work

ksym tracer doesn't work:

 # echo tasklist_lock:rw- > ksym_trace_filter
 -bash: echo: write error: No such device

It's because we pass to perf_event_create_kernel_counter()
a cpu number which is not present.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B3AF19E.1010201@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c    |   10 +++++++---
 kernel/trace/trace_ksym.c |    1 -
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 366eedf..48fb0bb 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -40,6 +40,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
@@ -388,7 +389,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 	if (!cpu_events)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_possible_cpu(cpu) {
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
 		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
 
@@ -399,18 +401,20 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			goto fail;
 		}
 	}
+	put_online_cpus();
 
 	return cpu_events;
 
 fail:
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
 		if (IS_ERR(*pevent))
 			break;
 		unregister_hw_breakpoint(*pevent);
 	}
+	put_online_cpus();
+
 	free_percpu(cpu_events);
-	/* return the error if any */
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index faf37fa..340b6ff 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -197,7 +197,6 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	entry->attr.bp_addr = addr;
 	entry->attr.bp_len = HW_BREAKPOINT_LEN_4;
 
-	ret = -EAGAIN;
 	entry->ksym_hbp = register_wide_hw_breakpoint(&entry->attr,
 					ksym_hbp_handler);
 
