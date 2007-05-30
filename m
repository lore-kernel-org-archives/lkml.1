Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXE3EGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXE3EGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXE3EG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:06:26 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25698 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXE3EGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:06:24 -0400
Date: Tue, 29 May 2007 22:03:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard resources
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <465CF794.1070406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This path adds validation of the MMCONFIG table against the ACPI reserved
motherboard resources. If the MMCONFIG table is found to be reserved in
ACPI, we don't bother checking the E820 table. The PCI Express firmware spec
apparently tells BIOS developers that reservation in ACPI is required and
E820 reservation is optional, so checking against ACPI first makes sense.
Many BIOSes don't reserve the MMCONFIG region in E820 even though it is
perfectly functional, the existing check needlessly disables MMCONFIG in
these cases.

In order to do this, MMCONFIG setup has been split into two phases. If PCI
configuration type 1 is not available then MMCONFIG is enabled early as before.
Otherwise, it is enabled later after the ACPI interpreter is enabled, since we
need to be able to execute control methods in order to check the ACPI reserved
resources. Presently this is just triggered off the end of ACPI interpreter
initialization.

There are a few other behavioral changes here:

-Validate all MMCONFIG configurations provided, not just the first one.

-Validate the entire required length of each configuration according to the
provided ending bus number is reserved, not just the minimum required allocation.

-Validate that the area is reserved even if we read it from the chipset directly
and not from the MCFG table. This catches the case where the BIOS didn't set the
location properly in the chipset and has mapped it over other things it shouldn't
have.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

diff -up linux-2.6.22-rc2-mm1/arch/i386/pci/init.c linux-2.6.22-rc2-mm1edit/arch/i386/pci/init.c
--- linux-2.6.22-rc2-mm1/arch/i386/pci/init.c	2007-05-23 21:20:43.000000000 -0600
+++ linux-2.6.22-rc2-mm1edit/arch/i386/pci/init.c	2007-05-23 21:31:50.000000000 -0600
@@ -12,7 +12,7 @@ static __init int pci_access_init(void)
 	type = pci_direct_probe();
 #endif
 #ifdef CONFIG_PCI_MMCONFIG
-	pci_mmcfg_init(type);
+	pci_mmcfg_early_init(type);
 #endif
 	if (raw_pci_ops)
 		return 0;
diff -up linux-2.6.22-rc2-mm1/arch/i386/pci/mmconfig-shared.c linux-2.6.22-rc2-mm1edit/arch/i386/pci/mmconfig-shared.c
--- linux-2.6.22-rc2-mm1/arch/i386/pci/mmconfig-shared.c	2007-05-23 21:21:04.000000000 -0600
+++ linux-2.6.22-rc2-mm1edit/arch/i386/pci/mmconfig-shared.c	2007-05-23 21:38:19.000000000 -0600
@@ -206,9 +206,77 @@ static void __init pci_mmcfg_insert_reso
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static void __init pci_mmcfg_reject_broken(int type)
+static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
+		void *data)
+{
+	struct resource *mcfg_res = data;
+	struct acpi_resource_address64 address;
+	acpi_status status;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32 =
+			&res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_OK;
+		if ((mcfg_res->start >= fixmem32->address) &&
+			(mcfg_res->end <= (fixmem32->address +
+					   fixmem32->address_length))) {
+			mcfg_res->flags = 1;
+			return AE_CTRL_TERMINATE;
+		}
+	}
+	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
+			(res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
+		return AE_OK;
+
+	status = acpi_resource_to_address64(res, &address);
+	if (ACPI_FAILURE(status) || (address.address_length <= 0) ||
+			(address.resource_type != ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	if ((mcfg_res->start >= address.minimum) &&
+			(mcfg_res->end <=
+			 (address.minimum +address.address_length))) {
+		mcfg_res->flags = 1;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
+		void *context, void **rv)
+{
+	struct resource *mcfg_res = context;
+
+	acpi_walk_resources(handle, METHOD_NAME__CRS,
+	  		    check_mcfg_resource, context);
+
+	if (mcfg_res->flags)
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static int __init is_acpi_reserved(unsigned long start, unsigned long end)
+{
+	struct resource mcfg_res;
+
+	mcfg_res.start = start;
+	mcfg_res.end = end;
+	mcfg_res.flags = 0;
+
+	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
+	
+	if( !mcfg_res.flags )
+		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res, NULL);
+
+	return mcfg_res.flags;
+}
+
+static void __init pci_mmcfg_reject_broken(void)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
+	int i;
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -228,18 +296,36 @@ static void __init pci_mmcfg_reject_brok
 		       "Rejected as broken MCFG.\n");
 		goto reject;
 	}
-
-	/*
-	 * Only do this check when type 1 works. If it doesn't work
-	 * assume we run on a Mac and always use MCFG
-	 */
-	if (type == 1 && !e820_all_mapped(cfg->address,
-					  cfg->address + MMCONFIG_APER_MIN,
-					  E820_RESERVED)) {
-		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
-		       " E820-reserved\n", cfg->address);
-		goto reject;
+	
+	for(i=0; i < pci_mmcfg_config_num; i++) {
+		u32 size = (cfg->end_bus_number + 1) << 20;
+		cfg = &pci_mmcfg_config[i];
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %p segment %hu buses %u - %u\n",
+			i, (void*)cfg->address, cfg->pci_segment,
+			(unsigned int)cfg->start_bus_number,
+			(unsigned int)cfg->end_bus_number);
+		if(is_acpi_reserved(cfg->address,
+				    cfg->address + size - 1))
+			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
+				"in ACPI motherboard resources\n",
+				cfg->address);
+		else {
+			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not "
+				"reserved in ACPI motherboard resources\n",
+				cfg->address);
+			/* Don't try to do this check unless configuration type 1 is
+			   available. */
+			if((pci_probe & PCI_PROBE_CONF1) &&
+			   e820_all_mapped(cfg->address,
+					   cfg->address + size - 1,
+					   E820_RESERVED))
+				printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved in E820\n",
+					cfg->address);
+			else
+				goto reject;
+		}
 	}
