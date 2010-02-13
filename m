Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0BMBku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:40:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:10815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0BMBkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="540400418"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:44 -0800
Subject: [PATCH 1/8] x86/ioapic: early enable ioapic for timer irq
Thread-Topic: [PATCH 1/8] x86/ioapic: early enable ioapic for timer irq
Thread-Index: AcqsTY7qLqyZJo/iRKSQn4w1/I1Haw==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D07@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3b1bd027b207d3771c92becbcaa05e1597c571ad Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 23 Sep 2009 07:20:23 -0700
Subject: [PATCH 1/8] x86/ioapic: early enable ioapic for timer irq

Moorestown platform needs apic ready early for the system timer irq
which is delievered via ioapic. should not impact other platforms.

in longer term, once ioapic setup is moved before late time init, we will not
need this patch to do early apic enabling

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 84fdd51..f1f45bc 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -186,6 +186,7 @@ extern struct mp_ioapic_gsi  mp_gsi_routing[];
 int mp_find_ioapic(int gsi);
 int mp_find_ioapic_pin(int ioapic, int gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+extern void __init pre_init_apic_IRQ0(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5a7aab2..bdb3646 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4250,3 +4250,24 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	nr_ioapics++;
 }
+
+/* Enable IOAPIC early just for system timer */
+void __init pre_init_apic_IRQ0(void)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+
+	printk(KERN_INFO "Early APIC setup for system timer0\n");
+#ifndef CONFIG_SMP
+	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+#endif
+	desc = irq_to_desc_alloc_node(0, 0);
+
+	setup_local_APIC();
+
+	cfg = irq_cfg(0);
+	add_pin_to_irq_node(cfg, 0, 0, 0);
+	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
+
+	setup_IO_APIC_irq(0, 0, 0, desc, 0, 0);
+}
-- 
1.6.5.3

