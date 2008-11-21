Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYKUHN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYKUHN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYKUHNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:13:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKUHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:13:30 -0500
Message-Id: <20081121071328.254501091@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 02:12:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] trace: branch profiling should not print percent without data
Content-Disposition: inline; filename=0003-trace-branch-profiling-should-not-print-percent-wit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup on output of branch profiler

When a branch has not been taken, it does not make sense to show
a percentage incorrect or hit. This patch changes the behaviour
to print out a 'X' when the branch has not been executed yet.

For example:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
    2096        0   0 do_arch_prctl                  process_64.c         832
       0        0   X do_arch_prctl                  process_64.c         804
    2604        0   0 IS_ERR                         err.h                34
  130228     5765   4 __switch_to                    process_64.c         673
       0        0   X enable_TSC                     process_64.c         448
       0        0   X disable_TSC                    process_64.c         431

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_branch.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 21dedc8..142acb3 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -225,7 +225,7 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_branch_data *p = v;
 	const char *f;
-	unsigned long percent;
+	long percent;
 
 	if (v == (void *)1) {
 		seq_printf(m, " correct incorrect  %% "
@@ -247,9 +247,13 @@ static int t_show(struct seq_file *m, void *v)
 		percent = p->incorrect * 100;
 		percent /= p->correct + p->incorrect;
 	} else
-		percent = p->incorrect ? 100 : 0;
+		percent = p->incorrect ? 100 : -1;
 
-	seq_printf(m, "%8lu %8lu %3lu ", p->correct, p->incorrect, percent);
+	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
+	if (percent < 0)
+		seq_printf(m, "  X ");
+	else
+		seq_printf(m, "%3ld ", percent);
 	seq_printf(m, "%-30.30s %-20.20s %d\n", p->func, f, p->line);
 	return 0;
 }
-- 
1.5.6.5

-- 
