Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab0CMB0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:26:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934906Ab0CMB0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:26:15 -0500
Date: Fri, 12 Mar 2010 18:25:19 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie, <bjorn.helgaas@hp.com>,
       <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Regression in i915 on 2.6.34-rc1
Message-ID: <20100312182519.3723e970@redhat.com>
In-Reply-To: <20100311003358.58194366@redhat.com>
References: <20100311003358.58194366@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 00:33:58 -0700, Pete Zaitcev <zaitcev@redhat.com> wrote:

I apologise for answering to myself, but while there was no answer,
git bisect found the offending commit and I verified that it was
the culprit. Also, I am adding Bjorn and Jesse to cc:.

> I seem to hit a sudden regression in 2.6.34-rc1: the modeset fails.
> On this box it also means, no way to start X, which is unfortunate.
> 
> Here's a quote from bad dmesg (truncated front and back for brievity):
> 
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
> agpgart-intel 0000:00:00.0: detected 131068K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> tpm_tis 00:09: 1.2 TPM (device-id 0xB, rev-id 16)
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> ................
> udev: starting version 151
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
>   alloc irq_desc for 33 on node -1
>   alloc kstat_irqs on node -1
> i915 0000:00:02.0: irq 33 for MSI/MSI-X
> [drm] set up 127M of stolen space
> [drm:i915_gem_init_ringbuffer] *ERROR* Ring head not reset to zero ctl ffffffff head ffffffff tail ffffffff start ffffffff
> [drm:i915_gem_init_ringbuffer] *ERROR* Ring head forced to zero ctl ffffffff head ffffffff tail ffffffff start ffffffff
> [drm:i915_gem_init_ringbuffer] *ERROR* Ring initialization failed ctl ffffffff head ffffffff tail ffffffff start ffffffff
> [drm:i915_driver_load] *ERROR* failed to init modeset
> i915: probe of 0000:00:02.0 failed with error -5
> dracut: Starting plymouth daemon
> 
> Here's old one from 2.6.33:
> 
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel Ironlake/D Chipset
> agpgart-intel 0000:00:00.0: detected 131068K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [drm] Initialized drm 1.1.0 20060810
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> ..........
> ACPI: Power Button [PWRF]
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> i915 0000:00:02.0: irq 31 for MSI/MSI-X
> [drm] set up 127M of stolen space
> Console: switching to colour frame buffer device 210x65
> fb0: inteldrmfb frame buffer device
> registered panic notifier
> [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
> acpi device:1d: registered as cooling_device5
> input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> dracut: Starting plymouth daemon

The commit follows appended.

It's possible that the BIOS on this motherboard is not up to snuff,
but the 2.6.33-rc8 worked fine, so clearly Linux can do it... right?

Cheers,
-- Pete

commit 7bc5e3f2be32ae6fb0c74cd0f707f986b3a01a26
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Feb 23 10:24:41 2010 -0700

    x86/PCI: use host bridge _CRS info by default on 2008 and newer machines
    
    The main benefit of using ACPI host bridge window information is that
    we can do better resource allocation in systems with multiple host bridges,
    e.g., http://bugzilla.kernel.org/show_bug.cgi?id=14183
    
    Sometimes we need _CRS information even if we only have one host bridge,
    e.g., https://bugs.launchpad.net/ubuntu/+source/linux/+bug/341681
    
    Most of these systems are relatively new, so this patch turns on
    "pci=use_crs" only on machines with a BIOS date of 2008 or newer.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 516225a..3e69c1c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1948,8 +1948,12 @@ and is between 256 and 4096 characters. It is defined in the file
 				IRQ routing is enabled.
 		noacpi		[X86] Do not use ACPI for IRQ routing
 				or for PCI scanning.
-		use_crs		[X86] Use _CRS for PCI resource
-				allocation.
+		use_crs		[X86] Use PCI host bridge window information
+				from ACPI.  On BIOSes from 2008 or later, this
+				is enabled by default.  If you need to use this,
+				please report a bug.
+		nocrs		[X86] Ignore PCI host bridge windows from ACPI.
+			        If you need to use this, please report a bug.
 		routeirq	Do IRQ routing for all PCI devices.
 				This is normally done in pci_enable_device(),
 				so this option is a temporary workaround
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index e97b255..93997bd 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -98,6 +98,7 @@ ia64_acpi_release_global_lock (unsigned int *lock)
 #endif
 #define acpi_processor_cstate_check(x) (x) /* no idle limits on IA64 :) */
 static inline void disable_acpi(void) { }
+static inline void pci_acpi_crs_quirks(void) { }
 
 const char *acpi_get_sysname (void);
 int acpi_request_vector (u32 int_type);
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b4bf9a9..05b58cc 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -29,6 +29,7 @@
 #define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
 #define PCI_HAS_IO_ECS		0x40000
 #define PCI_NOASSIGN_ROMS	0x80000
+#define PCI_ROOT_NO_CRS		0x100000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index a2f8cdb..5f11ff6 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -15,6 +15,51 @@ struct pci_root_info {
 	int busnum;
 };
 
