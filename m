Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZHDORE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZHDORE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZHDORD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:17:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:55141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbZHDORB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:17:01 -0400
Date: Tue, 4 Aug 2009 14:16:17 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090801075435.597863129@openvz.org>
References: <20090801075435.597863129@openvz.org>
Subject: [tip:x86/apic] x86, ioapic: Introduce for_each_irq_pin() helper
Message-ID: <tip-a09204211bcf17eddfdbb5cb2ceb2173e0e3c0d0@git.kernel.org>
Git-Commit-ID: a09204211bcf17eddfdbb5cb2ceb2173e0e3c0d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 14:16:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a09204211bcf17eddfdbb5cb2ceb2173e0e3c0d0
Gitweb:     http://git.kernel.org/tip/a09204211bcf17eddfdbb5cb2ceb2173e0e3c0d0
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 1 Aug 2009 11:47:59 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:11:53 +0200

x86, ioapic: Introduce for_each_irq_pin() helper

This allow us to save a few lines of code.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
LKML-Reference: <20090801075435.597863129@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   43 ++++++++++++++--------------------------
 1 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7e92a92..ffd8fdf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,8 @@
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
+#define for_each_irq_pin(entry, head) \
+	for (entry = head; entry; entry = entry->next)
 
 /*
  *      Is the SiS APIC rmw bug present ?
@@ -410,7 +412,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		int pin;
 
@@ -490,22 +492,21 @@ static void ioapic_mask_entry(int apic, int pin)
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
@@ -517,7 +518,7 @@ static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 {
 	struct irq_pin_list *entry;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
@@ -537,7 +538,7 @@ static void io_apic_modify_irq(struct irq_cfg *cfg,
 	int pin;
 	struct irq_pin_list *entry;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
@@ -1669,12 +1670,8 @@ __apicdebuginit(void) print_IO_APIC(void)
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
 
@@ -2227,7 +2224,7 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	struct irq_pin_list *entry;
 	u8 vector = cfg->vector;
 
-	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 
 		apic = entry->apic;
@@ -2556,20 +2553,10 @@ static void ack_apic_level(unsigned int irq)
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
