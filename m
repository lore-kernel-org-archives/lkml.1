Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZFBEpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZFBEpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZFBEno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZFBEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:40 -0400
Message-Id: <20090602044341.348255521@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/10] ftrace: do not profile functions when disabled
Content-Disposition: inline; filename=0010-ftrace-do-not-profile-functions-when-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

A race was found that if one were to enable and disable the function
profiler repeatedly, then the system can panic. This was because a profiled
function may be preempted just before disabling interrupts. While
the profiler is disabled and then reenabled, the preempted function
could start again, and access the hash as it is being initialized.

This just adds a check in the irq disabled part to check if the profiler
is enabled, and if it is not then it will just exit.

When the system is disabled, the profile_enabled variable is cleared
before calling the unregistering of the function profiler. This
unregistering calls stop machine which also acts as a synchronize schedule.

[ Impact: fix panic in enabling/disabling function profiler ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2074e5b..d6973df 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -599,7 +599,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	local_irq_save(flags);
 
 	stat = &__get_cpu_var(ftrace_profile_stats);
-	if (!stat->hash)
+	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
 	rec = ftrace_find_profiled_func(stat, ip);
@@ -630,7 +630,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	stat = &__get_cpu_var(ftrace_profile_stats);
-	if (!stat->hash)
+	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
 	calltime = trace->rettime - trace->calltime;
@@ -724,6 +724,10 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 			ftrace_profile_enabled = 1;
 		} else {
 			ftrace_profile_enabled = 0;
+			/*
+			 * unregister_ftrace_profiler calls stop_machine
+			 * so this acts like an synchronize_sched.
+			 */
 			unregister_ftrace_profiler();
 		}
 	}
-- 
1.6.3.1

-- 
