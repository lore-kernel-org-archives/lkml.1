Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZKUNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZKUNgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZKUNgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:36244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZKUNgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:42 -0500
Date: Sat, 21 Nov 2009 13:35:21 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E346.5050608@cn.fujitsu.com>
References: <4A52E346.5050608@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Fix the output of stat tracing
Message-ID: <tip-9d7e934408b52cd53dd85270eb36941a6a318cc5@git.kernel.org>
Git-Commit-ID: 9d7e934408b52cd53dd85270eb36941a6a318cc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d7e934408b52cd53dd85270eb36941a6a318cc5
Gitweb:     http://git.kernel.org/tip/9d7e934408b52cd53dd85270eb36941a6a318cc5
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:55:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:44 +0200

ksym_tracer: Fix the output of stat tracing

- make ksym_tracer_stat_start() return head->first instead of
  &head->first
- make the output properly aligned

Before:

   Access type                Symbol                     Counter
     NA                   <NA>                              0
     RW                   pid_max                               0

After:

  Access Type   Symbol                                       Counter
  -----------   ------                                       -------
  RW            pid_max                                            0

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E346.5050608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 7d349d3..1256a6e 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -453,8 +453,10 @@ device_initcall(init_ksym_trace);
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 static int ksym_tracer_stat_headers(struct seq_file *m)
 {
-	seq_printf(m, "   Access type    ");
-	seq_printf(m, "            Symbol                     Counter     \n");
+	seq_puts(m, "  Access Type ");
+	seq_puts(m, "  Symbol                                       Counter\n");
+	seq_puts(m, "  ----------- ");
+	seq_puts(m, "  ------                                       -------\n");
 	return 0;
 }
 
@@ -472,27 +474,27 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 
 	switch (access_type) {
 	case HW_BREAKPOINT_WRITE:
-		seq_printf(m, "     W     ");
+		seq_puts(m, "  W           ");
 		break;
 	case HW_BREAKPOINT_RW:
-		seq_printf(m, "     RW    ");
+		seq_puts(m, "  RW          ");
 		break;
 	default:
-		seq_printf(m, "     NA    ");
+		seq_puts(m, "  NA          ");
 	}
 
 	if (lookup_symbol_name(entry->ksym_addr, fn_name) >= 0)
-		seq_printf(m, "               %s                 ", fn_name);
+		seq_printf(m, "  %-36s", fn_name);
 	else
-		seq_printf(m, "               <NA>                ");
+		seq_printf(m, "  %-36s", "<NA>");
+	seq_printf(m, " %15lu\n", entry->counter);
 
-	seq_printf(m, "%15lu\n", entry->counter);
 	return 0;
 }
 
 static void *ksym_tracer_stat_start(struct tracer_stat *trace)
 {
-	return &(ksym_filter_head.first);
+	return ksym_filter_head.first;
 }
 
 static void *
