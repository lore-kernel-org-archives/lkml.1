Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZDUIIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZDUIIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZDUIHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:07:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZDUIHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:07:41 -0400
Date: Tue, 21 Apr 2009 08:07:00 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090420200450.271099000@linux-os.sc.intel.com>
References: <20090420200450.271099000@linux-os.sc.intel.com>
Subject: [tip:x86/apic] x86: x2apic, IR: Move eoi_ioapic_irq() into a CONFIG_INTR_REMAP section
Message-ID: <tip-25629d810a52176758401184d9b437fbb7f79195@git.kernel.org>
Git-Commit-ID: 25629d810a52176758401184d9b437fbb7f79195
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25629d810a52176758401184d9b437fbb7f79195
Gitweb:     http://git.kernel.org/tip/25629d810a52176758401184d9b437fbb7f79195
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 20 Apr 2009 13:02:28 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 09:08:26 +0200

x86: x2apic, IR: Move eoi_ioapic_irq() into a CONFIG_INTR_REMAP section

Address the following complier warning:

   arch/x86/kernel/apic/io_apic.c:2543: warning: `eoi_ioapic_irq' defined but not used

By moving that function (and eoi_ioapic_irq()) into an existing
#ifdef CONFIG_INTR_REMAP section of the code.

[ Impact: cleanup ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: dwmw2@infradead.org
Cc: Weidong Han <weidong.han@intel.com>
LKML-Reference: <20090420200450.271099000@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Weidong Han <weidong.han@intel.com>


---
 arch/x86/kernel/apic/io_apic.c |   66 ++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3a45d2e..4baa9cb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2517,39 +2517,6 @@ static void irq_complete_move(struct irq_desc **descp)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-
-	entry = cfg->irq_2_pin;
-	for (;;) {
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		io_apic_eoi(apic, pin);
-		entry = entry->next;
-	}
-}
-
-static void
-eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ack_apic_edge(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2659,6 +2626,39 @@ static void ack_apic_level(unsigned int irq)
 }
 
 #ifdef CONFIG_INTR_REMAP
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		io_apic_eoi(apic, pin);
+		entry = entry->next;
+	}
+}
+
+static void
+eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void ir_ack_apic_edge(unsigned int irq)
 {
 	ack_APIC_irq();
