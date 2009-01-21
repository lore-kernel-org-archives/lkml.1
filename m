Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZAURql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZAURql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZAURqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:46:31 -0500
Received: from relay00.pair.com ([209.68.5.9]:1243 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752909AbZAURqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:46:30 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 12:46:29 EST
X-pair-Authenticated: 66.134.71.115
From: Grant Erickson <gerickson@nuovations.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Add Alternative Log Buffer Support for printk Messages
Date: Wed, 21 Jan 2009 09:39:46 -0800
Message-Id: <1232559586-9164-1-git-send-email-gerickson@nuovations.com>
X-Mailer: git-send-email 1.6.1
Organization: Nuovation System Designs, LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This merges support for the previously DENX-only kernel feature of
specifying an alternative, "external" buffer for kernel printk
messages and their associated metadata. In addition, this ports
architecture support for this feature from arch/ppc to arch/powerpc.

When this option is enabled, an architecture- or machine-specific log
buffer is used for all printk messages. This allows entities such as
boot loaders (e.g. U-Boot) to place printk-compatible messages into
this buffer and for the kernel to coalesce them with its normal
messages.

Signed-off-by: Grant Erickson <gerickson@nuovations.com>
---

The code has historically been used and proven to work on the LWMON5
platform under arch/ppc and is now used (by me) successfully on the
AMCC Haleakala and Kilauea platforms.

As implemented for arch/powerpc, two suboptions for the alternative
log buffer are supported. The buffer may be contiguous with the
metadata and message data colocated or the metadata and message
storage may be in discontiguous regions of memory (e.g. a set of
scratch registers and an SRAM buffer). On Kilauea and Haleakala, I
have used the former; whereas LWMON5 has traditionally used the latter.

The code here is, more or less, as-is from the DENX GIT tree. Comments
welcome. Some prior discussion from the linuxppc-dev mailing list is at
http://ozlabs.org/pipermail/linuxppc-dev/2008-November/065589.html.

 arch/powerpc/kernel/prom.c |   93 +++++++++++++++++++++++++++
 include/linux/logbuff.h    |   56 ++++++++++++++++
 init/Kconfig               |   25 +++++++
 init/main.c                |    4 +
 kernel/printk.c            |  149 +++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 324 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/logbuff.h

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 3a2dc7e..60282f1 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/lmb.h>
+#include <linux/logbuff.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -61,6 +62,15 @@
 #define DBG(fmt...)
 #endif
 
+#ifdef CONFIG_LOGBUFFER
+#ifdef CONFIG_ALT_LB_LOCATION
+# if !defined(BOARD_ALT_LH_ADDR) || !defined(BOARD_ALT_LB_ADDR)
+#  error "Please specify BOARD_ALT_LH_ADDR & BOARD_ALT_LB_ADDR."
+# endif
+#else /* !CONFIG_ALT_LB_LOCATION */
+static phys_addr_t ext_logbuff;
+#endif /* CONFIG_ALT_LB_LOCATION */
+#endif /* CONFIG_LOGBUFFER */
 
 static int __initdata dt_root_addr_cells;
 static int __initdata dt_root_size_cells;
@@ -1018,6 +1028,85 @@ static int __init early_init_dt_scan_memory(unsigned long node,
 	return 0;
 }
 
+#ifdef CONFIG_LOGBUFFER
+#ifdef CONFIG_ALT_LB_LOCATION
+/* Alternative external log buffer mapping: log metadata header & the
+ * character buffer are separated and allocated not in RAM but in some
+ * other memory-mapped I/O region (e.g. log head in unused registers,
+ * and log buffer in OCM memory)
+ */
+int __init setup_ext_logbuff_mem(volatile logbuff_t **lhead, char **lbuf)
+{
+	void *h, *b;
+
+	if (unlikely(!lhead) || unlikely(!lbuf))
+		return -EINVAL;
+
+	/* map log head */
+	h = ioremap(BOARD_ALT_LH_ADDR, sizeof(logbuff_t));
+	if (unlikely(!h))
+		return -EFAULT;
+
+	/* map log buffer */
+	b = ioremap(BOARD_ALT_LB_ADDR, LOGBUFF_LEN);
+	if (unlikely(!b)) {
+		iounmap(h);
+		return -EFAULT;
+	}
+
+	*lhead = h;
+	*lbuf = b;
+
+	return 0;
+}
+#else /* !CONFIG_ALT_LB_LOCATION */
+/* Usual external log-buffer mapping: log metadata header & the character
+ * buffer are both contiguous in system RAM.
+ */
+int __init setup_ext_logbuff_mem(logbuff_t **lhead, char **lbuf)
+{
+	void *p;
+
+	if (unlikely(!lhead) || unlikely(!lbuf))
+		return -EINVAL;
+
+	if (unlikely(!ext_logbuff) || !lmb_is_reserved(ext_logbuff))
+		return -EFAULT;
+
+	p = ioremap(ext_logbuff, LOGBUFF_RESERVE);
+
+	if (unlikely(!p))
+		return -EFAULT;
+
+	*lhead = (logbuff_t *)(p + LOGBUFF_OVERHEAD -
+			       sizeof(logbuff_t) +
+			       sizeof(((logbuff_t *)0)->buf));
+	*lbuf = (*lhead)->buf;
+
+	return 0;
+}
+
+/* When the external log buffer configuration is used with the
+ * non-alternate location, the log head metadata and character buffer
+ * lie in the LOGBUFF_RESERVE bytes at the end of system RAM. Add this
+ * block of memory to the reserved memory pool so that it is not
+ * allocated for other purposes.
+ */
+static void __init reserve_ext_logbuff_mem(void)
+{
+	phys_addr_t top = lmb_end_of_DRAM();
+	phys_addr_t size = LOGBUFF_RESERVE;
+	phys_addr_t base = top - size;
+
+	if (top > base) {
+		ext_logbuff = base;
+		DBG("reserving: %x -> %x\n", base, size);
+		lmb_reserve(base, size);
+	}
+}
+#endif /* CONFIG_ALT_LB_LOCATION */
+#endif /* CONFIG_LOGBUFFER */
+
 static void __init early_reserve_mem(void)
 {
 	u64 base, size;
@@ -1033,6 +1122,10 @@ static void __init early_reserve_mem(void)
 	self_size = initial_boot_params->totalsize;
 	lmb_reserve(self_base, self_size);
 
+#if defined(CONFIG_LOGBUFFER) && !defined(CONFIG_ALT_LB_LOCATION)
+	reserve_ext_logbuff_mem();
+#endif /* defined(CONFIG_LOGBUFFER) && !defined(CONFIG_ALT_LB_LOCATION) */
+
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* then reserve the initrd, if any */
 	if (initrd_start && (initrd_end > initrd_start))
diff --git a/include/linux/logbuff.h b/include/linux/logbuff.h
new file mode 100644
index 0000000..22a51c0
--- /dev/null
+++ b/include/linux/logbuff.h
@@ -0,0 +1,56 @@
+/*
+ * (C) Copyright 2007
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * See file CREDITS for list of people who contributed to this
+ * project.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+#ifndef _LOGBUFF_H_
+#define _LOGBUFF_H_
+
+#ifdef CONFIG_LOGBUFFER
+
+#define LOGBUFF_MAGIC		0xc0de4ced
+#define LOGBUFF_LEN		16384
+#define LOGBUFF_OVERHEAD	4096
+#define LOGBUFF_RESERVE		(LOGBUFF_LEN + LOGBUFF_OVERHEAD)
+
+/* The mapping used here has to be the same as in logbuff_init_ptrs ()
+   in u-boot/common/cmd_log.c */
+
+typedef struct {
+	unsigned long	tag;
+	unsigned long	start;
+	unsigned long	con;	/* next char to be sent to consoles	*/
+	unsigned long	end;
+	unsigned long	chars;
+	unsigned char	buf[0];
+} logbuff_t;
+
+#ifdef CONFIG_ALT_LB_LOCATION
+# define LOGBUFF_VOLATILE	volatile
+#else
+# define LOGBUFF_VOLATILE
+#endif /* defined(CONFIG_ALT_LB_LOCATION) */
+
+extern void setup_ext_logbuff(void);
+/* arch specific */
+extern int setup_ext_logbuff_mem(LOGBUFF_VOLATILE logbuff_t **lhead, char **lbuf);
+
+#endif /* CONFIG_LOGBUFFER */
+#endif /* _LOGBUFF_H_ */
diff --git a/init/Kconfig b/init/Kconfig
index f763762..e1a1b59 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -619,6 +619,31 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config LOGBUFFER
+	bool "External logbuffer" if PRINTK
+	default n
+	help
+	  This option enables support for an alternative, "external"
+	  printk log buffer. When enabled, an architecture- or machine-
+	  specific log buffer is used for all printk messages. This
+	  allows entities such as boot loaders to place printk-compatible
+	  messages into this buffer and for the kernel to coalesce them
+	  with its normal messages.
+
+config ALT_LB_LOCATION
+	bool "Alternative logbuffer" if LOGBUFFER
+	default n
+	help
+	  When using an alternative, "external" printk log buffer, an
+	  architecture- or machine-specific log buffer with contiguous
+	  metadata and message storage is used. This option enables
+	  support for discontiguous metadata and message storage
+	  memory (e.g. a set of scratch registers and an SRAM
+	  buffer). By saying Y here, you must also ensure your
+	  architecture- or machine-code specify BOARD_ALT_LH_ADDR and
+	  BOARD_ALT_LB_ADDR, for the metadata and message memory,
+	  respectively.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/init/main.c b/init/main.c
index 7e117a2..5687b98 100644
--- a/init/main.c
+++ b/init/main.c
@@ -61,6 +61,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/logbuff.h>
 #include <linux/idr.h>
 #include <linux/ftrace.h>
 
@@ -563,6 +564,9 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
+#ifdef CONFIG_LOGBUFFER
+	setup_ext_logbuff();
+#endif
 	lock_kernel();
 	tick_init();
 	boot_cpu_init();
diff --git a/kernel/printk.c b/kernel/printk.c
index f492f15..59884e2 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/logbuff.h>
 
 #include <asm/uaccess.h>
 
@@ -101,9 +102,39 @@ static DEFINE_SPINLOCK(logbuf_lock);
  * The indices into log_buf are not constrained to log_buf_len - they
  * must be masked before subscripting
  */
+#ifdef CONFIG_LOGBUFFER
+/* Indexes to the local log buffer */
+static unsigned long _log_start;
+static unsigned long _con_start;
+static unsigned long _log_end;
+static unsigned long _logged_chars;
+/* These will be switched to the external log buffer */
+#ifndef CONFIG_ALT_LB_LOCATION
+/* usual logbuffer location */
+static unsigned long *ext_log_start = &_log_start;
+static unsigned long *ext_con_start = &_con_start;
+static unsigned long *ext_log_end = &_log_end;
+static unsigned long *ext_logged_chars = &_logged_chars;
+#define log_start	(*ext_log_start)
+#define con_start	(*ext_con_start)
+#define log_end		(*ext_log_end)
+#define logged_chars	(*ext_logged_chars)
+#else /* defined(CONFIG_ALT_LB_LOCATION) */
+/* alternative logbuffer location */
+static volatile unsigned long *ext_log_start = &_log_start;
+static volatile unsigned long *ext_con_start = &_con_start;
+static volatile unsigned long *ext_log_end = &_log_end;
+static volatile unsigned long *ext_logged_chars = &_logged_chars;
+#define log_start       (*((volatile u32 *)ext_log_start))
+#define con_start       (*((volatile u32 *)ext_con_start))
+#define log_end         (*((volatile u32 *)ext_log_end))
+#define logged_chars    (*((volatile u32 *)ext_logged_chars))
+#endif /* !defined(CONFIG_ALT_LB_LOCATION) */
+#else /* !defined(CONFIG_LOGBUFFER) */
 static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
 static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
+#endif /* CONFIG_LOGBUFFER */
 
 /*
  *	Array of consoles built from command line options (console=)
@@ -134,10 +165,121 @@ static int console_may_schedule;
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
+#ifndef CONFIG_LOGBUFFER
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
+#endif /* !defined(CONFIG_LOGBUFFER) */
+#ifdef CONFIG_LOGBUFFER
+/* Sanity check the external log buffer metadata. When an the external
+ * log buffer is enabled, the log metadata is effectively non-volatile
+ * in that the values are preserved from reboot to reboot (until/unless
+ * the system loses power).
+ */
+static void __init logbuff_check_metadata(LOGBUFF_VOLATILE logbuff_t *log)
+{
+	unsigned long chars;
+
+	/* Sanity check the producer and consumer indices. */
+
+	if (log->end - log->start > LOGBUFF_LEN)
+		log->start = log->end - LOGBUFF_LEN;
+
+	if (log->end - log->con > LOGBUFF_LEN)
+		log->con = log->end - LOGBUFF_LEN;
+
+	/* Occasionally, particularly following a reboot, the start
+	 * consumer index is not properly caught up to the console
+	 * consumer index. If this is the case, catch it up so that
+	 * the log buffer doesn't start with, for example,
+	 * "<0>Restarting system.\n" followed by the 'real' start of
+	 * the log.
+	 */
+
+	if (log->con > log->start)
+		log->start = log->con;
+
+	/* Ensure that the number of characters logged reflects the
+	 * characters actually logged based on the producer and
+	 * consumer indices rather than all characters cumulatively
+	 * logged across all reboots since a power-loss event.
+	 */
+
+	chars = log->end - log->start;
+
+	if (log->chars > chars)
+		log->chars = chars;
+}
+
+/* Coalesce the current log bounded buffer and the external log
+ * bounded buffer by appending the former to the latter. Precedence is
+ * given to the external log buffer when there is more data to be
+ * appended than space exists, so the current log buffer is truncated
+ * instead of overwritting the external buffer.
+ */
+static void __init logbuff_coalesce_buffers(LOGBUFF_VOLATILE logbuff_t *log)
+{
+	unsigned long dspace, ssize, len;
+
+	dspace = LOGBUFF_LEN - (log->end - log->start);
+	ssize = log_end - log_start;
+	len = min(dspace, ssize);
+
+	while (len-- > 0) {
+		log->buf[log->end++ & (LOGBUFF_LEN-1)] = LOG_BUF(log_start++);
+		log->chars++;
+	}
+}
 
+void __init setup_ext_logbuff(void)
+{
+	LOGBUFF_VOLATILE logbuff_t *log;
+	char *ext_log_buf = NULL;
+	unsigned long flags;
+
+	if (setup_ext_logbuff_mem(&log, &ext_log_buf) < 0) {
+		printk(KERN_WARNING
+		       "Failed to setup external logbuffer - ignoring it\n");
+		return;
+	}
+
+	/* When no properly setup buffer is found, reset pointers */
+	if (log->tag != LOGBUFF_MAGIC) {
+		printk(KERN_WARNING
+		       "Unexpected external log buffer magic number. "
+		       "Got %08lx, expected %08x. Resetting pointers and using "
+		       "the buffer anyway.\n",
+		       log->tag, LOGBUFF_MAGIC);
+		log->tag = LOGBUFF_MAGIC;
+		log->start = log->end = log->con = log->chars = 0;
+	}
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+
+	logbuff_check_metadata(log);
+	logbuff_coalesce_buffers(log);
+
+	/* Switch to the external log buffer */
+	ext_log_start		= &log->start;
+	ext_con_start		= &log->con;
+	ext_log_end		= &log->end;
+	ext_logged_chars	= &log->chars;
+
+	log_buf			= ext_log_buf;
+	log_buf_len 		= LOGBUFF_LEN;
+
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	printk(KERN_NOTICE "log_buf=%p\n", log_buf);
+}
+#endif /* CONFIG_LOGBUFFER */
 static int __init log_buf_len_setup(char *str)
 {
+#ifdef CONFIG_LOGBUFFER
+	/* Log buffer size is LOGBUFF_LEN bytes */
+	printk(KERN_NOTICE
+	       "External log buffer configured; "
+	       "ignoring log_buf_len param.\n");
+	return 1;
+#else
 	unsigned size = memparse(str, &str);
 	unsigned long flags;
 
@@ -173,6 +315,7 @@ static int __init log_buf_len_setup(char *str)
 	}
 out:
 	return 1;
+#endif /* CONFIG_LOGBUFFER */
 }
 
 __setup("log_buf_len=", log_buf_len_setup);
@@ -230,7 +373,7 @@ static void boot_delay_msec(void)
 static inline void boot_delay_msec(void)
 {
 }
-#endif
+#endif /* CONFIG_BOOT_PRINTK_DELAY */
 
 /*
  * Commands to do_syslog:
@@ -740,7 +883,7 @@ out_restore_irqs:
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
-#else
+#else /* !CONFIG_PRINTK */
 
 asmlinkage long sys_syslog(int type, char __user *buf, int len)
 {
@@ -751,7 +894,7 @@ static void call_console_drivers(unsigned start, unsigned end)
 {
 }
 
-#endif
+#endif /* CONFIG_PRINTK */
 
 static int __add_preferred_console(char *name, int idx, char *options,
 				   char *brl_options)
-- 
1.6.0.4
