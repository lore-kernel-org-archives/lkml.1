Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYJWNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYJWNkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYJWNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133723.810104301@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/12 v3] ftrace: add ftrace warn on to disable ftrace
Content-Disposition: inline; filename=ftrace-disable-warn-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace warn on to disable ftrace as well as report a warning.

[ Thanks to Andrew Morton for suggesting using the WARN_ON return value ]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 15:58:35.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 16:05:30.000000000 -0400
@@ -32,6 +32,18 @@
 
 #include "trace.h"
 
+#define FTRACE_WARN_ON(cond)			\
+	do {					\
+		if (WARN_ON(cond))		\
+			ftrace_kill();		\
+	} while (0)
+
+#define FTRACE_WARN_ON_ONCE(cond)		\
+	do {					\
+		if (WARN_ON_ONCE(cond))		\
+			ftrace_kill();		\
+	} while (0)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -358,10 +370,8 @@ static struct dyn_ftrace *ftrace_alloc_d
 		rec = ftrace_free_records;
 
 		if (unlikely(!(rec->flags & FTRACE_FL_FREE))) {
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			ftrace_free_records = NULL;
-			ftrace_disabled = 1;
-			ftrace_enabled = 0;
 			return NULL;
 		}
 
@@ -410,7 +420,7 @@ ftrace_record_ip(unsigned long ip)
 
 	key = hash_long(ip, FTRACE_HASHBITS);
 
-	WARN_ON_ONCE(key >= FTRACE_HASHSIZE);
+	FTRACE_WARN_ON_ONCE(key >= FTRACE_HASHSIZE);
 
 	if (ftrace_ip_in_hash(ip, key))
 		goto out;
@@ -602,12 +612,12 @@ ftrace_code_disable(struct dyn_ftrace *r
 	if (ret) {
 		switch (ret) {
 		case -EFAULT:
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on modifying ");
 			print_ip_sym(ip);
 			break;
 		case -EINVAL:
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace failed to modify ");
 			print_ip_sym(ip);
 			print_ip_ins(" expected: ", call);
@@ -616,12 +626,12 @@ ftrace_code_disable(struct dyn_ftrace *r
 			printk(KERN_CONT "\n");
 			break;
 		case -EPERM:
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on writing ");
 			print_ip_sym(ip);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on unknown error ");
 			print_ip_sym(ip);
 		}
@@ -1679,8 +1689,7 @@ static int ftraced(void *ignore)
 					ftrace_update_cnt != 1 ? "s" : "",
 					ftrace_update_tot_cnt,
 					usecs, usecs != 1 ? "s" : "");
-				ftrace_disabled = 1;
-				WARN_ON_ONCE(1);
+				FTRACE_WARN_ON_ONCE(1);
 			}
 		}
 		mutex_unlock(&ftraced_lock);

-- 
