Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYGNOhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYGNOhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYGNOhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:37:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbYGNOhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:37:10 -0400
Date: Mon, 14 Jul 2008 16:36:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/printk for v2.6.27
Message-ID: <20080714143654.GA19518@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the core/printk git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/printk

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      printk: export console_drivers

Jan Kiszka (1):
      printk: don't prefer unsuited consoles on registration

Jiri Slaby (1):
      x86, generic: mark early_printk as asmlinkage

Nick Andrew (2):
      printk: refactor processing of line severity tokens
      printk: remember the message level for multi-line output

Tejun Heo (1):
      printk: clean up recursion check related static variables

Thomas Gleixner (2):
      namespacecheck: fix kernel printk.c
      namespacecheck: more kernel/printk.c fixes


 arch/x86/kernel/early_printk.c |    2 +-
 include/linux/kernel.h         |    8 +---
 kernel/printk.c                |  107 +++++++++++++++++-----------------------
 3 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 643fd86..ff9e735 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -196,7 +196,7 @@ static struct console simnow_console = {
 static struct console *early_console = &early_vga_console;
 static int early_console_initialized;
 
-void early_printk(const char *fmt, ...)
+asmlinkage void early_printk(const char *fmt, ...)
 {
 	char buf[512];
 	int n;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2e70006..f9cd7a5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -187,9 +187,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
-extern int log_buf_get_len(void);
-extern int log_buf_read(int idx);
-extern int log_buf_copy(char *dest, int idx, int len);
 
 extern int printk_ratelimit_jiffies;
 extern int printk_ratelimit_burst;
@@ -205,9 +202,6 @@ static inline int vprintk(const char *s, va_list args) { return 0; }
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
-static inline int log_buf_get_len(void) { return 0; }
-static inline int log_buf_read(int idx) { return 0; }
-static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
 static inline int printk_ratelimit(void) { return 0; }
 static inline int __printk_ratelimit(int ratelimit_jiffies, \
 				     int ratelimit_burst) { return 0; }
@@ -216,7 +210,7 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 		{ return false; }
 #endif
 
-extern void __attribute__((format(printf, 1, 2)))
+extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
 
 unsigned long int_sqrt(unsigned long);
diff --git a/kernel/printk.c b/kernel/printk.c
index e2129e8..de1a4f4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -38,7 +38,7 @@
 /*
  * Architectures can override it:
  */
-void __attribute__((weak)) early_printk(const char *fmt, ...)
+void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 {
 }
 
@@ -75,6 +75,8 @@ EXPORT_SYMBOL(oops_in_progress);
 static DECLARE_MUTEX(console_sem);
 static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
+EXPORT_SYMBOL_GPL(console_drivers);
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
@@ -231,7 +233,7 @@ static inline void boot_delay_msec(void)
 /*
  * Return the number of unread characters in the log buffer.
  */
-int log_buf_get_len(void)
+static int log_buf_get_len(void)
 {
 	return logged_chars;
 }
@@ -268,19 +270,6 @@ int log_buf_copy(char *dest, int idx, int len)
 }
 
 /*
- * Extract a single character from the log buffer.
- */
-int log_buf_read(int idx)
-{
-	char ret;
-
-	if (log_buf_copy(&ret, idx, 1) == 1)
-		return ret;
-	else
-		return -1;
-}
-
-/*
  * Commands to do_syslog:
  *
  * 	0 -- Close the log.  Currently a NOP.
@@ -665,18 +654,17 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 	spin_unlock(&logbuf_lock);
 	return retval;
 }
-
-static const char printk_recursion_bug_msg [] =
-			KERN_CRIT "BUG: recent printk recursion!\n";
-static int printk_recursion_bug;
+static const char recursion_bug_msg [] =
+		KERN_CRIT "BUG: recent printk recursion!\n";
+static int recursion_bug;
+	static int new_text_line = 1;
+static char printk_buf[1024];
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	static int log_level_unknown = 1;
-	static char printk_buf[1024];
-
-	unsigned long flags;
 	int printed_len = 0;
+	int current_log_level = default_message_loglevel;
+	unsigned long flags;
 	int this_cpu;
 	char *p;
 
@@ -699,7 +687,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 * it can be printed at the next appropriate moment:
 		 */
 		if (!oops_in_progress) {
-			printk_recursion_bug = 1;
+			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
 		zap_locks();
@@ -709,70 +697,62 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
-	if (printk_recursion_bug) {
-		printk_recursion_bug = 0;
-		strcpy(printk_buf, printk_recursion_bug_msg);
-		printed_len = sizeof(printk_recursion_bug_msg);
+	if (recursion_bug) {
+		recursion_bug = 0;
+		strcpy(printk_buf, recursion_bug_msg);
+		printed_len = sizeof(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
+
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
 	 */
 	for (p = printk_buf; *p; p++) {
-		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
+		if (new_text_line) {
+			/* If a token, set current_log_level and skip over */
+			if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
+			    p[2] == '>') {
+				current_log_level = p[1] - '0';
+				p += 3;
+				printed_len -= 3;
+			}
+
+			/* Always output the token */
+			emit_log_char('<');
+			emit_log_char(current_log_level + '0');
+			emit_log_char('>');
+			printed_len += 3;
+			new_text_line = 0;
+
 			if (printk_time) {
-				int loglev_char;
+				/* Follow the token with the time */
 				char tbuf[50], *tp;
 				unsigned tlen;
 				unsigned long long t;
 				unsigned long nanosec_rem;
 
-				/*
-				 * force the log level token to be
-				 * before the time output.
-				 */
-				if (p[0] == '<' && p[1] >='0' &&
-				   p[1] <= '7' && p[2] == '>') {
-					loglev_char = p[1];
-					p += 3;
-					printed_len -= 3;
-				} else {
-					loglev_char = default_message_loglevel
-						+ '0';
-				}
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
-						loglev_char,
-						(unsigned long)t,
-						nanosec_rem/1000);
+				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+						(unsigned long) t,
+						nanosec_rem / 1000);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);
 				printed_len += tlen;
-			} else {
-				if (p[0] != '<' || p[1] < '0' ||
-				   p[1] > '7' || p[2] != '>') {
-					emit_log_char('<');
-					emit_log_char(default_message_loglevel
-						+ '0');
-					emit_log_char('>');
-					printed_len += 3;
-				}
 			}
-			log_level_unknown = 0;
+
 			if (!*p)
 				break;
 		}
+
 		emit_log_char(*p);
 		if (*p == '\n')
-			log_level_unknown = 1;
+			new_text_line = 1;
 	}
 
 	/*
@@ -1172,8 +1152,11 @@ void register_console(struct console *console)
 			console->index = 0;
 		if (console->setup == NULL ||
 		    console->setup(console, NULL) == 0) {
-			console->flags |= CON_ENABLED | CON_CONSDEV;
-			preferred_console = 0;
+			console->flags |= CON_ENABLED;
+			if (console->device) {
+				console->flags |= CON_CONSDEV;
+				preferred_console = 0;
+			}
 		}
 	}
 
