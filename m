Return-Path: <linux-kernel-owner+w=401wt.eu-S933329AbXAaPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbXAaPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXAaPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:02:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51612 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329AbXAaPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:02:17 -0500
Date: Wed, 31 Jan 2007 20:31:55 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       Eric Piel <Eric.Piel@tremplin-utc.net>, Kirill Korotaev <dev@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] core scheduler changes
Message-ID: <20070131150155.GA14145@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070126060142.GA2487@in.ibm.com> <20070126060317.GB2487@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126060317.GB2487@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:33:17AM +0530, Srivatsa Vaddagiri wrote:
> 
> This patch does several things:
> 
> 	- Introduces the notion of control window (current set at 1
> 	  sec - ideally the window size should be adjusted based on
> 	  number of users to avoid rapid context switches). Bandwidth of each 
> 	  user is controlled within this window.  rq->last_update tracks where 
> 	  are in the current window.

The patch below makes the control window size configurable (as a macro),
sets the default window size at 10 sec and also fixes a compile error (for 
!CONFIG_FAIRSCHED case).

Ideally the window size needs to be determined at run time (based on number of
users). I will address that if there is sufficient interest on a patch
like this ..

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>

---


diff -puN kernel/sched.c~window-fix kernel/sched.c
--- linux-2.6.20-rc5/kernel/sched.c~window-fix	2007-01-31 19:59:48.000000000 +0530
+++ linux-2.6.20-rc5-vatsa/kernel/sched.c	2007-01-31 20:08:57.000000000 +0530
@@ -769,17 +769,24 @@ static inline int is_user_starving(struc
 	return 0;
 }
 
-/* Are we past the 1-sec control window? If so, all groups get to renew their
+#define WINDOW_SIZE	(10*HZ)
+
+/* Are we past the control window? If so, all groups get to renew their
  * expired tokens.
  */
-static inline void adjust_control_window(void)
+static inline void adjust_control_window(int force)
 {
 	struct rq *rq = this_rq();
 	unsigned long delta;
 
+	if (force) {
+		rq->last_update = jiffies;
+		return;
+	}
+
 	delta = jiffies - rq->last_update;
-	if (delta >= HZ)
-		rq->last_update += (delta/HZ) * HZ;
+	if (delta >= WINDOW_SIZE)
+		rq->last_update += (delta/WINDOW_SIZE) * WINDOW_SIZE;
 }
 
 /* Account group's cpu usage */
@@ -788,7 +795,7 @@ static inline void inc_cpu_usage(struct 
 	struct user_struct *user = p->user;
 	struct cpu_usage *cu;
 
-	adjust_control_window();
+	adjust_control_window(0);
 
 	if (!user->cpu_limit)
 		return;
@@ -803,7 +810,7 @@ static inline int task_over_cpu_limit(st
 	struct user_struct *user = p->user;
 	struct cpu_usage *cu;
 
-	adjust_control_window();
+	adjust_control_window(0);
 
 	if (!user->cpu_limit)
 	 	return 0;
@@ -811,7 +818,7 @@ static inline int task_over_cpu_limit(st
 	cu = per_cpu_ptr(user->cpu_usage, task_cpu(p));
 	if (cu->last_update != rq->last_update) {
 		/* Replenish tokens */
-		cu->tokens += user->cpu_limit * HZ / 100;
+		cu->tokens += user->cpu_limit * WINDOW_SIZE / 100;
 		cu->last_update = rq->last_update;
 	}
 
@@ -830,6 +837,7 @@ static int task_over_cpu_limit(struct ta
 static void set_tsk_starving(struct task_struct *p) { }
 static void clear_tsk_starving(struct task_struct *p) { }
 static int is_user_starving(struct task_struct *p) { return 0;}
+static inline void adjust_control_window(int force) { }
 
 #endif		/* CONFIG_FAIRSCHED */
 
@@ -3668,7 +3676,7 @@ pick_next_task:
 	}
 
 	if (task_over_cpu_limit(next))
-		rq->last_update = jiffies;
+		adjust_control_window(1);
 	if (!next->time_slice)
 		next->time_slice = task_timeslice(next);
 	clear_tsk_starving(next);
_


-- 
Regards,
vatsa
