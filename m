Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZEARgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZEARgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZEARgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:36:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZEARgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:36:23 -0400
Date: Fri, 1 May 2009 10:34:52 -0700
Message-Id: <200905011734.n41HYqbp014338@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 MCE minor fixes
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixer <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are fixes for some relatively minor machine check issues in x86.

	-hpa

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-mce-for-linus

Andi Kleen (2):
      x86, mce: make polling timer interval per CPU
      x86, mce: fix boot logging logic

 arch/x86/include/asm/mce.h          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_64.c |   33 +++++++++++++++++----------------
 2 files changed, 18 insertions(+), 16 deletions(-)
commit 5679af4c1625a1534a4321e1ecc3c48a1cf65eb8
Author: Andi Kleen <andi@firstfloor.org>
Date:   Tue Apr 7 17:06:55 2009 +0200

    x86, mce: fix boot logging logic
    
    The earlier patch to change the poller to a separate function subtly
    broke the boot logging logic. This could lead to machine checks
    getting logged at boot even when disabled or defaulting to off
    on some systems. Fix that.
    
    [ Impact: bug fix - avoid spurious MCE in log ]
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 563933e..4f8c199 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -137,6 +137,7 @@ DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 enum mcp_flags {
 	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
 	MCP_UC = (1 << 1),		/* log uncorrected errors */
+	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
 };
 extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 82614f1..6fb0b35 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -239,9 +239,10 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-
-		mce_log(&m);
-		add_taint(TAINT_MACHINE_CHECK);
+		if (!(flags & MCP_DONTLOG)) {
+			mce_log(&m);
+			add_taint(TAINT_MACHINE_CHECK);
+		}
 
 		/*
 		 * Clear state for this bank.
@@ -585,7 +586,7 @@ static void mce_init(void *dummy)
 	 * Log the machine checks left over from the previous reset.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
-	machine_check_poll(MCP_UC, &all_banks);
+	machine_check_poll(MCP_UC|(!mce_bootlog ? MCP_DONTLOG : 0), &all_banks);
 
 	set_in_cr4(X86_CR4_MCE);
 

commit 6298c512bc1007c3ff5c9ce20e6996781651cc45
Author: Andi Kleen <andi@firstfloor.org>
Date:   Thu Apr 9 12:28:22 2009 +0200

    x86, mce: make polling timer interval per CPU
    
    The polling timer while running per CPU still uses a global next_interval
    variable, which lead to some CPUs either polling too fast or too slow.
    This was not a serious problem because all errors get picked up eventually,
    but it's still better to avoid it. Turn next_interval into a per cpu variable.
    
    v2: Fix check_interval == 0 case (Hidetoshi Seto)
    
    [ Impact: minor bug fix ]
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 863f895..82614f1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -452,13 +452,14 @@ void mce_log_therm_throt_event(__u64 status)
  */
 
 static int check_interval = 5 * 60; /* 5 minutes */
-static int next_interval; /* in jiffies */
+static DEFINE_PER_CPU(int, next_interval); /* in jiffies */
 static void mcheck_timer(unsigned long);
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
 static void mcheck_timer(unsigned long data)
 {
 	struct timer_list *t = &per_cpu(mce_timer, data);
+	int *n;
 
 	WARN_ON(smp_processor_id() != data);
 
@@ -470,14 +471,14 @@ static void mcheck_timer(unsigned long data)
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
 	 * polling interval, otherwise increase the polling interval.
 	 */
+	n = &__get_cpu_var(next_interval);
 	if (mce_notify_user()) {
-		next_interval = max(next_interval/2, HZ/100);
+		*n = max(*n/2, HZ/100);
 	} else {
-		next_interval = min(next_interval * 2,
-				(int)round_jiffies_relative(check_interval*HZ));
+		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
 	}
 
-	t->expires = jiffies + next_interval;
+	t->expires = jiffies + *n;
 	add_timer(t);
 }
 
@@ -632,14 +633,13 @@ static void mce_cpu_features(struct cpuinfo_x86 *c)
 static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
+	int *n = &__get_cpu_var(next_interval);
 
-	/* data race harmless because everyone sets to the same value */
-	if (!next_interval)
-		next_interval = check_interval * HZ;
-	if (!next_interval)
+	*n = check_interval * HZ;
+	if (!*n)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
-	t->expires = round_jiffies(jiffies + next_interval);
+	t->expires = round_jiffies(jiffies + *n);
 	add_timer(t);
 }
 
@@ -907,7 +907,6 @@ static void mce_cpu_restart(void *data)
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	next_interval = check_interval * HZ;
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
@@ -1110,7 +1109,8 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies + next_interval);
+		t->expires = round_jiffies(jiffies +
+						__get_cpu_var(next_interval));
 		add_timer_on(t, cpu);
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
