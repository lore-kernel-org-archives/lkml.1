Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYCCRPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYCCRPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYCCROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493AbYCCROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:09 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 07/52] unify smp_call_function_mask
Date: Mon,  3 Mar 2008 14:12:35 -0300
Message-Id: <1204564400-17636-8-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-7-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

definition is moved to common header, x86_64 function name
now is native_smp_call_function_mask

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |    7 ++++---
 include/asm-x86/smp.h    |    7 +++++++
 include/asm-x86/smp_32.h |    6 ------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index fd18161..225b765 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -386,9 +386,9 @@ static int __smp_call_function_mask(cpumask_t mask,
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function_mask(cpumask_t mask,
-			   void (*func)(void *), void *info,
-			   int wait)
+int native_smp_call_function_mask(cpumask_t mask,
+				  void (*func)(void *), void *info,
+				  int wait)
 {
 	int ret;
 
@@ -531,5 +531,6 @@ asmlinkage void smp_call_function_interrupt(void)
 
 struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_call_function_mask = native_smp_call_function_mask,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 28f33c0..d9782f4 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -28,6 +28,13 @@ static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
 }
+
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info), void *info,
+					 int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index c60a3dd..d9337ee 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -60,12 +60,6 @@ static inline void smp_send_stop(void)
 {
 	smp_ops.smp_send_stop();
 }
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
-- 
1.5.0.6

