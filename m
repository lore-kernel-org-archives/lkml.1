Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbZD2RCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbZD2RCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbZD2Qzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:50 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33386 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbZD2Qzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:41 -0400
X-BigFish: VPS0(zz1fa4L30e4izz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KIVGC5-02-4PH-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 21/21] amd64_edac: add module registration routines
Date: Wed, 29 Apr 2009 18:55:07 +0200
Message-ID: <1241024107-14535-22-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 16:55:23.0945 (UTC) FILETIME=[49E60190:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Also, link into Kbuild by adding Kconfig and Makefile entries.

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig      |   26 +++
 drivers/edac/Makefile     |    1 +
 drivers/edac/amd64_edac.c |  475 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 502 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index e5f5c5a..e854de1 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -58,6 +58,32 @@ config EDAC_MM_EDAC
 	  occurred so that a particular failing memory module can be
 	  replaced.  If unsure, select 'Y'.
 
+config EDAC_AMD64_OPTERON
+	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
+	depends on EDAC_MM_EDAC && X86 && PCI && NUMA
+	help
+	Support for error detection and correction on the AMD 64
+	Families of Memory Controllers (K8, F10h and F11h)
+
+config EDAC_AMD64_OPTERON_ERROR_INJECTION
+	bool "/sys Error Injection access"
+	depends on EDAC_AMD64_OPTERON
+	help
+	  Recent Opterons (Family 10h and later) provide for Memory Error
+	  Injection into the ECC detection circuits. The amd64_edac module
+	  allows the operator/user to inject Uncorrectable and Correctable
+	  errors into DRAM.
+
+	  When enabled, in each of the respective memory controller directories
+	  (/sys/devices/system/edac/mc/mcX), there are 3 input files:
+
+	  - z_inject_section (0..3, 16-byte section of 64-byte cacheline),
+	  - z_inject_word (0..8, 16-bit word of 16-byte section),
+	  - z_inject_bit_map (hex bitmap vector: mask bits of 16 bit word to
+	    error-out)
+
+	  In addition, there are two control files, z_inject_read and
+	  z_inject_write, which trigger the Read and Write errors respectively.
 
 config EDAC_AMD76X
 	tristate "AMD 76x (760, 762, 768)"
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index a5fdcf0..262fee7 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_EDAC_I3000)		+= i3000_edac.o
 obj-$(CONFIG_EDAC_X38)			+= x38_edac.o
 obj-$(CONFIG_EDAC_I82860)		+= i82860_edac.o
 obj-$(CONFIG_EDAC_R82600)		+= r82600_edac.o
+obj-$(CONFIG_EDAC_AMD64_OPTERON)	+= amd64_edac.o
 obj-$(CONFIG_EDAC_PASEMI)		+= pasemi_edac.o
 obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4d1076f..15f1fce 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4908,3 +4908,478 @@ static struct mcidev_sysfs_attribute amd64_mc_sysfs_ctls_attrs[] = {
 	}
 };
 
