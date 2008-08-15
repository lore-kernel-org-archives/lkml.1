Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYHOCW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYHOCW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYHOCV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58827 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYHOCV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vHjEwkaQUR9pQD51RMiKCn8QJopCHCbGtwWnhtPZ8PdZO0odKtYSj5PKb5GWvhLtC5
         FyRgj2SMrYJmvV4NaLBIAhgMKUZjZ7wZnV2iXnj09+CEnaQ1yNfrdbYKAv6cOLi+yXyV
         By27ANIwh5qClmY/pNArHFj0nZ9o0q3qi9fI4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/7] x86: make 32bit support per_cpu vector fix #1
Date: Thu, 14 Aug 2008 19:20:28 -0700
Message-Id: <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use cpu_online_map as target cpus for bigsmp. just like 64 bit doing

also remove some unused TARGET_CPUS macro.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/asm-x86/bigsmp/apic.h |   15 +++++----------
 include/asm-x86/es7000/apic.h |    3 +--
 include/asm-x86/numaq/apic.h  |    2 --
 include/asm-x86/summit/apic.h |    1 -
 4 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/include/asm-x86/bigsmp/apic.h b/include/asm-x86/bigsmp/apic.h
index 0a9cd7c..1d9543b 100644
--- a/include/asm-x86/bigsmp/apic.h
+++ b/include/asm-x86/bigsmp/apic.h
@@ -9,22 +9,17 @@ static inline int apic_id_registered(void)
 	return (1);
 }
 
-/* Round robin the irqs amoung the online cpus */
 static inline cpumask_t target_cpus(void)
 {
-	static unsigned long cpu = NR_CPUS;
-	do {
-		if (cpu >= NR_CPUS)
-			cpu = first_cpu(cpu_online_map);
-		else
-			cpu = next_cpu(cpu, cpu_online_map);
-	} while (cpu >= NR_CPUS);
-	return cpumask_of_cpu(cpu);
+#ifdef CONFIG_SMP
+        return cpu_online_map;
+#else
+        return cpumask_of_cpu(0);
+#endif
 }
 
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0
-#define TARGET_CPUS		(target_cpus())
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
 #define INT_DEST_MODE		(0)    /* phys delivery to target proc */
diff --git a/include/asm-x86/es7000/apic.h b/include/asm-x86/es7000/apic.h
index bd2c44d..750afad 100644
--- a/include/asm-x86/es7000/apic.h
+++ b/include/asm-x86/es7000/apic.h
@@ -17,7 +17,6 @@ static inline cpumask_t target_cpus(void)
 	return cpumask_of_cpu(smp_processor_id());
 #endif
 }
-#define TARGET_CPUS	(target_cpus())
 
 #if defined CONFIG_ES7000_CLUSTERED_APIC
 #define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
@@ -81,7 +80,7 @@ static inline void setup_apic_routing(void)
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
-		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
+		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(target_cpus())[0]);
 }
 
 static inline int multi_timer_check(int apic, int irq)
diff --git a/include/asm-x86/numaq/apic.h b/include/asm-x86/numaq/apic.h
index a8344ba..0bf2a06 100644
--- a/include/asm-x86/numaq/apic.h
+++ b/include/asm-x86/numaq/apic.h
@@ -12,8 +12,6 @@ static inline cpumask_t target_cpus(void)
 	return CPU_MASK_ALL;
 }
 
-#define TARGET_CPUS (target_cpus())
-
 #define NO_BALANCE_IRQ (1)
 #define esr_disable (1)
 
diff --git a/include/asm-x86/summit/apic.h b/include/asm-x86/summit/apic.h
index c5b2e4b..0f68037 100644
--- a/include/asm-x86/summit/apic.h
+++ b/include/asm-x86/summit/apic.h
@@ -22,7 +22,6 @@ static inline cpumask_t target_cpus(void)
 	 */
 	return cpumask_of_cpu(0);
 }
-#define TARGET_CPUS	(target_cpus())
 
 #define INT_DELIVERY_MODE (dest_LowestPrio)
 #define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
-- 
1.5.4.5

