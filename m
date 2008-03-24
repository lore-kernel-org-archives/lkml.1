Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYCXMj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYCXMj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbYCXMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:39:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:12424 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799AbYCXMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:39:23 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080324123921.841951000@chello.nl>
References: <20080324122424.671168000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 24 Mar 2008 13:24:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] printk_nowakeup()
Content-Disposition: inline; filename=printk_noflush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under certain, rather special, circumstances its impossible to
wake up klogd, for these provide: printk_nowakeup().

These circumstances include: holding rq->lock and or xtime lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel.h |    4 +++-
 kernel/printk.c        |   36 +++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 6 deletions(-)

Index: linux-2.6-2/include/linux/kernel.h
===================================================================
--- linux-2.6-2.orig/include/linux/kernel.h
+++ linux-2.6-2/include/linux/kernel.h
@@ -179,7 +179,9 @@ extern struct pid *session_of_pgrp(struc
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
+asmlinkage int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int printk_nowakeup(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 extern int log_buf_get_len(void);
 extern int log_buf_read(int idx);
Index: linux-2.6-2/kernel/printk.c
===================================================================
--- linux-2.6-2.orig/kernel/printk.c
+++ linux-2.6-2/kernel/printk.c
@@ -612,6 +612,7 @@ asmlinkage int printk(const char *fmt, .
 
 	return r;
 }
+EXPORT_SYMBOL(printk);
 
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
@@ -621,7 +622,9 @@ static int recursion_bug;
 static int log_level_unknown = 1;
 static char printk_buf[1024];
 
-asmlinkage int vprintk(const char *fmt, va_list args)
+static int __release_console_sem(void);
+
+static int __vprintk(int wakeup, const char *fmt, va_list args)
 {
 	unsigned long flags;
 	int printed_len = 0;
@@ -740,7 +743,8 @@ asmlinkage int vprintk(const char *fmt, 
 		 */
 		if (cpu_online(smp_processor_id()) || have_callable_console()) {
 			console_may_schedule = 0;
-			release_console_sem();
+			if (__release_console_sem() && wakeup)
+				wake_up_klogd();
 		} else {
 			/* Release by hand to avoid flushing the buffer. */
 			console_locked = 0;
@@ -764,7 +768,23 @@ out_restore_irqs:
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
+
+asmlinkage int printk_nowakeup(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = __vprintk(0, fmt, args);
+	va_end(args);
+
+	return r;
+}
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+{
+	return __vprintk(1, fmt, args);
+}
 EXPORT_SYMBOL(vprintk);
 
 #else
@@ -964,7 +984,7 @@ void wake_up_klogd(void)
  *
  * release_console_sem() may be called from any context.
  */
-void release_console_sem(void)
+static int __release_console_sem(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
@@ -994,7 +1014,13 @@ void release_console_sem(void)
 	console_locked = 0;
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
-	if (wake_klogd)
+
+	return wake_klogd;
+}
+
+void release_console_sem(void)
+{
+	if (__release_console_sem())
 		wake_up_klogd();
 }
 EXPORT_SYMBOL(release_console_sem);

--

