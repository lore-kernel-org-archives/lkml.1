Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbXJ2WkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbXJ2WkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXJ2Wjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:39:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11977 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXJ2Wjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:39:54 -0400
Message-ID: <47266132.5050001@ct.jp.nec.com>
Date: Mon, 29 Oct 2007 15:39:46 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com, tglx@linutronix.de
Cc: hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Revert x86: add lapic_shutdown for x86_64
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com> <20071024062933.GA4622@in.ibm.com>
In-Reply-To: <20071024062933.GA4622@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lapic_shutdown is useless on x86_64.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/apic_64.c |   14 --------------
 arch/x86/kernel/crash.c   |    5 +++++
 include/asm-x86/apic_64.h |    1 -
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index f28ccb5..f47bc49 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -287,20 +287,6 @@ void disable_local_APIC(void)
 	apic_write(APIC_SPIV, value);
 }
 
-void lapic_shutdown(void)
-{
-	unsigned long flags;
-
-	if (!cpu_has_apic)
-		return;
-
-	local_irq_save(flags);
-
-	disable_local_APIC();
-
-	local_irq_restore(flags);
-}
-
 /*
  * This is to verify that we're looking at a real local APIC.
  * Check these against your board if the CPUs aren't getting
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 8bb482f..79a5a25 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -136,7 +136,12 @@ void machine_crash_shutdown(struct pt_regs *regs)
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = safe_smp_processor_id();
 	nmi_shootdown_cpus();
+#ifdef CONFIG_X86_32
 	lapic_shutdown();
+#else
+	if (cpu_has_apic)
+		disable_local_APIC();
+#endif
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
diff --git a/include/asm-x86/apic_64.h b/include/asm-x86/apic_64.h
index 2747a11..3c8f21e 100644
--- a/include/asm-x86/apic_64.h
+++ b/include/asm-x86/apic_64.h
@@ -69,7 +69,6 @@ extern void clear_local_APIC (void);
 extern void connect_bsp_APIC (void);
 extern void disconnect_bsp_APIC (int virt_wire_setup);
 extern void disable_local_APIC (void);
-extern void lapic_shutdown (void);
 extern int verify_local_APIC (void);
 extern void cache_APIC_registers (void);
 extern void sync_Arb_IDs (void);
-- 
1.5.3.4

