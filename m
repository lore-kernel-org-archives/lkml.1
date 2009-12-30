Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZL3GWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZL3GWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZL3GWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:22:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbZL3GWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:22:34 -0500
Message-ID: <4B3AF19E.1010201@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 14:22:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ksym_tracer: Fix to make the tracer work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ksym tracer doesn't work:

 # echo tasklist_lock:rw- > ksym_trace_filter
 -bash: echo: write error: No such device

It's because we pass to perf_event_create_kernel_counter()
a cpu number which is not present.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/hw_breakpoint.c    |   10 +++++++---
 kernel/trace/trace_ksym.c |    1 -
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index dbcbf6a..50dbd59 100644
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
 
-- 
1.6.3

