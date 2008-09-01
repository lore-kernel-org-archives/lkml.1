Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYIAXSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYIAXSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYIAXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:45030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYIAXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:51 -0400
Date: Mon, 1 Sep 2008 16:08:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 5/13] hrtimer: convert kernel/* to the new hrtimer apis
Message-ID: <20080901160809.108f6fd9@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert kernel/* to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts kernel/* to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/futex.c           |    7 +++----
 kernel/hrtimer.c         |   44 +++++++++++++++++++++++---------------------
 kernel/posix-timers.c    |   10 ++++------
 kernel/rtmutex.c         |    3 +--
 kernel/sched.c           |    7 +++----
 kernel/time/ntp.c        |    3 +--
 kernel/time/tick-sched.c |   21 ++++++++++-----------
 kernel/time/timer_list.c |    4 ++--
 8 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7d1136e..4cd5b43 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1299,10 +1299,9 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC,
 						HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
-			t.timer.expires = *abs_time;
+			hrtimer_set_expires(&t.timer, *abs_time);
 
-			hrtimer_start(&t.timer, t.timer.expires,
-						HRTIMER_MODE_ABS);
+			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
 			if (!hrtimer_active(&t.timer))
 				t.task = NULL;
 
@@ -1404,7 +1403,7 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
 				      HRTIMER_MODE_ABS);
 		hrtimer_init_sleeper(to, current);
-		to->timer.expires = *time;
+		hrtimer_set_expires(&to->timer, *time);
 	}
 
 	q.pi_state = NULL;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 782137d..ae307fe 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -517,7 +517,7 @@ static void hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base)
 		if (!base->first)
 			continue;
 		timer = rb_entry(base->first, struct hrtimer, node);
-		expires = ktime_sub(timer->expires, base->offset);
+		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 		if (expires.tv64 < cpu_base->expires_next.tv64)
 			cpu_base->expires_next = expires;
 	}
@@ -539,10 +539,10 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
 	ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
-	ktime_t expires = ktime_sub(timer->expires, base->offset);
+	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 	int res;
 
-	WARN_ON_ONCE(timer->expires.tv64 < 0);
+	WARN_ON_ONCE(hrtimer_get_expires_tv64(timer) < 0);
 
 	/*
 	 * When the callback is running, we do not reprogram the clock event
@@ -794,7 +794,7 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 	u64 orun = 1;
 	ktime_t delta;
 
-	delta = ktime_sub(now, timer->expires);
+	delta = ktime_sub(now, hrtimer_get_expires(timer));
 
 	if (delta.tv64 < 0)
 		return 0;
@@ -806,8 +806,8 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 		s64 incr = ktime_to_ns(interval);
 
 		orun = ktime_divns(delta, incr);
-		timer->expires = ktime_add_ns(timer->expires, incr * orun);
-		if (timer->expires.tv64 > now.tv64)
+		hrtimer_add_expires_ns(timer, incr * orun);
+		if (hrtimer_get_expires_tv64(timer) > now.tv64)
 			return orun;
 		/*
 		 * This (and the ktime_add() below) is the
@@ -815,7 +815,7 @@ u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 		 */
 		orun++;
 	}
-	timer->expires = ktime_add_safe(timer->expires, interval);
+	hrtimer_add_expires(timer, interval);
 
 	return orun;
 }
