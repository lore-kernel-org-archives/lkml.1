Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYGLBpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYGLBpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 21:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYGLBow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 21:44:52 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:20719 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYGLBov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 21:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=L6Pbd5RKrx7EptCmV/q1EdTxaw2dVCpkO46lVuHf7RQfFaCvDg7SSDLwcsx1sfUnU3
         ZpMOwO6dddaY2KDeSCbiY0wYd1Mv4FjU9QxCL7r5kbZfv4AzV9WiRKjdRrWO7trIs2uh
         c8vKKS6lR+qDMRX9njjUVf7QMfMdhzQlCBZK0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: let 32bit use apic_ops too
Date: Fri, 11 Jul 2008 18:41:54 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
In-Reply-To: <200807102038.26591.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111841.55403.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic_32.c |   39 +++++++++++++++++++++++++++++++--------
 include/asm-x86/apic.h    |   13 ++-----------
 2 files changed, 33 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -145,19 +145,13 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
-void apic_icr_write(u32 low, u32 id)
-{
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(id));
-	apic_write_around(APIC_ICR, low);
-}
-
-void apic_wait_icr_idle(void)
+void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
-u32 safe_apic_wait_icr_idle(void)
+u32 safe_xapic_wait_icr_idle(void)
 {
 	u32 send_status;
 	int timeout;
@@ -173,6 +167,35 @@ u32 safe_apic_wait_icr_idle(void)
 	return send_status;
 }
 
+void xapic_icr_write(u32 low, u32 id)
+{
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write_around(APIC_ICR, low);
+}
+
+u64 xapic_icr_read(void)
+{
+	u32 icr1, icr2;
+
+	icr2 = apic_read(APIC_ICR2);
+	icr1 = apic_read(APIC_ICR);
+
+	return icr1 | ((u64)icr2 << 32);
+}
+
+static struct apic_ops xapic_ops = {
+	.read = native_apic_mem_read,
+	.write = native_apic_mem_write,
+	.write_atomic = native_apic_mem_write_atomic,
+	.icr_read = xapic_icr_read,
+	.icr_write = xapic_icr_write,
+	.wait_icr_idle = xapic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
+};
+
+struct apic_ops __read_mostly *apic_ops = &xapic_ops;
+EXPORT_SYMBOL_GPL(apic_ops);
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -49,11 +49,6 @@ extern int disable_apic;
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#ifndef CONFIG_X86_64
-#define apic_write native_apic_mem_write
-#define apic_write_atomic native_apic_mem_write_atomic
-#define apic_read native_apic_mem_read
-#endif
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
@@ -95,16 +90,13 @@ static inline u32 native_apic_msr_read(u
 	return low;
 }
 
-#ifdef CONFIG_X86_32
-extern void apic_wait_icr_idle(void);
-extern u32 safe_apic_wait_icr_idle(void);
-extern void apic_icr_write(u32 low, u32 id);
-#else
+#ifndef CONFIG_X86_32
 extern int x2apic, x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
+#endif
 
 struct apic_ops {
 	u32 (*read)(u32 reg);
@@ -125,7 +117,6 @@ extern struct apic_ops *apic_ops;
 #define apic_icr_write (apic_ops->icr_write)
 #define apic_wait_icr_idle (apic_ops->wait_icr_idle)
 #define safe_apic_wait_icr_idle (apic_ops->safe_wait_icr_idle)
-#endif
 
 extern int get_physical_broadcast(void);
