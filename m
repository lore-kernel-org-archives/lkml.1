Return-Path: <linux-kernel-owner+w=401wt.eu-S1765101AbYCSUNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765101AbYCSUNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYCSTiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbYCSTim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:42 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 38/79] [PATCH] move smp_intr_init away from smpboot_32.c
Date: Wed, 19 Mar 2008 14:25:33 -0300
Message-Id: <12059477472416-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477421707-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We move it to apic_32.c, since it's irq related anyway,
and only called from that file.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c    |   23 +++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   21 ---------------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6aa93db..c32cc0f 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1317,6 +1317,29 @@ void smp_error_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+#ifdef CONFIG_SMP
+void __init smp_intr_init(void)
+{
+	/*
+	 * IRQ0 must be given a fixed assignment and initialized,
+	 * because it's used before the IO-APIC is set up.
+	 */
+	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
+
+	/*
+	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
+	 * IPI, driven by wakeup.
+	 */
+	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+
+	/* IPI for invalidation */
+	set_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
+
+	/* IPI for generic function call */
+	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+}
+#endif
+
 /*
  * Initialize APIC interrupts
  */
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 1736404..87c9a75 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -968,24 +968,3 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 #endif
 	zap_low_mappings();
 }
-
-void __init smp_intr_init(void)
-{
-	/*
-	 * IRQ0 must be given a fixed assignment and initialized,
-	 * because it's used before the IO-APIC is set up.
-	 */
-	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
-
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	set_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPI for invalidation */
-	set_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
-
-	/* IPI for generic function call */
-	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-}
-- 
1.5.0.6