+
 	return;
 
 reject:
@@ -249,20 +335,46 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_init(int type)
+void __init pci_mmcfg_early_init(int type)
+{
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return;
+	
+	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
+	   defer until later when the ACPI interpreter is available to better
+	   validate things. */
+	if( type == 1 )
+		return;
+
+	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+
+	if ((pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return;
+
+	if (pci_mmcfg_arch_init())
+		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+}
+
+void __init pci_mmcfg_late_init(void)
 {
 	int known_bridge = 0;
 
+	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
+		
+	/* MMCONFIG already enabled */
+	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
+		return;
 
-	if (type == 1 && pci_mmcfg_check_hostbridge())
+	if ((pci_probe & PCI_PROBE_CONF1) && pci_mmcfg_check_hostbridge())
 		known_bridge = 1;
-
-	if (!known_bridge) {
+	else
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(type);
-	}
+
+	pci_mmcfg_reject_broken();
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -270,7 +382,7 @@ void __init pci_mmcfg_init(int type)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (type == 1)
+		if (pci_probe & PCI_PROBE_CONF1)
 			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
diff -up linux-2.6.22-rc2-mm1/arch/i386/pci/pci.h linux-2.6.22-rc2-mm1edit/arch/i386/pci/pci.h
--- linux-2.6.22-rc2-mm1/arch/i386/pci/pci.h	2007-04-25 21:08:32.000000000 -0600
+++ linux-2.6.22-rc2-mm1edit/arch/i386/pci/pci.h	2007-05-23 21:31:50.000000000 -0600
@@ -91,7 +91,8 @@ extern int pci_conf1_read(unsigned int s
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_mmcfg_init(int type);
+extern void pci_mmcfg_early_init(int type);
+extern void pci_mmcfg_late_init(void);
 extern void pcibios_sort(void);
 
 /* pci-mmconfig.c */
--- linux-2.6.22-rc2-mm1/drivers/acpi/bus.c	2007-05-23 21:20:44.000000000 -0600
+++ linux-2.6.22-rc2-mm1edit/drivers/acpi/bus.c	2007-05-23 21:31:50.000000000 -0600
@@ -42,6 +42,7 @@
 ACPI_MODULE_NAME("bus");
 #ifdef	CONFIG_X86
 extern void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger);
+extern void __init pci_mmcfg_late_init(void);
 #endif
 
 struct acpi_device *acpi_root;
@@ -755,6 +756,9 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
+#ifdef CONFIG_X86
+		pci_mmcfg_late_init();
+#endif		
 #ifdef CONFIG_PM_LEGACY
 		if (!PM_IS_ACTIVE())
 			pm_active = 1;

