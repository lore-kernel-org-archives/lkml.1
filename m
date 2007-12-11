Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXLKOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXLKOl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXLKOlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:41:49 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4532 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXLKOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:41:48 -0500
Date: Tue, 11 Dec 2007 09:39:10 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071211143910.GA10999@hmsreliant.think-freely.org>
References: <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com> <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com> <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com> <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> <20071207175832.GA18485@hmsreliant.think-freely.org> <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com> <20071211034349.GA3635@localhost.localdomain> <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 09:48:11PM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> Almost there.
cool! :)

<snip>
> 
> We should not need check_hypertransport_config as the generic loop
> now does the work for us.
> > +
> >  static void __init nvidia_bugs(void)
> >  {
> >  #ifdef CONFIG_ACPI
> > @@ -83,15 +127,25 @@ static void __init ati_bugs(void)
> >  #endif
> >  }
> >  
> > +static void __init amd_host_bugs(void)
> > +{
> > +	printk(KERN_CRIT "IN AMD_HOST_BUGS\n");
> > +	check_hypertransport_config();
> > +}
> 
> Likewise this function is unneeded and the printk is likely confusing
> for users.
> 
Copy that. Fixed

<snip>
> >  	{}
> So make that fix_hypertransport_config and we should be good.
Done

> 
> We don't need to shift device.  Although we can do:
> device_vendor = read_pci_config(num, slot, func, PCI_VENDOR_ID);
> device = device_vendor >> 16;
> vendor = device_vendor & 0xffff;
> 
I'm not so sure about this.  In my testing, it was clear that I needed to do a
shift on device to make valid comparisons to the defined PCI_DEVICE_* macros.
The origional code had to do the same thing with the class field, which is
simmilarly positioned in the pci config space.


Other than that, new patch attached.  Enables the detection of AMD
hypertransport functions and checks for the proper quirk just as before, and
incoporates your comments above Eric, as well as yours Yinghai.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 early-quirks.c |   76 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 15 deletions(-)



diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 88bb83e..e13c999 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -21,7 +21,7 @@
 #include <asm/gart.h>
 #endif
 
-static void __init via_bugs(void)
+static int __init via_bugs(int  num, int slot, int func)
 {
 #ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
@@ -32,6 +32,7 @@ static void __init via_bugs(void)
 		gart_iommu_aperture_disabled = 1;
 	}
 #endif
+	return 1;
 }
 
 #ifdef CONFIG_ACPI
@@ -44,7 +45,31 @@ static int __init nvidia_hpet_check(struct acpi_table_header *header)
 #endif /* CONFIG_X86_IO_APIC */
 #endif /* CONFIG_ACPI */
 
-static void __init nvidia_bugs(void)
+static int __init fix_hypertransport_config(int num, int slot, int func)
+{
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
+	return 1;
+	
+}
+
+static int __init nvidia_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
@@ -56,7 +81,7 @@ static void __init nvidia_bugs(void)
 	 * at least allow a command line override.
 	 */
 	if (acpi_use_timer_override)
-		return;
+		return 1;
 
 	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
 		acpi_skip_timer_override = 1;
@@ -70,9 +95,10 @@ static void __init nvidia_bugs(void)
 #endif
 	/* RED-PEN skip them on mptables too? */
 
+	return 1;
 }
 
-static void __init ati_bugs(void)
+static int __init ati_bugs(int num, int slot, int func)
 {
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_over_8254 == 1) {
@@ -81,17 +107,22 @@ static void __init ati_bugs(void)
 		"ATI board detected. Disabling timer routing over 8254.\n");
 	}
 #endif
+	return 1;
 }
 
 struct chipset {
-	u16 vendor;
-	void (*f)(void);
+	u32 vendor;
+	u32 device;
+	u32 class;
+	u32 class_mask;
+	int (*f)(int num, int slot, int func);
 };
 
 static struct chipset early_qrk[] __initdata = {
-	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
-	{ PCI_VENDOR_ID_VIA, via_bugs },
-	{ PCI_VENDOR_ID_ATI, ati_bugs },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, nvidia_bugs },
+	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, via_bugs },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, ati_bugs },
+	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB, PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, fix_hypertransport_config },
 	{}
 };
 
@@ -108,25 +139,40 @@ void __init early_quirks(void)
 			for (func = 0; func < 8; func++) {
 				u32 class;
 				u32 vendor;
+				u32 device;
 				u8 type;
+				int ret;
 				int i;
+
 				class = read_pci_config(num,slot,func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
 					break;
 
-				if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
-					continue;
+				class >>= 16;
 
 				vendor = read_pci_config(num, slot, func,
 							 PCI_VENDOR_ID);
 				vendor &= 0xffff;
 
-				for (i = 0; early_qrk[i].f; i++)
-					if (early_qrk[i].vendor == vendor) {
-						early_qrk[i].f();
-						return;
+				device = read_pci_config(num, slot, func,
+							PCI_DEVICE_ID);
+				device >>= 16;
+
+				for(i=0;early_qrk[i].f != NULL;i++) {
+					if (((early_qrk[i].vendor == PCI_ANY_ID) ||
+					    (early_qrk[i].vendor == vendor)) &&
+					   ((early_qrk[i].device == PCI_ANY_ID) ||
+					    (early_qrk[i].device == device)) &&
+					   (!((early_qrk[i].class ^ class) & 
+					     early_qrk[i].class_mask))) {
+						ret = early_qrk[i].f(num, slot, func);
+						if (ret == 1)
+							break;
+						if (ret == 2)
+							return;
 					}
+				}
 
 				type = read_pci_config_byte(num, slot, func,
 							    PCI_HEADER_TYPE);
