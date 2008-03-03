Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbYCCRRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbYCCRRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYCCROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbYCCROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:18 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 08/52] unify __cpu_up.
Date: Mon,  3 Mar 2008 14:12:36 -0300
Message-Id: <1204564400-17636-9-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-8-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function definition is moved to common header. x86_64 version
is now called native_cpu_up

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c     |    1 +
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/smp.h        |    7 +++++++
 include/asm-x86/smp_32.h     |    5 -----
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 225b765..7cc20a3 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -532,5 +532,6 @@ asmlinkage void smp_call_function_interrupt(void)
 struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
+	.cpu_up = native_cpu_up,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 0880f2c..e381fe7 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -929,7 +929,7 @@ void __init smp_prepare_boot_cpu(void)
 /*
  * Entry point to boot a CPU.
  */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index d9782f4..7dd7141 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -24,6 +24,11 @@ struct smp_ops {
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
+static inline int __cpu_up(unsigned int cpu)
+{
+	return smp_ops.cpu_up(cpu);
+}
+
 static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
@@ -35,6 +40,8 @@ static inline int smp_call_function_mask(cpumask_t mask,
 {
 	return smp_ops.smp_call_function_mask(mask, func, info, wait);
 }
+
+int native_cpu_up(unsigned int cpunum);
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index d9337ee..a7fab8e 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -47,10 +47,6 @@ static inline void smp_prepare_cpus(unsigned int max_cpus)
 {
 	smp_ops.smp_prepare_cpus(max_cpus);
 }
-static inline int __cpu_up(unsigned int cpu)
-{
-	return smp_ops.cpu_up(cpu);
-}
 static inline void smp_cpus_done(unsigned int max_cpus)
 {
 	smp_ops.smp_cpus_done(max_cpus);
@@ -63,7 +59,6 @@ static inline void smp_send_stop(void)
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
-int native_cpu_up(unsigned int cpunum);
 void native_smp_cpus_done(unsigned int max_cpus);
 
 #ifndef CONFIG_PARAVIRT
-- 
1.5.0.6

