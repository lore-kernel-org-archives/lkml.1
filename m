Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZHHP2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZHHP2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZHHP2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbZHHP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:28:06 -0400
Date: Sat, 8 Aug 2009 15:27:36 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20090805200931.GB5319@lenovo>
References: <20090805200931.GB5319@lenovo>
Subject: [tip:x86/apic] x86, ioapic: Panic on irq-pin binding only if needed
Message-ID: <tip-f3d1915a8623b9248572d3ee44e19a80b7a3520b@git.kernel.org>
Git-Commit-ID: f3d1915a8623b9248572d3ee44e19a80b7a3520b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3d1915a8623b9248572d3ee44e19a80b7a3520b
Gitweb:     http://git.kernel.org/tip/f3d1915a8623b9248572d3ee44e19a80b7a3520b
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 6 Aug 2009 00:09:31 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:20:03 +0200

x86, ioapic: Panic on irq-pin binding only if needed

Though the most time we are to panic on irq-pin allocation
fails, for PCI interrupts it's not the case and we could
continue operate even if irq-pin allocation failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090805200931.GB5319@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2a145d3..2999f3d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -490,7 +490,8 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int
+add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -498,19 +499,27 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin
 	last = &cfg->irq_2_pin;
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == apic && entry->pin == pin)
-			return;
+			return 0;
 		last = &entry->next;
 	}
 
 	entry = get_one_free_irq_2_pin(node);
 	if (!entry) {
-		printk(KERN_ERR "can not alloc irq_pin_list\n");
-		BUG_ON(1);
+		printk(KERN_ERR "can not alloc irq_pin_list (%d,%d,%d)\n",
+				node, apic, pin);
+		return -ENOMEM;
 	}
 	entry->apic = apic;
 	entry->pin = pin;
 
 	*last = entry;
+	return 0;
+}
+
+static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+{
+	if (add_pin_to_irq_node_nopanic(cfg, node, apic, pin))
+		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
 }
 
 /*
@@ -3843,7 +3852,11 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_node(cfg, node, ioapic, pin);
+		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
+			printk(KERN_INFO "can not add pin %d for irq %d\n",
+				pin, irq);
+			return 0;
+		}
 	}
 
 	setup_IO_APIC_irq(ioapic, pin, irq, desc, trigger, polarity);
