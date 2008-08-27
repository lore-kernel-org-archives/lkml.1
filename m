Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYH0HkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYH0HkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH0Hjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:39:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:17782 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYH0Hjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Je1OdDmFq2wOgMADK8oDVjw72vA+Rvq0Zj1qpQMWQp1sQrNpbJoYjZh6e5Tg+3oX2a
         wMiivVXLuqpyDd5uP31mnUTz1FYOOqX0uyCQ/NDYkf5FV6g1Pect4g39IvzyBAvmR1Hy
         9gKIyhfkDeQTUtPtTdSEXD47W33hWIqvoyQtY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] printk_time: prepare stub for using other than cpu_clock
Date: Wed, 27 Aug 2008 00:38:55 -0700
Message-Id: <1219822736-18628-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/kernel.h |    5 +++++
 init/main.c            |    1 +
 kernel/printk.c        |   14 +++++++++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -190,7 +190,10 @@ extern int kernel_text_address(unsigned
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
+typedef unsigned long long (*printk_time_clock_fn)(int cpu);
 #ifdef CONFIG_PRINTK
+extern void set_printk_time_clock(printk_time_clock_fn fn);
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -201,6 +204,8 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 #else
+static inline void set_printk_time_clock(printk_time_clock_fn fn) { }
+
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 static inline int vprintk(const char *s, va_list args) { return 0; }
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -671,6 +671,7 @@ asmlinkage void __init start_kernel(void
 	if (late_time_init)
 		late_time_init();
 	calibrate_delay();
+	set_printk_time_clock(cpu_clock);
 	pidmap_init();
 	pgtable_cache_init();
 	prio_tree_init();
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -659,6 +659,18 @@ static int recursion_bug;
 	static int new_text_line = 1;
 static char printk_buf[1024];
 
+static unsigned long long default_printk_time_clock(int cpu)
+{
+	return 0;
+}
+
+static printk_time_clock_fn printk_time_clock = default_printk_time_clock;
+
+void set_printk_time_clock(printk_time_clock_fn fn)
+{
+	printk_time_clock = fn;
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -734,7 +746,7 @@ asmlinkage int vprintk(const char *fmt,
 				unsigned long long t;
 				unsigned long nanosec_rem;
 
-				t = cpu_clock(printk_cpu);
+				t = printk_time_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
 						(unsigned long) t,
