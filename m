Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYGNFUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYGNFUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGNFUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:20:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:40769 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYGNFUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=iUFU2ODsl1X8BQtrqD2obKdysb9wrj091zb9SejapJo2Y+VcN2AH9s2JfQswLToJLQ
         h/CqFedFQJPfPEg+7c6jbV0gVJm3Z/PzuCXZ/M4w7Na24ursx8YXMm+cQRwij+taDlP1
         YbWI5NUZZACEKaGHSac/1pPgkXiLolM9kHVsw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: let 32bit use apic_ops too - fix
Date: Sun, 13 Jul 2008 22:19:35 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com>
In-Reply-To: <200807111841.55403.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807132219.35814.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix for pv.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/paravirt.c |    5 ----
 arch/x86/kernel/vmi_32.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/xen/enlighten.c   |   19 +++++++---------
 include/asm-x86/paravirt.h |   29 -------------------------
 4 files changed, 57 insertions(+), 47 deletions(-)

Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -373,11 +373,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-#ifndef CONFIG_X86_64
-	.apic_write = native_apic_mem_write,
-	.apic_write_atomic = native_apic_mem_write_atomic,
-	.apic_read = native_apic_mem_read,
-#endif
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 	.startup_ipi_hook = paravirt_nop,
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -676,6 +676,50 @@ static inline int __init probe_vmi_rom(v
 	return 0;
 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
+static u32 vmi_apic_read(u32 reg)
+{
+	return 0;
+}
+
+static void vmi_apic_write(u32 reg, u32 val)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static u64 vmi_apic_icr_read(void)
+{
+	return 0;
+}
+
+static void vmi_apic_icr_write(u32 low, u32 id)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static void vmi_apic_wait_icr_idle(void)
+{
+	return;
+}
+
+static u32 vmi_safe_apic_wait_icr_idle(void)
+{
+	return 0;
+}
+
+static struct apic_ops vmi_basic_apic_ops = {
+        .read = vmi_apic_read,
+        .write = vmi_apic_write,
+        .write_atomic = vmi_apic_write,
+        .icr_read = vmi_apic_icr_read,
+        .icr_write = vmi_apic_icr_write,
+        .wait_icr_idle = vmi_apic_wait_icr_idle,
+        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
+};
+#endif
+
 /*
  * VMI setup common to all processors
  */
@@ -904,9 +948,10 @@ static inline int __init activate_vmi(vo
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	para_fill(pv_apic_ops.apic_read, APICRead);
-	para_fill(pv_apic_ops.apic_write, APICWrite);
-	para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
+	para_fill(vmi_basic_apic_ops.read, APICRead);
+	para_fill(vmi_basic_apic_ops.write, APICWrite);
+	para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
+	apic_ops = &vmi_basic_apic_ops;
 #endif
 
 	/*
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -587,7 +587,6 @@ static void xen_apic_write(u32 reg, u32
 	WARN_ON(1);
 }
 
-#ifdef CONFIG_X86_64
 static u64 xen_apic_icr_read(void)
 {
 	return 0;
@@ -604,6 +603,11 @@ static void xen_apic_wait_icr_idle(void)
         return;
 }
 
+static u32 xen_safe_apic_wait_icr_idle(void)
+{
+        return 0;
+}
+
 static struct apic_ops xen_basic_apic_ops = {
 	.read = xen_apic_read,
 	.write = xen_apic_write,
@@ -611,9 +615,8 @@ static struct apic_ops xen_basic_apic_op
 	.icr_read = xen_apic_icr_read,
 	.icr_write = xen_apic_icr_write,
 	.wait_icr_idle = xen_apic_wait_icr_idle,
-	.safe_wait_icr_idle = xen_apic_wait_icr_idle,
+	.safe_wait_icr_idle = xen_safe_apic_wait_icr_idle,
 };
-#endif
 
 #endif
 
@@ -1298,11 +1301,6 @@ static const struct pv_irq_ops xen_irq_o
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
-#ifndef CONFIG_X86_64
-	.apic_write = xen_apic_write,
-	.apic_write_atomic = xen_apic_write,
-	.apic_read = xen_apic_read,
-#endif
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
 	.startup_ipi_hook = paravirt_nop,
@@ -1704,9 +1702,10 @@ asmlinkage void __init xen_start_kernel(
 	pv_irq_ops = xen_irq_ops;
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
-#ifdef CONFIG_X86_64
+
+#ifdef CONFIG_X86_LOCAL_APIC
 	/*
-	 * for 64bit, set up the basic apic ops aswell.
+	 * set up the basic apic ops.
 	 */
 	apic_ops = &xen_basic_apic_ops;
 #endif
Index: linux-2.6/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6.orig/include/asm-x86/paravirt.h
+++ linux-2.6/include/asm-x86/paravirt.h
@@ -200,15 +200,6 @@ struct pv_irq_ops {
 
 struct pv_apic_ops {
 #ifdef CONFIG_X86_LOCAL_APIC
-#ifndef CONFIG_X86_64
-	/*
-	 * Direct APIC operations, principally for VMI.  Ideally
-	 * these shouldn't be in this interface.
-	 */
-	void (*apic_write)(u32 reg, u32 v);
-	void (*apic_write_atomic)(u32 reg, u32 v);
-	u32 (*apic_read)(u32 reg);
-#endif
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
 
@@ -901,26 +892,6 @@ static inline void slow_down_io(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Basic functions accessing APICs.
- */
-#ifndef CONFIG_X86_64
-static inline void apic_write(u32 reg, u32 v)
-{
-	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
-}
-
-static inline void apic_write_atomic(u32 reg, u32 v)
-{
-	PVOP_VCALL2(pv_apic_ops.apic_write_atomic, reg, v);
-}
-
-static inline u32 apic_read(u32 reg)
-{
-	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
-}
-#endif
-
 static inline void setup_boot_clock(void)
 {
 	PVOP_VCALL0(pv_apic_ops.setup_boot_clock);
