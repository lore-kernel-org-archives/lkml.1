Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbZEOM2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbZEOM2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762669AbZEOMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:23:14 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:42478 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbZEOMXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:23:06 -0400
X-BigFish: VPS4(zz30e4izz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KJOQE2-01-0CA-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 22/22] amd64_edac: add module registration routines
Date: Fri, 15 May 2009 14:22:33 +0200
Message-ID: <1242390153-24493-23-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:52.0712 (UTC) FILETIME=[DE69DA80:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Also, link into Kbuild by adding Kconfig and Makefile entries.

Borislav:
- Kconfig/Makefile splitting
- use zero-sized arrays for the sysfs attrs if not enabled
- rename sysfs attrs to more conform values
- shorten CONFIG_ names
- make multiple structure members assignment vertically aligned
- fix/cleanup comments
- fix function return value patterns
- fix err labels
- fix a memleak bug caught by Ingo
- remove the NUMA dependency and use num_k8_northbrides for initializing
  a driver instance per NB.
- do not copy the pvt contents into the mci struct in
  amd64_init_2nd_stage() and save it in the mci->pvt_info void ptr
  instead.
- cleanup debug calls
- simplify amd64_setup_pci_device()

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig      |   26 +++
 drivers/edac/Makefile     |    7 +
 drivers/edac/amd64_edac.c |  375 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |   15 ++
 4 files changed, 423 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index e5f5c5a..1c5a325 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -58,6 +58,32 @@ config EDAC_MM_EDAC
 	  occurred so that a particular failing memory module can be
 	  replaced.  If unsure, select 'Y'.
 
+config EDAC_AMD64
+	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
+	depends on EDAC_MM_EDAC && X86 && PCI
+	default m
+	help
+	Support for error detection and correction on the AMD 64
+	Families of Memory Controllers (K8, F10h and F11h)
+
+config EDAC_AMD64_ERROR_INJECTION
+	bool "Sysfs Error Injection facilities"
+	depends on EDAC_AMD64
+	help
+	  Recent Opterons (Family 10h and later) provide for Memory Error
+	  Injection into the ECC detection circuits. The amd64_edac module
+	  allows the operator/user to inject Uncorrectable and Correctable
+	  errors into DRAM.
+
+	  When enabled, in each of the respective memory controller directories
+	  (/sys/devices/system/edac/mc/mcX), there are 3 input files:
+
+	  - inject_section (0..3, 16-byte section of 64-byte cacheline),
+	  - inject_word (0..8, 16-bit word of 16-byte section),
+	  - inject_ecc_vector (hex ecc vector: select bits of inject word)
+
+	  In addition, there are two control files, inject_read and inject_write,
+	  which trigger the DRAM ECC Read and Write respectively.
 
 config EDAC_AMD76X
 	tristate "AMD 76x (760, 762, 768)"
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index a5fdcf0..6f334e6 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -30,6 +30,13 @@ obj-$(CONFIG_EDAC_I3000)		+= i3000_edac.o
 obj-$(CONFIG_EDAC_X38)			+= x38_edac.o
 obj-$(CONFIG_EDAC_I82860)		+= i82860_edac.o
 obj-$(CONFIG_EDAC_R82600)		+= r82600_edac.o
+
+amd64_edac_mod-y :=  amd64_edac_err_types.o amd64_edac.o
+amd64_edac_mod-$(CONFIG_EDAC_DEBUG) += amd64_edac_dbg.o
+amd64_edac_mod-$(CONFIG_EDAC_AMD64_ERROR_INJECTION) += amd64_edac_inj.o
+
+obj-$(CONFIG_EDAC_AMD64)		+= amd64_edac_mod.o
+
 obj-$(CONFIG_EDAC_PASEMI)		+= pasemi_edac.o
 obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6a9d763..46e0a25 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1,4 +1,5 @@
 #include "amd64_edac.h"
+#include <asm/k8.h>
 
 static struct edac_pci_ctl_info *amd64_ctl_pci;
 
@@ -2977,3 +2978,377 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 	return ret;
 }
 
