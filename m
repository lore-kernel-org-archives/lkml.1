Return-Path: <linux-kernel-owner+w=401wt.eu-S1161474AbXD2Vvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161474AbXD2Vvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161480AbXD2Vvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:51:42 -0400
Received: from holomorphy.com ([66.93.40.71]:58749 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161474AbXD2Vvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:51:40 -0400
Date: Sun, 29 Apr 2007 14:52:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: linux-kernel@vger.kernel.org
Subject: privatize CALC_LOAD()
Message-ID: <20070429215215.GA19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I've posted this before, but anyway.

CALC_LOAD() and a number of its attendant macros are only ever used
in kernel/timer.c; this patch moves them there. Bizarrely, various
arch code for S/390, PPC Amiga, m68k(nommu), sh, and sh64 is using
FSHIFT, FIXED_1, and avenrun[] in a manner resembling /proc/ for the
purpose of LED flashing and similar (save S/390, which is rather odd),
so they can't be privatized without some sort of load average helpers.

The macros moved here are only ever used for updating the load average,
not reporting it. None of the platform drivers or /proc/ attempt to do
anything of that sort, so it's useless to clutter sched.h with them.

Spotted over the course of other, more meaningful cleanups being made
in preparation for more serious work.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: sched/include/linux/sched.h
===================================================================
--- sched.orig/include/linux/sched.h	2007-04-29 14:28:47.165445871 -0700
+++ sched/include/linux/sched.h	2007-04-29 14:29:02.030292970 -0700
@@ -109,15 +109,6 @@
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
-#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
-#define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
-#define EXP_5		2014		/* 1/exp(5sec/5min) */
-#define EXP_15		2037		/* 1/exp(5sec/15min) */
-
-#define CALC_LOAD(load,exp,n) \
-	load *= exp; \
-	load += n*(FIXED_1-exp); \
-	load >>= FSHIFT;
 
 extern unsigned long total_forks;
 extern int nr_threads;
Index: sched/kernel/timer.c
===================================================================
--- sched.orig/kernel/timer.c	2007-04-29 14:28:46.861428546 -0700
+++ sched/kernel/timer.c	2007-04-29 14:29:02.030292970 -0700
@@ -1242,6 +1242,15 @@
 
 EXPORT_SYMBOL(avenrun);
 
+#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
+#define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
+#define EXP_5		2014		/* 1/exp(5sec/5min) */
+#define EXP_15		2037		/* 1/exp(5sec/15min) */
+#define CALC_LOAD(load,exp,n) \
+	load *= exp; \
+	load += n*(FIXED_1-exp); \
+	load >>= FSHIFT;
+
 /*
  * calc_load - given tick count, update the avenrun load estimates.
  * This is called while holding a write_lock on xtime_lock.
