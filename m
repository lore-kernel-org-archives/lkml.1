Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZDQOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZDQOu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761889AbZDQOtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:49:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:40303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761945AbZDQOtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:49:52 -0400
Date: Fri, 17 Apr 2009 14:49:02 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239957736-6161-3-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-3-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] x86, intr-remap: fix ack for interrupt remapping
Message-ID: <tip-631dd7572e66ee524bb7dfe7dbc883f3484c7eee@git.kernel.org>
Git-Commit-ID: 631dd7572e66ee524bb7dfe7dbc883f3484c7eee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:49:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  631dd7572e66ee524bb7dfe7dbc883f3484c7eee
Gitweb:     http://git.kernel.org/tip/631dd7572e66ee524bb7dfe7dbc883f3484c7eee
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:23:44 +0200

x86, intr-remap: fix ack for interrupt remapping

Shouldn't call ack_apic_edge() in ir_ack_apic_edge(), because
ack_apic_edge() does more than just ack: it also does irq migration
in the non-interrupt-remapping case. But there is no such need for
interrupt-remapping case, as irq migration is done in the process
context.

Similarly, ir_ack_apic_level() shouldn't call ack_apic_level, and
instead should do the local cpu's EOI + directed EOI to the io-apic.

ack_x2APIC_irq() is not neccessary, because ack_APIC_irq() will use MSR
write for x2apic, and uncached write for non-x2apic.

[ Impact: simplify/standardize intr-remap IRQ acking, fix on !x2apic ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1239957736-6161-3-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h    |    8 --------
 arch/x86/kernel/apic/io_apic.c |   32 +++++---------------------------
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2bd5a46..d4cb7e5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -204,14 +204,6 @@ static inline int x2apic_enabled(void)
 
 extern int get_physical_broadcast(void);
 
-#ifdef CONFIG_X86_X2APIC
-static inline void ack_x2APIC_irq(void)
-{
-	/* Docs say use 0 for future compatibility */
-	native_apic_msr_write(APIC_EOI, 0);
-}
-#endif
-
 extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8499000..ea22a86 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2552,20 +2552,6 @@ eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-#ifdef CONFIG_X86_X2APIC
-static void ack_x2apic_level(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	ack_x2APIC_irq();
-	eoi_ioapic_irq(desc);
-}
-
-static void ack_x2apic_edge(unsigned int irq)
-{
-	ack_x2APIC_irq();
-}
-#endif
-
 static void ack_apic_edge(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2629,9 +2615,6 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
-	if (irq_remapped(irq))
-		eoi_ioapic_irq(desc);
-
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2680,20 +2663,15 @@ static void ack_apic_level(unsigned int irq)
 #ifdef CONFIG_INTR_REMAP
 static void ir_ack_apic_edge(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_edge(irq);
-#endif
-       return ack_apic_edge(irq);
+	ack_APIC_irq();
 }
 
 static void ir_ack_apic_level(unsigned int irq)
 {
-#ifdef CONFIG_X86_X2APIC
-       if (x2apic_enabled())
-               return ack_x2apic_level(irq);
-#endif
-       return ack_apic_level(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	ack_APIC_irq();
+	eoi_ioapic_irq(desc);
 }
 #endif /* CONFIG_INTR_REMAP */
 
