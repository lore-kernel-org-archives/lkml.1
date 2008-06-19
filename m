Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbYFSPya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbYFSPya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFSPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:54:20 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:7917 "EHLO
	mail183-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYFSPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:54:19 -0400
X-BigFish: VPS3(zzzz10d3izzz32i87i65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2PW5Z-01-ZFF-01
From: Robert Richter <robert.richter@amd.com>
To: stephane eranian <eranian@googlemail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] AMD64: Removing PCI ECS workaround
Date: Thu, 19 Jun 2008 17:50:39 +0200
Message-Id: <1213890640-4444-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
X-OriginalArrivalTime: 19 Jun 2008 15:54:01.0621 (UTC) FILETIME=[B15A7450:01C8D224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the workaround to access the Extended Config Space
that is needed to setup IBS interrupts. PCI functions are replaced by
standard PCI functions that support now ECS access.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/common.c            |    1 -
 arch/x86/perfmon/perfmon_amd64.c |  100 +------------------------------------
 2 files changed, 3 insertions(+), 98 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 400960b..6e64aaf 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -76,7 +76,6 @@ int pcibios_scanned;
  * configuration space.
  */
 DEFINE_SPINLOCK(pci_config_lock);
-EXPORT_SYMBOL(pci_config_lock);
 
 static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
 {
diff --git a/arch/x86/perfmon/perfmon_amd64.c b/arch/x86/perfmon/perfmon_amd64.c
index 6349e77..d8ad321 100644
--- a/arch/x86/perfmon/perfmon_amd64.c
+++ b/arch/x86/perfmon/perfmon_amd64.c
@@ -142,106 +142,12 @@ static struct pfm_context *pfm_nb_task_owner;
 
 static struct pfm_pmu_config pfm_amd64_pmu_conf;
 
-/* Functions for accessing extended PCI config space. Can be removed
-   when Kernel API exists. */
-extern spinlock_t pci_config_lock;
-
-#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
-	(0x80000000 | ((reg & 0xF00) << 16) | ((bus & 0xFF) << 16) \
-	| (devfn << 8) | (reg & 0xFC))
-
 #define is_ibs_pmc(x) (x == 4 || x == 5)
 
-static int pci_read(unsigned int seg, unsigned int bus,
-		    unsigned int devfn, int reg, int len, u32 *value)
-{
-	unsigned long flags;
-
-	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
-		*value = -1;
-		return -EINVAL;
-	}
-
-	spin_lock_irqsave(&pci_config_lock, flags);
-
-	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
-
-	switch (len) {
-	case 1:
-		*value = inb(0xCFC + (reg & 3));
-		break;
-	case 2:
-		*value = inw(0xCFC + (reg & 2));
-		break;
-	case 4:
-		*value = inl(0xCFC);
-		break;
-	}
-
-	spin_unlock_irqrestore(&pci_config_lock, flags);
-
-	return 0;
-}
-
-static int pci_write(unsigned int seg, unsigned int bus,
-		     unsigned int devfn, int reg, int len, u32 value)
-{
-	unsigned long flags;
-
-	if ((bus > 255) || (devfn > 255) || (reg > 4095))
-		return -EINVAL;
-
-	spin_lock_irqsave(&pci_config_lock, flags);
-
-	outl(PCI_CONF1_ADDRESS(bus, devfn, reg), 0xCF8);
-
-	switch (len) {
-	case 1:
-		outb((u8)value, 0xCFC + (reg & 3));
-		break;
-	case 2:
-		outw((u16)value, 0xCFC + (reg & 2));
-		break;
-	case 4:
-		outl((u32)value, 0xCFC);
-		break;
-	}
-
-	spin_unlock_irqrestore(&pci_config_lock, flags);
-
-	return 0;
-}
-
-static inline int
-pci_read_ext_config_dword(struct pci_dev *dev, int where, u32 *val)
-{
-	return pci_read(0, dev->bus->number, dev->devfn, where, 4, val);
-}
-
-static inline int
-pci_write_ext_config_dword(struct pci_dev *dev, int where, u32 val)
-{
-	return pci_write(0, dev->bus->number, dev->devfn, where, 4, val);
-}
-
-static void pfm_amd64_enable_pci_ecs_per_cpu(void)
-{
-#define ENABLE_CF8_EXT_CFG		(1ULL << 46)
-	u64 reg;
-	/* enable PCI extended config space */
-	rdmsrl(MSR_AMD64_NB_CFG, reg);
-	if (reg & ENABLE_CF8_EXT_CFG)
-		return;
-	reg |= ENABLE_CF8_EXT_CFG;
-	wrmsrl(MSR_AMD64_NB_CFG, reg);
-}
-
 static void pfm_amd64_setup_eilvt_per_cpu(void *info)
 {
 	u8 lvt_off;
 
-	pfm_amd64_enable_pci_ecs_per_cpu();
-
 	/* program the IBS vector to the perfmon vector */
 	lvt_off =  setup_APIC_eilvt_ibs(LOCAL_PERFMON_VECTOR,
 					APIC_EILVT_MSG_FIX, 0);
@@ -269,9 +175,9 @@ static int pfm_amd64_setup_eilvt(void)
 		if (!cpu_cfg)
 			break;
 		++nodes;
-		pci_write_ext_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
-					   | IBSCTL_LVTOFFSETVAL);
-		pci_read_ext_config_dword(cpu_cfg, IBSCTL, &value);
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVTOFFSETVAL);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
 		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
 			PFM_DBG("Failed to setup IBS LVT offset, "
 				"IBSCTL = 0x%08x", value);
-- 
1.5.5.3


