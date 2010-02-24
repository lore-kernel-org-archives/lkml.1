Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0BXIHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:07:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:58604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0BXIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:07:28 -0500
Date: Wed, 24 Feb 2010 08:07:02 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D07@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D07@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, ioapic: Early enable ioapic for timer irq
Message-ID: <tip-05ddafb17ad1a73c8bc333cb328bad46513e85e7@git.kernel.org>
Git-Commit-ID: 05ddafb17ad1a73c8bc333cb328bad46513e85e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05ddafb17ad1a73c8bc333cb328bad46513e85e7
Gitweb:     http://git.kernel.org/tip/05ddafb17ad1a73c8bc333cb328bad46513e85e7
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Wed, 23 Sep 2009 07:20:23 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:13:19 -0800

x86, ioapic: Early enable ioapic for timer irq

Moorestown platform needs apic ready early for the system timer irq
which is delievered via ioapic.  Should not impact other platforms.

In the longer term, once ioapic setup is moved before late time init,
we will not need this patch to do early apic enabling.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D07@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 31dfb42..99a416e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -187,6 +187,7 @@ extern struct mp_ioapic_gsi  mp_gsi_routing[];
 int mp_find_ioapic(int gsi);
 int mp_find_ioapic_pin(int ioapic, int gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+extern void __init pre_init_apic_IRQ0(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b348543..8c848b5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4289,3 +4289,24 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
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
