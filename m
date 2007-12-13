Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXLMOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXLMOmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXLMOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:41:57 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2668 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbXLMOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:41:55 -0500
Date: Thu, 13 Dec 2007 09:39:22 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071213143922.GA4674@hmsreliant.think-freely.org>
References: <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com> <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de> <20071212155515.GA29735@hmsendeavour.rdu.redhat.com> <20071212160722.GD4889@bingen.suse.de> <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com> <20071212202215.GB29735@hmsendeavour.rdu.redhat.com> <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, new patch attached, taking into account Andi's request for a cleaner method
to implement single application quirks.  I've spoken with Ben, who is continuing
to retest, and reports that clean methodical testing results in success with
this patch.


Summary:

Recently a kdump bug was discovered in which a system would hang inside
calibrate_delay during the booting of the kdump kernel.  This was caused by the
fact that the jiffies counter was not being incremented during timer
calibration.  The root cause of this problem was found to be a bios
misconfiguration of the hypertransport bus.  On system affected by this hang,
the bios had assigned APIC ids which used extended apic bits (more than the
nominal 4 bit ids's), but failed to configure bit 17 of the hypertransport
transaction config register, which indicated that the mask for the destination
field of interrupt packets accross the ht bus (see section 3.3.9 of
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF).
If a crash occurs on a cpu with an APIC id that extends beyond 4 bits, it will
not recieve interrupts during the kdump kernel boot, and this hang will be the
result.  The fix is to add this patch, whcih add an early pci quirk check, to
forcibly enable this bit in the httcfg register.  This enables all cpus on a
system to receive interrupts, and allows kdump kernel bootup to procede
normally.


Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 early-quirks.c |   86 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 21 deletions(-)



diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 88bb83e..f4ed3d1 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -21,8 +21,31 @@
 #include <asm/gart.h>
 #endif
 
-static void __init via_bugs(void)
+static void __init fix_hypertransport_config(int num, int slot, int func)
 {
+	u32 htcfg;
+	/*
+	 *we found a hypertransport bus
+	 *make sure that are broadcasting
+	 *interrupts to all cpus on the ht bus
+	 *if we're using extended apic ids
+	 */
+	htcfg = read_pci_config(num, slot, func, 0x68);
+	if (htcfg & (1 << 18)) {	
+		printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
+		if ((htcfg & (1 << 17)) == 0) {
+			printk(KERN_INFO "Enabling hypertransport extended apic interrupt broadcast\n");
+			printk(KERN_INFO "Note this is a bios bug, please contact your hw vendor\n");
+			htcfg |= (1 << 17);
+			write_pci_config(num, slot, func, 0x68, htcfg);
+		}
+	}
+
+	
+}
+
+static void __init via_bugs(int  num, int slot, int func)
+{
 #ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
 	    !gart_iommu_aperture_allowed) {
@@ -44,8 +67,8 @@
 #endif /* CONFIG_X86_IO_APIC */
 #endif /* CONFIG_ACPI */
 
-static void __init nvidia_bugs(void)
+static void __init nvidia_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
 	/*
@@ -72,8 +95,8 @@
 
 }
 
-static void __init ati_bugs(void)
+static void __init ati_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
@@ -83,15 +106,27 @@
 #endif
 }
 
+#define QFLAG_APPLY_ONCE 	0x1
+#define QFLAG_APPLIED		0x2
+#define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
 struct chipset {
-	u16 vendor;
-	void (*f)(void);
+	u32 vendor;
+	u32 device;
+	u32 class;
+	u32 class_mask;
+	u32 flags;
+	void (*f)(int num, int slot, int func);
 };
 
 static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
-	{ PCI_VENDOR_ID_VIA, via_bugs },
-	{ PCI_VENDOR_ID_ATI, ati_bugs },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
+	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID, 
+	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID, 
+	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, ati_bugs },
+	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB, 
+	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
 	{}
 };
 
@@ -106,27 +141,36 @@
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
-				u32 class;
-				u32 vendor;
+				u16 class;
+				u16 vendor;
+				u16 device;
 				u8 type;
 				int i;
-				class = read_pci_config(num,slot,func,
+
+				class = read_pci_config_16(num,slot,func,
 							PCI_CLASS_REVISION);
-				if (class == 0xffffffff)
+				if (class == 0xffff)
 					break;
 
-				if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
-					continue;
-
-				vendor = read_pci_config(num, slot, func,
+				vendor = read_pci_config_16(num, slot, func,
 							 PCI_VENDOR_ID);
-				vendor &= 0xffff;
 
-				for (i = 0; early_qrk[i].f; i++)
-					if (early_qrk[i].vendor == vendor) {
-						early_qrk[i].f();
-						return;
+				device = read_pci_config_16(num, slot, func,
+							PCI_DEVICE_ID);
+
+				for(i=0;early_qrk[i].f != NULL;i++) {
+					if (((early_qrk[i].vendor == PCI_ANY_ID) ||
+					    (early_qrk[i].vendor == vendor)) &&
+					   ((early_qrk[i].device == PCI_ANY_ID) ||
+					    (early_qrk[i].device == device)) &&
+					   (!((early_qrk[i].class ^ class) & 
+					     early_qrk[i].class_mask))) {
+						if ((early_qrk[i].flags & QFLAG_DONE) != QFLAG_DONE)
+							early_qrk[i].f(num, slot, func);
+						early_qrk[i].flags |= QFLAG_APPLIED;
+						
 					}
+				}
 
 				type = read_pci_config_byte(num, slot, func,
 							    PCI_HEADER_TYPE);
