Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0BQOfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:35:36 -0500
Received: from www.tglx.de ([62.245.132.106]:46580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0BQOfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:35:31 -0500
Message-Id: <20100217143453.615783432@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 14:35:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 2/2] x86: Convert pci_config_lock to raw_spinlock
References: <20100217143401.673569070@linutronix.de>
Content-Disposition: inline; filename=0141.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_config_lock must be a real spinlock in preempt-rt. Convert it to
raw_spinlock. No change for !RT kernels.
   
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/pci_x86.h |    2 +-
 arch/x86/pci/common.c          |    2 +-
 arch/x86/pci/direct.c          |   16 ++++++++--------
 arch/x86/pci/mmconfig_32.c     |    8 ++++----
 arch/x86/pci/numaq_32.c        |    8 ++++----
 arch/x86/pci/pcbios.c          |    8 ++++----
 6 files changed, 22 insertions(+), 22 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6-tip/arch/x86/include/asm/pci_x86.h
@@ -83,7 +83,7 @@ struct irq_routing_table {
 extern unsigned int pcibios_irq_mask;
 
 extern int pcibios_scanned;
-extern spinlock_t pci_config_lock;
+extern raw_spinlock_t pci_config_lock;
 
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
Index: linux-2.6-tip/arch/x86/pci/common.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/common.c
+++ linux-2.6-tip/arch/x86/pci/common.c
@@ -81,7 +81,7 @@ int pcibios_scanned;
  * This interrupt-safe spinlock protects all accesses to PCI
  * configuration space.
  */
-DEFINE_SPINLOCK(pci_config_lock);
+DEFINE_RAW_SPINLOCK(pci_config_lock);
 
 static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
 {
Index: linux-2.6-tip/arch/x86/pci/direct.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/direct.c
+++ linux-2.6-tip/arch/x86/pci/direct.c
@@ -27,7 +27,7 @@ static int pci_conf1_read(unsigned int s
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
 
@@ -43,7 +43,7 @@ static int pci_conf1_read(unsigned int s
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -56,7 +56,7 @@ static int pci_conf1_write(unsigned int 
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
 
@@ -72,7 +72,7 @@ static int pci_conf1_write(unsigned int 
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -108,7 +108,7 @@ static int pci_conf2_read(unsigned int s
 	if (dev & 0x10) 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outb((u8)(0xF0 | (fn << 1)), 0xCF8);
 	outb((u8)bus, 0xCFA);
@@ -127,7 +127,7 @@ static int pci_conf2_read(unsigned int s
 
 	outb(0, 0xCF8);
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -147,7 +147,7 @@ static int pci_conf2_write(unsigned int 
 	if (dev & 0x10) 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outb((u8)(0xF0 | (fn << 1)), 0xCF8);
 	outb((u8)bus, 0xCFA);
@@ -166,7 +166,7 @@ static int pci_conf2_write(unsigned int 
 
 	outb(0, 0xCF8);    
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/x86/pci/mmconfig_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/mmconfig_32.c
+++ linux-2.6-tip/arch/x86/pci/mmconfig_32.c
@@ -64,7 +64,7 @@ err:		*value = -1;
 	if (!base)
 		goto err;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	pci_exp_set_dev_base(base, bus, devfn);
 
@@ -79,7 +79,7 @@ err:		*value = -1;
 		*value = mmio_config_readl(mmcfg_virt_addr + reg);
 		break;
 	}
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -97,7 +97,7 @@ static int pci_mmcfg_write(unsigned int 
 	if (!base)
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	pci_exp_set_dev_base(base, bus, devfn);
 
@@ -112,7 +112,7 @@ static int pci_mmcfg_write(unsigned int 
 		mmio_config_writel(mmcfg_virt_addr + reg, value);
 		break;
 	}
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/x86/pci/numaq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/numaq_32.c
+++ linux-2.6-tip/arch/x86/pci/numaq_32.c
@@ -41,7 +41,7 @@ static int pci_conf1_mq_read(unsigned in
 	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	write_cf8(bus, devfn, reg);
 
@@ -66,7 +66,7 @@ static int pci_conf1_mq_read(unsigned in
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -80,7 +80,7 @@ static int pci_conf1_mq_write(unsigned i
 	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	write_cf8(bus, devfn, reg);
 
@@ -105,7 +105,7 @@ static int pci_conf1_mq_write(unsigned i
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/x86/pci/pcbios.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/pcbios.c
+++ linux-2.6-tip/arch/x86/pci/pcbios.c
@@ -161,7 +161,7 @@ static int pci_bios_read(unsigned int se
 	if (!value || (bus > 255) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	switch (len) {
 	case 1:
@@ -212,7 +212,7 @@ static int pci_bios_read(unsigned int se
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return (int)((result & 0xff00) >> 8);
 }
@@ -227,7 +227,7 @@ static int pci_bios_write(unsigned int s
 	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	switch (len) {
 	case 1:
@@ -268,7 +268,7 @@ static int pci_bios_write(unsigned int s
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return (int)((result & 0xff00) >> 8);
 }


