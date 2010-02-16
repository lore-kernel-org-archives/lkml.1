Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab0BPQmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:42:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0BPQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:42:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=sZjzZ6ENFy0A:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=EWAeA-sw7JC2HHnoofQA:9 a=YymoY9CrwkrhnhgFrM8A:7 a=fLCeNi2-2B9BDkCGkp9ZxBQW1S0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100216164207.110923172@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Feb 2010 11:41:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] tracing: Add correct/incorrect to sort keys for branch annotation output
References: <20100216164122.891864374@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-correct-incorrect-to-sort-keys-for-branc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The branch annotation is a bit difficult to see the worst offenders
because it only sorts by percentage:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0      163 100 qdisc_restart                  sch_generic.c        179
       0      163 100 pfifo_fast_dequeue             sch_generic.c        447
       0        4 100 pskb_trim_rcsum                skbuff.h             1689
       0        4 100 llc_rcv                        llc_input.c          170
       0       18 100 psmouse_interrupt              psmouse-base.c       304
       0        3 100 atkbd_interrupt                atkbd.c              389
       0        5 100 usb_alloc_dev                  usb.c                437
       0       11 100 vsscanf                        vsprintf.c           1897
       0        2 100 IS_ERR                         err.h                34
       0       23 100 __rmqueue_fallback             page_alloc.c         865
       0        4 100 probe_wakeup_sched_switch      trace_sched_wakeup.c 142
       0        3 100 move_masked_irq                migration.c          11

Adding the incorrect and correct values as sort keys makes this file a
bit more informative:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0   366541 100 audit_syscall_entry            auditsc.c            1637
       0   366538 100 audit_syscall_exit             auditsc.c            1685
       0   115839 100 sched_info_switch              sched_stats.h        269
       0    74567 100 sched_info_queued              sched_stats.h        222
       0    66578 100 sched_info_dequeued            sched_stats.h        177
       0    15113 100 trace_workqueue_insertion      workqueue.h          38
       0    15107 100 trace_workqueue_execution      workqueue.h          45
       0     3622 100 syscall_trace_leave            ptrace.c             1772
       0     2750 100 sched_move_task                sched.c              10100
       0     2750 100 sched_move_task                sched.c              10110
       0     1815 100 pre_schedule_rt                sched_rt.c           1462
       0      837 100 audit_alloc                    auditsc.c            879
       0      814 100 tcp_mss_split_point            tcp_output.c         1302

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4a194f0..b9bc4d4 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -307,8 +307,23 @@ static int annotated_branch_stat_cmp(void *p1, void *p2)
 		return -1;
 	if (percent_a > percent_b)
 		return 1;
-	else
-		return 0;
+
+	if (a->incorrect < b->incorrect)
+		return -1;
+	if (a->incorrect > b->incorrect)
+		return 1;
+
+	/*
+	 * Since the above shows worse (incorrect) cases
+	 * first, we continue that by showing best (correct)
+	 * cases last.
+	 */
+	if (a->correct > b->correct)
+		return -1;
+	if (a->correct < b->correct)
+		return 1;
+
+	return 0;
 }
 
 static struct tracer_stat annotated_branch_stats = {
-- 
1.6.5


