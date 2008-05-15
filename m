Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbYEOTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbYEOTwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbYEOTvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762017AbYEOTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Date: Thu, 15 May 2008 21:51:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>
References: <20080515070546.6ea9c681@infradead.org> <200805150907.06930.jbarnes@virtuousgeek.org>
In-Reply-To: <200805150907.06930.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152151.31936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of May 2008, Jesse Barnes wrote:
> On Thursday, May 15, 2008 7:05 am Arjan van de Ven wrote:
> > Hi,
> >
> > the following is a bug in the PCI layer wrt suspend/resume and quirks:
> >
> > pci_device_resume_early does the following:
> >
> > static int pci_device_resume_early(struct device * dev)
> > {
> >         int error = 0;
> >         struct pci_dev * pci_dev = to_pci_dev(dev);
> >         struct pci_driver * drv = pci_dev->driver;
> >
> >         pci_fixup_device(pci_fixup_resume, pci_dev);
> >
> > eg it calls the resume quirks.
> >
> > However, one of these quirks is
> > DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,  
> >   asus_hides_smbus_lpc_ich6);
> >
> > and asus_hides_smbus_lpc_ich6 does
> >
> >         base = ioremap_nocache(rcba & 0xFFFFC000, 0x4000); /* use bits
> > 31:14, 16 kB aligned */ if (base == NULL) return;
> >         val=readl(base + 0x3418); /* read the Function Disable register,
> > dword mode only */ writel(val & 0xFFFFFFF7, base + 0x3418); /* enable the
> > SMBus device */ iounmap(base);
> >
> > internally. ioremap()/iounmap() does a global tlb flush of course, which
> > includes doing an IPI to other cpus. However, during early resume,
> > interrupts are disabled, and it's not allowed to do a IPI/global tlbflush
> > with interrupts off...
> 
> Yeah I just got a similar report for quirk_vialatency().  But why are we only 
> seeing these issues now?  Is our interrupt disabled check catching more stuff 
> these days?
> 
> Rafael said he's looking at the VIA issue, and iirc we had talked about 
> changing this stuff around a few weeks ago anyway.  So yeah we may need 
> either a new fixup phase or maybe we can just move the resume fixups to occur 
> a little later, when interrupts are enabled.

In fact I forgot about a Shaohua's patch that cleaned up that a bit and is
appended (should apply on top of the current -git).

Please have a look and tell me what you think.

Thanks,
Rafael

---

Some quirks should be called with interrupt disabled, we can't directly
call them in .resume_early. Also the patch introduces
pci_fixup_resume_early and pci_fixup_suspend, which matches current
device core callbacks (.suspend/.resume_early).

TBD: Somebody knows why we need quirk resume should double check if a
quirk should be called in resume or resume_early. I changed some per my
understanding, but can't make sure I fixed all.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/pci/pci-driver.c          |    6 +
 drivers/pci/quirks.c              |  120 +++++++++++++++++++++++++-------------
 include/asm-generic/vmlinux.lds.h |    6 +
 include/linux/pci.h               |   10 ++-
 4 files changed, 102 insertions(+), 40 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -292,6 +292,9 @@ static int pci_device_suspend(struct dev
 		if (pci_dev->current_state == PCI_D0)
 			pci_dev->current_state = PCI_UNKNOWN;
 	}
+
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
+
 	return i;
 }
 
@@ -337,6 +340,7 @@ static int pci_device_resume(struct devi
 		error = drv->resume(pci_dev);
 	else
 		error = pci_default_resume(pci_dev);
+	pci_fixup_device(pci_fixup_resume, pci_dev);
 	return error;
 }
 
