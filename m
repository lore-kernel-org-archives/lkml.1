Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZDLQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZDLQvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZDLQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:51:06 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53008 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZDLQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Xhli2NJdlG+imFRasC4K+TzOjA2mWZlFXzFOiAuGYedo4ktseswakaCAQ2L1fpe+AL
         jy/hA7aTw1ynkpXvgMrR7D7UcWM89l6Rrtl+X9YGSxC/tR4LUppOArc7IVH94HCsQ2wO
         y7zaZ5ApUeV3BLsg6NCaeYxyVo/4Lb7haZWJ4=
Message-Id: <20090412165058.724788431@openvz.org>
User-Agent: quilt/0.47-1
Date: Sun, 12 Apr 2009 20:47:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: xemul@openvz.org, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, andi@firstfloor.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 3/4] x86: apic - introduce dummy apic operations
References: <20090412164738.967602112@openvz.org>
Content-Disposition: inline; filename=x86-apic-write-nop
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if apic was disabled by kernel option
or hardware limits we could use dummy operations
such as apic->write at moment.

Same time the patch fixes the missed EOI in
do_IRQ function (which has place if kernel
is compiled as X86-32 and interrupt without
handler happens where apic was not asked to
be disabled via kernel option).

Note that native_apic_write_dummy consists of
WARN_ON_ONCE to catch any unpredictable
writes on enabled APICs. Could be removed
after long time of testing.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h |    3 ++-
 arch/x86/kernel/apic/apic.c |   24 ++++++++++++++++++++++++
 arch/x86/kernel/irq.c       |   10 ++--------
 3 files changed, 28 insertions(+), 9 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -212,6 +212,7 @@ static inline void ack_x2APIC_irq(void)
 }
 #endif
 
+extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -252,7 +253,7 @@ static inline void lapic_shutdown(void) 
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
-
+static inline void apic_disable(void) { }
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_64
Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -233,6 +233,24 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * bare function to substitute write operation
+ * and it's _that_ fast :)
+ */
+void native_apic_write_dummy(u32 reg, u32 v)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+}
+
+/*
+ * right after this call apic->write doesn't do anything
+ * note that there is no restore operation it works one way
+ */
+void apic_disable(void)
+{
+	apic->write = native_apic_write_dummy;
+}
+
 void native_apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
@@ -1592,6 +1610,12 @@ void __init init_apic_mappings(void)
 	 */
 	if (boot_cpu_physical_apicid == -1U)
 		boot_cpu_physical_apicid = read_apic_id();
+
+	/* lets check if we may to NOP'ify apic operations */
+	if (!cpu_has_apic) {
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+	}
 }
 
 /*
Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -27,7 +27,6 @@ void ack_bad_irq(unsigned int irq)
 	if (printk_ratelimit())
 		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
 	 * We _must_ ack these because every local APIC has only N
@@ -37,9 +36,7 @@ void ack_bad_irq(unsigned int irq)
 	 * completely.
 	 * But only ack when the APIC is enabled -AK
 	 */
-	if (cpu_has_apic)
-		ack_APIC_irq();
-#endif
+	ack_APIC_irq();
 }
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
@@ -224,10 +221,7 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
-		if (!disable_apic)
-			ack_APIC_irq();
-#endif
+		ack_APIC_irq();
 
 		if (printk_ratelimit())
 			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",

