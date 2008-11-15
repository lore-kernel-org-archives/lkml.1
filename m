Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYKOAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYKOAqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYKOAqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:46:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYKOAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:46:08 -0500
Message-Id: <20081115004604.410464326@goodmis.org>
References: <20081115004537.616030629@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 19:45:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: disable ftrace on anomalies in trace start and stop
Content-Disposition: inline; filename=0002-ftrace-disable-ftrace-on-anomalies-in-trace-start-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: robust feature to disable ftrace on start or stop tracing on error

Currently only the initial conversion to nops will disable ftrace
on an anomaly. But if an anomaly happens on start or stopping of the
tracer, it will silently fail.

This patch adds a check there too, to disable ftrace and warn if the
conversion fails.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   81 ++++++++++++++++++++++++++----------------------
 1 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 66aa19e..4ef1331 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -349,6 +349,47 @@ ftrace_record_ip(unsigned long ip)
 	return rec;
 }
 
+static void print_ip_ins(const char *fmt, unsigned char *p)
+{
+	int i;
+
+	printk(KERN_CONT "%s", fmt);
+
+	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
+		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+}
+
+static void ftrace_bug(int failed, unsigned long ip,
+		       unsigned char *expected,
+		       unsigned char *replace)
+{
+	switch (failed) {
+	case -EFAULT:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on modifying ");
+		print_ip_sym(ip);
+		break;
+	case -EINVAL:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace failed to modify ");
+		print_ip_sym(ip);
+		print_ip_ins(" expected: ", expected);
+		print_ip_ins(" actual: ", (unsigned char *)ip);
+		print_ip_ins(" replace: ", replace);
+		printk(KERN_CONT "\n");
+		break;
+	case -EPERM:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on writing ");
+		print_ip_sym(ip);
+		break;
+	default:
+		FTRACE_WARN_ON_ONCE(1);
+		pr_info("ftrace faulted on unknown error ");
+		print_ip_sym(ip);
+	}
+}
+
 #define FTRACE_ADDR ((long)(ftrace_caller))
 
 static int
@@ -466,22 +507,13 @@ static void ftrace_replace_code(int enable)
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
 					ftrace_free_rec(rec);
-				}
+				} else
+					ftrace_bug(failed, rec->ip, old, new);
 			}
 		}
 	}
 }
 
-static void print_ip_ins(const char *fmt, unsigned char *p)
-{
-	int i;
-
-	printk(KERN_CONT "%s", fmt);
-
-	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
-}
-
 static int
 ftrace_code_disable(struct dyn_ftrace *rec)
 {
@@ -496,32 +528,7 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 
 	ret = ftrace_modify_code(ip, call, nop);
 	if (ret) {
-		switch (ret) {
-		case -EFAULT:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on modifying ");
-			print_ip_sym(ip);
-			break;
-		case -EINVAL:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace failed to modify ");
-			print_ip_sym(ip);
-			print_ip_ins(" expected: ", call);
-			print_ip_ins(" actual: ", (unsigned char *)ip);
-			print_ip_ins(" replace: ", nop);
-			printk(KERN_CONT "\n");
-			break;
-		case -EPERM:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on writing ");
-			print_ip_sym(ip);
-			break;
-		default:
-			FTRACE_WARN_ON_ONCE(1);
-			pr_info("ftrace faulted on unknown error ");
-			print_ip_sym(ip);
-		}
-
+		ftrace_bug(ret, ip, call, nop);
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
-- 
1.5.6.5

-- 
