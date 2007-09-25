Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbXIYRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbXIYRif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbXIYRi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:38:28 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53989 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXIYRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:38:27 -0400
Date: Tue, 25 Sep 2007 13:37:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] UML - time build fix
Message-ID: <20070925173713.GA8262@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put back an implementation of timeval_to_ns in
arch/um/os-Linux/time.c.  tglx pointed out in his review of tickless
support that there was a perfectly good implementation of it in
linux/time.h.  The problem is that this is userspace code which can't
pull in kernel headers and there doesn't seem to be a libc version.

So, I'm copying the version from linux/time.h rather than resurrecting
my version.  This causes some declaration changes as it now returns a
signed value rather than an unsigned value.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h    |    4 ++--
 arch/um/os-Linux/time.c |   22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-09-25 09:26:42.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2007-09-25 09:28:42.000000000 -0400
@@ -252,9 +252,9 @@ extern void os_dump_core(void);
 extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
-extern unsigned long long disable_timer(void);
+extern long long disable_timer(void);
 extern void uml_idle_timer(void);
-extern unsigned long long os_nsecs(void);
+extern long long os_nsecs(void);
 
 /* skas/mem.c */
 extern long run_syscall_stub(struct mm_id * mm_idp,
Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2007-09-25 09:26:42.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/time.c	2007-09-25 09:28:42.000000000 -0400
@@ -39,7 +39,23 @@ int timer_one_shot(int ticks)
 	return 0;
 }
 
-unsigned long long disable_timer(void)
+/**
+ * timeval_to_ns - Convert timeval to nanoseconds
+ * @ts:		pointer to the timeval variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timeval
+ * parameter.
+ *
+ * Ripped from linux/time.h because it's a kernel header, and thus
+ * unusable from here.
+ */
+static inline long long timeval_to_ns(const struct timeval *tv)
+{
+	return ((long long) tv->tv_sec * UM_NSEC_PER_SEC) +
+		tv->tv_usec * UM_NSEC_PER_USEC;
+}
+
+long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
@@ -47,10 +63,10 @@ unsigned long long disable_timer(void)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return tv_to_nsec(&time.it_value);
+	return timeval_to_ns(&time.it_value);
 }
 
-unsigned long long os_nsecs(void)
+long long os_nsecs(void)
 {
 	struct timeval tv;
 
