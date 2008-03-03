Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbYCCRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbYCCRR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbYCCROV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYCCROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:19 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 09/52] unify prepare_boot_cpu
Date: Mon,  3 Mar 2008 14:12:37 -0300
Message-Id: <1204564400-17636-10-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-9-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

definition is moved to common header. x86_64 version is now called
native_prepare_boot_cpu

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c     |    1 +
 arch/x86/kernel/smpboot_64.c |    2 +-
 include/asm-x86/smp.h        |    6 ++++++
 include/asm-x86/smp_32.h     |    5 -----
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 7cc20a3..05116c1 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -530,6 +530,7 @@ asmlinkage void smp_call_function_interrupt(void)
 }
 
 struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 	.cpu_up = native_cpu_up,
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index e381fe7..47e654c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -918,7 +918,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 /*
  * Early setup to make printk work.
  */
-void __init smp_prepare_boot_cpu(void)
+void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
 	/* already set me in cpu_online_map in boot_cpu_init() */
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 7dd7141..a2d69a1 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -24,6 +24,11 @@ struct smp_ops {
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
+static inline void smp_prepare_boot_cpu(void)
+{
+	smp_ops.smp_prepare_boot_cpu();
+}
+
 static inline int __cpu_up(unsigned int cpu)
 {
 	return smp_ops.cpu_up(cpu);
@@ -41,6 +46,7 @@ static inline int smp_call_function_mask(cpumask_t mask,
 	return smp_ops.smp_call_function_mask(mask, func, info, wait);
 }
 
+void native_smp_prepare_boot_cpu(void);
 int native_cpu_up(unsigned int cpunum);
 #endif
 
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index a7fab8e..2c7ecfa 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -39,10 +39,6 @@ extern void remove_siblinginfo(int cpu);
 extern void set_cpu_sibling_map(int cpu);
 
 #ifdef CONFIG_SMP
-static inline void smp_prepare_boot_cpu(void)
-{
-	smp_ops.smp_prepare_boot_cpu();
-}
 static inline void smp_prepare_cpus(unsigned int max_cpus)
 {
 	smp_ops.smp_prepare_cpus(max_cpus);
@@ -57,7 +53,6 @@ static inline void smp_send_stop(void)
 	smp_ops.smp_send_stop();
 }
 
-void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 
-- 
1.5.0.6

