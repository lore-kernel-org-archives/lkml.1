Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbZEARL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbZEARL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764074AbZEARK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:43333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764009AbZEARK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:27 -0400
Date: Fri, 1 May 2009 17:07:25 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, tony.luck@intel.com,
       bjorn.helgaas@hp.com, ebiederm@xmission.com, lenb@kernel.org,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, tony.luck@intel.com,
       bjorn.helgaas@hp.com, ebiederm@xmission.com, lenb@kernel.org,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F65560.20904@kernel.org>
References: <49F65560.20904@kernel.org>
Subject: [tip:irq/numa] irq: change ACPI GSI APIs to also take a device argument
Message-ID: <tip-a2f809b08ae4dddc1015c7dcd8659e5729e45b3e@git.kernel.org>
Git-Commit-ID: a2f809b08ae4dddc1015c7dcd8659e5729e45b3e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2f809b08ae4dddc1015c7dcd8659e5729e45b3e
Gitweb:     http://git.kernel.org/tip/a2f809b08ae4dddc1015c7dcd8659e5729e45b3e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 18:01:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:17 +0200

irq: change ACPI GSI APIs to also take a device argument

We want to use dev_to_node() later on, to be aware of the 'home node'
of the GSI in question.

[ Impact: cleanup, prepare the IRQ code to be more NUMA aware ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-ia64@vger.kernel.org
LKML-Reference: <49F65560.20904@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/kernel/acpi.c        |    5 +++--
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/include/asm/mpspec.h  |    4 +++-
 arch/x86/kernel/acpi/boot.c    |    8 ++++----
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 drivers/acpi/pci_irq.c         |    5 +++--
 drivers/char/hpet.c            |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |    2 +-
 include/linux/acpi.h           |    2 +-
 9 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 5510317..baec6f0 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -636,7 +636,7 @@ void __init acpi_numa_arch_fixup(void)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
 		return gsi;
@@ -678,7 +678,8 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
 	fadt = (struct acpi_table_fadt *)fadt_header;
 
-	acpi_register_gsi(fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW);
+	acpi_register_gsi(NULL, fadt->sci_interrupt, ACPI_LEVEL_SENSITIVE,
+				 ACPI_ACTIVE_LOW);
 	return 0;
 }
 
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..07f2913 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -154,8 +154,8 @@ extern int timer_through_8259;
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
-				   int edge_level, int active_high_low);
+extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
+				  int irq, int edge_level, int active_high_low);
 #endif /* CONFIG_ACPI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 642fc7f..3ea1f53 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -72,7 +72,9 @@ extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
-extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+struct device;
+extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
+				 int active_high_low);
 extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 723989d..6ee96b5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -522,7 +522,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  * success: return IRQ number (>=0)
  * failure: return < 0
  */
-int acpi_register_gsi(u32 gsi, int triggering, int polarity)
+int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	unsigned int irq;
 	unsigned int plat_gsi = gsi;
@@ -539,7 +539,7 @@ int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 
 #ifdef CONFIG_X86_IO_APIC
 	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC) {
-		plat_gsi = mp_register_gsi(gsi, triggering, polarity);
+		plat_gsi = mp_register_gsi(dev, gsi, triggering, polarity);
 	}
 #endif
 	acpi_gsi_to_irq(plat_gsi, &irq);
@@ -1158,7 +1158,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	}
 }
 
-int mp_register_gsi(u32 gsi, int triggering, int polarity)
+int mp_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 {
 	int ioapic;
 	int ioapic_pin;
@@ -1253,7 +1253,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		}
 	}
 #endif
-	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
+	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
 				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	return gsi;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 560b887..d934662 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3958,7 +3958,8 @@ int __init io_apic_get_version(int ioapic)
 }
 #endif
 
-int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
+int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 51b9f82..2faa9e2 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -401,7 +401,8 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
-			acpi_register_gsi(dev->irq, ACPI_LEVEL_SENSITIVE,
+			acpi_register_gsi(&dev->dev, dev->irq,
+					  ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
 		} else {
@@ -410,7 +411,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		}
 	}
 
-	rc = acpi_register_gsi(gsi, triggering, polarity);
+	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (rc < 0) {
 		dev_warn(&dev->dev, "PCI INT %c: failed to register GSI\n",
 			 pin_name(pin));
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 340ba4f..4a9f349 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -224,7 +224,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 			break;
 		}
 
-		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+		gsi = acpi_register_gsi(NULL, irq, ACPI_LEVEL_SENSITIVE,
 					ACPI_ACTIVE_LOW);
 		if (gsi > 0)
 			break;
@@ -939,7 +939,7 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		irqp = &res->data.extended_irq;
 
 		for (i = 0; i < irqp->interrupt_count; i++) {
-			irq = acpi_register_gsi(irqp->interrupts[i],
+			irq = acpi_register_gsi(NULL, irqp->interrupts[i],
 				      irqp->triggering, irqp->polarity);
 			if (irq < 0)
 				return AE_ERROR;
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index adf1785..7f207f3 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -123,7 +123,7 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
 	}
 
 	flags = irq_flags(triggering, polarity, shareable);
-	irq = acpi_register_gsi(gsi, triggering, polarity);
+	irq = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
 	if (irq >= 0)
 		pcibios_penalize_isa_irq(irq, 1);
 	else
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 88be890..51b4b0a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -119,7 +119,7 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
-int acpi_register_gsi (u32 gsi, int triggering, int polarity);
+int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
 #ifdef CONFIG_X86_IO_APIC
