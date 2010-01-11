Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419Ab0AKVa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0AKVa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139Ab0AKV1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:22 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0AKV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pUm/zth8Wvuxt1Auwjk6tr3ZEWFxAIjALUagOPf3zpH2dYf1tdoKqsyuyTlnzEiO/t
         ud2e0UynDj1BFfJ3BgPsO77tU7CNy1HK5cpVNOc5airnl1i5iqK/gRPGvlTcJPUa3nl0
         1b8Zq8ELILyaUtDOuEEWM6nJK0Fc9CNo+cGZM=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 07/26] x86: Convert pci_config_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:37 +0100
Message-Id: <1263245216-14754-8-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-7-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks.

See also bde31e2e149219765bb3a4bb3c568fa9623b5521

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/include/asm/pci_x86.h |    2 +-
 arch/x86/pci/common.c          |    2 +-
 arch/x86/pci/direct.c          |   16 ++++++++--------
 arch/x86/pci/mmconfig_32.c     |    8 ++++----
 arch/x86/pci/numaq_32.c        |    8 ++++----
 arch/x86/pci/pcbios.c          |    8 ++++----
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b4bf9a9..567d009 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -83,7 +83,7 @@ struct irq_routing_table {
 extern unsigned int pcibios_irq_mask;
 
 extern int pcibios_scanned;
-extern spinlock_t pci_config_lock;
+extern raw_spinlock_t pci_config_lock;
 
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index d2552c6..b79d322 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -81,7 +81,7 @@ int pcibios_scanned;
  * This interrupt-safe spinlock protects all accesses to PCI
  * configuration space.
  */
-DEFINE_SPINLOCK(pci_config_lock);
+DEFINE_RAW_SPINLOCK(pci_config_lock);
 
 static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
 {
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 347d882..bd33620 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -27,7 +27,7 @@ static int pci_conf1_read(unsigned int seg, unsigned int bus,
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
 
@@ -43,7 +43,7 @@ static int pci_conf1_read(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -56,7 +56,7 @@ static int pci_conf1_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
 
@@ -72,7 +72,7 @@ static int pci_conf1_write(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -108,7 +108,7 @@ static int pci_conf2_read(unsigned int seg, unsigned int bus,
 	if (dev & 0x10) 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outb((u8)(0xF0 | (fn << 1)), 0xCF8);
 	outb((u8)bus, 0xCFA);
@@ -127,7 +127,7 @@ static int pci_conf2_read(unsigned int seg, unsigned int bus,
 
 	outb(0, 0xCF8);
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -147,7 +147,7 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 	if (dev & 0x10) 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	outb((u8)(0xF0 | (fn << 1)), 0xCF8);
 	outb((u8)bus, 0xCFA);
@@ -166,7 +166,7 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 
 	outb(0, 0xCF8);    
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 90d5fd4..a3d9c54 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
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
@@ -97,7 +97,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if (!base)
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	pci_exp_set_dev_base(base, bus, devfn);
 
@@ -112,7 +112,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		mmio_config_writel(mmcfg_virt_addr + reg, value);
 		break;
 	}
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8eb295e..2dad4dc 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -41,7 +41,7 @@ static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
 	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	write_cf8(bus, devfn, reg);
 
@@ -66,7 +66,7 @@ static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
@@ -80,7 +80,7 @@ static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
 	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	write_cf8(bus, devfn, reg);
 
@@ -105,7 +105,7 @@ static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
 }
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 1c975cc..2daa521 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -161,7 +161,7 @@ static int pci_bios_read(unsigned int seg, unsigned int bus,
 	if (!value || (bus > 255) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	switch (len) {
 	case 1:
@@ -212,7 +212,7 @@ static int pci_bios_read(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return (int)((result & 0xff00) >> 8);
 }
@@ -227,7 +227,7 @@ static int pci_bios_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
 		return -EINVAL;
 
-	spin_lock_irqsave(&pci_config_lock, flags);
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
 	switch (len) {
 	case 1:
@@ -268,7 +268,7 @@ static int pci_bios_write(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	spin_unlock_irqrestore(&pci_config_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return (int)((result & 0xff00) >> 8);
 }
-- 
1.6.5.2

