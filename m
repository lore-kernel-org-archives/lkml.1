Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbXHBJ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbXHBJ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXHBJ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:27:05 -0400
Received: from qsrv02ps.mx.bigpond.com ([144.140.83.182]:57192 "EHLO
	qsrv02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbXHBJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:27:03 -0400
Message-ID: <46B17AA3.80906@bigpond.net.au>
Date: Thu, 02 Aug 2007 16:33:07 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Tidy up left over smpnice code after changes introduced with
 CFS
Content-Type: multipart/mixed;
 boundary="------------040600050209030100070609"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06ps.mx.bigpond.com from [124.186.206.38] using ID pwil3058@bigpond.net.au at Thu, 2 Aug 2007 06:33:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040600050209030100070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

1. The only place that RTPRIO_TO_LOAD_WEIGHT() is used is in the call to 
move_tasks() in the function active_load_balance() and its purpose here 
is just to make sure that the load to be moved is big enough to ensure 
that exactly one task is moved (if there's one available).  This can be 
accomplished by using ULONG_MAX instead and this allows 
RTPRIO_TO_LOAD_WEIGHT() to be deleted.

2. This, in turn, allows PRIO_TO_LOAD_WEIGHT() to be deleted.

3. This allows load_weight() to be deleted which allows 
TIME_SLICE_NICE_ZERO to be deleted along with the comment above it.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

--------------040600050209030100070609
Content-Type: text/x-patch;
 name="tidy-up-smpnice-code-after-cfs-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tidy-up-smpnice-code-after-cfs-changes.patch"

diff -r 622a128d084b kernel/sched.c
--- a/kernel/sched.c	Mon Jul 30 21:54:37 2007 -0700
+++ b/kernel/sched.c	Thu Aug 02 16:21:19 2007 +1000
@@ -727,19 +727,6 @@ static void update_curr_load(struct rq *
  * slice expiry etc.
  */
 
-/*
- * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
- * If static_prio_timeslice() is ever changed to break this assumption then
- * this code will need modification
- */
-#define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
-#define load_weight(lp) \
-	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
-#define PRIO_TO_LOAD_WEIGHT(prio) \
-	load_weight(static_prio_timeslice(prio))
-#define RTPRIO_TO_LOAD_WEIGHT(rp) \
-	(PRIO_TO_LOAD_WEIGHT(MAX_RT_PRIO) + load_weight(rp))
-
 #define WEIGHT_IDLEPRIO		2
 #define WMULT_IDLEPRIO		(1 << 31)
 
@@ -2906,8 +2893,7 @@ static void active_load_balance(struct r
 		schedstat_inc(sd, alb_cnt);
 
 		if (move_tasks(target_rq, target_cpu, busiest_rq, 1,
-			       RTPRIO_TO_LOAD_WEIGHT(100), sd, CPU_IDLE,
-			       NULL))
+			       ULONG_MAX, sd, CPU_IDLE, NULL))
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);

--------------040600050209030100070609--
