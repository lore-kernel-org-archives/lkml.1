Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYKUUbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYKUUbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYKUUbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121203100.878295527@goodmis.org>
References: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: add ftrace_off_permanent
Content-Disposition: inline; filename=0004-ftrace-add-ftrace_off_permanent.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: feature to disable all of ftrace on anomalies

It case of a serious anomaly being detected (like something caught by
lockdep) it is a good idea to disable all tracing immediately, without
grabing any locks.

This patch adds ftrace_off_permanent that disables the tracers, function
tracing and ring buffers without a way to enable them again. This should
only be used when something serious has been detected.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    2 ++
 kernel/trace/trace.c   |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f1af1aa..efa5f27 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -257,6 +257,7 @@ extern int ftrace_dump_on_oops;
 
 extern void tracing_start(void);
 extern void tracing_stop(void);
+extern void ftrace_off_permanent(void);
 
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
@@ -290,6 +291,7 @@ ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
 
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
+static inline void ftrace_off_permanent(void) { }
 static inline int
 ftrace_printk(const char *fmt, ...)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5653c6b..25b560f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -639,6 +639,21 @@ static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
 
 /**
+ * ftrace_off_permanent - disable all ftrace code permanently
+ *
+ * This should only be called when a serious anomally has
+ * been detected.  This will turn off the function tracing,
+ * ring buffers, and other tracing utilites. It takes no
+ * locks and can be called from any context.
+ */
+void ftrace_off_permanent(void)
+{
+	tracing_disabled = 1;
+	ftrace_stop();
+	tracing_off_permanent();
+}
+
+/**
  * tracing_start - quick start of the tracer
  *
  * If tracing is enabled but was stopped by tracing_stop,
-- 
1.5.6.5

-- 
