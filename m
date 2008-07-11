Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYGKPRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYGKPRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYGKPPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64875 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbYGKPPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:02 -0400
X-BigFish: VPS31(zz10d1I9321ivzz10d3izzz32i)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 31
X-WSS-ID: 0K3UL0C-04-EOF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/16] AMD IOMMU: add comments to the initialization code
Date: Fri, 11 Jul 2008 17:14:21 +0200
Message-ID: <1215789275-20975-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:35.0940 (UTC) FILETIME=[D462AE40:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some comments to the AMD IOMMU initialization code to increase
its readability.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |  214 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 206 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index bb02800..9ddb46d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -71,6 +71,17 @@
 #define ACPI_DEVFLAG_LINT1              0x80
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
+/*
+ * ACPI table definitions
+ *
+ * These data structures are laid over the table to parse the important values
+ * out of it.
+ */
+
+/*
+ * structure describing one IOMMU in the ACPI table. Typically followed by one
+ * or more ivhd_entrys.
+ */
 struct ivhd_header {
 	u8 type;
 	u8 flags;
@@ -83,6 +94,10 @@ struct ivhd_header {
 	u32 reserved;
 } __attribute__((packed));
 
+/*
+ * A device entry describing which devices a specific IOMMU translates and
+ * which requestor ids they use.
+ */
 struct ivhd_entry {
 	u8 type;
 	u16 devid;
@@ -90,6 +105,10 @@ struct ivhd_entry {
 	u32 ext;
 } __attribute__((packed));
 
+/*
+ * An AMD IOMMU memory definition structure. It defines things like exclusion
+ * ranges for devices and regions that should be unity mapped.
+ */
 struct ivmd_header {
 	u8 type;
 	u8 flags;
@@ -103,22 +122,66 @@ struct ivmd_header {
 
 static int __initdata amd_iommu_detected;
 
-u16 amd_iommu_last_bdf;
-struct list_head amd_iommu_unity_map;
-unsigned amd_iommu_aperture_order = 26;
-int amd_iommu_isolate;
+u16 amd_iommu_last_bdf;			/* largest PCI device id we have
+					   to handle */
+struct list_head amd_iommu_unity_map;	/* a list of required unity mappings
+					   we find in ACPI */
+unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
+int amd_iommu_isolate;			/* if 1, device isolation is enabled */
 
-struct list_head amd_iommu_list;
+struct list_head amd_iommu_list;	/* list of all AMD IOMMUs in the
+					   system */
+
+/*
+ * Pointer to the device table which is shared by all AMD IOMMUs
+ * it is indexed by the PCI device id or the HT unit id and contains
+ * information about the domain the device belongs to as well as the
+ * page table root pointer.
+ */
 struct dev_table_entry *amd_iommu_dev_table;
+
+/*
+ * The alias table is a driver specific data structure which contains the
+ * mappings of the PCI device ids to the actual requestor ids on the IOMMU.
+ * More than one device can share the same requestor id.
+ */
 u16 *amd_iommu_alias_table;
+
+/*
+ * The rlookup table is used to find the IOMMU which is responsible
+ * for a specific device. It is also indexed by the PCI device id.
+ */
 struct amd_iommu **amd_iommu_rlookup_table;
+
+/*
+ * The pd table (protection domain table) is used to find the protection domain
+ * data structure a device belongs to. Indexed with the PCI device id too.
+ */
 struct protection_domain **amd_iommu_pd_table;
+
+/*
+ * AMD IOMMU allows up to 2^16 differend protection domains. This is a bitmap
+ * to know which ones are already in use.
+ */
 unsigned long *amd_iommu_pd_alloc_bitmap;
 
-static u32 dev_table_size;
-static u32 alias_table_size;
-static u32 rlookup_table_size;
+static u32 dev_table_size;	/* size of the device table */
+static u32 alias_table_size;	/* size of the alias table */
+static u32 rlookup_table_size;	/* size if the rlookup table */
+
+/****************************************************************************
+ *
+ * AMD IOMMU MMIO register space handling functions
+ *
+ * These functions are used to program the IOMMU device registers in
+ * MMIO space required for that driver.
+ *
+ ****************************************************************************/
 
+/*
+ * This function set the exclusion range in the IOMMU. DMA accesses to the
+ * exclusion range are passed through untranslated
+ */
 static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
@@ -137,6 +200,7 @@ static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
 			&entry, sizeof(entry));
 }
 
+/* Programs the physical address of the device table into the IOMMU hardware */
 static void __init iommu_set_device_table(struct amd_iommu *iommu)
 {
 	u32 entry;
@@ -149,6 +213,7 @@ static void __init iommu_set_device_table(struct amd_iommu *iommu)
 			&entry, sizeof(entry));
 }
 
+/* Generic functions to enable/disable certain features of the IOMMU. */
 static void __init iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
@@ -167,6 +232,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
+/* Function to enable the hardware */
 void __init iommu_enable(struct amd_iommu *iommu)
 {
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at ");
@@ -176,6 +242,10 @@ void __init iommu_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
+/*
+ * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
+ * the system has one.
+ */
 static u8 * __init iommu_map_mmio_space(u64 address)
 {
 	u8 *ret;
@@ -199,6 +269,19 @@ static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
 	release_mem_region(iommu->mmio_phys, MMIO_REGION_LENGTH);
 }
 
+/****************************************************************************
+ *
+ * The functions below belong to the first pass of AMD IOMMU ACPI table
+ * parsing. In this pass we try to find out the highest device id this
+ * code has to handle. Upon this information the size of the shared data
+ * structures is determined later.
+ *
+ ****************************************************************************/
+
+/*
+ * This function reads the last device id the IOMMU has to handle from the PCI
+ * capability header for this IOMMU
+ */
 static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 {
 	u32 cap;
@@ -209,6 +292,10 @@ static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
 	return 0;
 }
 
+/*
+ * After reading the highest device id from the IOMMU PCI capability header
+ * this function looks if there is a higher device id defined in the ACPI table
+ */
 static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 {
 	u8 *p = (void *)h, *end = (void *)h;
@@ -229,6 +316,7 @@ static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 		case IVHD_DEV_RANGE_END:
 		case IVHD_DEV_ALIAS:
 		case IVHD_DEV_EXT_SELECT:
+			/* all the above subfield types refer to device ids */
 			UPDATE_LAST_BDF(dev->devid);
 			break;
 		default:
@@ -242,6 +330,11 @@ static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 	return 0;
 }
 
+/*
+ * Iterate over all IVHD entries in the ACPI table and find the highest device
+ * id which we need to handle. This is the first of three functions which parse
+ * the ACPI table. So we check the checksum here.
+ */
 static int __init find_last_devid_acpi(struct acpi_table_header *table)
 {
 	int i;
@@ -277,6 +370,20 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	return 0;
 }
 
+/****************************************************************************
+ *
+ * The following functions belong the the code path which parses the ACPI table
+ * the second time. In this ACPI parsing iteration we allocate IOMMU specific
+ * data structures, initialize the device/alias/rlookup table and also
+ * basically initialize the hardware.
+ *
+ ****************************************************************************/
+
+/*
+ * Allocates the command buffer. This buffer is per AMD IOMMU. We can
+ * write commands to that buffer later and the IOMMU will execute them
+ * asynchronously
+ */
 static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 {
 	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL,
@@ -307,6 +414,7 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 				get_order(CMD_BUFFER_SIZE));
 }
 
+/* sets a specific bit in the device table entry. */
 static void set_dev_entry_bit(u16 devid, u8 bit)
 {
 	int i = (bit >> 5) & 0x07;
@@ -315,6 +423,10 @@ static void set_dev_entry_bit(u16 devid, u8 bit)
 	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
 }
 
+/*
+ * This function takes the device specific flags read from the ACPI
+ * table and sets up the device table entry with that information
+ */
 static void __init set_dev_entry_from_acpi(u16 devid, u32 flags, u32 ext_flags)
 {
 	if (flags & ACPI_DEVFLAG_INITPASS)
@@ -333,11 +445,16 @@ static void __init set_dev_entry_from_acpi(u16 devid, u32 flags, u32 ext_flags)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
 }
 
+/* Writes the specific IOMMU for a device into the rlookup table */
 static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
 {
 	amd_iommu_rlookup_table[devid] = iommu;
 }
 
+/*
+ * Reads the device exclusion range from ACPI and initialize IOMMU with
+ * it
+ */
 static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 {
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
@@ -346,12 +463,22 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 		return;
 
 	if (iommu) {
+		/*
+		 * We only can configure exclusion ranges per IOMMU, not
+		 * per device. But we can enable the exclusion range per
+		 * device. This is done here
+		 */
 		set_dev_entry_bit(m->devid, DEV_ENTRY_EX);
 		iommu->exclusion_start = m->range_start;
 		iommu->exclusion_length = m->range_length;
 	}
 }
 
+/*
+ * This function reads some important data from the IOMMU PCI space and
+ * initializes the driver data structure with it. It reads the hardware
+ * capabilities and the first/last device entries
+ */
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
 	int bus = PCI_BUS(iommu->devid);
@@ -367,6 +494,10 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->last_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_LD(range));
 }
 
