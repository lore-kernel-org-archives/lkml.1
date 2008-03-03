Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbYCCRQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbYCCRQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYCCROR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbYCCROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:11 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 06/52] merge smp_send_reschedule
Date: Mon,  3 Mar 2008 14:12:34 -0300
Message-Id: <1204564400-17636-7-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-6-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function definition is moved to common header, x86_64 version is now called
native_smp_send_reschedule

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |    7 +++++--
 include/asm-x86/smp.h    |    5 +++++
 include/asm-x86/smp_32.h |    4 ----
 include/asm-x86/smp_64.h |    2 --
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 80dba12..fd18161 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -290,8 +290,9 @@ void flush_tlb_all(void)
  * anything. Worst case is that we lose a reschedule ...
  */
 
-void smp_send_reschedule(int cpu)
+static void native_smp_send_reschedule(int cpu)
 {
+	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
@@ -528,5 +529,7 @@ asmlinkage void smp_call_function_interrupt(void)
 	}
 }
 
-struct smp_ops smp_ops;
+struct smp_ops smp_ops = {
+	.smp_send_reschedule = native_smp_send_reschedule,
+};
 EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index ee98bee..28f33c0 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -23,6 +23,11 @@ struct smp_ops {
 
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
+
+static inline void smp_send_reschedule(int cpu)
+{
+	smp_ops.smp_send_reschedule(cpu);
+}
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 74755e8..c60a3dd 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -60,10 +60,6 @@ static inline void smp_send_stop(void)
 {
 	smp_ops.smp_send_stop();
 }
-static inline void smp_send_reschedule(int cpu)
-{
-	smp_ops.smp_send_reschedule(cpu);
-}
 static inline int smp_call_function_mask(cpumask_t mask,
 					 void (*func) (void *info), void *info,
 					 int wait)
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 284f701..b920458 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -65,8 +65,6 @@ static inline int num_booting_cpus(void)
 	return cpus_weight(cpu_callout_map);
 }
 
-extern void smp_send_reschedule(int cpu);
-
 #else /* CONFIG_SMP */
 
 extern unsigned int boot_cpu_id;
-- 
1.5.0.6