+struct mcidev_sysfs_attribute sysfs_attrs[ARRAY_SIZE(amd64_dbg_attrs) +
+					  ARRAY_SIZE(amd64_inj_attrs) +
+					  1];
+
+struct mcidev_sysfs_attribute terminator = { .attr = { .name = NULL } };
+
+static void amd64_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
+{
+	unsigned int i = 0, j = 0;
+
+	for (; i < ARRAY_SIZE(amd64_dbg_attrs); i++)
+		sysfs_attrs[i] = amd64_dbg_attrs[i];
+
+	for (j = 0; j < ARRAY_SIZE(amd64_inj_attrs); j++, i++)
+		sysfs_attrs[i] = amd64_inj_attrs[j];
+
+	sysfs_attrs[i] = terminator;
+
+	mci->mc_driver_sysfs_attributes = sysfs_attrs;
+}
+
+static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	mci->mtype_cap		= MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
+	mci->edac_ctl_cap	= EDAC_FLAG_NONE;
+	mci->edac_cap		= EDAC_FLAG_NONE;
+
+	if (pvt->nbcap & K8_NBCAP_SECDED)
+		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
+
+	if (pvt->nbcap & K8_NBCAP_CHIPKILL)
+		mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
+
+	mci->edac_cap		= amd64_determine_edac_cap(pvt);
+	mci->mod_name		= EDAC_MOD_STR;
+	mci->mod_ver		= EDAC_AMD64_VERSION;
+	mci->ctl_name		= get_amd_family_name(pvt->mc_type_index);
+	mci->dev_name		= pci_name(pvt->dram_f2_ctl);
+	mci->ctl_page_to_phys	= NULL;
+
+	/* IMPORTANT: Set the polling 'check' function in this module */
+	mci->edac_check		= amd64_check;
+
+	/* memory scrubber interface */
+	mci->set_sdram_scrub_rate = amd64_set_scrub_rate;
+	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
+}
+
+/*
+ * Init stuff for this DRAM Controller device.
+ *
+ * Due to a hardware feature on Fam10h CPUs, the Enable Extended Configuration
+ * Space feature MUST be enabled on ALL Processors prior to actually reading
+ * from the ECS registers. Since the loading of the module can occur on any
+ * 'core', and cores don't 'see' all the other processors ECS data when the
+ * others are NOT enabled. Our solution is to first enable ECS access in this
+ * routine on all processors, gather some data in a amd64_pvt structure and
+ * later come back in a finish-setup function to perform that final
+ * initialization. See also amd64_init_2nd_stage() for that.
+ */
+static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
+				    int mc_type_index)
+{
+	struct amd64_pvt *pvt = NULL;
+	int err = 0, ret;
+
+	ret = -ENOMEM;
+	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
+	if (!pvt)
+		goto err_exit;
+
+	pvt->mc_node_id = get_mc_node_id_from_pdev(dram_f2_ctl);
+
+	pvt->dram_f2_ctl	= dram_f2_ctl;
+	pvt->ext_model		= boot_cpu_data.x86_model >> 4;
+	pvt->mc_type_index	= mc_type_index;
+	pvt->ops		= family_ops(mc_type_index);
+	pvt->old_mcgctl		= 0;
+
+	/*
+	 * We have the dram_f2_ctl device as an argument, now go reserve its
+	 * sibling devices from the PCI system.
+	 */
+	ret = -ENODEV;
+	err = amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
+	if (err)
+		goto err_free;
+
+	ret = -EINVAL;
+	err = amd64_check_ecc_enabled(pvt);
+	if (err)
+		goto err_put;
+
+	/*
+	 * Key operation here: setup of HW prior to performing ops on it. Some
+	 * setup is required to access ECS data. After this is performed, the
+	 * 'teardown' function must be called upon error and normal exit paths.
+	 */
+	if (boot_cpu_data.x86 >= 0x10)
+		amd64_setup(pvt);
+
+	/*
+	 * Save the pointer to the private data for use in 2nd initialization
+	 * stage
+	 */
+	pvt_lookup[pvt->mc_node_id] = pvt;
+
+	return 0;
+
+err_put:
+	amd64_free_mc_sibling_devices(pvt);
+
+err_free:
+	kfree(pvt);
+
+err_exit:
+	return ret;
+}
+
+/*
+ * This is the finishing stage of the init code. Needs to be performed after all
+ * MCs' hardware have been prepped for accessing extended config space.
+ */
+static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
+{
+	int node_id = pvt->mc_node_id;
+	struct mem_ctl_info *mci;
+	int ret, err = 0;
+
+	amd64_read_mc_registers(pvt);
+
+	ret = -ENODEV;
+	if (pvt->ops->probe_valid_hardware) {
+		err = pvt->ops->probe_valid_hardware(pvt);
+		if (err)
+			goto err_exit;
+	}
+
+	/*
+	 * We need to determine how many memory channels there are. Then use
+	 * that information for calculating the size of the dynamic instance
+	 * tables in the 'mci' structure
+	 */
+	pvt->channel_count = pvt->ops->early_channel_count(pvt);
+	if (pvt->channel_count < 0)
+		goto err_exit;
+
+	ret = -ENOMEM;
+	mci = edac_mc_alloc(0, CHIPSELECT_COUNT, pvt->channel_count, node_id);
+	if (!mci)
+		goto err_exit;
+
+	mci->pvt_info = pvt;
+
+	mci->dev = &pvt->dram_f2_ctl->dev;
+	amd64_setup_mci_misc_attributes(mci);
+
+	if (amd64_init_csrows(mci))
+		mci->edac_cap = EDAC_FLAG_NONE;
+
+	amd64_enable_ecc_error_reporting(mci);
+	amd64_set_mc_sysfs_attributes(mci);
+
+	ret = -ENODEV;
+	if (edac_mc_add_mc(mci)) {
+		debugf1("failed edac_mc_add_mc()\n");
+		goto err_add_mc;
+	}
+
+	mci_lookup[node_id] = mci;
+	pvt_lookup[node_id] = NULL;
+	return 0;
+
+err_add_mc:
+	edac_mc_free(mci);
+
+err_exit:
+	debugf0("failure to init 2nd stage: ret=%d\n", ret);
+
+	amd64_restore_ecc_error_reporting(pvt);
+
+	if (boot_cpu_data.x86 > 0xf)
+		amd64_teardown(pvt);
+
+	amd64_free_mc_sibling_devices(pvt);
+
+	kfree(pvt_lookup[pvt->mc_node_id]);
+	pvt_lookup[node_id] = NULL;
+
+	return ret;
+}
+
+
+static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
+				 const struct pci_device_id *mc_type)
+{
+	int ret = 0;
+
+	debugf0("(MC node=%d,mc_type='%s')\n",
+		get_mc_node_id_from_pdev(pdev),
+		get_amd_family_name(mc_type->driver_data));
+
+	ret = pci_enable_device(pdev);
+	if (ret < 0)
+		ret = -EIO;
+	else
+		ret = amd64_probe_one_instance(pdev, mc_type->driver_data);
+
+	if (ret < 0)
+		debugf0("ret=%d\n", ret);
+
+	return ret;
+}
+
+static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+
+	/* Remove from EDAC CORE tracking list */
+	mci = edac_mc_del_mc(&pdev->dev);
+	if (!mci)
+		return;
+
+	pvt = mci->pvt_info;
+
+	amd64_restore_ecc_error_reporting(pvt);
+
+	if (boot_cpu_data.x86 > 0xf)
+		amd64_teardown(pvt);
+
+	amd64_free_mc_sibling_devices(pvt);
+
+	kfree(pvt);
+	mci->pvt_info = NULL;
+
+	mci_lookup[pvt->mc_node_id] = NULL;
+
+	/* Free the EDAC CORE resources */
+	edac_mc_free(mci);
+}
+
+/*
+ * This table is part of the interface for loading drivers for PCI devices. The
+ * PCI core identifies what devices are on a system during boot, and then
+ * inquiry this table to see if this driver is for a given device found.
+ */
+static const struct pci_device_id amd64_pci_table[] __devinitdata = {
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= K8_CPUS
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_10H_NB_DRAM,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= F10_CPUS
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_DEVICE_ID_AMD_11H_NB_DRAM,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= F11_CPUS
+	},
+	{0, }
+};
+MODULE_DEVICE_TABLE(pci, amd64_pci_table);
+
+static struct pci_driver amd64_pci_driver = {
+	.name		= EDAC_MOD_STR,
+	.probe		= amd64_init_one_instance,
+	.remove		= __devexit_p(amd64_remove_one_instance),
+	.id_table	= amd64_pci_table,
+};
+
+static void amd64_setup_pci_device(void)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+
+	if (amd64_ctl_pci)
+		return;
+
+	mci = mci_lookup[0];
+	if (mci) {
+
+		pvt = mci->pvt_info;
+		amd64_ctl_pci =
+			edac_pci_create_generic_ctl(&pvt->dram_f2_ctl->dev,
+						    EDAC_MOD_STR);
+
+		if (!amd64_ctl_pci) {
+			pr_warning("%s(): Unable to create PCI control\n",
+				   __func__);
+
+			pr_warning("%s(): PCI error report via EDAC not set\n",
+				   __func__);
+			}
+	}
+}
+
+static int __init amd64_edac_init(void)
+{
+	int nb, err = -ENODEV;
+
+	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
+
+	opstate_init();
+
+	if (cache_k8_northbridges() < 0)
+		goto err_exit;
+
+	err = pci_register_driver(&amd64_pci_driver);
+
+	/*
+	 * At this point, the array 'pvt_lookup[]' contains pointers to alloc'd
+	 * amd64_pvt structs. These will be used in the 2nd stage init function
+	 * to finish initialization of the MC instances.
+	 */
+	if (err)
+		return err;
+
+	for (nb = 0; nb < num_k8_northbridges; nb++) {
+		if (!pvt_lookup[nb])
+			continue;
+
+		err = amd64_init_2nd_stage(pvt_lookup[nb]);
+		if (err)
+			goto err_exit;
+	}
+
+	amd64_setup_pci_device();
+
+	return 0;
+
+err_exit:
+	debugf0("'finish_setup' stage failed\n");
+	pci_unregister_driver(&amd64_pci_driver);
+
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
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 1a3e62d..0386d1d 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -590,6 +590,21 @@ extern const char *ii_msgs[4];
 extern const char *ext_msgs[32];
 extern const char *htlink_msgs[8];
 
+#ifdef CONFIG_EDAC_DEBUG
+#define NUM_DBG_ATTRS 9
+#else
+#define NUM_DBG_ATTRS 0
+#endif
+
+#ifdef CONFIG_EDAC_AMD64_ERROR_INJECTION
+#define NUM_INJ_ATTRS 5
+#else
+#define NUM_INJ_ATTRS 0
+#endif
+
+extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
+				     amd64_inj_attrs[NUM_INJ_ATTRS];
+
 /*
  * Each of the PCI Device IDs types have their own set of hardware accessor
  * functions and per device encoding/decoding logic.
-- 
1.6.2.4


