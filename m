Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYBYBoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYBYBoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYBYBn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:43:56 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55375 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbYBYBny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:43:54 -0500
Date: Sun, 24 Feb 2008 17:52:34 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be
 clustered_box v2
In-reply-to: <200802241500.52860.yinghai.lu@sun.com>
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com
Message-id: <200802241752.34918.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <20080224122903.GC13637@one.firstfloor.org>
 <200802241500.52860.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 February 2008 03:00:52 pm Yinghai Lu wrote:
> On Sunday 24 February 2008 04:29:03 am Andi Kleen wrote:
> > On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
> > > 
> > > quad core 8 socket system will have apic id lifting.the apic id range could
> > > be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
> > > and that is large than 2. So it is treated as clustered_box.
> > 
> > Ok I see you chose the quick hack over doing it properly ...
> > 
> > > 
> > > and will get
> > > 
> > > Marking TSC unstable due to TSCs unsynchronized
> > > 
> > > even the CPUs have X86_FEATURE_CONSTANT_TSC set.
> > 
> > I doubt that will do the right thing on AMD based vSMP,
> > which also required the cluster check on AMD iirc.
> > 
> > Cc'ed Kiran/Shai. damage has already hit x86 tree I believe.
> 
> do you have bootlog for these box?
> 
> IBM summit2, Unisys es70000, and system from scalemp..
> 
> DMI could tell the difference?

i produced one patch against linus tree. but it can not be applied to x86/testing

x86/testing has
obj-$(CONFIG_PARAVIRT)          += vsmp_64.o

so my question: is the vsmp the real HW or just in paravirt?

YH

----

[PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v3

quad core 8 socket system will have apic id lifting.the apic id range could
be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
and that is large than 2. So it is treated as clustered_box.

and will get

Marking TSC unstable due to TSCs unsynchronized

even the CPUs have X86_FEATURE_CONSTANT_TSC set.

this patch will check if the cpu is from AMD.

also vsmp still need that checking...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4eb5ce8..2bec799 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -60,7 +60,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
+obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index d8d03e0..1427ec3 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1180,9 +1180,20 @@ __cpuinit int apic_is_clustered_box(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
-	u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	u16 *bios_cpu_apicid;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
+	/*
+	 * there is not this kind of box with AMD CPU yet.
+	 * Some AMD box with quadcore cpu and 8 sockets apicid
+	 * will be [4, 0x23] or [8, 0x27] could be thought to
+	 * have three apic_clusters. So go out early.
+	 * vsmp box still need checking...
+	 */
+	if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
+		return 0;
+
+	bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
 	for (i = 0; i < NR_CPUS; i++) {
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index d971210..2780df1 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -16,19 +16,35 @@
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 
+static int vsmp = -1;
+
+__cpuinit int is_vsmp_box(void)
+{
+	if (vsmp != -1)
+		return vsmp;
+
+	vsmp = 0;
+	if (!early_pci_allowed())
+		return vsmp;
+
+	/* Check if we are running on a ScaleMP vSMP box */
+	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
+	     (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
+		vsmp = 1;
+
+	return vsmp;
+}
+
+#ifdef CONFIG_X86_VSMP
 static int __init vsmp_init(void)
 {
 	void *address;
 	unsigned int cap, ctl;
 
-	if (!early_pci_allowed())
+	if (!vsmp)
 		return 0;
 
-	/* Check if we are running on a ScaleMP vSMP box */
-	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) !=
-	     PCI_VENDOR_ID_SCALEMP) ||
-	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) !=
-	     PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
+	if (!early_pci_allowed())
 		return 0;
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
@@ -50,3 +66,4 @@ static int __init vsmp_init(void)
 }
 
 core_initcall(vsmp_init);
+#endif
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index bcfc07f..d69f596 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -130,6 +130,7 @@ extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
 extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
 extern int apic_is_clustered_box(void);
+extern int is_vsmp_box(void);
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
