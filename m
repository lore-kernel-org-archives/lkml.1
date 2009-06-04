Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZFDF0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZFDF0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZFDF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZFDF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:12 -0400
Message-Id: <20090604052612.802684387@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] tracing/function-profiler: do not free per cpu variable stat
Content-Disposition: inline; filename=0001-tracing-function-profiler-do-not-free-per-cpu-variab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The per cpu variable stat is freeded if we fail to allocate a name
on start up. This was due to stat at first being allocated in the
initial design. But since then, it has become a static per cpu variable
but the free on error was not removed.

Also added __init annotation to the function that this is in.

[ Impact: prevent possible memory corruption on low mem at boot up ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d6973df..134e580 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -766,7 +766,7 @@ static struct tracer_stat function_stats __initdata = {
 	.stat_show	= function_stat_show
 };
 
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -784,7 +784,6 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 			 * The files created are permanent, if something happens
 			 * we still do not free memory.
 			 */
-			kfree(stat);
 			WARN(1,
 			     "Could not allocate stat file for cpu %d\n",
 			     cpu);
@@ -811,7 +810,7 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
-static void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
-- 
1.6.3.1

-- 
