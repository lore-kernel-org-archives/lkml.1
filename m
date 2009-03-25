Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbZCYRjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbZCYRjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763769AbZCYRi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:38:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763701AbZCYRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:38:55 -0400
Date: Wed, 25 Mar 2009 13:38:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH][GIT PULL] tracing: clean up tracing profiler
In-Reply-To: <alpine.DEB.2.00.0903251134310.5675@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903251337570.5675@gandalf.stny.rr.com>
References: <20090325035646.662994901@goodmis.org> <20090325040832.251748832@goodmis.org> <20090325100252.GH2341@elte.hu> <alpine.DEB.2.00.0903251134310.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest rfc/tip/tracing/function-profiler tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
rfc/tip/tracing/function-profiler


Steven Rostedt (1):
      tracing: clean up tracing profiler

----
 kernel/trace/ftrace.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)
---------------------------
commit fb9fb015e92123fa3a8e0c2e2fff491d4a56b470
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Mar 25 13:26:41 2009 -0400

    tracing: clean up tracing profiler
    
    Ingo Molnar suggested clean ups for the profiling code. This patch
    makes those updates.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 71e5fae..a141d84 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -69,7 +69,7 @@ static DEFINE_MUTEX(ftrace_lock);
 
 static struct ftrace_ops ftrace_list_end __read_mostly =
 {
-	.func = ftrace_stub,
+	.func		= ftrace_stub,
 };
 
 static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
@@ -271,8 +271,10 @@ struct ftrace_profile_stat {
 #define PROFILES_PER_PAGE					\
 	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
 
-static int ftrace_profile_bits;
-static int ftrace_profile_enabled;
+static int ftrace_profile_bits __read_mostly;
+static int ftrace_profile_enabled __read_mostly;
+
+/* ftrace_profile_lock - synchronize the enable and disable of the profiler */
 static DEFINE_MUTEX(ftrace_profile_lock);
 
 static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
@@ -651,7 +653,7 @@ static void unregister_ftrace_profiler(void)
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly =
 {
-	.func = function_profile_call,
+	.func		= function_profile_call,
 };
 
 static int register_ftrace_profiler(void)
@@ -670,7 +672,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
 	unsigned long val;
-	char buf[64];
+	char buf[64];		/* big enough to hold a number */
 	int ret;
 
 	if (cnt >= sizeof(buf))
@@ -719,7 +721,7 @@ static ssize_t
 ftrace_profile_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	char buf[64];
+	char buf[64];		/* big enough to hold a number */
 	int r;
 
 	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
@@ -734,12 +736,12 @@ static const struct file_operations ftrace_profile_fops = {
 
 /* used to initialize the real stat files */
 static struct tracer_stat function_stats __initdata = {
-	.name = "functions",
-	.stat_start = function_stat_start,
-	.stat_next = function_stat_next,
-	.stat_cmp = function_stat_cmp,
-	.stat_headers = function_stat_headers,
-	.stat_show = function_stat_show
+	.name		= "functions",
+	.stat_start	= function_stat_start,
+	.stat_next	= function_stat_next,
+	.stat_cmp	= function_stat_cmp,
+	.stat_headers	= function_stat_headers,
+	.stat_show	= function_stat_show
 };
 
 static void ftrace_profile_debugfs(struct dentry *d_tracer)
@@ -1954,7 +1956,7 @@ function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
-	.func = function_trace_probe_call,
+	.func		= function_trace_probe_call,
 };
 
 static int ftrace_probe_registered;


