Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYJBXWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYJBXWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYJBXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:22:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbYJBXW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:22:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] printk.caller
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Melodic winter gumption
   (2) Burrowing charismatic baskets
   (3) Enigmatic flake exclamations
Message-Id: <20081002232115.8D2BB154212@magilla.localdomain>
Date: Thu,  2 Oct 2008 16:21:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the printk.caller=[0|1] boot parameter, default setting
controlled by CONFIG_PRINTK_CALLER.  (This is modelled on printk.time
and CONFIG_PRINTK_TIME.)

When this is set, each printk line is automagically prefixed with
"{0x123abc} " giving the PC address of that printk call (actually
the PC address just after the call).

As a kernel hacker, I always hate having to grep for some fragment
of a message to find the code that generated it.  But I always have
my -g vmlinux handy, so:
	(gdb) info line *(0x123abc - 1)
is real handy (it pops the source up in an Emacs buffer).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Documentation/kernel-parameters.txt |    3 ++
 include/linux/kernel.h              |    4 ++-
 kernel/printk.c                     |   38 +++++++++++++++++++++++++++++-----
 lib/Kconfig.debug                   |    9 ++++++++
 4 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..9f1e1b9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1689,6 +1689,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
+	printk.caller=	Show caller PC prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..e03b475 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -191,7 +191,9 @@ struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 #ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
+# define vprintk(fmt, args) \
+	vprintk_caller(fmt, args, __builtin_return_address(0))
+asmlinkage int vprintk_caller(const char *fmt, va_list args, void *caller)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..e4294c8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -532,6 +532,12 @@ static void emit_log_char(char c)
 		logged_chars++;
 }
 
+static void emit_log_chars(const char *p, unsigned n)
+{
+	while (n-- > 0)
+		emit_log_char(*p++);
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
@@ -560,6 +566,13 @@ static int printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+#if defined(CONFIG_PRINTK_CALLER)
+static int printk_caller = 1;
+#else
+static int printk_caller = 0;
+#endif
+module_param_named(caller, printk_caller, bool, S_IRUGO | S_IWUSR);
+
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -662,7 +675,7 @@ static int recursion_bug;
 	static int new_text_line = 1;
 static char printk_buf[1024];
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+asmlinkage int vprintk_caller(const char *fmt, va_list args, void *caller)
 {
 	int printed_len = 0;
 	int current_log_level = default_message_loglevel;
@@ -708,7 +721,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
-
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
@@ -732,7 +744,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 
 			if (printk_time) {
 				/* Follow the token with the time */
-				char tbuf[50], *tp;
+				char tbuf[50];
 				unsigned tlen;
 				unsigned long long t;
 				unsigned long nanosec_rem;
@@ -743,11 +755,25 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 						(unsigned long) t,
 						nanosec_rem / 1000);
 
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
+				emit_log_chars(tbuf, tlen);
 				printed_len += tlen;
 			}
 
+			if (caller && printk_caller) {
+				char pbuf[sizeof caller * 2 + sizeof "{0x} "];
+				unsigned plen;
+
+				if (sizeof caller > 4)
+					plen = sprintf(pbuf, "{0x%016lx} ",
+						       (unsigned long) caller);
+				else
+					plen = sprintf(pbuf, "{0x%08lx} ",
+						       (unsigned long) caller);
+
+				emit_log_chars(pbuf, plen);
+				printed_len += plen;
+			}
+
 			if (!*p)
 				break;
 		}
@@ -778,7 +804,7 @@ out_restore_irqs:
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
-EXPORT_SYMBOL(vprintk);
+EXPORT_SYMBOL(vprintk_caller);
 
 #else
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..b90134e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -9,6 +9,15 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config PRINTK_CALLER
+	bool "Show caller PC on printks"
+	depends on PRINTK
+	help
+	  Selecting this option causes printk output to include
+	  the PC address of the printk call.  This is useful for
+	  kernels hackers to quickly locate the source code that
+	  produced the message.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
