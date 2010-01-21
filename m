Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669Ab0AUQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0AUQl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322Ab0AUQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38399 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0AUQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] x86, smp: Adjust native_wbinvd for smp_call_function-helpers
Date: Thu, 21 Jan 2010 17:41:28 +0100
Message-Id: <1264092093-13739-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a wbinvd_on_cpu() helper and fold the void * arg in the wbinvd macro
definition so that native_wbinvd can be used in the smp_call_function_*
helpers as a pointed-to function.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/paravirt.h       |    3 ++-
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/include/asm/smp.h            |    3 +++
 arch/x86/include/asm/system.h         |   10 ++++++++--
 arch/x86/lib/smp.c                    |    7 +++++++
 5 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index dd59a85..ee034a6 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -117,7 +117,8 @@ static inline void halt(void)
 
 static inline void wbinvd(void)
 {
-	PVOP_VCALL0(pv_cpu_ops.wbinvd);
+	void *uninitialized_var(dummy_ptr);
+	PVOP_VCALL1(pv_cpu_ops.wbinvd, dummy_ptr);
 }
 
 #define get_kernel_rpl()  (pv_info.kernel_rpl)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index b1e70d5..79730b8 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -136,7 +136,7 @@ struct pv_cpu_ops {
 
 	void (*set_iopl_mask)(unsigned mask);
 
-	void (*wbinvd)(void);
+	void (*wbinvd)(void *);
 	void (*io_delay)(void);
 
 	/* cpuid emulation, mostly so that caps bits can be disabled */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1e79678..090146e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -138,6 +138,7 @@ void play_dead_common(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
+void wbinvd_on_cpu(int cpu);
 
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
@@ -147,6 +148,8 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+#else /* !CONFIG_SMP */
+#define wbinvd_on_cpu(cpu)	wbinvd()
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index ecb544e..8c531ab 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -297,7 +297,7 @@ static inline void native_write_cr8(unsigned long val)
 }
 #endif
 
-static inline void native_wbinvd(void)
+static inline void native_wbinvd(void *dummy)
 {
 	asm volatile("wbinvd": : :"memory");
 }
@@ -314,7 +314,13 @@ static inline void native_wbinvd(void)
 #define read_cr4()	(native_read_cr4())
 #define read_cr4_safe()	(native_read_cr4_safe())
 #define write_cr4(x)	(native_write_cr4(x))
-#define wbinvd()	(native_wbinvd())
+
+#define wbinvd()					\
+	({						\
+		void *uninitialized_var(dumb_ptr);	\
+		native_wbinvd(dumb_ptr);		\
+	})
+
 #ifdef CONFIG_X86_64
 #define read_cr8()	(native_read_cr8())
 #define write_cr8(x)	(native_write_cr8(x))
diff --git a/arch/x86/lib/smp.c b/arch/x86/lib/smp.c
index a6b1b86..408c3b7 100644
--- a/arch/x86/lib/smp.c
+++ b/arch/x86/lib/smp.c
@@ -2,6 +2,7 @@
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <asm/msr.h>
+#include <asm/system.h>
 
 static void __rdmsr_on_cpu(void *info)
 {
@@ -202,3 +203,9 @@ int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
 	return err ? err : rv.err;
 }
 EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
+
+void wbinvd_on_cpu(int cpu)
+{
+	smp_call_function_single(cpu, native_wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_cpu);
-- 
1.6.6

