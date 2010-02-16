Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0BPDNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 22:13:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:63180 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab0BPDNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 22:13:18 -0500
Message-ID: <4B7A0D2D.2010806@windriver.com>
Date: Mon, 15 Feb 2010 21:12:45 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 22/28] printk,kdb: capture printk() when in kdb shell
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-23-git-send-email-jason.wessel@windriver.com><20100212145440.7f0c68d0.akpm@linux-foundation.org><4B75E236.7060108@windriver.com> <20100212203922.d8fef332.akpm@linux-foundation.org>
In-Reply-To: <20100212203922.d8fef332.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000409060609090903080308"
X-OriginalArrivalTime: 16 Feb 2010 03:12:46.0567 (UTC) FILETIME=[E9A48F70:01CAAEB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000409060609090903080308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Fri, 12 Feb 2010 17:20:22 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> If you feel that would be cleaner, I can make that change, but I would
>> also have to call vprintk() from vkdb_printf when ever kdb_trap_printk
>> is not set.  Do I understand your recommendation correctly?
>>
>>     
>
> Was trying to find
> a way to avoid the code duplication.
>
>
>   


You did make me think about the interface a bit further.  If you were
going to ack one of the versions of this patch, which would you prefer? 
The previous version, this new version or something else?

The difference here is that we use a replaced function call vs using the
if statement.  There are more lines source in the kdb, but the interface
api is clean.

Thanks,
Jason.

--------------000409060609090903080308
Content-Type: text/x-diff;
 name="kdb_printk_integration.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kdb_printk_integration.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] printk,kdb: capture printk() when in kdb shell

Certain calls from the kdb shell will call out to printk(), and any of
these calls should get vectored back to the kdb_printf() so that the
kdb pager and processing can be used, as well as to properly channel
I/O to the polled I/O devices.

CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/kdb.h         |    6 ++++
 kernel/debug/kdb/kdb_bt.c   |    2 +
 kernel/debug/kdb/kdb_io.c   |   56 ++++++++++++++++++++++++++++++++++++++++----
 kernel/debug/kdb/kdb_main.c |    4 +++
 kernel/printk.c             |    8 +++++-
 5 files changed, 71 insertions(+), 5 deletions(-)

--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -78,6 +78,12 @@ typedef enum {
 	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
 } kdb_reason_t;
 
+/* kdb printk and lowlevel kernel printk interface */
+extern asmlinkage int (*vprintk_func) (const char *, va_list);
+extern void kdb_trap_printk_enable(void);
+extern void kdb_trap_printk_disable(void);
+extern asmlinkage int vkdb_printf(const char *fmt, va_list args)
+	    __attribute__ ((format (printf, 1, 0)));
 extern int kdb_printf(const char *, ...)
 	    __attribute__ ((format (printf, 1, 2)));
 typedef int (*kdb_printf_t)(const char *, ...)
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -23,6 +23,7 @@ static void kdb_show_stack(struct task_s
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk_enable();
 	kdb_set_current_task(p);
 	if (addr) {
 		show_stack((struct task_struct *)p, addr);
@@ -36,6 +37,7 @@ static void kdb_show_stack(struct task_s
 		show_stack(p, NULL);
 	}
 	console_loglevel = old_lvl;
+	kdb_trap_printk_disable();
 }
 
 /*
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -582,6 +582,12 @@ static int have_callable_console(void)
 	return 0;
 }
 
+#ifdef CONFIG_KGDB_KDB
+asmlinkage int (*vprintk_func) (const char *, va_list) = vprintk;
+#else
+#define vprintk_func(x, y) vprintk(x, y)
+#endif
+
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -610,7 +616,7 @@ asmlinkage int printk(const char *fmt, .
 	int r;
 
 	va_start(args, fmt);
-	r = vprintk(fmt, args);
+	r = vprintk_func(fmt, args);
 	va_end(args);
 
 	return r;
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -29,6 +29,36 @@
 #define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
+static int kdb_trap_printk;
+
+#ifdef CONFIG_PRINTK
+static inline void kdb_vprintk_func_set(void)
+{
+	vprintk_func = vkdb_printf;
+}
+
+static inline void kdb_vprintk_func_restore(void)
+{
+	vprintk_func = vprintk;
+}
+#else /* ! CONFIG_PRINTK */
+#define kdb_vprintk_func_set()
+#define kdb_vprintk_func_restore()
+#endif /* ! CONFIG_PRINTK */
+
+void kdb_trap_printk_enable(void)
+{
+	if (!kdb_trap_printk)
+		kdb_vprintk_func_set();
+	kdb_trap_printk++;
+}
+
+void kdb_trap_printk_disable(void)
+{
+	kdb_trap_printk--;
+	if (!kdb_trap_printk)
+		kdb_vprintk_func_restore();
+}
 
 static void kgdb_transition_check(char *buffer)
 {
@@ -533,12 +563,12 @@ static int kdb_search_string(char *searc
 	return 0;
 }
 
-int kdb_printf(const char *fmt, ...)
+asmlinkage int vkdb_printf(const char *fmt, va_list ap)
 {
-	va_list ap;
 	int diag;
 	int linecount;
 	int logging, saved_loglevel = 0;
+	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int retlen = 0;
 	int fnd, len;
@@ -549,6 +579,10 @@ int kdb_printf(const char *fmt, ...)
 	unsigned long uninitialized_var(flags);
 
 	preempt_disable();
+	saved_trap_printk = kdb_trap_printk;
+	kdb_trap_printk = 0;
+	kdb_vprintk_func_restore();
+
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
 	 * even if it is interleaved with any other text.
@@ -575,9 +609,7 @@ int kdb_printf(const char *fmt, ...)
 		next_avail = kdb_buffer;
 		size_avail = sizeof(kdb_buffer);
 	}
-	va_start(ap, fmt);
 	vsnprintf(next_avail, size_avail, fmt, ap);
-	va_end(ap);
 
 	/*
 	 * If kdb_parse() found that the command was cmd xxx | grep yyy
@@ -805,6 +837,22 @@ kdb_print_out:
 	} else {
 		__release(kdb_printf_lock);
 	}
+	kdb_trap_printk = saved_trap_printk;
+	if (kdb_trap_printk > 0)
+		kdb_vprintk_func_set();
 	preempt_enable();
 	return retlen;
 }
+
+int kdb_printf(const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = vkdb_printf(fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1056,7 +1056,9 @@ static void kdb_dumpregs(struct pt_regs 
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk_enable();
 	show_regs(regs);
+	kdb_trap_printk_disable();
 	kdb_printf("\n");
 	console_loglevel = old_lvl;
 }
@@ -1823,7 +1825,9 @@ static int kdb_sr(int argc, const char *
 		__sysrq_enabled = 1;
 	}
 
+	kdb_trap_printk_enable();
 	handle_sysrq(*argv[1], NULL);
+	kdb_trap_printk_disable();
 
 	return 0;
 }

--------------000409060609090903080308--