+static bool pci_use_crs = true;
+
+static int __init set_use_crs(const struct dmi_system_id *id)
+{
+	pci_use_crs = true;
+	return 0;
+}
+
+static const struct dmi_system_id pci_use_crs_table[] __initconst = {
+	/* http://bugzilla.kernel.org/show_bug.cgi?id=14183 */
+	{
+		.callback = set_use_crs,
+		.ident = "IBM System x3800",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
+		},
+	},
+	{}
+};
+
+void __init pci_acpi_crs_quirks(void)
+{
+	int year;
+
+	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year < 2008)
+		pci_use_crs = false;
+
+	dmi_check_system(pci_use_crs_table);
+
+	/*
+	 * If the user specifies "pci=use_crs" or "pci=nocrs" explicitly, that
+	 * takes precedence over anything we figured out above.
+	 */
+	if (pci_probe & PCI_ROOT_NO_CRS)
+		pci_use_crs = false;
+	else if (pci_probe & PCI_USE__CRS)
+		pci_use_crs = true;
+
+	printk(KERN_INFO "PCI: %s host bridge windows from ACPI; "
+	       "if necessary, use \"pci=%s\" and report a bug\n",
+	       pci_use_crs ? "Using" : "Ignoring",
+	       pci_use_crs ? "nocrs" : "use_crs");
+}
+
 static acpi_status
 resource_to_addr(struct acpi_resource *resource,
 			struct acpi_resource_address64 *addr)
@@ -106,7 +151,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->child = NULL;
 	align_resource(info->bridge, res);
 
-	if (!(pci_probe & PCI_USE__CRS)) {
+	if (!pci_use_crs) {
 		dev_printk(KERN_DEBUG, &info->bridge->dev,
 			   "host bridge window %pR (ignored)\n", res);
 		return AE_OK;
@@ -137,12 +182,8 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
-	if (pci_probe & PCI_USE__CRS)
+	if (pci_use_crs)
 		pci_bus_remove_resources(bus);
-	else
-		dev_info(&device->dev,
-			 "ignoring host bridge windows from ACPI; "
-			 "boot with \"pci=use_crs\" to use them\n");
 
 	info.bridge = device;
 	info.bus = bus;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index d2552c6..3736176 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -520,6 +520,9 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "use_crs")) {
 		pci_probe |= PCI_USE__CRS;
 		return NULL;
+	} else if (!strcmp(str, "nocrs")) {
+		pci_probe |= PCI_ROOT_NO_CRS;
+		return NULL;
 	} else if (!strcmp(str, "earlydump")) {
 		pci_early_dump_regs = 1;
 		return NULL;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 9cd8bed..d724736 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -566,6 +566,7 @@ static int __init acpi_pci_root_init(void)
 	if (acpi_pci_disabled)
 		return 0;
 
+	pci_acpi_crs_quirks();
 	if (acpi_bus_register_driver(&acpi_pci_root_driver) < 0)
 		return -ENODEV;
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f4906f6..3a4767c 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -104,6 +104,7 @@ int acpi_pci_bind_root(struct acpi_device *device);
 
 struct pci_bus *pci_acpi_scan_root(struct acpi_device *device, int domain,
 				   int bus);
+void pci_acpi_crs_quirks(void);
 
 /* --------------------------------------------------------------------------
                                     Processor
