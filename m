Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZBCCon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZBCCon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZBCCoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:44:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZBCCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:43:59 -0500
Message-Id: <20090203024358.332574797@goodmis.org>
References: <20090203023830.440860800@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Feb 2009 21:38:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] trace: fix default boot up tracer
Content-Disposition: inline; filename=0002-trace-fix-default-boot-up-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Peter Zijlstra started the functionality to start up a default
tracing at bootup. This patch finishes the work.

Now if you add 'ftrace=<tracer>' to the command line, when that tracer
is registered on bootup, that tracer is selected and starts tracing.

Note, all selftests for tracers that are registered after this tracer
is disabled. This prevents the selftests from disturbing the running
tracer, or the running tracer from disturbing the selftest.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   60 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2f8ac1f..2c720c7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -53,6 +53,11 @@ unsigned long __read_mostly	tracing_thresh;
  */
 static bool __read_mostly tracing_selftest_running;
 
+/*
+ * If a tracer is running, we do not want to run SELFTEST.
+ */
+static bool __read_mostly tracing_selftest_disabled;
+
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
 	{ }
@@ -110,14 +115,19 @@ static cpumask_var_t __read_mostly	tracing_buffer_mask;
  */
 int ftrace_dump_on_oops;
 
-static int tracing_set_tracer(char *buf);
+static int tracing_set_tracer(const char *buf);
+
+#define BOOTUP_TRACER_SIZE		100
+static char bootup_tracer_buf[BOOTUP_TRACER_SIZE] __initdata;
+static char *default_bootup_tracer;
 
 static int __init set_ftrace(char *str)
 {
-	tracing_set_tracer(str);
+	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
+	default_bootup_tracer = bootup_tracer_buf;
 	return 1;
 }
-__setup("ftrace", set_ftrace);
+__setup("ftrace=", set_ftrace);
 
 static int __init set_ftrace_dump_on_oops(char *str)
 {
@@ -468,7 +478,7 @@ int register_tracer(struct tracer *type)
 			type->flags->opts = dummy_tracer_opt;
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-	if (type->selftest) {
+	if (type->selftest && !tracing_selftest_disabled) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
 		int i;
@@ -510,8 +520,25 @@ int register_tracer(struct tracer *type)
  out:
 	tracing_selftest_running = false;
 	mutex_unlock(&trace_types_lock);
-	lock_kernel();
 
+	if (!ret && default_bootup_tracer) {
+		if (!strncmp(default_bootup_tracer, type->name,
+			     BOOTUP_TRACER_SIZE)) {
+			printk(KERN_INFO "Starting tracer '%s'\n",
+			       type->name);
+			/* Do we want this tracer to start on bootup? */
+			tracing_set_tracer(type->name);
+			default_bootup_tracer = NULL;
+			/* disable other selftests, since this will break it. */
+			tracing_selftest_disabled = 1;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+			printk(KERN_INFO "Disabling FTRACE selftests due"
+			       " to running tracer '%s'\n", type->name);
+#endif
+		}
+	}
+
+	lock_kernel();
 	return ret;
 }
 
@@ -2245,7 +2272,7 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
-static int tracing_set_tracer(char *buf)
+static int tracing_set_tracer(const char *buf)
 {
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
@@ -3163,5 +3190,26 @@ out_free_buffer_mask:
 out:
 	return ret;
 }
+
+__init static int clear_boot_tracer(void)
+{
+	/*
+	 * The default tracer at boot buffer is an init section.
+	 * This function is called in lateinit. If we did not
+	 * find the boot tracer, then clear it out, to prevent
+	 * later registration from accessing the buffer that is
+	 * about to be freed.
+	 */
+	if (!default_bootup_tracer)
+		return 0;
+
+	printk(KERN_INFO "ftrace bootup tracer '%s' not registered.\n",
+	       default_bootup_tracer);
+	default_bootup_tracer = NULL;
+
+	return 0;
+}
+
 early_initcall(tracer_alloc_buffers);
 fs_initcall(tracer_init_debugfs);
+late_initcall(clear_boot_tracer);
-- 
1.5.6.5

-- 
