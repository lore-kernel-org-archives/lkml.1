Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZAWOHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZAWOHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZAWOGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:06:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759528AbZAWOGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:06:52 -0500
Date: Fri, 23 Jan 2009 12:06:23 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org
Subject: [PATCH tip 1/2] ftrace: Add ftrace_vprintk
Message-ID: <20090123140623.GC21737@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrace@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: New API

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/ftrace.h |    8 ++++++++
 kernel/trace/trace.c   |    9 +++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f7880d..7840e71 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -302,6 +302,9 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
 extern int
 __ftrace_printk(unsigned long ip, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+# define ftrace_vprintk(fmt, ap) __ftrace_printk(_THIS_IP_, fmt, ap)
+extern int
+__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 extern void ftrace_dump(void);
 #else
 static inline void
@@ -317,6 +320,11 @@ ftrace_printk(const char *fmt, ...)
 {
 	return 0;
 }
+static inline int
+ftrace_vprintk(const char *fmt, va_list ap)
+{
+	return 0;
+}
 static inline void ftrace_dump(void) { }
 #endif
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2129ab9..2f8ac1f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2951,6 +2951,15 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(__ftrace_printk);
 
+int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
+{
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	return trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+}
+EXPORT_SYMBOL_GPL(__ftrace_vprintk);
+
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
-- 
1.6.0.6