+/*
+ * Takes a pointer to an AMD IOMMU entry in the ACPI table and
+ * initializes the hardware and our data structures with it.
+ */
 static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 					struct ivhd_header *h)
 {
@@ -467,6 +598,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	}
 }
 
+/* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
 	u16 i;
@@ -494,6 +626,11 @@ static void __init free_iommu_all(void)
 	}
 }
 
+/*
+ * This function clues the initialization function for one IOMMU
+ * together and also allocates the command buffer and programs the
+ * hardware. It does NOT enable the IOMMU. This is done afterwards.
+ */
 static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 {
 	spin_lock_init(&iommu->lock);
@@ -521,6 +658,10 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	return 0;
 }
 
+/*
+ * Iterates over all IOMMU entries in the ACPI table, allocates the
+ * IOMMU structure and initializes it with init_iommu_one()
+ */
 static int __init init_iommu_all(struct acpi_table_header *table)
 {
 	u8 *p = (u8 *)table, *end = (u8 *)table;
@@ -555,6 +696,14 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
+/****************************************************************************
+ *
+ * The next functions belong to the third pass of parsing the ACPI
+ * table. In this last pass the memory mapping requirements are
+ * gathered (like exclusion and unity mapping reanges).
+ *
+ ****************************************************************************/
+
 static void __init free_unity_maps(void)
 {
 	struct unity_map_entry *entry, *next;
@@ -565,6 +714,7 @@ static void __init free_unity_maps(void)
 	}
 }
 
