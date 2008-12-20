Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYLTRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYLTRuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 12:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYLTRuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 12:50:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYLTRuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 12:50:02 -0500
Date: Sat, 20 Dec 2008 18:48:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] posix-timers: CLOCK_MONOTONIC_RAW: fix the usage of
	->it_clock
Message-ID: <20081220174817.GA5273@redhat.com>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain> <20081220161457.GA26499@redhat.com> <20081220163033.GB26499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220163033.GB26499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(compile tested)

common_timer_create() and common_timer_set() blindly pass ->it_clock to
hrtimer_init() as clock_id. This used to work until CLOCK_MONOTONIC_RAW
was introduced, now we should be careful.

Perhaps it makes sense to add BUG_ON(clock_id >= HRTIMER_MAX_CLOCK_BASES)
to __hrtimer_init(), the wrong clock_id leads to catastrophe.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/posix-timers.c~CLOCK_MONOTONIC_RAW	2008-12-02 17:12:40.000000000 +0100
+++ K-28/kernel/posix-timers.c	2008-12-20 18:23:28.000000000 +0100
@@ -191,12 +191,20 @@ static inline int common_clock_set(const
 	return do_sys_settimeofday(tp, NULL);
 }
 
-static int common_timer_create(struct k_itimer *new_timer)
+static inline int
+__common_timer_init(struct k_itimer *timer, enum hrtimer_mode mode)
 {
-	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
+	clockid_t clock_id = timer->it_clock ?
+				CLOCK_MONOTONIC : CLOCK_REALTIME;
+	hrtimer_init(&timer->it.real.timer, clock_id, mode);
 	return 0;
 }
 
+static int common_timer_create(struct k_itimer *new_timer)
+{
+	return __common_timer_init(new_timer, HRTIMER_MODE_ABS);
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -730,7 +738,7 @@ common_timer_set(struct k_itimer *timr, 
 		return 0;
 
 	mode = flags & TIMER_ABSTIME ? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
-	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode);
+	__common_timer_init(timr, mode);
 	timr->it.real.timer.function = posix_timer_fn;
 
 	hrtimer_set_expires(timer, timespec_to_ktime(new_setting->it_value));

