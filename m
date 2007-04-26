Return-Path: <linux-kernel-owner+w=401wt.eu-S1031486AbXDZUAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031486AbXDZUAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031490AbXDZUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:34 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49653 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031486AbXDZUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:30 -0400
Date: Thu, 26 Apr 2007 15:56:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Gregory Smith <gasmith3@wisc.edu>
Subject: [PATCH 5/5] UML - Virtualized time fix
Message-ID: <20070426195626.GA9568@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the current timekeeping, !CONFIG_UML_REAL_TIME_CLOCK has
inconsistent behavior.  Previously, gettimeofday could be (and was)
isolated from the clock ticking.  Now, it's not, so when
CONFIG_UML_REAL_TIME_CLOCK is disabled, gettimeofday must progress in
lockstep with the clock, making it fully virtual.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/time.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/time.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/time.c	2007-04-08 19:18:52.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/time.c	2007-04-19 13:43:55.000000000 -0400
@@ -34,8 +34,8 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-static unsigned long long prev_nsecs[NR_CPUS];
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
+static unsigned long long prev_nsecs[NR_CPUS];
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
@@ -94,7 +94,12 @@ irqreturn_t um_timer(int irq, void *dev)
 
 	do_timer(1);
 
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	nsecs = get_time();
+#else
+	nsecs = (unsigned long long) xtime.tv_sec * BILLION + xtime.tv_nsec +
+		BILLION / HZ;
+#endif
 	xtime.tv_sec = nsecs / NSEC_PER_SEC;
 	xtime.tv_nsec = nsecs - xtime.tv_sec * NSEC_PER_SEC;
 
@@ -127,13 +132,18 @@ void time_init(void)
 	nsecs = os_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
 				-nsecs % BILLION);
+	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
 	late_time_init = register_timer;
 }
 
 void do_gettimeofday(struct timeval *tv)
 {
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	unsigned long long nsecs = get_time();
-
+#else
+	unsigned long long nsecs = (unsigned long long) xtime.tv_sec * BILLION +
+		xtime.tv_nsec;
+#endif
 	tv->tv_sec = nsecs / NSEC_PER_SEC;
 	/* Careful about calculations here - this was originally done as
 	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
