Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbYCSUZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbYCSUZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYCSTje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281AbYCSTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:05 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 10/79] [PATCH] merge smp_store_cpu_info
Date: Wed, 19 Mar 2008 14:25:05 -0300
Message-Id: <12059476212769-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476162900-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

now that it is the same between arches, put it into smpboot.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   77 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   71 +--------------------------------------
 arch/x86/kernel/smpboot_64.c |   15 --------
 include/asm-x86/smp.h        |    2 +
 include/asm-x86/smp_32.h     |    2 -
 5 files changed, 80 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b13b9d5..a157a52 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -45,6 +45,83 @@ unsigned char *trampoline_base = __va(SMP_TRAMPOLINE_BASE);
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
+#ifdef CONFIG_X86_32
+/* Set if we find a B stepping CPU */
+int __cpuinitdata smp_b_stepping;
+#endif
+
+static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_32
+	/*
+	 * Mask B, Pentium, but not Pentium MMX
+	 */
+	if (c->x86_vendor == X86_VENDOR_INTEL &&
+	    c->x86 == 5 &&
+	    c->x86_mask >= 1 && c->x86_mask <= 4 &&
+	    c->x86_model <= 3)
+		/*
+		 * Remember we have B step Pentia with bugs
+		 */
+		smp_b_stepping = 1;
+
+	/*
+	 * Certain Athlons might work (for various values of 'work') in SMP
+	 * but they are not certified as MP capable.
+	 */
+	if ((c->x86_vendor == X86_VENDOR_AMD) && (c->x86 == 6)) {
+
+		if (num_possible_cpus() == 1)
+			goto valid_k7;
+
+		/* Athlon 660/661 is valid. */
+		if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
+		    (c->x86_mask == 1)))
+			goto valid_k7;
+
+		/* Duron 670 is valid */
+		if ((c->x86_model == 7) && (c->x86_mask == 0))
+			goto valid_k7;
+
+		/*
+		 * Athlon 662, Duron 671, and Athlon >model 7 have capability
+		 * bit. It's worth noting that the A5 stepping (662) of some
+		 * Athlon XP's have the MP bit set.
+		 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
+		 * more.
+		 */
+		if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
+		    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
+		     (c->x86_model > 7))
+			if (cpu_has_mp)
+				goto valid_k7;
+
+		/* If we get here, not a certified SMP capable AMD system. */
+		add_taint(TAINT_UNSAFE_SMP);
+	}
+
+valid_k7:
+	;
+#endif
+}
+
+/*
+ * The bootstrap kernel entry code has set these up. Save them for
+ * a given CPU
+ */
+
+void __cpuinit smp_store_cpu_info(int id)
+{
+	struct cpuinfo_x86 *c = &cpu_data(id);
+
+	*c = boot_cpu_data;
+	c->cpu_index = id;
+	if (id != 0)
+		identify_secondary_cpu(c);
+	smp_apply_quirks(c);
+}
+
+
 void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index e050064..0bfb31e 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -59,8 +59,7 @@
 #include <asm/vmi.h>
 #include <asm/mtrr.h>
 
-/* Set if we find a B stepping CPU */
-static int __cpuinitdata smp_b_stepping;
+extern int smp_b_stepping;
 
 static cpumask_t smp_commenced_mask;
 
@@ -78,74 +77,6 @@ static void map_cpu_to_logical_apicid(void);
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
-{
-	/*
-	 * Mask B, Pentium, but not Pentium MMX
-	 */
-	if (c->x86_vendor == X86_VENDOR_INTEL &&
-	    c->x86 == 5 &&
-	    c->x86_mask >= 1 && c->x86_mask <= 4 &&
-	    c->x86_model <= 3)
-		/*
-		 * Remember we have B step Pentia with bugs
-		 */
-		smp_b_stepping = 1;
-
-	/*
-	 * Certain Athlons might work (for various values of 'work') in SMP
-	 * but they are not certified as MP capable.
-	 */
-	if ((c->x86_vendor == X86_VENDOR_AMD) && (c->x86 == 6)) {
-
-		if (num_possible_cpus() == 1)
-			goto valid_k7;
-
-		/* Athlon 660/661 is valid. */	
-		if ((c->x86_model==6) && ((c->x86_mask==0) || (c->x86_mask==1)))
-			goto valid_k7;
-
-		/* Duron 670 is valid */
-		if ((c->x86_model==7) && (c->x86_mask==0))
-			goto valid_k7;
-
-		/*
-		 * Athlon 662, Duron 671, and Athlon >model 7 have capability bit.
-		 * It's worth noting that the A5 stepping (662) of some Athlon XP's
-		 * have the MP bit set.
-		 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for more.
-		 */
-		if (((c->x86_model==6) && (c->x86_mask>=2)) ||
-		    ((c->x86_model==7) && (c->x86_mask>=1)) ||
-		     (c->x86_model> 7))
-			if (cpu_has_mp)
-				goto valid_k7;
-
-		/* If we get here, it's not a certified SMP capable AMD system. */
-		add_taint(TAINT_UNSAFE_SMP);
-	}
-
-valid_k7:
-	;
-
-}
-
-/*
- * The bootstrap kernel entry code has set these up. Save them for
- * a given CPU
- */
-
-void __cpuinit smp_store_cpu_info(int id)
-{
-	struct cpuinfo_x86 *c = &cpu_data(id);
-
-	*c = boot_cpu_data;
-	c->cpu_index = id;
-	if (id != 0)
-		identify_secondary_cpu(c);
-	smp_apply_quirks(c);
-}
-
 static atomic_t init_deasserted;
 
 static void __cpuinit smp_callin(void)
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index f84e30d..c213345 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -85,21 +85,6 @@ struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define set_idle_for_cpu(x,p)   (idle_thread_array[(x)] = (p))
 #endif
 
-/*
- * The bootstrap kernel entry code has set these up. Save them for
- * a given CPU
- */
-
-static void __cpuinit smp_store_cpu_info(int id)
-{
-	struct cpuinfo_x86 *c = &cpu_data(id);
-
-	*c = boot_cpu_data;
-	c->cpu_index = id;
-	if (id != 0)
-		identify_secondary_cpu(c);
-}
-
 static inline void wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 4dc271b..b4c5143 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -88,6 +88,8 @@ extern void prefill_possible_map(void);
 
 #define SMP_TRAMPOLINE_BASE 0x6000
 extern unsigned long setup_trampoline(void);
+
+void smp_store_cpu_info(int id);
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 76740de..51624ab 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -42,8 +42,6 @@ DECLARE_PER_CPU(int, cpu_number);
 
 extern int safe_smp_processor_id(void);
 
-void __cpuinit smp_store_cpu_info(int id);
-
 /* We don't mark CPUs online until __cpu_up(), so we need another measure */
 static inline int num_booting_cpus(void)
 {
-- 
1.5.0.6

