Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYCST6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYCST6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCSThv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYCSThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:45 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 04/79] [PATCH] use start_ipi_hook in x86_64
Date: Wed, 19 Mar 2008 14:24:59 -0300
Message-Id: <12059475944070-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059475892790-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

It is used to match i386. The definition for the non-paravirt
case is moved to smp.h instead of smp_32.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |    8 ++++++++
 include/asm-x86/smp.h        |    3 +++
 include/asm-x86/smp_32.h     |    4 ----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 57ebe6c..13ab112 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -345,6 +345,14 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	num_starts = 2;
 
 	/*
+	 * Paravirt / VMI wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
+			(unsigned long) init_rsp);
+
+
+	/*
 	 * Run STARTUP IPI loop.
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 513c857..4dc271b 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -33,6 +33,9 @@ struct smp_ops {
 extern void set_cpu_sibling_map(int cpu);
 
 #ifdef CONFIG_SMP
+#ifndef CONFIG_PARAVIRT
+#define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
+#endif
 extern struct smp_ops smp_ops;
 
 static inline void smp_send_stop(void)
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 4fec2fe..76740de 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -30,10 +30,6 @@ DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 
 #ifdef CONFIG_SMP
-#ifndef CONFIG_PARAVIRT
-#define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
-#endif
-
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
-- 
1.5.0.6

