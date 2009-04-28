Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZD1BDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZD1BDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZD1BDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:03:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbZD1BDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:03:04 -0400
Message-ID: <49F6557E.3080101@kernel.org>
Date: Mon, 27 Apr 2009 18:01:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] irq: make io_apic_set_pci_routing to use device
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E8047E.8090805@kernel.org>
In-Reply-To: <49E8047E.8090805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: dev_to_node(dev)

so use right node in irq_desc_alloc_node()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3921,7 +3921,7 @@ int io_apic_set_pci_routing(struct devic
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node;
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3929,6 +3929,11 @@ int io_apic_set_pci_routing(struct devic
 		return -EINVAL;
 	}
 
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
