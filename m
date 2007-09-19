Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXISRGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXISRGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbXISRDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:03:21 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53181 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762068AbXISRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:03:17 -0400
Date: Wed, 19 Sep 2007 13:02:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 11/11] UML - Use *SEC_PER_*SEC constants
Message-ID: <20070919170230.GA10213@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are various uses of powers of 1000, plus the odd BILLION
constant in the time code.  However, there are perfectly good definitions of
*SEC_PER_*SEC in linux/time.h which can be used instaed.

These are replaced directly in kernel code.  Userspace code imports
those constants as UM_*SEC_PER_*SEC and uses these.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/common-offsets.h |    4 ++++
 arch/um/include/os.h             |    2 --
 arch/um/kernel/time.c            |    9 +++++----
 arch/um/os-Linux/skas/process.c  |   12 +++++++-----
 arch/um/os-Linux/time.c          |   16 ++++++++--------
 5 files changed, 24 insertions(+), 19 deletions(-)

Index: linux-2.6.20/arch/um/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/time.c	2007-09-19 12:25:07.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/time.c	2007-09-19 12:25:08.000000000 -0400
@@ -17,7 +17,7 @@
  */
 unsigned long long sched_clock(void)
 {
-	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
+	return (unsigned long long)jiffies_64 * (NSEC_PER_SEC / HZ);
 }
 
 void timer_handler(int sig, struct uml_pt_regs *regs)
@@ -119,8 +119,9 @@ void __init time_init(void)
 	timer_init();
 
 	nsecs = os_nsecs();
-	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
-				-nsecs % BILLION);
-	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
+	set_normalized_timespec(&wall_to_monotonic, -nsecs / NSEC_PER_SEC,
+				-nsecs % NSEC_PER_SEC);
+	set_normalized_timespec(&xtime, nsecs / NSEC_PER_SEC,
+				nsecs % NSEC_PER_SEC);
 	late_time_init = setup_itimer;
 }
Index: linux-2.6.20/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/time.c	2007-09-19 12:25:08.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/time.c	2007-09-19 12:25:08.000000000 -0400
@@ -14,7 +14,7 @@
 
 int set_interval(void)
 {
-	int usec = 1000000/UM_HZ;
+	int usec = UM_USEC_PER_SEC / UM_HZ;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
@@ -26,11 +26,11 @@ int set_interval(void)
 
 int timer_one_shot(int ticks)
 {
-	unsigned long usec = ticks * 1000000 / UM_HZ;
-	unsigned long sec = usec / 1000000;
+	unsigned long usec = ticks * UM_USEC_PER_SEC / UM_HZ;
+	unsigned long sec = usec / UM_USEC_PER_SEC;
 	struct itimerval interval;
 
-	usec %= 1000000;
+	usec %= UM_USEC_PER_SEC;
 	interval = ((struct itimerval) { { 0, 0 }, { sec, usec } });
 
 	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
@@ -47,8 +47,8 @@ static inline unsigned long long tv_to_n
 	 * return.
 	 */
 
-	return ((unsigned long long) tv->tv_sec) * BILLION +
-		tv->tv_usec * 1000;
+	return ((unsigned long long) tv->tv_sec) * UM_NSEC_PER_SEC +
+		tv->tv_usec * UM_NSEC_PER_USEC;
 }
 
 unsigned long long disable_timer(void)
@@ -74,8 +74,8 @@ extern void alarm_handler(int sig, struc
 
 void idle_sleep(unsigned long long nsecs)
 {
-	struct timespec ts = { .tv_sec	= nsecs / BILLION,
-			       .tv_nsec = nsecs % BILLION };
+	struct timespec ts = { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
+			       .tv_nsec = nsecs % UM_NSEC_PER_SEC };
 
 	if (nanosleep(&ts, &ts) == 0)
 		alarm_handler(SIGVTALRM, NULL);
Index: linux-2.6.20/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/skas/process.c	2007-09-19 12:25:08.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/skas/process.c	2007-09-19 12:25:08.000000000 -0400
@@ -294,8 +294,8 @@ void userspace(struct uml_pt_regs *regs)
 
 	if (getitimer(ITIMER_VIRTUAL, &timer))
 		printk("Failed to get itimer, errno = %d\n", errno);
-	nsecs = timer.it_value.tv_sec * BILLION +
-		timer.it_value.tv_usec * 1000;
+	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
+		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
 	nsecs += os_nsecs();
 
 	while (1) {
@@ -347,8 +347,10 @@ void userspace(struct uml_pt_regs *regs)
 				block_signals();
 				(*sig_info[sig])(sig, regs);
 				unblock_signals();
-				nsecs = timer.it_value.tv_sec * BILLION +
-					timer.it_value.tv_usec * 1000;
+				nsecs = timer.it_value.tv_sec *
+					UM_NSEC_PER_SEC +
+					timer.it_value.tv_usec *
+					UM_NSEC_PER_USEC;
 				nsecs += os_nsecs();
 				break;
 			case SIGIO:
@@ -395,7 +397,7 @@ __initcall(init_thread_regs);
 
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
-	struct timeval tv = { .tv_sec = 0, .tv_usec = 1000000 / UM_HZ };
+	struct timeval tv = { .tv_sec = 0, .tv_usec = UM_USEC_PER_SEC / UM_HZ };
 	int err;
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
Index: linux-2.6.20/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/common-offsets.h	2007-09-19 12:25:05.000000000 -0400
+++ linux-2.6.20/arch/um/include/common-offsets.h	2007-09-19 12:25:08.000000000 -0400
@@ -34,3 +34,7 @@ DEFINE(crypto_tfm_ctx_offset, offsetof(s
 DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
 
 DEFINE(UM_HZ, HZ);
+
+DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
+DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
+DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
Index: linux-2.6.20/arch/um/include/os.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/os.h	2007-09-19 12:25:08.000000000 -0400
+++ linux-2.6.20/arch/um/include/os.h	2007-09-19 12:25:08.000000000 -0400
@@ -249,8 +249,6 @@ extern int setjmp_wrapper(void (*proc)(v
 extern void os_dump_core(void);
 
 /* time.c */
-#define BILLION (1000 * 1000 * 1000)
-
 extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
