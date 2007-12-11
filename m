Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXLKSZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXLKSZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXLKSZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:25:41 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3951 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXLKSZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:25:40 -0500
Date: Tue, 11 Dec 2007 13:22:54 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071211182254.GB10999@hmsreliant.think-freely.org>
References: <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com> <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com> <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> <20071207175832.GA18485@hmsreliant.think-freely.org> <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com> <20071211034349.GA3635@localhost.localdomain> <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com> <20071211143910.GA10999@hmsreliant.think-freely.org> <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 08:29:20AM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > On Mon, Dec 10, 2007 at 09:48:11PM -0700, Eric W. Biederman wrote:
> >> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> Ok.  I just looked at read_pci_config.  It doesn't do the right thing for
> a non-aligned 32bit access.  (Not that I am convinced there is a right
> thing we can do).  Please make this read_pci_config_16 instead
> and you won't need the shift.
> 
> Either that or as I earlier suggested just do a 32bit read from offset 0
> and use shifts and masks to get vendor and device fields.
> 


The former seems like a reasonable solution to me.  Corrected in this updated
patch.

> You almost got YH's comment.  You need return 2 for the old functions
> so we don't try and apply a per chipset fixup for every device in
> the system.
> 
> I'm actually inclined to remove the return magic and just do something
> like:
> 	static fix_applied;
> 	if (fix_applied++)
>         	return;
> In those functions that should be called only once.
> 

I like the latter approach better.  It seems less convoluted to me.

New patch attached.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 early-quirks.c |   90 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 21 deletions(-)


diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 88bb83e..f307285 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -21,8 +21,13 @@
 #include <asm/gart.h>
 #endif
 
-static void __init via_bugs(void)
+static void __init via_bugs(int  num, int slot, int func)
 {
+	static int fix_applied = 0;
+
+	if (fix_applied++)
+		return;
+
 #ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
 	    !gart_iommu_aperture_allowed) {
@@ -44,8 +49,36 @@ static int __init nvidia_hpet_check(struct acpi_table_header *header)
 #endif /* CONFIG_X86_IO_APIC */
 #endif /* CONFIG_ACPI */
 
-static void __init nvidia_bugs(void)
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
+static void __init nvidia_bugs(int num, int slot, int func)
+{
+	static int fix_applied = 0;
+
+	if (fix_applied++)
+		return;
+
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
 	/*
@@ -72,8 +105,13 @@ static void __init nvidia_bugs(void)
 
 }
 
-static void __init ati_bugs(void)
+static void __init ati_bugs(int num, int slot, int func)
 {
+	static int fix_applied = 0;
+
+	if (fix_applied++)
+		return;
+
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
@@ -84,14 +122,18 @@ static void __init ati_bugs(void)
 }
 
 struct chipset {
-	u16 vendor;
-	void (*f)(void);
+	u32 vendor;
+	u32 device;
+	u32 class;
+	u32 class_mask;
+	void (*f)(int num, int slot, int func);
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
 
@@ -106,27 +148,33 @@ void __init early_quirks(void)
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
+						early_qrk[i].f(num, slot, func);
 					}
+				}
 
 				type = read_pci_config_byte(num, slot, func,
 							    PCI_HEADER_TYPE);
