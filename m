Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbXLRH2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbXLRH2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXLRH2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:28:10 -0500
Received: from ozlabs.org ([203.10.76.45]:56482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXLRH2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:28:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC] hrtimers: add slop parameter
Date: Tue, 18 Dec 2007 18:27:59 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181827.59676.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I don't really like this patch yet, but wanted to get something out there)

After discussion with Thomas Gleixner, we came up with the idea of
introducing a new parameter to hrtimers (and probably eventually all
timers in the kernel, then onto userspace).  I call it "slop", and it
is an indication of how precise a timer should be.

The idea is that this "slop" can be used to calculate what timers can
be batched, and maybe even eventually unify normal and high res timers.
A timer should fire no earlier than its expiry, but we don't care if it's
delayed until after expiry+slop.

For this patch, DEFAULT_SLOP (currently 0) is used everywhere, and
the parameter is unused.

diff -r 0eabf082c13a drivers/kvm/lapic.c
--- a/drivers/kvm/lapic.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/drivers/kvm/lapic.c	Tue Dec 18 15:04:33 2007 +1100
@@ -968,7 +968,8 @@ int kvm_create_lapic(struct kvm_vcpu *vc
 	memset(apic->regs, 0, PAGE_SIZE);
 	apic->vcpu = vcpu;
 
-	hrtimer_init(&apic->timer.dev, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&apic->timer.dev, CLOCK_MONOTONIC, HRTIMER_MODE_ABS,
+		     DEFAULT_SLOP);
 	apic->timer.dev.function = apic_timer_fn;
 	apic->base_address = APIC_DEFAULT_PHYS_BASE;
 	vcpu->apic_base = APIC_DEFAULT_PHYS_BASE;
diff -r 0eabf082c13a drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/drivers/net/virtio_net.c	Tue Dec 18 15:04:33 2007 +1100
@@ -403,7 +403,8 @@ static int virtnet_probe(struct virtio_d
 	netif_napi_add(dev, &vi->napi, virtnet_poll, 16);
 	vi->dev = dev;
 	vi->vdev = vdev;
-	hrtimer_init(&vi->tx_timer, CLOCK_REALTIME, HRTIMER_MODE_REL);
+	hrtimer_init(&vi->tx_timer, CLOCK_REALTIME, HRTIMER_MODE_REL,
+		     DEFAULT_SLOP);
 	vi->tx_timer.function = kick_xmit;
 	vi->tx_timer.cb_mode = HRTIMER_CB_SOFTIRQ;
 	vi->out_max = -1U;
diff -r 0eabf082c13a include/linux/hrtimer.h
--- a/include/linux/hrtimer.h	Tue Dec 18 13:51:13 2007 +1100
+++ b/include/linux/hrtimer.h	Tue Dec 18 15:04:33 2007 +1100
@@ -100,6 +100,7 @@ enum hrtimer_cb_mode {
  * @cb_mode:	high resolution timer feature to select the callback execution
  *		 mode
  * @cb_entry:	list head to enqueue an expired timer into the callback list
+ * @slop:	how much extra delay can be added (eg. for deferring wakeups)
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
@@ -118,6 +119,7 @@ struct hrtimer {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	enum hrtimer_cb_mode		cb_mode;
 	struct list_head		cb_entry;
+	ktime_t				slop;
 #endif
 #ifdef CONFIG_TIMER_STATS
 	void				*start_site;
@@ -256,8 +258,9 @@ extern ktime_t ktime_get_real(void);
 /* Exported timer functions: */
 
 /* Initialize timers: */
+#define DEFAULT_SLOP ((ktime_t) { .tv64 = 0 })
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
-			 enum hrtimer_mode mode);
+			 enum hrtimer_mode mode, ktime_t slop);
 
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
diff -r 0eabf082c13a kernel/fork.c
--- a/kernel/fork.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/fork.c	Tue Dec 18 15:04:33 2007 +1100
@@ -874,7 +874,8 @@ static int copy_signal(unsigned long clo
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
-	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL,
+		     DEFAULT_SLOP);
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
 	sig->tsk = tsk;
diff -r 0eabf082c13a kernel/futex.c
--- a/kernel/futex.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/futex.c	Tue Dec 18 15:04:33 2007 +1100
@@ -1247,7 +1247,8 @@ static int futex_wait(u32 __user *uaddr,
 		if (!abs_time)
 			schedule();
 		else {
-			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+			hrtimer_init(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS,
+				     DEFAULT_SLOP);
 			hrtimer_init_sleeper(&t, current);
 			t.timer.expires = *abs_time;
 
@@ -1344,7 +1345,8 @@ static int futex_lock_pi(u32 __user *uad
 
 	if (time) {
 		to = &timeout;
-		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+		hrtimer_init(&to->timer, CLOCK_REALTIME, HRTIMER_MODE_ABS,
+			     DEFAULT_SLOP);
 		hrtimer_init_sleeper(to, current);
 		to->timer.expires = *time;
 	}
diff -r 0eabf082c13a kernel/hrtimer.c
--- a/kernel/hrtimer.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/hrtimer.c	Tue Dec 18 15:04:33 2007 +1100
@@ -522,9 +522,10 @@ static inline void hrtimer_init_hres(str
 /*
  * Initialize the high resolution related parts of a hrtimer
  */
-static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
+static inline void hrtimer_init_timer_hres(struct hrtimer *timer, ktime_t slop)
 {
 	INIT_LIST_HEAD(&timer->cb_entry);
+	timer->slop = slop;
 }
 
 /*
@@ -621,7 +622,9 @@ static inline int hrtimer_cb_pending(str
 static inline int hrtimer_cb_pending(struct hrtimer *timer) { return 0; }
 static inline void hrtimer_remove_cb_pending(struct hrtimer *timer) { }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
-static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
+static inline void hrtimer_init_timer_hres(struct hrtimer *timer, ktime_t slop)
+{
+}
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -987,9 +990,10 @@ ktime_t hrtimer_get_next_event(void)
  * @timer:	the timer to be initialized
  * @clock_id:	the clock to be used
  * @mode:	timer mode abs/rel
+ * @slop:	delay which can be added to timer without significant effect.
  */
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-		  enum hrtimer_mode mode)
+		  enum hrtimer_mode mode, ktime_t slop)
 {
 	struct hrtimer_cpu_base *cpu_base;
 
@@ -1001,7 +1005,7 @@ void hrtimer_init(struct hrtimer *timer,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
-	hrtimer_init_timer_hres(timer);
+	hrtimer_init_timer_hres(timer, slop);
 
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
@@ -1299,7 +1303,7 @@ long __sched hrtimer_nanosleep_restart(s
 
 	restart->fn = do_no_restart_syscall;
 
-	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
+	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS, DEFAULT_SLOP);
 	t.timer.expires.tv64 = ((u64)restart->arg3 << 32) | (u64) restart->arg2;
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
@@ -1326,7 +1330,7 @@ long hrtimer_nanosleep(struct timespec *
 	struct hrtimer_sleeper t;
 	ktime_t rem;
 
-	hrtimer_init(&t.timer, clockid, mode);
+	hrtimer_init(&t.timer, clockid, mode, DEFAULT_SLOP);
 	t.timer.expires = timespec_to_ktime(*rqtp);
 	if (do_nanosleep(&t, mode))
 		return 0;
diff -r 0eabf082c13a kernel/posix-timers.c
--- a/kernel/posix-timers.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/posix-timers.c	Tue Dec 18 15:04:33 2007 +1100
@@ -194,7 +194,8 @@ static inline int common_clock_set(const
 
 static int common_timer_create(struct k_itimer *new_timer)
 {
-	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
+	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0,
+		     DEFAULT_SLOP);
 	return 0;
 }
 
@@ -755,7 +756,7 @@ common_timer_set(struct k_itimer *timr, 
 		return 0;
 
 	mode = flags & TIMER_ABSTIME ? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
-	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode);
+	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode, DEFAULT_SLOP);
 	timr->it.real.timer.function = posix_timer_fn;
 
 	timer->expires = timespec_to_ktime(new_setting->it_value);
diff -r 0eabf082c13a kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/time/tick-sched.c	Tue Dec 18 15:04:33 2007 +1100
@@ -475,7 +475,8 @@ static void tick_nohz_switch_to_nohz(voi
 	 * Recycle the hrtimer in ts, so we can share the
 	 * hrtimer_forward with the highres code.
 	 */
-	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS,
+		     DEFAULT_SLOP);
 	/* Get the next period */
 	next = tick_init_jiffy_update();
 
@@ -579,7 +580,8 @@ void tick_setup_sched_timer(void)
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
 	 */
-	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS,
+		     DEFAULT_SLOP);
 	ts->sched_timer.function = tick_sched_timer;
 	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
