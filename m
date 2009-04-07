Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZDGNNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZDGNNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZDGNN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:13:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZDGNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:13:28 -0400
Date: Tue, 7 Apr 2009 13:12:38 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49D05D10.4030009@cn.fujitsu.com>
References: <49D05D10.4030009@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: fix incorrect return type of ns2usecs()
Message-ID: <tip-cf8e3474654f20433aab9aa35826d43b5f245008@git.kernel.org>
Git-Commit-ID: cf8e3474654f20433aab9aa35826d43b5f245008
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:12:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf8e3474654f20433aab9aa35826d43b5f245008
Gitweb:     http://git.kernel.org/tip/cf8e3474654f20433aab9aa35826d43b5f245008
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 30 Mar 2009 13:48:00 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:59:23 +0200

tracing: fix incorrect return type of ns2usecs()

Impact: fix time output bug in 32bits system

ns2usecs() returns 'long', it's incorrect.

(In i386)
..
          <idle>-0     [000]   521.442100: _spin_lock <-tick_do_update_jiffies64
          <idle>-0     [000]   521.442101: do_timer <-tick_do_update_jiffies64
          <idle>-0     [000]   521.442102: update_wall_time <-do_timer
          <idle>-0     [000]   521.442102: update_xtime_cache <-update_wall_time
...
(It always print the time less than 2200 seconds besides ...)
Because 'long' is 32bits in i386. ( (1<<31) useconds is about 2200 seconds)

..
          <idle>-0     [001] 4154502640.134759: rcu_bh_qsctr_inc <-__do_softirq
          <idle>-0     [001] 4154502640.134760: _local_bh_enable <-__do_softirq
          <idle>-0     [001] 4154502640.134761: idle_cpu <-irq_exit
..
(very large value)
Because 'long' is a signed type and it is 32bits in i386.

Changes in v2:
return 'unsigned long long' instead of 'cycle_t'

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <49D05D10.4030009@cn.fujitsu.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c        |    3 +--
 kernel/trace/trace.h        |    2 +-
 kernel/trace/trace_output.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a0174a4..457dd8c 100644
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
index cb0ce3f..0d81a4a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -596,7 +596,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-extern long ns2usecs(cycle_t nsec);
+extern unsigned long long ns2usecs(cycle_t nsec);
 extern int
 trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index d72b9a6..64b54a5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -423,7 +423,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
+		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
 				       entry->pid, iter->cpu, entry->flags,
 				       entry->preempt_count, iter->idx,
