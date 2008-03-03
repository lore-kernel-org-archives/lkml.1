Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbYCCRS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbYCCRS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYCCRO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669AbYCCROZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:25 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 11/52] unify smp_cpus_done
Date: Mon,  3 Mar 2008 14:12:39 -0300
Message-Id: <1204564400-17636-12-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-11-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

definition is moved to common header. x86_64 version is now called
native_smp_cpus_done

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c     |    2 ++
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/smp.h        |    6 ++++++
 include/asm-x86/smp_32.h     |    7 -------
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index c520374..275101a 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -532,6 +532,8 @@ asmlinkage void smp_call_function_interrupt(void)
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = native_smp_prepare_cpus,
+	.smp_cpus_done = native_smp_cpus_done,
+
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 	.cpu_up = native_cpu_up,
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index b106983..fd0d3a9 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -987,7 +987,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 /*
  * Finish the SMP boot.
  */
-void __init smp_cpus_done(unsigned int max_cpus)
+void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	smp_cleanup_boot();
 	setup_ioapic_dest();
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 31bd99d..9620165 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -34,6 +34,11 @@ static inline void smp_prepare_cpus(unsigned int max_cpus)
 	smp_ops.smp_prepare_cpus(max_cpus);
 }
 
+static inline void smp_cpus_done(unsigned int max_cpus)
+{
+	smp_ops.smp_cpus_done(max_cpus);
+}
+
 static inline int __cpu_up(unsigned int cpu)
 {
 	return smp_ops.cpu_up(cpu);
@@ -53,6 +58,7 @@ static inline int smp_call_function_mask(cpumask_t mask,
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
+void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
 #endif
 
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 5078538..bc90a4e 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -39,18 +39,11 @@ extern void remove_siblinginfo(int cpu);
 extern void set_cpu_sibling_map(int cpu);
 
 #ifdef CONFIG_SMP
-static inline void smp_cpus_done(unsigned int max_cpus)
-{
-	smp_ops.smp_cpus_done(max_cpus);
-}
-
 static inline void smp_send_stop(void)
 {
 	smp_ops.smp_send_stop();
 }
 
-void native_smp_cpus_done(unsigned int max_cpus);
-
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
 #endif
-- 
1.5.0.6

