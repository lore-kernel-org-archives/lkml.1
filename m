Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYGXPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYGXPS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYGXPSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:18:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYGXPSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:18:20 -0400
Date: Thu, 24 Jul 2008 17:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] timer fixes
Message-ID: <20080724151802.GA21151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timer fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	Ingo

------------------>
Thomas Gleixner (2):
      nohz: prevent tick stop outside of the idle loop
      nohz: adjust tick_nohz_stop_sched_tick() call of s390 as well


 arch/arm/kernel/process.c              |    2 +-
 arch/avr32/kernel/process.c            |    2 +-
 arch/blackfin/kernel/process.c         |    2 +-
 arch/mips/kernel/process.c             |    2 +-
 arch/powerpc/kernel/idle.c             |    2 +-
 arch/powerpc/platforms/iseries/setup.c |    4 ++--
 arch/s390/kernel/process.c             |    2 +-
 arch/sh/kernel/process_32.c            |    2 +-
 arch/sparc64/kernel/process.c          |    2 +-
 arch/um/kernel/process.c               |    2 +-
 arch/x86/kernel/process_32.c           |    2 +-
 arch/x86/kernel/process_64.c           |    2 +-
 include/linux/tick.h                   |    5 +++--
 kernel/softirq.c                       |    2 +-
 kernel/time/tick-sched.c               |   12 ++++++++++--
 15 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 199b368..89bfded 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -162,7 +162,7 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 		leds_event(led_idle_start);
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched())
 			idle();
 		leds_event(led_idle_end);
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 6cf9df1..ff820a9 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -31,7 +31,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched())
 			cpu_idle_sleep();
 		tick_nohz_restart_sched_tick();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 53c2cd2..77800dd 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -105,7 +105,7 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched())
 			idle();
 		tick_nohz_restart_sched_tick();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index c06f5b5..b16facd 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -53,7 +53,7 @@ void __noreturn cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched()) {
 #ifdef CONFIG_SMTC_IDLE_HOOK_DEBUG
 			extern void smtc_idle_loop_hook(void);
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index c3cf0e8..d308a9f 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -60,7 +60,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index b721207..70b688c 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -561,7 +561,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -591,7 +591,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 85defd0..9839767 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -142,7 +142,7 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched())
 			default_idle();
 		tick_nohz_restart_sched_tick();
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index b98e37a..921892c 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -86,7 +86,7 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched())
 			idle();
 		tick_nohz_restart_sched_tick();
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index 2084f81..0798928 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -97,7 +97,7 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 83603cf..a1c6d07 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -243,7 +243,7 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
 		tick_nohz_restart_sched_tick();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0c3927a..53bc653 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -128,7 +128,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched()) {
 
 			check_pgt_cache();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index a8e5362..9a10c18 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(1);
 		while (!need_resched()) {
 
 			rmb();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index a881c65..d3c0269 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -49,6 +49,7 @@ struct tick_sched {
 	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
 	ktime_t				idle_tick;
+	int				inidle;
 	int				tick_stopped;
 	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
@@ -105,14 +106,14 @@ static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(void);
+extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_update_jiffies(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern void tick_nohz_stop_idle(int cpu);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(void) { }
+static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline void tick_nohz_update_jiffies(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 81e2fe0..f6b03d5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -286,7 +286,7 @@ void irq_exit(void)
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
-		tick_nohz_stop_sched_tick();
+		tick_nohz_stop_sched_tick(0);
 	rcu_irq_exit();
 #endif
 	preempt_enable_no_resched();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index beef7cc..a5c26d2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -195,7 +195,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-void tick_nohz_stop_sched_tick(void)
+void tick_nohz_stop_sched_tick(int inidle)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
@@ -224,6 +224,11 @@ void tick_nohz_stop_sched_tick(void)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
+	if (!inidle && !ts->inidle)
+		goto end;
+
+	ts->inidle = 1;
+
 	if (need_resched())
 		goto end;
 
@@ -373,11 +378,14 @@ void tick_nohz_restart_sched_tick(void)
 	local_irq_disable();
 	tick_nohz_stop_idle(cpu);
 
-	if (!ts->tick_stopped) {
+	if (!ts->inidle || !ts->tick_stopped) {
+		ts->inidle = 0;
 		local_irq_enable();
 		return;
 	}
 
+	ts->inidle = 0;
+
 	rcu_exit_nohz();
 
 	/* Update jiffies first */