@@ -346,7 +350,7 @@ static int pci_device_resume_early(struc
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
-	pci_fixup_device(pci_fixup_resume, pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
 	if (drv && drv->resume_early)
 		error = drv->resume_early(pci_dev);
Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -556,7 +556,7 @@ static void quirk_via_ioapic(struct pci_
 	pci_write_config_byte (dev, 0x58, tmp);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quirk_via_ioapic);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quirk_via_ioapic);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686,	quirk_via_ioapic);
 
 /*
  * VIA 8237: Some BIOSs don't set the 'Bypass APIC De-Assert Message' Bit.
@@ -576,7 +576,7 @@ static void quirk_via_vt8237_bypass_apic
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_vt8237_bypass_apic_deassert);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_vt8237_bypass_apic_deassert);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_vt8237_bypass_apic_deassert);
 
 /*
  * The AMD io apic can hang the box when an apic irq is masked.
@@ -622,7 +622,7 @@ static void quirk_amd_8131_ioapic(struct
         }
 } 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
@@ -774,7 +774,7 @@ static void quirk_cardbus_legacy(struct 
 	pci_write_config_dword(dev, PCI_CB_LEGACY_MODE_BASE, 0);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_cardbus_legacy);
-DECLARE_PCI_FIXUP_RESUME(PCI_ANY_ID, PCI_ANY_ID, quirk_cardbus_legacy);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_ANY_ID, PCI_ANY_ID, quirk_cardbus_legacy);
 
 /*
  * Following the PCI ordering rules is optional on the AMD762. I'm not
@@ -797,7 +797,7 @@ static void quirk_amd_ordering(struct pc
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_FE_GATE_700C, quirk_amd_ordering);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_FE_GATE_700C, quirk_amd_ordering);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_FE_GATE_700C, quirk_amd_ordering);
 
 /*
  *	DreamWorks provided workaround for Dunord I-3000 problem
@@ -865,7 +865,7 @@ static void quirk_disable_pxb(struct pci
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb);
 
 static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
@@ -885,9 +885,9 @@ static void __devinit quirk_amd_ide_mode
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
@@ -1093,31 +1093,61 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801CA_12,	asus_hides_smbus_lpc);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_12,	asus_hides_smbus_lpc);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801EB_0,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801AA_0,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_0,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801BA_0,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801CA_0,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801CA_12,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_12,	asus_hides_smbus_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801EB_0,	asus_hides_smbus_lpc);
-
-static void asus_hides_smbus_lpc_ich6(struct pci_dev *dev)
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801AA_0,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_0,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801BA_0,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801CA_0,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801CA_12,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_12,	asus_hides_smbus_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801EB_0,	asus_hides_smbus_lpc);
+
+/* It appears we just have one such device. If not, we have a warning */
+static void __iomem *asus_rcba_base;
+static void asus_hides_smbus_lpc_ich6_suspend(struct pci_dev *dev)
 {
-	u32 val, rcba;
-	void __iomem *base;
+	u32 rcba;
 
 	if (likely(!asus_hides_smbus))
 		return;
+	WARN_ON(asus_rcba_base);
+
 	pci_read_config_dword(dev, 0xF0, &rcba);
-	base = ioremap_nocache(rcba & 0xFFFFC000, 0x4000); /* use bits 31:14, 16 kB aligned */
-	if (base == NULL) return;
-	val=readl(base + 0x3418); /* read the Function Disable register, dword mode only */
-	writel(val & 0xFFFFFFF7, base + 0x3418); /* enable the SMBus device */
-	iounmap(base);
+	/* use bits 31:14, 16 kB aligned */
+	asus_rcba_base = ioremap_nocache(rcba & 0xFFFFC000, 0x4000);
+	if (asus_rcba_base == NULL)
+		return;
+}
+
+static void asus_hides_smbus_lpc_ich6_resume_early(struct pci_dev *dev)
+{
+	u32 val;
+
+	if (likely(!asus_hides_smbus || !asus_rcba_base))
+		return;
+	/* read the Function Disable register, dword mode only */
+	val = readl(asus_rcba_base + 0x3418);
+	writel(val & 0xFFFFFFF7, asus_rcba_base + 0x3418); /* enable the SMBus device */
+}
+
+static void asus_hides_smbus_lpc_ich6_resume(struct pci_dev *dev)
+{
+	if (likely(!asus_hides_smbus || !asus_rcba_base))
+		return;
+	iounmap(asus_rcba_base);
+	asus_rcba_base = NULL;
 	dev_info(&dev->dev, "Enabled ICH6/i801 SMBus device\n");
 }
