Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbZFPUSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbZFPUSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761722AbZFPUQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:15 -0400
Received: from claw.goop.org ([74.207.240.146]:40591 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbZFPUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/16] x86/ioapic.c: clean up replace_pin_at_irq_node logic and comments
Date: Tue, 16 Jun 2009 13:15:53 -0700
Message-Id: <1245183355-25808-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need for a control variable in replace_pin_at_irq_node();
it can just return if it finds the old apic/pin to replace.

If the loop terminates, then it didn't find the old apic/pin, so it can
add the new ones.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b71d2a2..f466a1e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -509,25 +509,22 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin
  * Reroute an IRQ to a different pin.
  */
 static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
-				      int oldapic, int oldpin,
-				      int newapic, int newpin)
+					   int oldapic, int oldpin,
+					   int newapic, int newpin)
 {
 	struct irq_pin_list *entry;
-	int replaced = 0;
 
 	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
-			replaced = 1;
 			/* every one is different, right? */
-			break;
+			return;
 		}
 	}
 
-	/* why? call replace before add? */
-	if (!replaced)
-		add_pin_to_irq_node(cfg, node, newapic, newpin);
+	/* old apic/pin didn't exist, so just add new ones */
+	add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
 static void io_apic_modify_irq(struct irq_cfg *cfg,
-- 
1.6.2.2

