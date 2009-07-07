Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZGGFz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZGGFz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZGGFzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:55:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58210 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZGGFzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:55:13 -0400
Message-ID: <4A52E346.5050608@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:55:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] ksym_tracer: Fix the output of stat tracing
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.5.4.rc3
