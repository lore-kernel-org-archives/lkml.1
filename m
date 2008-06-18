Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbYFRAij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbYFRAij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 20:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYFRAi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 20:38:27 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54387 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbYFRAiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 20:38:17 -0400
Date: Wed, 18 Jun 2008 03:36:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh/kernel/ cleanups
Message-ID: <20080618003650.GO25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global code static:
  - cf-enabler.c: cf_init()
  - cpu/clock.c: __clk_enable()
  - cpu/clock.c: __clk_disable()
  - process_32.c: default_idle()
  - time_32.c: struct clocksource_sh
  - timers/timer-tmu.c: struct tmu_timer_ops
- remove the following unused functions (no CONFIG_BLK_DEV_FD on sh):
  - process_{32,64}.c: disable_hlt()
  - process_{32,64}.c: enable_hlt()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/kernel/cf-enabler.c       |    2 +-
 arch/sh/kernel/cpu/clock.c        |    6 ++----
 arch/sh/kernel/process_32.c       |   14 +-------------
 arch/sh/kernel/process_64.c       |   10 ----------
 arch/sh/kernel/time_32.c          |    2 +-
 arch/sh/kernel/timers/timer-tmu.c |    2 +-
 include/asm-sh/clock.h            |    3 ---
 include/asm-sh/system.h           |    8 --------
 include/asm-sh/timer.h            |    1 -
 9 files changed, 6 insertions(+), 42 deletions(-)

6afa3ab285425364d3764cb8f9bd3b054405ecc1 diff --git a/arch/sh/kernel/cf-enabler.c b/arch/sh/kernel/cf-enabler.c
index 01ff4d0..d3d9f32 100644
--- a/arch/sh/kernel/cf-enabler.c
+++ b/arch/sh/kernel/cf-enabler.c
@@ -157,7 +157,7 @@ static int __init cf_init_se(void)
 }
 #endif
 
-int __init cf_init(void)
+static int __init cf_init(void)
 {
 	if (mach_is_se() || mach_is_7722se() || mach_is_7721se())
 		return cf_init_se();
diff --git a/arch/sh/kernel/cpu/clock.c b/arch/sh/kernel/cpu/clock.c
index b5f1e23..73334c6 100644
--- a/arch/sh/kernel/cpu/clock.c
+++ b/arch/sh/kernel/cpu/clock.c
@@ -88,7 +88,7 @@ static void propagate_rate(struct clk *clk)
 	}
 }
 
-int __clk_enable(struct clk *clk)
+static int __clk_enable(struct clk *clk)
 {
 	/*
 	 * See if this is the first time we're enabling the clock, some
@@ -111,7 +111,6 @@ int __clk_enable(struct clk *clk)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__clk_enable);
 
 int clk_enable(struct clk *clk)
 {
@@ -131,7 +130,7 @@ static void clk_kref_release(struct kref *kref)
 	/* Nothing to do */
 }
 
-void __clk_disable(struct clk *clk)
+static void __clk_disable(struct clk *clk)
 {
 	int count = kref_put(&clk->kref, clk_kref_release);
 
@@ -143,7 +142,6 @@ void __clk_disable(struct clk *clk)
 			clk->ops->disable(clk);
 	}
 }
-EXPORT_SYMBOL_GPL(__clk_disable);
 
 void clk_disable(struct clk *clk)
 {
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index b98e37a..e15086a 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -34,18 +34,6 @@ void (*pm_idle)(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
 static int __init nohlt_setup(char *__unused)
 {
 	hlt_counter = 1;
@@ -60,7 +48,7 @@ static int __init hlt_setup(char *__unused)
 }
 __setup("hlt", hlt_setup);
 
-void default_idle(void)
+static void default_idle(void)
 {
 	if (!hlt_counter) {
 		clear_thread_flag(TIF_POLLING_NRFLAG);
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -36,16 +36,6 @@ static int hlt_counter = 1;
 
 #define HARD_IDLE_TIMEOUT (HZ / 3)
 
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-
 static int __init nohlt_setup(char *__unused)
 {
 	hlt_counter = 1;
diff --git a/arch/sh/kernel/time_32.c b/arch/sh/kernel/time_32.c
index 7281342..0758b5e 100644
--- a/arch/sh/kernel/time_32.c
+++ b/arch/sh/kernel/time_32.c
@@ -211,7 +211,7 @@ unsigned long sh_hpt_frequency = 0;
 
 #define NSEC_PER_CYC_SHIFT	10
 
-struct clocksource clocksource_sh = {
+static struct clocksource clocksource_sh = {
 	.name		= "SuperH",
 	.rating		= 200,
 	.mask		= CLOCKSOURCE_MASK(32),
diff --git a/arch/sh/kernel/timers/timer-tmu.c b/arch/sh/kernel/timers/timer-tmu.c
index 8935570..1ca9ad4 100644
--- a/arch/sh/kernel/timers/timer-tmu.c
+++ b/arch/sh/kernel/timers/timer-tmu.c
@@ -209,7 +209,7 @@ static int tmu_timer_init(void)
 	return 0;
 }
 
-struct sys_timer_ops tmu_timer_ops = {
+static struct sys_timer_ops tmu_timer_ops = {
 	.init		= tmu_timer_init,
 	.start		= tmu_timer_start,
 	.stop		= tmu_timer_stop,
diff --git a/include/asm-sh/clock.h b/include/asm-sh/clock.h
index b550a27..608fda5 100644
--- a/include/asm-sh/clock.h
+++ b/include/asm-sh/clock.h
@@ -41,9 +41,6 @@ void arch_init_clk_ops(struct clk_ops **, int type);
 /* arch/sh/kernel/cpu/clock.c */
 int clk_init(void);
 
-int __clk_enable(struct clk *);
-void __clk_disable(struct clk *);
-
 void clk_recalc_rate(struct clk *);
 
 int clk_register(struct clk *);
diff --git a/include/asm-sh/system.h b/include/asm-sh/system.h
index e65b6b8..056d68c 100644
--- a/include/asm-sh/system.h
+++ b/include/asm-sh/system.h
@@ -148,14 +148,6 @@ extern unsigned long cached_to_uncached;
 
 extern struct dentry *sh_debugfs_root;
 
-/* XXX
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-void disable_hlt(void);
-void enable_hlt(void);
-
-void default_idle(void);
 void per_cpu_trap_init(void);
 
 asmlinkage void break_point_trap(void);
diff --git a/include/asm-sh/timer.h b/include/asm-sh/timer.h
index 701ba84..327f7eb 100644
--- a/include/asm-sh/timer.h
+++ b/include/asm-sh/timer.h
@@ -40,6 +40,5 @@ struct sys_timer *get_sys_timer(void);
 /* arch/sh/kernel/time.c */
 void handle_timer_tick(void);
 extern unsigned long sh_hpt_frequency;
-extern struct clocksource clocksource_sh;
 
 #endif /* __ASM_SH_TIMER_H */