@@ -847,7 +847,8 @@ static void enqueue_hrtimer(struct hrtimer *timer,
 		 * We dont care about collisions. Nodes with
 		 * the same expiry time stay together.
 		 */
-		if (timer->expires.tv64 < entry->expires.tv64) {
+		if (hrtimer_get_expires_tv64(timer) <
+				hrtimer_get_expires_tv64(entry)) {
 			link = &(*link)->rb_left;
 		} else {
 			link = &(*link)->rb_right;
@@ -982,7 +983,7 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 #endif
 	}
 
-	timer->expires = tim;
+	hrtimer_set_expires(timer, tim);
 
 	timer_stats_hrtimer_set_start_info(timer);
 
@@ -1076,7 +1077,7 @@ ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 	ktime_t rem;
 
 	base = lock_hrtimer_base(timer, &flags);
-	rem = ktime_sub(timer->expires, base->get_time());
+	rem = hrtimer_expires_remaining(timer);
 	unlock_hrtimer_base(timer, &flags);
 
 	return rem;
@@ -1108,7 +1109,7 @@ ktime_t hrtimer_get_next_event(void)
 				continue;
 
 			timer = rb_entry(base->first, struct hrtimer, node);
-			delta.tv64 = timer->expires.tv64;
+			delta.tv64 = hrtimer_get_expires_tv64(timer);
 			delta = ktime_sub(delta, base->get_time());
 			if (delta.tv64 < mindelta.tv64)
 				mindelta.tv64 = delta.tv64;
@@ -1308,10 +1309,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 			timer = rb_entry(node, struct hrtimer, node);
 
-			if (basenow.tv64 < timer->expires.tv64) {
+			if (basenow.tv64 < hrtimer_get_expires_tv64(timer)) {
 				ktime_t expires;
 
-				expires = ktime_sub(timer->expires,
+				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
@@ -1414,7 +1415,8 @@ void hrtimer_run_queues(void)
 			struct hrtimer *timer;
 
 			timer = rb_entry(node, struct hrtimer, node);
-			if (base->softirq_time.tv64 <= timer->expires.tv64)
+			if (base->softirq_time.tv64 <=
+					hrtimer_get_expires_tv64(timer))
 				break;
 
 			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
@@ -1462,7 +1464,7 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
-		hrtimer_start(&t->timer, t->timer.expires, mode);
+		hrtimer_start_expires(&t->timer, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
 
@@ -1484,7 +1486,7 @@ static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
 	struct timespec rmt;
 	ktime_t rem;
 
-	rem = ktime_sub(timer->expires, timer->base->get_time());
+	rem = hrtimer_expires_remaining(timer);
 	if (rem.tv64 <= 0)
 		return 0;
 	rmt = ktime_to_timespec(rem);
@@ -1503,7 +1505,7 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 
 	hrtimer_init_on_stack(&t.timer, restart->nanosleep.index,
 				HRTIMER_MODE_ABS);
-	t.timer.expires.tv64 = restart->nanosleep.expires;
+	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		goto out;
@@ -1530,7 +1532,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	int ret = 0;
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
-	t.timer.expires = timespec_to_ktime(*rqtp);
+	hrtimer_set_expires(&t.timer, timespec_to_ktime(*rqtp));
 	if (do_nanosleep(&t, mode))
 		goto out;
 
@@ -1550,7 +1552,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.index = t.timer.base->index;
 	restart->nanosleep.rmtp = rmtp;
-	restart->nanosleep.expires = t.timer.expires.tv64;
+	restart->nanosleep.expires = hrtimer_get_expires_tv64(&t.timer);
 
 	ret = -ERESTART_RESTARTBLOCK;
 out:
@@ -1724,11 +1726,11 @@ int __sched schedule_hrtimeout(ktime_t *expires,
 	}
 
 	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
-	t.timer.expires = *expires;
+	hrtimer_set_expires(&t.timer, *expires);
 
 	hrtimer_init_sleeper(&t, current);
 
-	hrtimer_start(&t.timer, t.timer.expires, mode);
+	hrtimer_start_expires(&t.timer, mode);
 	if (!hrtimer_active(&t.timer))
 		t.task = NULL;
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e36d579..f85efcd 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -668,7 +668,7 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
 		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
 
-	remaining = ktime_sub(timer->expires, now);
+	remaining = ktime_sub(hrtimer_get_expires(timer), now);
 	/* Return 0 only, when the timer is expired and not pending */
 	if (remaining.tv64 <= 0) {
 		/*
@@ -762,7 +762,7 @@ common_timer_set(struct k_itimer *timr, int flags,
 	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode);
 	timr->it.real.timer.function = posix_timer_fn;
 
-	timer->expires = timespec_to_ktime(new_setting->it_value);
+	hrtimer_set_expires(timer, timespec_to_ktime(new_setting->it_value));
 
 	/* Convert interval */
 	timr->it.real.interval = timespec_to_ktime(new_setting->it_interval);
@@ -771,14 +771,12 @@ common_timer_set(struct k_itimer *timr, int flags,
 	if (((timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
 		/* Setup correct expiry time for relative timers */
 		if (mode == HRTIMER_MODE_REL) {
-			timer->expires =
-				ktime_add_safe(timer->expires,
-					       timer->base->get_time());
+			hrtimer_add_expires(timer, timer->base->get_time());
 		}
 		return 0;
 	}
 
-	hrtimer_start(timer, timer->expires, mode);
+	hrtimer_start_expires(timer, mode);
 	return 0;
 }
 
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 6522ae5..69d9cb9 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -631,8 +631,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 	/* Setup the timer, when timeout != NULL */
 	if (unlikely(timeout)) {
-		hrtimer_start(&timeout->timer, timeout->timer.expires,
-			      HRTIMER_MODE_ABS);
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
 		if (!hrtimer_active(&timeout->timer))
 			timeout->task = NULL;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a1ddb8..b5e2605 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -221,9 +221,8 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 
 		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
 		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-		hrtimer_start(&rt_b->rt_period_timer,
-			      rt_b->rt_period_timer.expires,
-			      HRTIMER_MODE_ABS);
+		hrtimer_start_expires(&rt_b->rt_period_timer,
+				HRTIMER_MODE_ABS);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 }
@@ -1058,7 +1057,7 @@ static void hrtick_start(struct rq *rq, u64 delay)
 	struct hrtimer *timer = &rq->hrtick_timer;
 	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
 
-	timer->expires = time;
+	hrtimer_set_expires(timer, time);
 
 	if (rq == this_rq()) {
 		hrtimer_restart(timer);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5125ddd..4c8d854 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -142,8 +142,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE "Clock: "
 		       "inserting leap second 23:59:60 UTC\n");
-		leap_timer.expires = ktime_add_ns(leap_timer.expires,
-						  NSEC_PER_SEC);
+		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7a46bde..be105fd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -285,7 +285,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 				goto out;
 			}
 
-			ts->idle_tick = ts->sched_timer.expires;
+			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 			rcu_enter_nohz();
@@ -416,21 +416,21 @@ void tick_nohz_restart_sched_tick(void)
 	ts->tick_stopped  = 0;
 	ts->idle_exittime = now;
 	hrtimer_cancel(&ts->sched_timer);
-	ts->sched_timer.expires = ts->idle_tick;
+	hrtimer_set_expires(&ts->sched_timer, ts->idle_tick);
 
 	while (1) {
 		/* Forward the time to expire in the future */
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-			hrtimer_start(&ts->sched_timer,
-				      ts->sched_timer.expires,
+			hrtimer_start_expires(&ts->sched_timer,
 				      HRTIMER_MODE_ABS);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				break;
 		} else {
-			if (!tick_program_event(ts->sched_timer.expires, 0))
+			if (!tick_program_event(
+				hrtimer_get_expires(&ts->sched_timer), 0))
 				break;
 		}
 		/* Update jiffies and reread time */
@@ -443,7 +443,7 @@ void tick_nohz_restart_sched_tick(void)
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
 	hrtimer_forward(&ts->sched_timer, now, tick_period);
-	return tick_program_event(ts->sched_timer.expires, 0);
+	return tick_program_event(hrtimer_get_expires(&ts->sched_timer), 0);
 }
 
 /*
@@ -526,7 +526,7 @@ static void tick_nohz_switch_to_nohz(void)
 	next = tick_init_jiffy_update();
 
 	for (;;) {
-		ts->sched_timer.expires = next;
+		hrtimer_set_expires(&ts->sched_timer, next);
 		if (!tick_program_event(next, 0))
 			break;
 		next = ktime_add(next, tick_period);
@@ -622,16 +622,15 @@ void tick_setup_sched_timer(void)
 	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
 	/* Get the next period (per cpu) */
-	ts->sched_timer.expires = tick_init_jiffy_update();
+	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 	offset = ktime_to_ns(tick_period) >> 1;
 	do_div(offset, num_possible_cpus());
 	offset *= smp_processor_id();
-	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
+	hrtimer_add_expires_ns(&ts->sched_timer, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
-		hrtimer_start(&ts->sched_timer, ts->sched_timer.expires,
-			      HRTIMER_MODE_ABS);
+		hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS);
 		/* Check, if the timer was already in the past */
 		if (hrtimer_active(&ts->sched_timer))
 			break;
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a40e20f..5224a32 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -66,8 +66,8 @@ print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
 #endif
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
-		(unsigned long long)ktime_to_ns(timer->expires),
-		(long long)(ktime_to_ns(timer->expires) - now));
+		(unsigned long long)ktime_to_ns(hrtimer_get_expires(timer)),
+		(long long)(ktime_to_ns(hrtimer_get_expires(timer)) - now));
 }
 
 static void
-- 
1.5.5.1