+
+static void asus_hides_smbus_lpc_ich6(struct pci_dev *dev)
+{
+	asus_hides_smbus_lpc_ich6_suspend(dev);
+	asus_hides_smbus_lpc_ich6_resume_early(dev);
+	asus_hides_smbus_lpc_ich6_resume(dev);
+}
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6);
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6_resume);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1,	asus_hides_smbus_lpc_ich6_resume_early);
 
 /*
  * SiS 96x south bridge: BIOS typically hides SMBus device...
@@ -1135,10 +1165,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_962,		quirk_sis_96x_smbus);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_963,		quirk_sis_96x_smbus);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_LPC,		quirk_sis_96x_smbus);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_961,		quirk_sis_96x_smbus);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_962,		quirk_sis_96x_smbus);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_963,		quirk_sis_96x_smbus);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_LPC,		quirk_sis_96x_smbus);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_961,		quirk_sis_96x_smbus);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_962,		quirk_sis_96x_smbus);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_963,		quirk_sis_96x_smbus);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_LPC,		quirk_sis_96x_smbus);
 
 /*
  * ... This is further complicated by the fact that some SiS96x south
@@ -1172,7 +1202,7 @@ static void quirk_sis_503(struct pci_dev
 	quirk_sis_96x_smbus(dev);
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_503,		quirk_sis_503);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_503,		quirk_sis_503);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,	PCI_DEVICE_ID_SI_503,		quirk_sis_503);
 
 
 /*
@@ -1205,7 +1235,7 @@ static void asus_hides_ac97_lpc(struct p
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237, asus_hides_ac97_lpc);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237, asus_hides_ac97_lpc);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237, asus_hides_ac97_lpc);
 
 #if defined(CONFIG_ATA) || defined(CONFIG_ATA_MODULE)
 
@@ -1270,12 +1300,12 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JM
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
 
 #endif
 
@@ -1522,6 +1552,10 @@ extern struct pci_fixup __start_pci_fixu
 extern struct pci_fixup __end_pci_fixups_enable[];
 extern struct pci_fixup __start_pci_fixups_resume[];
 extern struct pci_fixup __end_pci_fixups_resume[];
+extern struct pci_fixup __start_pci_fixups_resume_early[];
+extern struct pci_fixup __end_pci_fixups_resume_early[];
+extern struct pci_fixup __start_pci_fixups_suspend[];
+extern struct pci_fixup __end_pci_fixups_suspend[];
 
 
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
@@ -1554,6 +1588,16 @@ void pci_fixup_device(enum pci_fixup_pas
 		end = __end_pci_fixups_resume;
 		break;
 
+	case pci_fixup_resume_early:
+		start = __start_pci_fixups_resume_early;
+		end = __end_pci_fixups_resume_early;
+		break;
+
+	case pci_fixup_suspend:
+		start = __start_pci_fixups_suspend;
+		end = __end_pci_fixups_suspend;
+		break;
+
 	default:
 		/* stupid compiler warning, you would think with an enum... */
 		return;
@@ -1630,7 +1674,7 @@ static void quirk_nvidia_ck804_pcie_aer_
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
 static void __devinit quirk_via_cx700_pci_parking_caching(struct pci_dev *dev)
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -84,6 +84,12 @@
 		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
 		*(.pci_fixup_resume)					\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
+		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
+		*(.pci_fixup_resume_early)				\
+		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
+		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
+		*(.pci_fixup_suspend)					\
+		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
 	}								\
 									\
 	/* RapidIO route ops */						\
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1013,7 +1013,9 @@ enum pci_fixup_pass {
 	pci_fixup_header,	/* After reading configuration header */
 	pci_fixup_final,	/* Final phase of device fixups */
 	pci_fixup_enable,	/* pci_enable_device() time */
-	pci_fixup_resume,	/* pci_enable_device() time */
+	pci_fixup_resume,	/* pci_device_resume() */
+	pci_fixup_suspend,	/* pci_device_suspend */
+	pci_fixup_resume_early, /* pci_device_resume_early() */
 };
 
 /* Anonymous variables would be nice... */
@@ -1035,6 +1037,12 @@ enum pci_fixup_pass {
 #define DECLARE_PCI_FIXUP_RESUME(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume,			\
 			resume##vendor##device##hook, vendor, device, hook)
+#define DECLARE_PCI_FIXUP_RESUME_EARLY(vendor, device, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume_early,		\
+			resume_early##vendor##device##hook, vendor, device, hook)
+#define DECLARE_PCI_FIXUP_SUSPEND(vendor, device, hook)			\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
+			suspend##vendor##device##hook, vendor, device, hook)
 
 
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