+/*
+ * amd64_set_mc_sysfs_attributes
+ */
+static void amd64_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
+{
+	mci->mc_driver_sysfs_attributes = amd64_mc_sysfs_ctls_attrs;
+}
+
+/*
+ * amd64_setup_mci_misc_attributes
+ *
+ *	initialize various attributes of the mci structure
+ */
+static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	/* Initialize various states */
+	mci->mtype_cap = MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE;
+	mci->edac_cap = EDAC_FLAG_NONE;
+
+	/* Exam the capabilities of the northbridge in order to reflect them
+	 * in the presentation via sysfs attributes, etc
+	 */
+	if (pvt->nbcap & K8_NBCAP_SECDED)
+		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
+
+	if (pvt->nbcap & K8_NBCAP_CHIPKILL)
+		mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
+
+	/* What type of SECDED is there? */
+	mci->edac_cap = amd64_determine_edac_cap(pvt);
+
+	/* Misc attributes to set */
+	mci->mod_name = EDAC_MOD_STR;
+	mci->mod_ver = EDAC_AMD64_VERSION;
+	mci->ctl_name = get_amd_family_name(pvt->mc_type_index);
+	mci->dev_name = pci_name(pvt->dram_f2_ctl);
+	mci->ctl_page_to_phys = NULL;
+
+	/* IMPORTANT: Set the polling 'check' function in this module */
+	mci->edac_check = amd64_check;
+
+	/* memory scrubber interface */
+	mci->set_sdram_scrub_rate = amd64_set_scrub_rate;
+	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
+}
+
+/*
+ * amd64_probe_one_instance
+ *
+ *    probe function to determine if there is a DRAM Controller device is
+ *    present and to construct data tables for it.
+ *
+ *    Due to a hardware feature on Family 10H cpus, the Enable Extended
+ *    Configuration Space feature MUST be enabled on ALL Processors prior to
+ *    actually reading from the ECS registers. Since the loading of the module
+ *    can occur on any 'core', and cores don't 'see' all the other processors
+ *    ECS data when the others are NOT enabled. Our solution is to first
+ *    enable ECS access in this routine on all processors, gather some data in
+ *    a amd64_pvt structure and later come back in a 'finishup_setup' function
+ *    to perform that final initialization.
+ *
+ *    See also amd64_init_2nd_stage().
+ */
+static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
+					int mc_type_index)
+{
+	struct amd64_pvt *pvt;
+	int err, num_cpus;
+	int rc;
+
+	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
+	if (pvt == NULL) {
+		rc = -ENOMEM;
+		goto exit_now;
+	}
+
+	pvt->mc_node_id = get_mc_node_id_from_pdev(dram_f2_ctl);
+
+	debugf0("=========== %s(Instance= %d) ===========\n",
+		__func__, pvt->mc_node_id);
+
+	pvt->dram_f2_ctl = dram_f2_ctl;
+	pvt->ext_model = boot_cpu_data.x86_model >> 4;
+	pvt->mc_type_index = mc_type_index;
+	pvt->ops = get_amd_family_ops(mc_type_index);
+
+	num_cpus = cpumask_weight(cpumask_of_node(pvt->mc_node_id));
+	pvt->old_mcgctl = kzalloc(sizeof(u32) * num_cpus, GFP_KERNEL);
+	if (!pvt->old_mcgctl) {
+		rc = -ENOMEM;
+		goto free_pvt;
+	}
+
+	/*
+	 * We have the dram_f2_ctl device as an argument, now go reserved its
+	 * sibling devices from the PCI system.
+	 */
+	err = amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
+	if (err) {
+		rc = -ENODEV;
+		goto exit_now;
+	}
+
+	rc = amd64_check_ecc_enabled(pvt);
+	if (rc)
+		goto exit_release_devices;
+
+	/*
+	 * Key operation here: setup of HW prior to performing ops on it. Some
+	 * setup is required to access ECS data. After this is performed, then
+	 * the 'teardown' function must be called upon error and normal exit
+	 * paths.
+	 */
+	if (boot_cpu_data.x86 > 0xf)
+		amd64_setup(pvt);
+
+	/*
+	 * Save the pointer to the private data for use in 2nd initialization
+	 * stage
+	 */
+	pvt_lookup[pvt->mc_node_id] = pvt;
+
+	debugf0("%s(): init 1st stage done pvt-%d\n", __func__,
+		pvt->mc_node_id);
+	return 0;
+
+
+exit_release_devices:
+	pci_dev_put(pvt->addr_f1_ctl);
+	pci_dev_put(pvt->misc_f3_ctl);
+
+free_pvt:
+	kfree(pvt);
+
+exit_now:
+	return rc;
+}
+
+/*
+ * amd64_init_2nd_stage
+ *
+ *	this is the "finishing" up initialization code
+ *	Needs to be performed after all MCs' Hardware have been
+ *	"prep'ed" for accessing extended config space.
+ */
+static int amd64_init_2nd_stage(struct amd64_pvt *pvt_temp)
+{
+	int node_id = pvt_temp->mc_node_id;
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+	int rc;
+	int err;
+
+	debugf0("%s()\n", __func__);
+
+	amd64_read_mc_registers(pvt_temp);
+
+	/* Check hardware to see if this module can support HW at this time */
+	if (pvt_temp->ops->probe_valid_hardware) {
+		err = pvt_temp->ops->probe_valid_hardware(pvt_temp);
+		if (err) {
+			rc = -ENODEV;
+			goto exit_failure;
+		}
+	}
+
+	/*
+	 * We need to determine how many memory channels there are. Then use
+	 * that information for calculating the size of the dynamic instance
+	 * tables in the 'mci' structure
+	 */
+	pvt_temp->channel_count = pvt_temp->ops->early_channel_count(pvt_temp);
+
+	mci = edac_mc_alloc(sizeof(*pvt_temp),
+				CHIPSELECT_COUNT,
+				pvt_temp->channel_count,
+				node_id);
+	if (mci == NULL) {
+		rc = -ENOMEM;
+		goto exit_failure;
+	}
+
+	/*
+	 * transfer the info from the interium pvt area to the private area of
+	 * the MC instance structure
+	 */
+	pvt = mci->pvt_info;
+	*pvt = *pvt_temp;
+
+	mci->dev = &pvt_temp->dram_f2_ctl->dev;
+	amd64_setup_mci_misc_attributes(mci);
+
+	if (amd64_init_csrows(mci)) {
+		debugf1("Setting mci->edac_cap to EDAC_FLAG_NONE because\n");
+		debugf1("   amd64_init_csrows() returned NO csrows found\n");
+		mci->edac_cap = EDAC_FLAG_NONE;
+	}
+
+	amd64_enable_ecc_error_reporting(mci);
+	amd64_set_mc_sysfs_attributes(mci);
+
+	if (edac_mc_add_mc(mci)) {
+		debugf1("%s(): failed edac_mc_add_mc()\n", __func__);
+		rc = -ENODEV;
+		goto exit_add_mc_failure;
+	}
+
+	debugf0("%s(): init 2nd stage done mci%d\n", __func__,
+		pvt->mc_node_id);
+
+	mci_lookup[node_id] = mci;
+
+	kfree((pvt_lookup[pvt->mc_node_id])->old_mcgctl);
+	kfree(pvt_lookup[pvt->mc_node_id]);
+	pvt_lookup[node_id] = NULL;
+	return 0;
+
+exit_add_mc_failure:
+	edac_mc_free(mci);
+
+exit_failure:
+	debugf0("%s() failure init 2nd stage: rc=%d\n", __func__, rc);
+
+	amd64_restore_ecc_error_reporting(pvt);
+
+	if (boot_cpu_data.x86 > 0xf)
+		amd64_teardown(pvt);
+
+	pci_dev_put(pvt->addr_f1_ctl);
+	pci_dev_put(pvt->misc_f3_ctl);
+
+	kfree((pvt_lookup[pvt->mc_node_id])->old_mcgctl);
+	kfree(pvt_lookup[pvt->mc_node_id]);
+	pvt_lookup[node_id] = NULL;
+
+	return rc;
+}
+
+
+/*
+ * amd64_init_one_instance
+ *
+ *	initialize just one device
+ *
+ *	returns:
+ *		 count (>= 0), or
+ *		negative on error
+ */
+static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
+				 const struct pci_device_id *mc_type)
+{
+	int rc;
+
+	debugf0("%s(MC node=%d,mc_type='%s')\n",
+		__func__,
+		get_mc_node_id_from_pdev(pdev),
+		get_amd_family_name(mc_type->driver_data));
+
+	/* wake up and enable device */
+	rc = pci_enable_device(pdev);
+	if (rc < 0)
+		rc = -EIO;
+	else
+		rc = amd64_probe_one_instance(pdev, mc_type->driver_data);
+
+	if (rc < 0)
+		debugf0("%s() rc=%d\n", __func__, rc);
+
+	return rc;
+}
+
+/*
+ * amd64_remove_one_instance
+ *
+ *	remove just one device instance upon driver unloading
+ */
+static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+
+	debugf0("%s()\n", __func__);
+
+	/* Remove from EDAC CORE tracking list */
+	mci = edac_mc_del_mc(&pdev->dev);
+	if (mci == NULL)
+		return;
+
+	pvt = mci->pvt_info;
+
+	amd64_restore_ecc_error_reporting(pvt);
+
+	if (boot_cpu_data.x86 > 0xf)
+		amd64_teardown(pvt);
+
+	pci_dev_put(pvt->addr_f1_ctl);
+	pci_dev_put(pvt->misc_f3_ctl);
+
+	mci_lookup[pvt->mc_node_id] = NULL;
+
+	/* Free the EDAC CORE resources */
+	edac_mc_free(mci);
+}
+
+/*
+ * The 'pci_device_id' table.
+ *
+ *	This table is part of the interface for loading drivers for PCI
+ *	devices. The PCI core identifies what devices are on a system
+ *	during boot, and then inquiry this table to see if this driver
+ *	is for a given device found.
+ *
+ *	The PCI helpper functions walk this table and call the
+ *	'.probe' function of the 'pci_driver' table, for each
+ *	instance in this table
+ */
+static const struct pci_device_id amd64_pci_table[] __devinitdata = {
+	{
+		/* Rev F and prior */
+		.vendor = PCI_VENDOR_ID_AMD,
+		.device = PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = 0,
+		.class_mask = 0,
+		.driver_data = K8_CPUS
+	},
+	{
+		/* Family 10h */
+		.vendor = PCI_VENDOR_ID_AMD,
+		.device = PCI_DEVICE_ID_AMD_10H_NB_DRAM,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = 0,
+		.class_mask = 0,
+		.driver_data = F10_CPUS
+	},
+	{
+		/* Family 11h */
+		.vendor = PCI_VENDOR_ID_AMD,
+		.device = PCI_DEVICE_ID_AMD_11H_NB_DRAM,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = 0,
+		.class_mask = 0,
+		.driver_data = F11_CPUS
+	},
+	{0, }
+};
+MODULE_DEVICE_TABLE(pci, amd64_pci_table);
+
+/*
+ * The 'pci_driver' structure to define the name, probe and removal
+ * functions
+ */
+static struct pci_driver amd64_pci_driver = {
+	.name = EDAC_MOD_STR,
+	.probe = amd64_init_one_instance,
+	.remove = __devexit_p(amd64_remove_one_instance),
+	.id_table = amd64_pci_table,
+};
+
+
+/*
+ * amd64_setup_pci_device
+ *
+ *	setup the PCI Device Driver for monitoring PCI errors
+ */
+static void amd64_setup_pci_device(void)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+
+	if (!amd64_ctl_pci) {
+
+		mci = mci_lookup[0];
+		if (mci) {
+			debugf1("%s(): Registering ONE PCI control\n",
+				__func__);
+
+			pvt = mci->pvt_info;
+			amd64_ctl_pci = edac_pci_create_generic_ctl(
+						&pvt->dram_f2_ctl->dev,
+						EDAC_MOD_STR);
+			if (!amd64_ctl_pci) {
+				printk(KERN_WARNING
+					"%s(): Unable to create PCI control\n",
+					__func__);
+				printk(KERN_WARNING
+					"%s(): PCI error report via EDAC "
+					"not setup\n",
+					__func__);
+			}
+		} else {
+			debugf1("%s(): ONE PCI control already registered\n",
+				__func__);
+		}
+	}
+}
+
+static int __init amd64_edac_init(void)
+{
+	int err;
+	int node;
+
+	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
+
+	opstate_init();
+
+	debugf0("%s() ******************  ENTRY  **********************\n",
+		__func__);
+
+	/* Attempt to register drivers for instances
+	 * DUE to the failure of some 'cores' to access Extended Config Space
+	 * prior to all memory controllers having their ECS register enabled,
+	 * the initialization has been created into 2 stages. Here we
+	 * call for the 1st stage. After all have been enabled, then we
+	 * do the 2nd stage to finishup setup.
+	 */
+	err = pci_register_driver(&amd64_pci_driver);
+
+	/* At this point, the array 'pvt_lookup[]' contains pointers to
+	 * allocated struct amd64_pvt control structures. These will be used
+	 * in the 2nd stage init function to finish initialization of
+	 * the MC instances.
+	 */
+
+	/* if no error occurred on first pass init, then do 2nd pass init */
+	if (!err) {
+		for_each_online_node(node) {
+			if (!pvt_lookup[node])
+				continue;
+
+			/* If any failure then need to clean up */
+			err = amd64_init_2nd_stage(pvt_lookup[node]);
+			if (err) {
+				debugf0("%s() 'finish_setup' stage failed\n",
+					__func__);
+
+				/* undo prior instances' registrations
+				 * and leave as failed
+				 */
+				pci_unregister_driver(&amd64_pci_driver);
+				goto error_exit;
+			}
+		}
+		amd64_setup_pci_device();
+	}
+
+error_exit:
+	return err;
+}
+
+static void __exit amd64_edac_exit(void)
+{
+	if (amd64_ctl_pci)
+		edac_pci_release_generic_ctl(amd64_ctl_pci);
+
+	pci_unregister_driver(&amd64_pci_driver);
+}
+
+module_init(amd64_edac_init);
+module_exit(amd64_edac_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("SoftwareBitMaker: Doug Thompson, "
+		"Dave Peterson, Thayne Harbaugh");
+MODULE_DESCRIPTION("MC support for AMD64 memory controllers - "
+		EDAC_AMD64_VERSION);
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
-- 
1.6.2.4


