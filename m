Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZHEUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZHEUJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZHEUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:09:34 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34679 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZHEUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LFDIRIFRDeRoVfUeeoGYyoW9wsYAvFIkcCPbd9YpIn46U88IRUelCFgbd88Rtr6xwE
         xzOWSR9RRy+MuEesNs9On9/o3wlY7/ZbzRGM7+S47zmH4DdDHcilcBYKSpzq6EFU/GkA
         5qbfs89Qs1dCwRDK/P6tr8CH+1u9x9u+vffn4=
Date: Thu, 6 Aug 2009 00:09:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [rfc] x86,ioapic: panic on irq-pin binding only if needed
Message-ID: <20090805200931.GB5319@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though the most time we are to panic on irq-pin allocation
fails, for PCI interrupts it's not the case and we could
continue operate even if irq-pin allocation failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review. Not sure that it's a best solution at all
but allow us to not panic in case of PCI irq routing fails.

But note that irq descriptor is allocated anyway in such
a case. Perhaps we need to bring in irq_descr freeing
function as well. Or what is more likelihood is that
I'm missing something. Yinghai?

 arch/x86/kernel/apic/io_apic.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -490,7 +490,8 @@ static void ioapic_mask_entry(int apic, 
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int
+add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -498,19 +499,27 @@ static void add_pin_to_irq_node(struct i
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
@@ -3846,7 +3855,11 @@ static int __io_apic_set_pci_routing(str
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
