Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbZHAHy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbZHAHy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZHAHyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:54:55 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51307 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZHAHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=S0XELnIRFAqub6dR5RZc/CwxYU1AQmWlSYuhlJumcr2PRCawz29VGk/CC6ho6q4jMQ
         sNgiWb95h7DEan9cOoLP/CAWAq1F+DS3d2qP64qUOq+AzwT503UP/HWqg21J4GIw5ssi
         kd8pyp2pJEFylbHISCdU1fWQ3UjdP2XLUrx9U=
Message-Id: <20090801075435.597863129@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 01 Aug 2009 11:47:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: yinghai@kernel.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 1/2] x86,ioapic: introduce for_each_irq_pin helper
References: <20090801074758.502095557@openvz.org>
Content-Disposition: inline; filename=x86-ioapic-for-each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to save a few lines of code.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/io_apic.c |   43 ++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,8 @@
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
+#define for_each_irq_pin(entry, head) \
+	for (entry = head; entry; entry = entry->next)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -410,7 +412,7 @@ static bool io_apic_level_ack_pending(st
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		int pin;
 
@@ -490,22 +492,21 @@ static void ioapic_mask_entry(int apic, 
  */
 static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	struct irq_pin_list **entryp, *entry;
+	struct irq_pin_list **last, *entry;
 
-	for (entryp = &cfg->irq_2_pin;
-	     *entryp != NULL;
-	     entryp = &(*entryp)->next) {
-		entry = *entryp;
-		/* not again, please */
+	/* don't allow duplicates */
+	last = &cfg->irq_2_pin;
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == apic && entry->pin == pin)
 			return;
+		last = &entry->next;
 	}
 
 	entry = get_one_free_irq_2_pin(node);
 	entry->apic = apic;
 	entry->pin = pin;
 
-	*entryp = entry;
+	*last = entry;
 }
 
 /*
@@ -517,7 +518,7 @@ static void __init replace_pin_at_irq_no
 {
 	struct irq_pin_list *entry;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
@@ -537,7 +538,7 @@ static void io_apic_modify_irq(struct ir
 	int pin;
 	struct irq_pin_list *entry;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
@@ -1669,12 +1670,8 @@ __apicdebuginit(void) print_IO_APIC(void
 		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
-		for (;;) {
+		for_each_irq_pin(entry, cfg->irq_2_pin)
 			printk("-> %d:%d", entry->apic, entry->pin);
-			if (!entry->next)
-				break;
-			entry = entry->next;
-		}
 		printk("\n");
 	}
 
@@ -2227,7 +2224,7 @@ static void __target_IO_APIC_irq(unsigne
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 
 		apic = entry->apic;
@@ -2556,20 +2553,10 @@ static void ack_apic_level(unsigned int 
 #ifdef CONFIG_INTR_REMAP
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
-	int apic, pin;
 	struct irq_pin_list *entry;
 
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
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		io_apic_eoi(entry->apic, entry->pin);
 }
 
 static void

