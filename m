Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZBGHjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZBGHjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZBGHjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:39:32 -0500
Received: from ozlabs.org ([203.10.76.45]:48279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZBGHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:39:30 -0500
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       "David S. Miller" <davem@davemloft.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Mike Travis <travis@sgi.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 7 Feb 2009 18:09:16 +1030
Subject: [PATCH 1/3] cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071809.17953.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Thanks to Al Viro for reminding me of this, via Ingo)

CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:

	#define CPU_MASK_ALL (cpumask_t) { { ... } }

Taking the address of such a temporary is questionable at best,
unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
CPU_MASK_ALL_PTR:

	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)

Which formalizes this practice.  One day gcc could bite us over this
usage (though we seem to have gotten away with it so far).

So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
with the modern "cpu_all_mask" (a real struct cpumask *), and remove
CPU_MASK_ALL_PTR altogether.

Also remove the confusing and deprecated large-NR_CPUS-only
"cpu_mask_all".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
---
 arch/mips/alchemy/common/time.c      |    2 +-
 arch/sparc/include/asm/topology_64.h |    2 +-
 arch/x86/include/asm/es7000/apic.h   |    2 +-
 arch/x86/include/asm/numaq/apic.h    |    2 +-
 include/linux/cpumask.h              |    6 ------
 init/main.c                          |    7 +------
 kernel/kmod.c                        |    2 +-
 kernel/kthread.c                     |    4 ++--
 mm/pdflush.c                         |    2 +-
 9 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -89,7 +89,7 @@ static struct clock_event_device au1x_rt
 	.irq		= AU1000_RTC_MATCH2_INT,
 	.set_next_event	= au1x_rtcmatch2_set_next_event,
 	.set_mode	= au1x_rtcmatch2_set_mode,
-	.cpumask	= CPU_MASK_ALL_PTR,
+	.cpumask	= cpu_all_mask,
 };
 
 static struct irqaction au1x_rtcmatch2_irqaction = {
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -49,7 +49,7 @@ static inline int pcibus_to_node(struct 
 	 node_to_cpumask(pcibus_to_node(bus)))
 #define cpumask_of_pcibus(bus)	\
 	(pcibus_to_node(bus) == -1 ? \
-	 CPU_MASK_ALL_PTR : \
+	 cpu_all_mask : \
 	 cpumask_of_node(pcibus_to_node(bus)))
 
 #define SD_NODE_INIT (struct sched_domain) {		\
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -13,7 +13,7 @@ static inline int apic_id_registered(voi
 
 static inline const cpumask_t *target_cpus_cluster(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 static inline const cpumask_t *target_cpus(void)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -9,7 +9,7 @@
 
 static inline const cpumask_t *target_cpus(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 #define NO_BALANCE_IRQ (1)
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -324,8 +324,6 @@ static inline const struct cpumask *get_
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
-
 #else
 
 #define CPU_MASK_ALL							\
@@ -333,10 +331,6 @@ static inline const struct cpumask *get_
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
-
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
 
 #endif
 
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -358,11 +358,6 @@ static inline void smp_prepare_cpus(unsi
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
-
-#if NR_CPUS > BITS_PER_LONG
-cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_mask_all);
-#endif
 
 /* Setup number of possible processor ids */
 int nr_cpu_ids __read_mostly = NR_CPUS;
@@ -834,7 +829,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
diff --git a/kernel/kmod.c b/kernel/kmod.c
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -167,7 +167,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff --git a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -110,7 +110,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed_ptr(create->result, cpu_all_mask);
 	}
 	complete(&create->done);
 }
@@ -240,7 +240,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
diff --git a/mm/pdflush.c b/mm/pdflush.c
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -191,7 +191,7 @@ static int pdflush(void *dummy)
 
 	/*
 	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == CPU_MASK_ALL.
+	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
 	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.

