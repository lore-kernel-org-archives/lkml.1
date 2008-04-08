Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYDHSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYDHSCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYDHSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:02:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYDHSCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:02:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] PRINTK: Decouple input locking from output locking and move
	render outside lock
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 08 Apr 2008 19:01:29 +0100
Message-ID: <20080408180129.21772.9835.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decouple the printk input locking from the output locking using a dual-tailed
ring buffer, and move the render (vscnprintf) and processing (log level token
inclusion and timestamp inclusion) outside of the input locked section.

	+---------+
	|         |
	| vprintk |
	|         |
	+---------+                                   +-----------------+
	     |                                        |                 |
	     V                                   +--->| Syslog syscall  |
	+---------+                              |    |                 |
	|         |                              |    +-----------------+
	| Render  |                              |
	|         |                              |    +-----------------+
	+---------+      +-------------------+   |    |                 |
	     |           | Ring buffer       |   +--->| /proc/kmsg      |
	     V           |   +---------------+   |    |                 |
	+---------+      |   | syslog queue  |---+    +-----------------+
	|         |      |   +---------------+
	| Process |----->|                   |
	|         |      |   +---------------+
	+---------+      |   | console queue |---+    +-----------------+
	                 |   +---------------+   |    |                 |
	                 |                   |   +--->| Console drivers |
	                 +-------------------+        |                 |
	                                              +-----------------+


New/renamed global variables:

 (*) printk_insertion_point is the point in the ring buffer at which data is
     inserted.  It may only be moved if printk_insertion_lock is held.

 (*) log_extraction_point is the point in the ring buffer from which data is
     read out by do_syslog().  It may only be moved if log_extraction_lock is
     held.

 (*) con_extraction_point is the point in the ring buffer from which data is
     read out to be fed to the console drivers.  It may only be moved if
     console_sem is held.  No spinlock needs to be held whilst writing to the
     console.

 (*) console_anytime is the number of registered drivers that have CON_ANYTIME
     flagged.  This avoids the need to walk the console list regularly before
     the CPU is officially online.


This patch has the following effects:

 (1) vprintk() spends much less time within the insertion critical section.

 (2) vprintk() can be filling the buffer whilst do_syslog() and
     release_console_sem are emptying it.  Memory barriers are employed to
     prevent out-of-order access between the buffers and the pointers.

 (3) Instead of a single render buffer, vprintk() has two render buffers per
     CPU.  This allows multiple CPUs to be rendering and processing their
     rendered texts at the same time without the need for this to be within a
     spinlock.

 (4) vprintk() first prints the string into the first buffer for that CPU, and
     then post-processes it into the CPU's second buffer to make sure metadata
     is present (log level and timestamp)

     As the rendering is done into a temporary buffer rather than a ring
     buffer, the printed output is more likely to get truncated as there's less
     room for metadata.  This can be alleviated by increasing the size of the
     processing output buffer.

     These render buffers amount to 2KB * NR_CPUS in total instead of 1KB.

 (5) The timestamp inserted by vprintk() into a line is the time at which the
     rendered line is processed, not the time it hits the buffer.  This means:

     (a) all those calls to do_div() and snprintf() are done outside the
     	 critical section (except for recursion messages), and

     (b) lines from different CPUs may appear to be out of order (this can be
     	 solved by throwing a lock around the processing section, a lock that's
     	 not printk_insertion_lock).

 (6) A partial vprintk() on one CPU (ie: not ending in "\n") will have a
     newline inserted after it if another CPU gets a line in first.

 (7) release_console_sem() does not need to take any spinlocks; console_sem is
     probably sufficient locking for talking to console drivers.  Although the
     function disables IRQs too, this may be unnecessary, provided the IRQ
     handler doesn't try filling up the ring buffer without being able to empty
     it because someone further up the stack holds console_sem.

 (8) vprintk() may have to discard messages under high load:

     (a) If the console queue can't be emptied fast enough, new messages are
     	 discarded wholly or in part.  Possibly old messages should be
     	 discarded instead.

     (b) If the syslog queue can't be emptied fast enough, then if vprintk()
     	 can immediately get the appropriate lock, it will advance the
     	 extraction point by at least 1024 characters, rounded up to the next
     	 newline, thus discarding some old messages.  Failing that, new
     	 messages will be discarded wholly or in part instead.


Why this patch?
===============

We're seeing the kernel spit messages out about CPUs getting stuck on the
console locks.  This appears to be due to I/O errors in a just-disconnected
iSCSI block device causing lots and lots of printks.  The system on which this
is being seen is a ppc64 system with spinlocks that yield to the hypervisor,
which I suspect is exacerbating the situation.

This patch attempts to alleviate the situation by shortening the amount of time
spent in the kernel logging critical sections by breaking up the locking and
moving out stuff that can be done outside of the critical section.


Testing
=======

