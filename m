Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZLWVWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZLWVWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZLWVV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:45328 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbZLWVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 25/37] printk,kdb: capture printk() when in kdb shell
Date: Wed, 23 Dec 2009 15:19:38 -0600
Message-Id: <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:25.0380 (UTC) FILETIME=[BE34EE40:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain calls from the kdb shell will call out to printk(), and any of
these calls should get vectored back to the kdb_printf() so that the
kdb pager and processing can be used, as well as to properly channel
I/O to the polled I/O devices.

CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kdb.h         |    4 ++++
 kernel/debug/kdb/kdb_bt.c   |    2 ++
 kernel/debug/kdb/kdb_io.c   |   21 +++++++++++++++++----
 kernel/debug/kdb/kdb_main.c |    4 ++++
 kernel/printk.c             |   10 +++++++++-
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 1d8c1ac..387a916 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -80,8 +80,12 @@ typedef enum {
 	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
 } kdb_reason_t;
 
+extern int kdb_trap_printk;
+extern void vkdb_printf(const char *fmt, va_list args)
+	    __attribute__ ((format (printf, 1, 0)));
 extern void kdb_printf(const char *, ...)
 	    __attribute__ ((format (printf, 1, 2)));
+
 typedef void (*kdb_printf_t)(const char *, ...)
 	     __attribute__ ((format (printf, 1, 2)));
 extern void kdb_init(void);
diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index c73402c..176da1a 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -23,6 +23,7 @@ static void kdb_show_stack(struct task_struct *p, void *addr)
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk++;
 	kdb_set_current_task(p);
 	if (addr) {
 		show_stack((struct task_struct *)p, addr);
@@ -36,6 +37,7 @@ static void kdb_show_stack(struct task_struct *p, void *addr)
 		show_stack(p, NULL);
 	}
 	console_loglevel = old_lvl;
+	kdb_trap_printk--;
 }
 
 /*
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 17aa1f2..75f4355 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -29,6 +29,7 @@
 #define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
+int kdb_trap_printk;
 
 static void kgdb_transition_check(char *buffer)
 {
@@ -533,12 +534,12 @@ static int kdb_search_string(char *searched, char *searchfor)
 	return 0;
 }
 
-void kdb_printf(const char *fmt, ...)
+void vkdb_printf(const char *fmt, va_list ap)
 {
-	va_list ap;
 	int diag;
 	int linecount;
 	int logging, saved_loglevel = 0;
+	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int fnd, len;
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
@@ -548,6 +549,9 @@ void kdb_printf(const char *fmt, ...)
 	unsigned long uninitialized_var(flags);
 
 	preempt_disable();
+	saved_trap_printk = kdb_trap_printk;
+	kdb_trap_printk = 0;
+
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
 	 * even if it is interleaved with any other text.
@@ -574,9 +578,7 @@ void kdb_printf(const char *fmt, ...)
 		next_avail = kdb_buffer;
 		size_avail = sizeof(kdb_buffer);
 	}
-	va_start(ap, fmt);
 	vsnprintf(next_avail, size_avail, fmt, ap);
-	va_end(ap);
 
 	/*
 	 * If kdb_parse() found that the command was cmd xxx | grep yyy
@@ -803,5 +805,16 @@ kdb_print_out:
 	} else {
 		__release(kdb_printf_lock);
 	}
+	kdb_trap_printk = saved_trap_printk;
 	preempt_enable();
 }
+
+void kdb_printf(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vkdb_printf(fmt, ap);
+	va_end(ap);
+}
+
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index e0754c8..cb97359 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1058,7 +1058,9 @@ void kdb_dumpregs(struct pt_regs *regs)
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk++;
 	show_regs(regs);
+	kdb_trap_printk--;
 	kdb_printf("\n");
 	console_loglevel = old_lvl;
 }
@@ -1837,7 +1839,9 @@ static int kdb_sr(int argc, const char **argv)
 		__sysrq_enabled = 1;
 	}
 
+	kdb_trap_printk++;
 	handle_sysrq(*argv[1], NULL);
+	kdb_trap_printk--;
 
 	return 0;
 }
diff --git a/kernel/printk.c b/kernel/printk.c
index 9bee02e..3321a3a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/kdb.h>
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 
@@ -608,7 +609,14 @@ asmlinkage int printk(const char *fmt, ...)
 {
 	va_list args;
 	int r;
-
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		va_start(args, fmt);
+		vkdb_printf(fmt, args);
+		va_end(args);
+		return 0;
+	}
+#endif
 	va_start(args, fmt);
 	r = vprintk(fmt, args);
 	va_end(args);
-- 
1.6.4.rc1

