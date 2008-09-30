Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYI3DXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYI3DXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYI3DUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:20:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:28027 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYI3DUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="385866641"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent malicious
	write/erase
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:20:13 -0700
Message-ID: <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:20:13.0512 (UTC) FILETIME=[73D8F480:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Set the hardware to ignore all write/erase cycles to the GbE region in
the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
parameter (enabled by default) though that is not recommended.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/e1000.h   |    2 ++
 drivers/net/e1000e/ethtool.c |    3 +++
 drivers/net/e1000e/ich8lan.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/e1000e/netdev.c  |    8 +++++--
 drivers/net/e1000e/param.c   |   30 +++++++++++++++++++++++++++
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index 2a3a311..6b0eb73 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -307,6 +307,7 @@ struct e1000_info {
 #define FLAG_HAS_CTRLEXT_ON_LOAD          (1 << 5)
 #define FLAG_HAS_SWSM_ON_LOAD             (1 << 6)
 #define FLAG_HAS_JUMBO_FRAMES             (1 << 7)
+#define FLAG_READ_ONLY_NVM                (1 << 8)
 #define FLAG_IS_ICH                       (1 << 9)
 #define FLAG_HAS_SMART_POWER_DOWN         (1 << 11)
 #define FLAG_IS_QUAD_PORT_A               (1 << 12)
@@ -387,6 +388,7 @@ extern bool e1000e_enable_mng_pass_thru(struct e1000_hw *hw);
 extern bool e1000e_get_laa_state_82571(struct e1000_hw *hw);
 extern void e1000e_set_laa_state_82571(struct e1000_hw *hw, bool state);
 
+extern void e1000e_write_protect_nvm_ich8lan(struct e1000_hw *hw, bool enable);
 extern void e1000e_set_kmrn_lock_loss_workaround_ich8lan(struct e1000_hw *hw,
 						 bool state);
 extern void e1000e_igp3_phy_powerdown_workaround_ich8lan(struct e1000_hw *hw);
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index f3b49f6..33a3ff1 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -533,6 +533,9 @@ static int e1000_set_eeprom(struct net_device *netdev,
 	if (eeprom->magic != (adapter->pdev->vendor | (adapter->pdev->device << 16)))
 		return -EFAULT;
 
+	if (adapter->flags & FLAG_READ_ONLY_NVM)
+		return -EINVAL;
+
 	max_len = hw->nvm.word_size * 2;
 
 	first_word = eeprom->offset >> 1;
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 2b1aa2a..5e3dac9 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -58,6 +58,7 @@
 #define ICH_FLASH_HSFCTL		0x0006
 #define ICH_FLASH_FADDR			0x0008
 #define ICH_FLASH_FDATA0		0x0010
+#define ICH_FLASH_PR0			0x0074
 
 #define ICH_FLASH_READ_COMMAND_TIMEOUT	500
 #define ICH_FLASH_WRITE_COMMAND_TIMEOUT	500
@@ -150,6 +151,19 @@ union ich8_hws_flash_regacc {
 	u16 regval;
 };
 
+/* ICH Flash Protected Region */
+union ich8_flash_protected_range {
+	struct ich8_pr {
+		u32 base:13;     /* 0:12 Protected Range Base */
+		u32 reserved1:2; /* 13:14 Reserved */
+		u32 rpe:1;       /* 15 Read Protection Enable */
+		u32 limit:13;    /* 16:28 Protected Range Limit */
+		u32 reserved2:2; /* 29:30 Reserved */
+		u32 wpe:1;       /* 31 Write Protection Enable */
+	} range;
+	u32 regval;
+};
+
 static s32 e1000_setup_link_ich8lan(struct e1000_hw *hw);
 static void e1000_clear_hw_cntrs_ich8lan(struct e1000_hw *hw);
 static void e1000_initialize_hw_bits_ich8lan(struct e1000_hw *hw);
@@ -1317,6 +1331,7 @@ static s32 e1000_update_nvm_checksum_ich8lan(struct e1000_hw *hw)
 	 * programming failed.
 	 */
 	if (ret_val) {
+		/* Possibly read-only, see e1000e_write_protect_nvm_ich8lan() */
 		hw_dbg(hw, "Flash commit failed.\n");
 		e1000_release_swflag_ich8lan(hw);
 		return ret_val;
@@ -1407,6 +1422,37 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 }
 
 /**
+ *  e1000e_write_protect_nvm_ich8lan - Make the NVM read-only
+ *  @hw: pointer to the HW structure
+ *  @enable: pointer to the HW structure
+ *  @enable: TRUE to enable write protection, FALSE to disable write protection
+ *
+ *  To prevent malicious write/erase of the NVM, set it to be read-only
+ *  so that the hardware ignores all write/erase cycles of the NVM via
+ *  the flash control registers.  The shadow-ram copy of the NVM will
+ *  still be updated, however any updates to this copy will not stick
+ *  across driver reloads.
+ **/
+void e1000e_write_protect_nvm_ich8lan(struct e1000_hw *hw, bool enable)
+{
+	union ich8_flash_protected_range pr0;
+	u32 gfpreg;
+
+	if (hw->nvm.ops.acquire_nvm(hw))
+		return;
+
+	gfpreg = er32flash(ICH_FLASH_GFPREG);
+
+	pr0.regval = er32flash(ICH_FLASH_PR0);
+	pr0.range.base = gfpreg & FLASH_GFPREG_BASE_MASK;
+	pr0.range.limit = ((gfpreg >> 16) & FLASH_GFPREG_BASE_MASK);
+	pr0.range.wpe = enable;
+	ew32flash(ICH_FLASH_PR0, pr0.regval);
+
+	hw->nvm.ops.release_nvm(hw);
+}
+
+/**
  *  e1000_write_flash_data_ich8lan - Writes bytes to the NVM
  *  @hw: pointer to the HW structure
  *  @offset: The offset (in bytes) of the byte/word to read.
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index f04de5a..2626c42 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4508,6 +4508,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	adapter->bd_number = cards_found++;
 
+	e1000e_check_options(adapter);
+
 	/* setup adapter struct */
 	err = e1000_sw_init(adapter);
 	if (err)
@@ -4523,6 +4525,10 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_hw_init;
 
+	if (adapter->flags & FLAG_IS_ICH)
+		e1000e_write_protect_nvm_ich8lan(&adapter->hw,
+		                       !!(adapter->flags & FLAG_READ_ONLY_NVM));
+
 	hw->mac.ops.get_bus_info(&adapter->hw);
 
 	adapter->hw.phy.autoneg_wait_to_complete = 0;
@@ -4629,8 +4635,6 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
 	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 
-	e1000e_check_options(adapter);
-
 	/* Initialize link parameters. User can change them with ethtool */
 	adapter->hw.mac.autoneg = 1;
 	adapter->fc_autoneg = 1;
diff --git a/drivers/net/e1000e/param.c b/drivers/net/e1000e/param.c
index ed912e0..d91dbf7 100644
--- a/drivers/net/e1000e/param.c
+++ b/drivers/net/e1000e/param.c
@@ -133,6 +133,15 @@ E1000_PARAM(SmartPowerDownEnable, "Enable PHY smart power down");
  */
 E1000_PARAM(KumeranLockLoss, "Enable Kumeran lock loss workaround");
 
+/*
+ * Write Protect NVM
+ *
+ * Valid Range: 0, 1
+ *
+ * Default Value: 1 (enabled)
+ */
+E1000_PARAM(WriteProtectNVM, "Write-protect NVM [WARNING: disabling this can lead to corrupted NVM]");
+
 struct e1000_option {
 	enum { enable_option, range_option, list_option } type;
 	const char *name;
@@ -388,4 +397,25 @@ void __devinit e1000e_check_options(struct e1000_adapter *adapter)
 								       opt.def);
 		}
 	}
+	{ /* Write-protect NVM */
+		const struct e1000_option opt = {
+			.type = enable_option,
+			.name = "Write-protect NVM",
+			.err  = "defaulting to Enabled",
+			.def  = OPTION_ENABLED
+		};
+
+		if (adapter->flags & FLAG_IS_ICH) {
+			if (num_WriteProtectNVM > bd) {
+				unsigned int write_protect_nvm = WriteProtectNVM[bd];
+				e1000_validate_option(&write_protect_nvm, &opt,
+						      adapter);
+				if (write_protect_nvm)
+					adapter->flags |= FLAG_READ_ONLY_NVM;
+			} else {
+				if (opt.def)
+					adapter->flags |= FLAG_READ_ONLY_NVM;
+			}
+		}
+	}
 }