I've used my FRV test board (32-bit/BE/UP) firstly to step through the code and
check the various values with GDB under various cases, and secondly to generate
a sequence of numbered printks, which I've checked have all been correctly
displayed, and correctly ordered.

I've also run this up on my x86_64 box with 2 CPUs (64-bit/LE/SMP), checking
that it correctly handles output from FS-Cache and CacheFiles with full
debugging output turned on, both in printing to tty and serial consoles and in
extraction via syslog().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/printk.c |  820 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 521 insertions(+), 299 deletions(-)


diff --git a/kernel/printk.c b/kernel/printk.c
index c46a20a..cc6f358 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/circ_buf.h>
 
 #include <asm/uaccess.h>
 
@@ -68,13 +69,21 @@ int oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
 /*
- * console_sem protects the console_drivers list, and also
- * provides serialisation for access to the entire console
- * driver system.
+ * Track if we have an anytime console available
+ */
+static int console_anytime;
+
+/*
+ * console_sem:
+ *
+ * (1) protects the console_drivers list
+ * (2) protects con_extraction_point
+ * (3) provides serialisation for access to the entire console driver system
  */
 static DECLARE_MUTEX(console_sem);
 static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
@@ -86,22 +95,33 @@ struct console *console_drivers;
 static int console_locked, console_suspended;
 
 /*
- * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
- * It is also used in interesting ways to provide interlocking in
- * release_console_sem().
+ * printk_insertion_lock protects insertion into log_buf and alteration of
+ * printk_insertion_point.  It is also used in interesting ways to provide
+ * interlocking in release_console_sem().
  */
-static DEFINE_SPINLOCK(logbuf_lock);
+static DEFINE_SPINLOCK(printk_insertion_lock);
+
+/*
+ * log_extraction_lock protects alteration of log_extraction_point.
+ */
+static DEFINE_SPINLOCK(log_extraction_lock);
 
 #define LOG_BUF_MASK (log_buf_len-1)
 #define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
 
 /*
- * The indices into log_buf are not constrained to log_buf_len - they
- * must be masked before subscripting
+ * These indices into the log_buf ring buffer must be masked before using
  */
