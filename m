Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZA3KTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZA3KTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZA3KRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54363 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZA3KRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:50 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Move wakeup_secondary_via_nmi into numaq_32.c
Date: Fri, 30 Jan 2009 11:17:07 +0100
Message-Id: <1233310639-27916-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It's only used there.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/numaq_32.c   |   39 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c    |   39 ---------------------------------------
 3 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 45b4027..8c8289c 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -20,7 +20,6 @@ static inline void visws_early_detect(void) { }
 static inline int is_visws_box(void) { return 0; }
 #endif
 
-extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 83bb055..295c82e 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -234,6 +234,45 @@ static int __init numaq_setup_ioapic_ids(void)
 	return 1;
 }
 
+/*
+ * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
+ * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
+ * won't ... remember to clear down the APIC, etc later.
+ */
+static int __devinit
+wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+{
+	unsigned long send_status, accept_status = 0;
+	int maxlvt;
+
+	/* Target chip */
+	/* Boot on the stack */
+	/* Kick the second */
+	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
+
+	pr_debug("Waiting for send to finish...\n");
+	send_status = safe_apic_wait_icr_idle();
+
+	/*
+	 * Give the other CPU some time to accept the IPI.
+	 */
+	udelay(200);
+	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
+		accept_status = (apic_read(APIC_ESR) & 0xEF);
+	}
+	pr_debug("NMI sent.\n");
+
+	if (send_status)
+		printk(KERN_ERR "APIC never delivered???\n");
+	if (accept_status)
+		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
+
+	return (send_status | accept_status);
+}
+
 static int __init numaq_update_genapic(void)
 {
 	apic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2912fa3..709b65d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -570,45 +570,6 @@ void __inquire_remote_apic(int apicid)
 	}
 }
 
-/*
- * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
- * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
- * won't ... remember to clear down the APIC, etc later.
- */
-int __devinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
-{
-	unsigned long send_status, accept_status = 0;
-	int maxlvt;
-
-	/* Target chip */
-	/* Boot on the stack */
-	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
-
-	pr_debug("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	/*
-	 * Give the other CPU some time to accept the IPI.
-	 */
-	udelay(200);
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
-			apic_write(APIC_ESR, 0);
-		accept_status = (apic_read(APIC_ESR) & 0xEF);
-	}
-	pr_debug("NMI sent.\n");
-
-	if (send_status)
-		printk(KERN_ERR "APIC never delivered???\n");
-	if (accept_status)
-		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
-
-	return (send_status | accept_status);
-}
-
 int __devinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
-- 
1.5.6.5

