Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZC3FuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZC3FuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 01:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZC3FuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 01:50:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZC3FuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 01:50:08 -0400
Message-ID: <49D05D10.4030009@cn.fujitsu.com>
Date: Mon, 30 Mar 2009 13:48:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix incorrect return type of ns2usecs() V2
References: <49D041ED.1060007@cn.fujitsu.com>
In-Reply-To: <49D041ED.1060007@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix time output bug in 32bits system

ns2usecs() returns 'long', it's incorrect.

(In i386)
# cat trace
...
          <idle>-0     [000]   521.442100: _spin_lock <-tick_do_update_jiffies64
          <idle>-0     [000]   521.442101: do_timer <-tick_do_update_jiffies64
          <idle>-0     [000]   521.442102: update_wall_time <-do_timer
          <idle>-0     [000]   521.442102: update_xtime_cache <-update_wall_time
....
(It always print the time less than 2200 seconds besides ...)
Because 'long' is 32bits in i386. ( (1<<31) useconds is about 2200 seconds)

# cat trace
...
          <idle>-0     [001] 4154502640.134759: rcu_bh_qsctr_inc <-__do_softirq
          <idle>-0     [001] 4154502640.134760: _local_bh_enable <-__do_softirq
          <idle>-0     [001] 4154502640.134761: idle_cpu <-irq_exit
...
(very large value)
Because 'long' is a signed type and it is 32bits in i386.

Changed from V1:
return 'unsigned long long' instead of 'cycle_t'

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a81dec..5232201 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -147,8 +147,7 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
-long
-ns2usecs(cycle_t nsec)
+unsigned long long ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
 	do_div(nsec, 1000);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fec6521..47aa6d0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -602,7 +602,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-extern long ns2usecs(cycle_t nsec);
+extern unsigned long long ns2usecs(cycle_t nsec);
 extern int
 trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index aeac358..0e70fb0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -433,7 +433,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
+		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
 				       entry->pid, iter->cpu, entry->flags,
 				       entry->preempt_count, iter->idx,