-static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
+static size_t printk_insertion_point;	/* next point to insert at */
+static size_t log_extraction_point;	/* next char to be read by syslog() */
+static size_t con_extraction_point;	/* next char to be read by consoles */
+
+#define LOG_CNT() \
+	CIRC_CNT(printk_insertion_point, log_extraction_point, log_buf_len)
+#define LOG_CNT_MB() \
+	({ size_t x = LOG_CNT(); smp_rmb(); x; })
+#define CON_CNT() \
+	CIRC_CNT(printk_insertion_point, con_extraction_point, log_buf_len)
 
 /*
  *	Array of consoles built from command line options (console=)
@@ -127,7 +147,6 @@ static int console_may_schedule;
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
-static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
 static int __init log_buf_len_setup(char *str)
 {
@@ -137,7 +156,7 @@ static int __init log_buf_len_setup(char *str)
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len) {
-		unsigned start, dest_idx, offset;
+		size_t log_amount, con_amount, amount, tmp, offset;
 		char *new_log_buf;
 
 		new_log_buf = alloc_bootmem(size);
@@ -146,21 +165,35 @@ static int __init log_buf_len_setup(char *str)
 			goto out;
 		}
 
-		spin_lock_irqsave(&logbuf_lock, flags);
-		log_buf_len = size;
+		acquire_console_sem();
+		spin_lock_irqsave(&printk_insertion_lock, flags);
+		spin_lock(&log_extraction_lock);
+
+		log_amount = LOG_CNT();
+		con_amount = CON_CNT();
+		amount = max(log_amount, con_amount);
+		if (amount > 0) {
+			offset = printk_insertion_point - amount;
+			offset &= LOG_BUF_MASK;
+			if (offset < printk_insertion_point) {
+				memcpy(new_log_buf, log_buf + offset, amount);
+			} else {
+				tmp = log_buf_len = amount;
+				memcpy(new_log_buf, log_buf + offset, tmp);
+				memcpy(new_log_buf + tmp, log_buf,
+				       amount - tmp);
+			}
+		}
+
 		log_buf = new_log_buf;
+		log_buf_len = size;
+		printk_insertion_point = amount;
+		log_extraction_point = amount - log_amount;
+		con_extraction_point = amount - con_amount;
 
-		offset = start = min(con_start, log_start);
-		dest_idx = 0;
-		while (start != log_end) {
-			log_buf[dest_idx] = __log_buf[start & (__LOG_BUF_LEN - 1)];
-			start++;
-			dest_idx++;
-		}
-		log_start -= offset;
-		con_start -= offset;
-		log_end -= offset;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		spin_unlock(&log_extraction_lock);
+		spin_unlock_irqrestore(&printk_insertion_lock, flags);
+		release_console_sem();
 
 		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
 	}
@@ -230,7 +263,7 @@ static inline void boot_delay_msec(void)
  */
 int log_buf_get_len(void)
 {
-	return logged_chars;
+	return LOG_CNT_MB();
 }
 
 /*
@@ -238,29 +271,39 @@ int log_buf_get_len(void)
  */
 int log_buf_copy(char *dest, int idx, int len)
 {
-	int ret, max;
+	size_t insert, extract;
+	int ret, max, part;
 	bool took_lock = false;
 
 	if (!oops_in_progress) {
-		spin_lock_irq(&logbuf_lock);
+		spin_lock_irq(&log_extraction_lock);
 		took_lock = true;
 	}
 
-	max = log_buf_get_len();
-	if (idx < 0 || idx >= max) {
-		ret = -1;
+	insert = printk_insertion_point;
+	smp_rmb();
+	extract = log_extraction_point;
+	ret = -1;
+	if (idx < 0 || idx >= CIRC_CNT(insert, extract, log_buf_len))
+		goto error;
+
+	extract += idx;
+	max = CIRC_CNT(insert, extract, log_buf_len);
+	if (len > max)
+		len = max;
+
+	part = log_buf_len - extract;
+	if (part < len) {
+		memcpy(dest, log_buf + extract, part);
+		memcpy(dest + part, log_buf, len - part);
 	} else {
-		if (len > max)
-			len = max;
-		ret = len;
-		idx += (log_end - max);
-		while (len-- > 0)
-			dest[len] = LOG_BUF(idx + len);
+		memcpy(dest, log_buf + extract, len);
 	}
 
+	ret = len;
+error:
 	if (took_lock)
-		spin_unlock_irq(&logbuf_lock);
-
+		spin_unlock_irq(&log_extraction_lock);
 	return ret;
 }
 
@@ -294,7 +337,8 @@ int log_buf_read(int idx)
  */
 int do_syslog(int type, char __user *buf, int len)
 {
-	unsigned i, j, limit, count;
+	size_t insert, extract, max, count;
+	unsigned i;
 	int do_clear = 0;
 	char c;
 	int error = 0;
@@ -319,23 +363,25 @@ int do_syslog(int type, char __user *buf, int len)
 			error = -EFAULT;
 			goto out;
 		}
-		error = wait_event_interruptible(log_wait,
-							(log_start - log_end));
+		error = wait_event_interruptible(log_wait, LOG_CNT_MB() > 0);
 		if (error)
 			goto out;
 		i = 0;
-		spin_lock_irq(&logbuf_lock);
-		while (!error && (log_start != log_end) && i < len) {
-			c = LOG_BUF(log_start);
-			log_start++;
-			spin_unlock_irq(&logbuf_lock);
+		spin_lock_irq(&log_extraction_lock);
+		while (!error && LOG_CNT() && i < len) {
+			extract = log_extraction_point;
+			c = log_buf[extract];
+			extract = (extract + 1) & LOG_BUF_MASK;
+			smp_mb();
+			log_extraction_point = extract;
+			spin_unlock_irq(&log_extraction_lock);
 			error = __put_user(c,buf);
 			buf++;
 			i++;
 			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+			spin_lock_irq(&log_extraction_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
+		spin_unlock_irq(&log_extraction_lock);
 		if (!error)
 			error = i;
 		break;
@@ -353,50 +399,57 @@ int do_syslog(int type, char __user *buf, int len)
 			error = -EFAULT;
 			goto out;
 		}
-		count = len;
-		if (count > log_buf_len)
-			count = log_buf_len;
-		spin_lock_irq(&logbuf_lock);
-		if (count > logged_chars)
-			count = logged_chars;
-		if (do_clear)
-			logged_chars = 0;
-		limit = log_end;
-		/*
-		 * __put_user() could sleep, and while we sleep
-		 * printk() could overwrite the messages
-		 * we try to copy to user space. Therefore
-		 * the messages are copied in reverse. <manfreds>
+
+		/* we just copy out an appropriately sized chunk of the log
+		 * buffer, hoping that it doesn't get overwritten beneath us.
+		 *
+		 * because we may sleep whilst reading, the insertion and
+		 * extraction points may both move due to other processes, and,
+		 * indeed, the entire log may be overwritten under us.  There's
+		 * nothing we can really do about that except hope (well, we
+		 * could do something about it at the expense of locking and/or
+		 * resources)
+		 *
+		 * to mimimise the chances of the last messages being
+		 * overwritten, we copy the data out of our window in the
+		 * reverse order
 		 */
-		for (i = 0; i < count && !error; i++) {
-			j = limit-1-i;
-			if (j + log_buf_len < log_end)
-				break;
-			c = LOG_BUF(j);
-			spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,&buf[count-1-i]);
-			cond_resched();
-			spin_lock_irq(&logbuf_lock);
+		spin_lock_irq(&log_extraction_lock);
+
+		insert = printk_insertion_point;
+		extract = log_extraction_point;
+		smp_rmb();
+		max = CIRC_CNT(insert, extract, log_buf_len);
+		count = min((size_t) len, max);
+		if (count > 0) {
+			extract = (insert - count) & LOG_BUF_MASK;
+			if (do_clear) {
+				smp_mb();
+				log_extraction_point = insert;
+			}
+			spin_unlock_irq(&log_extraction_lock);
+
+			i = count;
+			do {
+				insert = (insert - 1) & LOG_BUF_MASK;
+				c = log_buf[insert];
+				i--;
+				error = __put_user(c, &buf[i]);
+				cond_resched();
+			} while (CIRC_CNT(insert, extract, log_buf_len) > 0 &&
+				 !error);
+		} else {
+			spin_unlock_irq(&log_extraction_lock);
 		}
-		spin_unlock_irq(&logbuf_lock);
 		if (error)
 			break;
-		error = i;
-		if (i != count) {
-			int offset = count-error;
-			/* buffer overflow during copy, correct user buffer. */
-			for (i = 0; i < error; i++) {
-				if (__get_user(c,&buf[i+offset]) ||
-				    __put_user(c,&buf[i])) {
-					error = -EFAULT;
-					break;
-				}
-				cond_resched();
-			}
-		}
+		error = count;
 		break;
 	case 5:		/* Clear ring buffer */
-		logged_chars = 0;
+		spin_lock_irq(&log_extraction_lock);
+		insert = printk_insertion_point;
+		log_extraction_point = insert;
+		spin_lock_irq(&log_extraction_lock);
 		break;
 	case 6:		/* Disable logging to console */
 		console_loglevel = minimum_console_loglevel;
@@ -414,7 +467,7 @@ int do_syslog(int type, char __user *buf, int len)
 		error = 0;
 		break;
 	case 9:		/* Number of chars in the log buffer */
-		error = log_end - log_start;
+		error = LOG_CNT();
 		break;
 	case 10:	/* Size of the log buffer */
 		error = log_buf_len;
@@ -432,10 +485,23 @@ asmlinkage long sys_syslog(int type, char __user *buf, int len)
 	return do_syslog(type, buf, len);
 }
 
+static int __read_mostly ignore_loglevel;
+
+static int __init ignore_loglevel_setup(char *str)
+{
+	ignore_loglevel = 1;
+	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
+
+	return 0;
+}
+
+early_param("ignore_loglevel", ignore_loglevel_setup);
+
 /*
  * Call the console drivers on a range of log_buf
+ * Call the console drivers on a string
  */
-static void __call_console_drivers(unsigned start, unsigned end)
+static void ___call_console_drivers(const char *s, size_t len)
 {
 	struct console *con;
 
@@ -443,35 +509,30 @@ static void __call_console_drivers(unsigned start, unsigned end)
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+			con->write(con, s, len);
 	}
 }
 
-static int __read_mostly ignore_loglevel;
-
-static int __init ignore_loglevel_setup(char *str)
+/*
+ * Call the console drivers on a range of log_buf
+ */
+static void __call_console_drivers(size_t start, size_t end)
 {
-	ignore_loglevel = 1;
-	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
-
-	return 0;
+	___call_console_drivers(log_buf + start, end - start);
 }
 
-early_param("ignore_loglevel", ignore_loglevel_setup);
-
 /*
  * Write out chars from start to end - 1 inclusive
  */
-static void _call_console_drivers(unsigned start,
-				unsigned end, int msg_log_level)
+static void _call_console_drivers(size_t start, size_t end, int msg_log_level)
 {
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
-			console_drivers && start != end) {
-		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
+	    console_drivers &&
+	    start != end) {
+		if (start > end) {
 			/* wrapped write */
-			__call_console_drivers(start & LOG_BUF_MASK,
-						log_buf_len);
-			__call_console_drivers(0, end & LOG_BUF_MASK);
+			__call_console_drivers(start, log_buf_len);
+			__call_console_drivers(0, end);
 		} else {
 			__call_console_drivers(start, end);
 		}
@@ -479,63 +540,76 @@ static void _call_console_drivers(unsigned start,
 }
 
 /*
- * Call the console drivers, asking them to write out
- * log_buf[start] to log_buf[end - 1].
- * The console_sem must be held.
+ * Call the console drivers, asking them to write out log_buf[start] to
+ * log_buf[end - 1], where the region of the buffer may wrap.
+ * - the caller must hold console_sem
  */
-static void call_console_drivers(unsigned start, unsigned end)
+static void call_console_drivers(size_t start, size_t end)
 {
-	unsigned cur_index, start_print;
 	static int msg_level = -1;
+	unsigned point;
+
+	while (start != end) {
+		if (msg_level < 0 &&
+		    CIRC_CNT(end, start, log_buf_len) > 2 &&
+		    LOG_BUF(start + 0) == '<' &&
+		    LOG_BUF(start + 1) >= '0' &&
+		    LOG_BUF(start + 1) <= '7' &&
+		    LOG_BUF(start + 2) == '>') {
+			msg_level = LOG_BUF(start + 1) - '0';
+			start = (start + 3) & LOG_BUF_MASK;
+		}
+
+		/* try and write a whole line at a time */
+		point = start;
+		while (point != end) {
+			char c = log_buf[point];
 
-	BUG_ON(((int)(start - end)) > 0);
-
-	cur_index = start;
-	start_print = start;
-	while (cur_index != end) {
-		if (msg_level < 0 && ((end - cur_index) > 2) &&
-				LOG_BUF(cur_index + 0) == '<' &&
-				LOG_BUF(cur_index + 1) >= '0' &&
-				LOG_BUF(cur_index + 1) <= '7' &&
-				LOG_BUF(cur_index + 2) == '>') {
-			msg_level = LOG_BUF(cur_index + 1) - '0';
-			cur_index += 3;
-			start_print = cur_index;
+			point = (point + 1) & LOG_BUF_MASK;
+			if (c == '\n')
+				goto found_newline;
 		}
-		while (cur_index != end) {
-			char c = LOG_BUF(cur_index);
-
-			cur_index++;
-			if (c == '\n') {
-				if (msg_level < 0) {
-					/*
-					 * printk() has already given us loglevel tags in
-					 * the buffer.  This code is here in case the
-					 * log buffer has wrapped right round and scribbled
-					 * on those tags
-					 */
-					msg_level = default_message_loglevel;
-				}
-				_call_console_drivers(start_print, cur_index, msg_level);
-				msg_level = -1;
-				start_print = cur_index;
-				break;
-			}
+		_call_console_drivers(start, end, msg_level);
+		break;
+
+	found_newline:
+		if (msg_level < 0) {
+			/* printk() has already given us loglevel tags in the
+			 * buffer.  This code is here in case the log buffer
+			 * has wrapped right round and scribbled on those tags
+			 */
+			msg_level = default_message_loglevel;
 		}
+
+		_call_console_drivers(start, point, msg_level);
+		msg_level = -1;
+		start = point;
 	}
-	_call_console_drivers(start_print, end, msg_level);
 }
 
-static void emit_log_char(char c)
+/*
+ * insert a line into the printk ring buffer
+ * - the caller must hold logbuf_lock
+ * - the caller must check there is sufficient room
+ */
+static void emit_line(const char *p, size_t len)
 {
-	LOG_BUF(log_end) = c;
-	log_end++;
-	if (log_end - log_start > log_buf_len)
-		log_start = log_end - log_buf_len;
-	if (log_end - con_start > log_buf_len)
-		con_start = log_end - log_buf_len;
-	if (logged_chars < log_buf_len)
-		logged_chars++;
+	size_t n, lip, second;
+
+	lip = printk_insertion_point;
+	n = log_buf_len - lip;
+	n = min(len, n);
+	memcpy(log_buf + lip, p, n);
+	second = len - n;
+	if (second > 0) {
+		memcpy(log_buf, p + n, second);
+		lip = second;
+	} else {
+		lip = (lip + len) & LOG_BUF_MASK;
+	}
+
+	smp_wmb();
+	printk_insertion_point = lip;
 }
 
 /*
@@ -554,8 +628,9 @@ static void zap_locks(void)
 	oops_timestamp = jiffies;
 
 	/* If a crash is occurring, make sure we can't deadlock */
-	spin_lock_init(&logbuf_lock);
+	spin_lock_init(&printk_insertion_lock);
 	/* And make sure that we print immediately */
+	spin_lock_init(&log_extraction_lock);
 	init_MUTEX(&console_sem);
 }
 
@@ -566,18 +641,6 @@ static int printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-/* Check if we have any console registered that can be called early in boot. */
-static int have_callable_console(void)
-{
-	struct console *con;
-
-	for (con = console_drivers; con; con = con->next)
-		if (con->flags & CON_ANYTIME)
-			return 1;
-
-	return 0;
-}
-
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -619,25 +682,21 @@ static volatile unsigned int printk_cpu = UINT_MAX;
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated - so
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
-	return cpu_online(cpu) || have_callable_console();
+	return cpu_online(cpu) || console_anytime > 0;
 }
 
 /*
- * Try to get console ownership to actually show the kernel
- * messages from a 'printk'. Return true (and with the
- * console_semaphore held, and 'console_locked' set) if it
- * is successful, false otherwise.
+ * Try to get console ownership to actually show the kernel messages from a
+ * 'printk'. Return true (and with the console_semaphore held, and
+ * 'console_locked' set) if it is successful, false otherwise.
  *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
+ * This gets called interrupts disabled.
  */
 static int acquire_console_semaphore_for_printk(unsigned int cpu)
 {
@@ -645,36 +704,46 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 
 	if (can_use_console(cpu))
 		retval = !try_acquire_console_sem();
-	printk_cpu = UINT_MAX;
-	spin_unlock(&logbuf_lock);
 	return retval;
 }
 
-const char printk_recursion_bug_msg [] =
+static const char printk_recursion_bug_msg [] =
 			KERN_CRIT "BUG: recent printk recursion!\n";
 static int printk_recursion_bug;
 
+/**
+ * vprintk - Distribute kernel messages
+ * fmt: The printf-style format arguments
+ * args: The varargs argument list pointer
+ *
+ * This function renders a kernel message from a printf-style format string
+ * with varargs arguments and distributes it to the console and the syslog
+ * daemon.
+ */
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	static int log_level_unknown = 1;
-	static char printk_buf[1024];
+	static int printk_append_next_line = -1;
+	static char printk_render_buf[NR_CPUS][2][1024];
 
+	unsigned long long t;
+	unsigned long nanosec_rem;
 	unsigned long flags;
-	int printed_len = 0;
-	int this_cpu;
-	char *p;
+	unsigned int cpu;
+	size_t printed_len = 0, metalen, max, len, tmp;
+	char *prbuf, *p, *q, *pstop, *o, *olimit;
+	int prtime;
 
 	boot_delay_msec();
 
-	preempt_disable();
-	/* This stops the holder of console_sem just where we want him */
+	/* prevent migration to another CPU */
+	cpu = get_cpu();
+
+	/* don't let interrupts try to print whilst we're using this CPU's
+	 * static render buffers */
 	raw_local_irq_save(flags);
-	this_cpu = smp_processor_id();
 
-	/*
-	 * Ouch, printk recursed into itself!
-	 */
-	if (unlikely(printk_cpu == this_cpu)) {
+	/* catch printk recursing into itself */
+	if (unlikely(printk_cpu == cpu)) {
 		/*
 		 * If a crash is occurring during printk() on this CPU,
 		 * then try to get the crash message out but make sure
@@ -689,94 +758,224 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		zap_locks();
 	}
 
+	/* render the raw text */
+	prbuf = printk_render_buf[cpu][0];
+	len = vscnprintf(prbuf, sizeof(printk_render_buf[0][0]), fmt, args);
+
+	/* process the rendered text to make sure it includes metadata */
+	p = prbuf;
+	pstop = p + len;
+	o = printk_render_buf[cpu][1];
+	olimit = o + sizeof(printk_render_buf[0][1]) - 1;
+	prtime = printk_time;
+
+	while (p < pstop) {
+		/* each line must placed into the ring buffer must begin with a
+		 * log-level token of the form "<L>" where L is the level */
+		if (o >= olimit - 3)
+			break; /* can't insert a log level token */
+
+		if (p[0] == '<' && p[1] >='0' && p[1] <= '7' && p[2] == '>') {
+			/* this line begins with a log level */
+			*o++ = *p++;
+			*o++ = *p++;
+			*o++ = *p++;
+		} else {
+			*o++ = '<';
+			*o++ = '0' + default_message_loglevel;
+			*o++ = '>';
+		}
+
+		/* insert a timestamp after the log-level token if one is
+		 * required */
+		if (prtime) {
+			if (o >= olimit - 15) {
+				o -= 3;
+				break; /* can't insert a time token */
+			}
+
+			t = cpu_clock(printk_cpu);
+			nanosec_rem = do_div(t, 1000000000);
+			len = snprintf(o, olimit - o - 2,
+				       "[%5lu.%06lu",
+				       (unsigned long) t, nanosec_rem / 1000);
+			o[len++] = ']';
+			o[len++] = ' ';
+
+			if (len >= olimit - o) {
+				o -= 3;
+				break; /* can't insert anything after the time
+					* token */
+			}
+			o += len;
+		}
+
+		/* insert as much of the text of this line as we can */
+		q = memchr(p, '\n', pstop - p);
+		if (q)
+			q++;
+		else
+			q = pstop;
+
+		max = olimit - o;
+		len = q - p;
+		if (len > max)
+			len = max;
+		memcpy(o, p, len);
+		p += len;
+		o += len;
+		if (o >= olimit)
+			break;
+	}
+
+	*o = '\0';
+	olimit = o;
+	len = olimit - printk_render_buf[cpu][1];
+
+	/* we've now got a string we can emit, so now, and only now, should we
+	 * need the insertion spinlock */
 	lockdep_off();
-	spin_lock(&logbuf_lock);
-	printk_cpu = this_cpu;
+	spin_lock(&printk_insertion_lock);
+	printk_cpu = cpu;
+
+	/* work out how much space we have
+	 * - we have a ring buffer with one head and two tails, neither of which
+	 *   the head may overtake
+	 * - we may, however, nudge the syslog extraction point forward if it
+	 *   isn't advancing fast enough (for instance if klogd isn't running)
+	 */
+	max = CIRC_SPACE(printk_insertion_point, log_extraction_point,
+			 log_buf_len);
+	if (max < len + 30) {
+		if (spin_trylock(&log_extraction_lock)) {
+			size_t extract = log_extraction_point;
+
+			barrier();
+			extract = (extract + 1024) & LOG_BUF_MASK;
+			while (extract != printk_insertion_point &&
+			       log_buf[extract] != '\n')
+				extract = (extract + 1) & LOG_BUF_MASK;
+			barrier();
+			log_extraction_point = extract;
+			spin_unlock(&log_extraction_lock);
+
+			max = CIRC_SPACE(printk_insertion_point, extract,
+					 log_buf_len);
+		}
+	}
+
+	tmp = CIRC_SPACE(printk_insertion_point, con_extraction_point,
+			 log_buf_len);
+	if (tmp < max)
+		max = tmp;
+
+	/* handle notification of a recursion bug */
+	if (unlikely(printk_recursion_bug)) {
+		const char *recbug;
+
+		if (printk_append_next_line != -1) {
+			emit_line("\n", 1);
+			printk_append_next_line = -1;
+			printed_len += 1;
+			max -= 1;
+		}
 
-	if (printk_recursion_bug) {
+		if (prtime) {
+			recbug = p = prbuf;
+			*p++ = printk_recursion_bug_msg[0];
+			*p++ = printk_recursion_bug_msg[1];
+			*p++ = printk_recursion_bug_msg[2];
+
+			t = cpu_clock(cpu);
+			nanosec_rem = do_div(t, 1000000000);
+			len = sprintf(p, "[%5lu.%06lu] %s",
+				      (unsigned long) t, nanosec_rem / 1000,
+				      printk_recursion_bug_msg + 3);
+			len += 3;
+		} else {
+			recbug = printk_recursion_bug_msg;
+			len = sizeof(printk_recursion_bug_msg) - 1;
+		}
+		if (len > max)
+			goto no_space;
+		printed_len += len;
+		max -= len;
+		emit_line(recbug, len);
 		printk_recursion_bug = 0;
-		strcpy(printk_buf, printk_recursion_bug_msg);
-		printed_len = sizeof(printk_recursion_bug_msg);
 	}
-	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
 
-	/*
-	 * Copy the output into log_buf.  If the caller didn't provide
-	 * appropriate log level tags, we insert them here
-	 */
-	for (p = printk_buf; *p; p++) {
-		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
-			if (printk_time) {
-				int loglev_char;
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
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
-				t = cpu_clock(printk_cpu);
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
-						loglev_char,
-						(unsigned long)t,
-						nanosec_rem/1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
-				printed_len += tlen;
-			} else {
-				if (p[0] != '<' || p[1] < '0' ||
-				   p[1] > '7' || p[2] != '>') {
-					emit_log_char('<');
-					emit_log_char(default_message_loglevel
-						+ '0');
-					emit_log_char('>');
-					printed_len += 3;
-				}
+	/* emit the text into the ring buffer a line at a time */
+	o = printk_render_buf[cpu][1];
+	while (o < olimit) {
+		if (!prtime) {
+			metalen = 3;
+		} else {
+			p = o + 16;
+			while (*p != ']' && p < olimit)
+				p++;
+			metalen = olimit - p;
+		}
+
+		/* try and append to a previous printk emitted by this process
+		 * if that didn't include a newline */
+		if (printk_append_next_line != -1) {
+			if (printk_append_next_line == current->pid) {
+				o += metalen;
+				goto dont_emit_metadata;
 			}
-			log_level_unknown = 0;
-			if (!*p)
+			printk_append_next_line = -1;
+			if (max == 0)
 				break;
+			emit_line("\n", 1);
+			printed_len += 1;
+			max -= 1;
 		}
-		emit_log_char(*p);
-		if (*p == '\n')
-			log_level_unknown = 1;
+
+		/* don't print anything more if we can't print the metadata and
+		 * at least one character from the text */
+		if (max <= metalen)
+			break;
+
+	dont_emit_metadata:
+		p = memchr(o, '\n', olimit - o);
+		if (p) {
+			printk_append_next_line = -1;
+			p++;
+		} else {
+			printk_append_next_line = current->pid;
+			p = olimit;
+		}
+
+		len = p - o;
+		if (len > max) {
+			printk_append_next_line = -1;
+			max = len;
+		}
+
+		printed_len += len;
+		max -= len;
+		emit_line(o, len);
+		if (max == 0)
+			break;
+		o = p;
 	}
 
-	/*
-	 * Try to acquire and then immediately release the
-	 * console semaphore. The release will do all the
-	 * actual magic (print out buffers, wake up klogd,
-	 * etc). 
-	 *
-	 * The acquire_console_semaphore_for_printk() function
-	 * will release 'logbuf_lock' regardless of whether it
-	 * actually gets the semaphore or not.
-	 */
-	if (acquire_console_semaphore_for_printk(this_cpu))
-		release_console_sem();
+no_space:
+	printk_cpu = UINT_MAX;
+	spin_unlock(&printk_insertion_lock);
 
+	if (printed_len > 0) {
+		/* Try to acquire and then immediately release the console
+		 * semaphore. The release will do all the actual magic (print
+		 * out buffers, wake up klogd, etc).
+		 */
+		if (acquire_console_semaphore_for_printk(cpu))
+			release_console_sem();
+	}
 	lockdep_on();
 out_restore_irqs:
 	raw_local_irq_restore(flags);
-
-	preempt_enable();
+	put_cpu();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
@@ -789,7 +988,7 @@ asmlinkage long sys_syslog(int type, char __user *buf, int len)
 	return -ENOSYS;
 }
 
-static void call_console_drivers(unsigned start, unsigned end)
+static void call_console_drivers(size_t start, size_t end)
 {
 }
 
@@ -981,34 +1180,57 @@ void wake_up_klogd(void)
  */
 void release_console_sem(void)
 {
+	size_t insert, extract;
 	unsigned long flags;
-	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	unsigned wake_klogd;
 
+relocked:
 	if (console_suspended) {
 		up(&secondary_console_sem);
 		return;
 	}
 
 	console_may_schedule = 0;
+	wake_klogd = 0;
+
+	/* we hold the console lock, so we are the only one that can transfer
+	 * data from con_extraction_point to the console devices */
+	for (;;) {
+		insert = printk_insertion_point;
+		barrier();
+		wake_klogd |= log_extraction_point - insert;
+		extract = con_extraction_point;
+		if (extract == insert)
+			break;
 
-	for ( ; ; ) {
-		spin_lock_irqsave(&logbuf_lock, flags);
-		wake_klogd |= log_start - log_end;
-		if (con_start == log_end)
-			break;			/* Nothing to print */
-		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
-		spin_unlock(&logbuf_lock);
-		call_console_drivers(_con_start, _log_end);
+		local_irq_save(flags);
+		insert = printk_insertion_point;
+		smp_rmb();
+		if (extract != insert) {
+			call_console_drivers(extract, insert);
+			smp_mb();
+			con_extraction_point = insert;	/* Flush */
+		}
 		local_irq_restore(flags);
 	}
+
 	console_locked = 0;
 	up(&console_sem);
-	spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
 		wake_up_klogd();
+
+	/* there's a race between us writing data from the ring buffer and
+	 * releasing the console sem, so we need to check again and possibly
+	 * reget the lock and go round again */
+	insert = printk_insertion_point;
+	extract = con_extraction_point;
+	smp_rmb();
+	if (insert != extract) {
+		/* however, if someone else gets the semaphore, we don't need
+		 * to worry - it's then their responsibility */
+		if (try_acquire_console_sem() == 0)
+			goto relocked;
+	}
 }
 EXPORT_SYMBOL(release_console_sem);
 
@@ -1190,14 +1412,16 @@ void register_console(struct console *console)
 		console->next = console_drivers->next;
 		console_drivers->next = console;
 	}
+	if (console->flags & CON_ANYTIME)
+		console_anytime++;
 	if (console->flags & CON_PRINTBUFFER) {
 		/*
 		 * release_console_sem() will print out the buffered messages
 		 * for us.
 		 */
-		spin_lock_irqsave(&logbuf_lock, flags);
-		con_start = log_start;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+		spin_lock_irqsave(&log_extraction_lock, flags);
+		con_extraction_point = log_extraction_point;
+		spin_unlock_irqrestore(&log_extraction_lock, flags);
 	}
 	release_console_sem();
 }
@@ -1205,21 +1429,19 @@ EXPORT_SYMBOL(register_console);
 
 int unregister_console(struct console *console)
 {
-        struct console *a, *b;
+        struct console **pp, *p;
 	int res = 1;
 
 	acquire_console_sem();
-	if (console_drivers == console) {
-		console_drivers=console->next;
-		res = 0;
-	} else if (console_drivers) {
-		for (a=console_drivers->next, b=console_drivers ;
-		     a; b=a, a=b->next) {
-			if (a == console) {
-				b->next = a->next;
-				res = 0;
-				break;
-			}
+
+	for (pp = &console_drivers; *pp; pp = &(*pp)->next) {
+		p = *pp;
+		if (p == console) {
+			*pp = console->next;
+			res = 0;
+			if (console->flags & CON_ANYTIME)
+				console_anytime--;
+			break;
 		}
 	}
 
@@ -1227,7 +1449,7 @@ int unregister_console(struct console *console)
 	 * If this isn't the last console and it has CON_CONSDEV set, we
 	 * need to set it on the next preferred console.
 	 */
-	if (console_drivers != NULL && console->flags & CON_CONSDEV)
+	if (console_drivers && console->flags & CON_CONSDEV)
 		console_drivers->flags |= CON_CONSDEV;
 
 	release_console_sem();

