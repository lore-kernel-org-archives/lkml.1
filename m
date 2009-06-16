Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbZFPURm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbZFPURm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbZFPUQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:13 -0400
Received: from claw.goop.org ([74.207.240.146]:40587 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865AbZFPUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/16] x86/ioapic.c: simplify add_pin_to_irq_node()
Date: Tue, 16 Jun 2009 13:15:51 -0700
Message-Id: <1245183355-25808-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Rather than duplicating the same alloc/init code twice, restructure
the function to look for duplicates and then add an entry
if none is found.

This function is not performance critical; all but one of its callers
are __init functions, and the non-__init caller is for PCI device setup.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8ee2b14..350d99b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -487,34 +487,22 @@ static void ioapic_mask_entry(int apic, int pin)
  */
 static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list *entry;
+	struct irq_pin_list **entryp, *entry;
 
-	entry = cfg->irq_2_pin;
-	if (!entry) {
-		entry = get_one_free_irq_2_pin(node);
-		if (!entry) {
-			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
-					apic, pin);
-			return;
-		}
-		cfg->irq_2_pin = entry;
-		entry->apic = apic;
-		entry->pin = pin;
-		return;
-	}
-
-	while (entry->next) {
+	for (entryp = &cfg->irq_2_pin;
+	     *entryp != NULL;
+	     entryp = &(*entryp)->next) {
+		entry = *entryp;
 		/* not again, please */
 		if (entry->apic == apic && entry->pin == pin)
 			return;
-
-		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(node);
-	entry = entry->next;
+	entry = get_one_free_irq_2_pin(node);
 	entry->apic = apic;
 	entry->pin = pin;
+
+	*entryp = entry;
 }
 
 /*
-- 
1.6.2.2

