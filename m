Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYG2KK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYG2KK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbYG2KKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:10:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:19464 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbYG2KKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=P6scDml8OBEAe6vZOwu56YAabhTgfXbTGU8gVZrEcDa1pi+BsK608xTo9IDTf8NlUF
         S5fIvxwDpaMHMmVBaoC/1cptZ+5C0OdsNQH5rOIZ7lpcSbdQiooWq4KGC4eyV+5+qXJ1
         TEu/RoXU9VBlfVBWNEc6Urz8Dt4GMc0Cht768=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] printk_time: prepare stub for using other than cpu_clock
Date: Tue, 29 Jul 2008 03:08:34 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290308.35230.yhlu.kernel@gmail.com>
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
@@ -184,7 +184,10 @@ extern int kernel_text_address(unsigned
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
+typedef unsigned long long (*printk_time_clock_fn)(int cpu);
 #ifdef CONFIG_PRINTK
+extern void set_printk_time_clock(printk_time_clock_fn fn);
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
@@ -195,6 +198,8 @@ extern int printk_ratelimit(void);
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
@@ -663,6 +663,7 @@ asmlinkage void __init start_kernel(void
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
@@ -662,6 +662,18 @@ static int recursion_bug;
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
@@ -737,7 +749,7 @@ asmlinkage int vprintk(const char *fmt,
 				unsigned long long t;
 				unsigned long nanosec_rem;
 
-				t = cpu_clock(printk_cpu);
+				t = printk_time_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
 						(unsigned long) t,
