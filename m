Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0BWRYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:24:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4433 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0BWRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:24:42 -0500
Subject: [PATCH v5 5/5] x86/PCI: use host bridge _CRS info by default on 2008
	and newer machines
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 23 Feb 2010 10:24:41 -0700
Message-ID: <20100223172441.17242.70624.stgit@bob.kio>
In-Reply-To: <20100223172355.17242.55927.stgit@bob.kio>
References: <20100223172355.17242.55927.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The main benefit of using ACPI host bridge window information is that
we can do better resource allocation in systems with multiple host bridges,
e.g., http://bugzilla.kernel.org/show_bug.cgi?id=14183

Sometimes we need _CRS information even if we only have one host bridge,
e.g., https://bugs.launchpad.net/ubuntu/+source/linux/+bug/341681

Most of these systems are relatively new, so this patch turns on
"pci=use_crs" only on machines with a BIOS date of 2008 or newer.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 Documentation/kernel-parameters.txt |    8 ++++-
 arch/ia64/include/asm/acpi.h        |    1 +
 arch/x86/include/asm/pci_x86.h      |    1 +
 arch/x86/pci/acpi.c                 |   53 +++++++++++++++++++++++++++++++----
 arch/x86/pci/common.c               |    3 ++
 drivers/acpi/pci_root.c             |    1 +
 include/acpi/acpi_drivers.h         |    1 +
 7 files changed, 60 insertions(+), 8 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 01e2a98..6913e9a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1939,8 +1939,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
index 7ae5889..7f2d7f2 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -97,6 +97,7 @@ ia64_acpi_release_global_lock (unsigned int *lock)
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
index 64ae2f2..4a46051 100644
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

