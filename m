Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0BJWtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:49:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:56416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab0BJWtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:49:13 -0500
Date: Wed, 10 Feb 2010 22:48:46 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, trenn@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, trenn@suse.de
In-Reply-To: <1265793639-15071-2-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix SCI on IOAPIC != 0
Message-ID: <tip-18dce6ba5c8c6bd0f3ab4efa4cbdd698dab5c40a@git.kernel.org>
Git-Commit-ID: 18dce6ba5c8c6bd0f3ab4efa4cbdd698dab5c40a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 22:48:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18dce6ba5c8c6bd0f3ab4efa4cbdd698dab5c40a
Gitweb:     http://git.kernel.org/tip/18dce6ba5c8c6bd0f3ab4efa4cbdd698dab5c40a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:05 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 10 Feb 2010 13:47:39 -0800

x86: Fix SCI on IOAPIC != 0

Thomas Renninger <trenn@suse.de> reported on IBM x3330

booting a latest kernel on this machine results in:

PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
ACPI: SCI (IRQ30) allocation failed
ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
ACPI: Unable to start the ACPI Interpreter

Later all kind of devices fail...

and bisect it down to this commit:
commit b9c61b70075c87a8612624736faf4a2de5b1ed30

    x86/pci: update pirq_enable_irq() to setup io apic routing

it turns out we need to set irq routing for the sci on ioapic1 early.

-v2: make it work without sparseirq too.
-v3: fix checkpatch.pl warning, and cc to stable

Reported-by: Thomas Renninger <trenn@suse.de>
Bisected-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-2-git-send-email-yinghai@kernel.org>
Cc: stable@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |    9 ++++++-
 arch/x86/kernel/apic/io_apic.c |   50 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c7c16c..5f61f6e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -160,6 +160,7 @@ extern int io_apic_get_redir_entries(int ioapic);
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
+void setup_IO_APIC_irq_extra(u32 gsi);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0acbcdf..5c96b75 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -446,6 +446,12 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi;
+
+#ifdef CONFIG_X86_IO_APIC
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
+		setup_IO_APIC_irq_extra(gsi);
+#endif
+
 	return 0;
 }
 
@@ -473,7 +479,8 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		plat_gsi = mp_register_gsi(dev, gsi, trigger, polarity);
 	}
 #endif
-	acpi_gsi_to_irq(plat_gsi, &irq);
+	irq = plat_gsi;
+
 	return irq;
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 53243ca..5e4cce2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1539,6 +1539,56 @@ static void __init setup_IO_APIC_irqs(void)
 }
 
 /*
+ * for the gsit that is not in first ioapic
+ * but could not use acpi_register_gsi()
+ * like some special sci in IBM x3330
+ */
+void setup_IO_APIC_irq_extra(u32 gsi)
+{
+	int apic_id = 0, pin, idx, irq;
+	int node = cpu_to_node(boot_cpu_id);
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	apic_id = mp_find_ioapic(gsi);
+	if (apic_id < 0)
+		return;
+
+	pin = mp_find_ioapic_pin(apic_id, gsi);
+	idx = find_irq_entry(apic_id, pin, mp_INT);
+	if (idx == -1)
+		return;
+
+	irq = pin_2_irq(idx, apic_id, pin);
+#ifdef CONFIG_SPARSE_IRQ
+	desc = irq_to_desc(irq);
+	if (desc)
+		return;
+#endif
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		return;
+	}
+
+	cfg = desc->chip_data;
+	add_pin_to_irq_node(cfg, node, apic_id, pin);
+
+	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[apic_id].apicid, pin);
+		return;
+	}
+	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+
+	setup_IO_APIC_irq(apic_id, pin, irq, desc,
+			irq_trigger(idx), irq_polarity(idx));
+}
+
+/*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