+/* called when we find an exclusion range definition in ACPI */
 static int __init init_exclusion_range(struct ivmd_header *m)
 {
 	int i;
@@ -588,6 +738,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 	return 0;
 }
 
+/* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
 	struct unity_map_entry *e = 0;
@@ -619,6 +770,7 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	return 0;
 }
 
+/* iterates over all memory definitions we find in the ACPI table */
 static int __init init_memory_definitions(struct acpi_table_header *table)
 {
 	u8 *p = (u8 *)table, *end = (u8 *)table;
@@ -642,6 +794,10 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 	return 0;
 }
 
+/*
+ * This function finally enables all IOMMUs found in the system after
+ * they have been initialized
+ */
 static void __init enable_iommus(void)
 {
 	struct amd_iommu *iommu;
@@ -678,6 +834,34 @@ static struct sys_device device_amd_iommu = {
 	.cls = &amd_iommu_sysdev_class,
 };
 
+/*
+ * This is the core init function for AMD IOMMU hardware in the system.
+ * This function is called from the generic x86 DMA layer initialization
+ * code.
+ *
+ * This function basically parses the ACPI table for AMD IOMMU (IVRS)
+ * three times:
+ *
+ *	1 pass) Find the highest PCI device id the driver has to handle.
+ *		Upon this information the size of the data structures is
+ *		determined that needs to be allocated.
+ *
+ *	2 pass) Initialize the data structures just allocated with the
+ *		information in the ACPI table about available AMD IOMMUs
+ *		in the system. It also maps the PCI devices in the
+ *		system to specific IOMMUs
+ *
+ *	3 pass) After the basic data structures are allocated and
+ *		initialized we update them with information about memory
+ *		remapping requirements parsed out of the ACPI table in
+ *		this last pass.
+ *
+ * After that the hardware is initialized and ready to go. In the last
+ * step we do some Linux specific things like registering the driver in
+ * the dma_ops interface and initializing the suspend/resume support
+ * functions. Finally it prints some information about AMD IOMMUs and
+ * the driver state and enables the hardware.
+ */
 int __init amd_iommu_init(void)
 {
 	int i, ret = 0;
@@ -821,6 +1005,13 @@ free:
 	goto out;
 }
 
+/****************************************************************************
+ *
+ * Early detect code. This code runs at IOMMU detection time in the DMA
+ * layer. It just looks if there is an IVRS ACPI table to detect AMD
+ * IOMMUs
+ *
+ ****************************************************************************/
 static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 {
 	return 0;
@@ -841,6 +1032,13 @@ void __init amd_iommu_detect(void)
 	}
 }
 
+/****************************************************************************
+ *
+ * Parsing functions for the AMD IOMMU specific kernel command line
+ * options.
+ *
+ ****************************************************************************/
+
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-- 
1.5.3.7


