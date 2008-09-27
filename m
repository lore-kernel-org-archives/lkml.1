Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYI0Ek4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYI0Ek4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYI0Eks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:40:48 -0400
Received: from mail.tpi.com ([198.107.51.143]:1458 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYI0Ekr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:40:47 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2008 00:40:46 EDT
Message-ID: <48DDB48C.9000305@canonical.com>
Date: Fri, 26 Sep 2008 22:20:28 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <48DCCC5F.8040609@linux.intel.com> <200809261052.38966.jbarnes@virtuousgeek.org> <200809261123.52198.jbarnes@virtuousgeek.org> <48DD2F98.8070509@tpi.com> <Pine.WNT.4.63.0809261316310.4052@jbrandeb-desk.amr.corp.intel.com>
In-Reply-To: <Pine.WNT.4.63.0809261316310.4052@jbrandeb-desk.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------030004090004060603020604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030004090004060603020604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Brandeburg, Jesse wrote:
> On Fri, 26 Sep 2008, Tim Gardner wrote:
>>> Ok here's an updated one.  Jesse (Br) can you add it to your list?  If the X 
>>> driver really is mapping too much this should catch it, as long as it goes 
>>> through sysfs.
> 
> I have, am testing with it now.
> 
>> I've been experimenting with unmapping flash space until its actually
>> needed, e.g., in the functions that use the E1000_READ_FLASH and
>> E1000_WRITE_FLASH macros. Along the way I looked at how flash write
> 
> That sounds like a good patch set.  I had thought of trying that but 
> hadn't gotten to it yet, so if you have something to look at in diff 
> format just post it and we'll take a look.
> 
>> cycles are initiated because I was having a hard time believing that
>> having flash space mapped was part of the root cause. However, it looks
>> like its pretty simple to initiate a write or erase cycle. All of the
>> required action bits in ICH_FLASH_HSFSTS and ICH_FLASH_HSFCTL must be 1,
>> and these 2 register are in the correct order if X was writing 0xff in
>> ascending order.
> 
> Seems simple but when I tried it for a couple of hours yesterday I 
> couldn't get anything to happen to my flash.  This included putting 
> ew16flash writes in the e1000e driver, and writing those magic bits.

Jesse,

Here is a patch against 2.6.27-rc7 that maps flash space on demand.
I've only compile tested it, but a similar patch that applies against
the Ubuntu Intrepid tree is at

https://lists.ubuntu.com/archives/kernel-team/2008-September/003193.html

Note that this 2nd, actually tested patch is against the e1000e
driver v0.4.7.1 that originated from sourceforge.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------030004090004060603020604
Content-Type: text/x-diff;
 name="0001-e1000e-ioremap-NV-RAM-as-needed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-e1000e-ioremap-NV-RAM-as-needed.patch"

>From 98a10d340fd029c4c910cf18845e116b53df3ab4 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 26 Sep 2008 22:02:17 -0600
Subject: [PATCH] e1000e: ioremap NV RAM as needed.

Instead of leaving flash mapped for the life of the driver, map it on
demand when accessed from the ethtool interfaces. This ought to prevent random
writes to flash registers accidentally starting an erase or write cycle.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/e1000e/hw.h      |    4 ++
 drivers/net/e1000e/ich8lan.c |  114 +++++++++++++++++++++++++++++++++++++----
 drivers/net/e1000e/netdev.c  |    5 ++
 3 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index 74f263a..355fe45 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -864,6 +864,10 @@ struct e1000_hw {
 	u8 __iomem *hw_addr;
 	u8 __iomem *flash_address;
 
+	/* Protect access to NV RAM mapping */
+	spinlock_t flash_address_map_lock;
+	u32 flash_address_map_cnt;
+
 	struct e1000_mac_info  mac;
 	struct e1000_fc_info   fc;
 	struct e1000_phy_info  phy;
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 9e38452..8275b33 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -189,6 +189,54 @@ static inline void __ew32flash(struct e1000_hw *hw, unsigned long reg, u32 val)
 #define ew16flash(reg,val)	__ew16flash(hw, (reg), (val))
 #define ew32flash(reg,val)	__ew32flash(hw, (reg), (val))
 
+/*
+ * NV RAM mapping can get nested, so keep track of the mapping depth.
+ */
+static int e1000e_map_nvram(struct e1000_hw *hw)
+{
+	int ret_val = 0;
+	struct e1000_adapter *adapter = hw->adapter;
+
+	spin_lock(&hw->flash_address_map_lock);
+
+	hw->flash_address_map_cnt++;
+
+	if (hw->flash_address_map_cnt==1) {
+		BUG_ON(adapter->hw.flash_address);
+		WARN_ON(irqs_disabled());
+		adapter->hw.flash_address = ioremap(pci_resource_start(adapter->pdev, 1),
+							pci_resource_len(adapter->pdev, 1));
+		if (!adapter->hw.flash_address) {
+			hw->flash_address_map_cnt--;
+			ret_val = -E1000_ERR_NVM;
+		}
+	}
+
+	spin_unlock(&hw->flash_address_map_lock);
+
+	return ret_val;
+}
+
+static void e1000e_unmap_nvram(struct e1000_hw *hw)
+{
+	struct e1000_adapter *adapter = hw->adapter;
+
+	spin_lock(&hw->flash_address_map_lock);
+
+	BUG_ON(!hw->flash_address_map_cnt);
+
+	hw->flash_address_map_cnt--;
+
+	if (hw->flash_address_map_cnt==0) {
+		BUG_ON(!adapter->hw.flash_address);
+		WARN_ON(irqs_disabled());
+		iounmap(adapter->hw.flash_address);
+		adapter->hw.flash_address = NULL;
+	}
+
+	spin_unlock(&hw->flash_address_map_lock);
+}
+
 /**
  *  e1000_init_phy_params_ich8lan - Initialize PHY function pointers
  *  @hw: pointer to the HW structure
@@ -268,10 +316,11 @@ static s32 e1000_init_nvm_params_ich8lan(struct e1000_hw *hw)
 	u32 sector_base_addr;
 	u32 sector_end_addr;
 	u16 i;
+	int ret_val;
 
 	/* Can't read flash registers if the register set isn't mapped. */
-	if (!hw->flash_address) {
-		hw_dbg(hw, "ERROR: Flash registers not mapped\n");
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
 		return -E1000_ERR_CONFIG;
 	}
 
@@ -308,6 +357,7 @@ static s32 e1000_init_nvm_params_ich8lan(struct e1000_hw *hw)
 		dev_spec->shadow_ram[i].value    = 0xFFFF;
 	}
 
+	e1000e_unmap_nvram(hw);
 	return 0;
 }
 
@@ -962,13 +1012,19 @@ static s32 e1000_flash_cycle_init_ich8lan(struct e1000_hw *hw)
 	s32 ret_val = -E1000_ERR_NVM;
 	s32 i = 0;
 
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
+		return ret_val;
+	}
+
 	hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
 
 	/* Check if the flash descriptor is valid */
 	if (hsfsts.hsf_status.fldesvalid == 0) {
 		hw_dbg(hw, "Flash descriptor invalid.  "
 			 "SW Sequencing must be used.");
-		return -E1000_ERR_NVM;
+		ret_val = -E1000_ERR_NVM;
+		goto out;
 	}
 
 	/* Clear FCERR and DAEL in hw status by writing 1 */
@@ -1020,6 +1076,8 @@ static s32 e1000_flash_cycle_init_ich8lan(struct e1000_hw *hw)
 		}
 	}
 
+out:
+	e1000e_unmap_nvram(hw);
 	return ret_val;
 }
 
@@ -1034,9 +1092,16 @@ static s32 e1000_flash_cycle_ich8lan(struct e1000_hw *hw, u32 timeout)
 {
 	union ich8_hws_flash_ctrl hsflctl;
 	union ich8_hws_flash_status hsfsts;
-	s32 ret_val = -E1000_ERR_NVM;
+	s32 ret_val;
 	u32 i = 0;
 
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
+		return ret_val;
+	}
+
+	ret_val = -E1000_ERR_NVM;
+
 	/* Start a cycle by writing 1 in Flash Cycle Go in Hw Flash Control */
 	hsflctl.regval = er16flash(ICH_FLASH_HSFCTL);
 	hsflctl.hsf_ctrl.flcgo = 1;
@@ -1051,8 +1116,9 @@ static s32 e1000_flash_cycle_ich8lan(struct e1000_hw *hw, u32 timeout)
 	} while (i++ < timeout);
 
 	if (hsfsts.hsf_status.flcdone == 1 && hsfsts.hsf_status.flcerr == 0)
-		return 0;
+		ret_val = 0;
 
+	e1000e_unmap_nvram(hw);
 	return ret_val;
 }
 
@@ -1093,8 +1159,15 @@ static s32 e1000_read_flash_data_ich8lan(struct e1000_hw *hw, u32 offset,
 	s32 ret_val = -E1000_ERR_NVM;
 	u8 count = 0;
 
-	if (size < 1  || size > 2 || offset > ICH_FLASH_LINEAR_ADDR_MASK)
-		return -E1000_ERR_NVM;
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
+		return ret_val;
+	}
+
+	if (size < 1  || size > 2 || offset > ICH_FLASH_LINEAR_ADDR_MASK) {
+		ret_val = -E1000_ERR_NVM;
+		goto out;
+	}
 
 	flash_linear_addr = (ICH_FLASH_LINEAR_ADDR_MASK & offset) +
 			    hw->nvm.flash_base_addr;
@@ -1150,6 +1223,8 @@ static s32 e1000_read_flash_data_ich8lan(struct e1000_hw *hw, u32 offset,
 		}
 	} while (count++ < ICH_FLASH_CYCLE_REPEAT_COUNT);
 
+out:
+	e1000e_unmap_nvram(hw);
 	return ret_val;
 }
 
@@ -1396,6 +1471,11 @@ static s32 e1000_write_flash_data_ich8lan(struct e1000_hw *hw, u32 offset,
 	    offset > ICH_FLASH_LINEAR_ADDR_MASK)
 		return -E1000_ERR_NVM;
 
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
+		return ret_val;
+	}
+
 	flash_linear_addr = (ICH_FLASH_LINEAR_ADDR_MASK & offset) +
 			    hw->nvm.flash_base_addr;
 
@@ -1447,6 +1527,7 @@ static s32 e1000_write_flash_data_ich8lan(struct e1000_hw *hw, u32 offset,
 		}
 	} while (count++ < ICH_FLASH_CYCLE_REPEAT_COUNT);
 
+	e1000e_unmap_nvram(hw);
 	return ret_val;
 }
 
@@ -1520,6 +1601,11 @@ static s32 e1000_erase_flash_bank_ich8lan(struct e1000_hw *hw, u32 bank)
 	s32 sector_size;
 	s32 j;
 
+	ret_val = e1000e_map_nvram(hw);
+	if (ret_val) {
+		return ret_val;
+	}
+
 	hsfsts.regval = er16flash(ICH_FLASH_HSFSTS);
 
 	/*
@@ -1550,7 +1636,8 @@ static s32 e1000_erase_flash_bank_ich8lan(struct e1000_hw *hw, u32 bank)
 			sector_size = ICH_FLASH_SEG_SIZE_8K;
 			iteration = flash_bank_size / ICH_FLASH_SEG_SIZE_8K;
 		} else {
-			return -E1000_ERR_NVM;
+			ret_val = -E1000_ERR_NVM;
+			goto out;
 		}
 		break;
 	case 3:
@@ -1558,7 +1645,8 @@ static s32 e1000_erase_flash_bank_ich8lan(struct e1000_hw *hw, u32 bank)
 		iteration = flash_bank_size / ICH_FLASH_SEG_SIZE_64K;
 		break;
 	default:
-		return -E1000_ERR_NVM;
+		ret_val = -E1000_ERR_NVM;
+		goto out;
 	}
 
 	/* Start with the base address, then add the sector offset. */
@@ -1570,7 +1658,7 @@ static s32 e1000_erase_flash_bank_ich8lan(struct e1000_hw *hw, u32 bank)
 			/* Steps */
 			ret_val = e1000_flash_cycle_init_ich8lan(hw);
 			if (ret_val)
-				return ret_val;
+				goto out;
 
 			/*
 			 * Write a value 11 (block Erase) in Flash
@@ -1603,11 +1691,13 @@ static s32 e1000_erase_flash_bank_ich8lan(struct e1000_hw *hw, u32 bank)
 				/* repeat for some time before giving up */
 				continue;
 			else if (hsfsts.hsf_status.flcdone == 0)
-				return ret_val;
+				goto out;
 		} while (++count < ICH_FLASH_CYCLE_REPEAT_COUNT);
 	}
 
-	return 0;
+out:
+	e1000e_unmap_nvram(hw);
+	return ret_val;
 }
 
 /**
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index d266510..e5fe247 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4439,6 +4439,11 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		adapter->hw.flash_address = ioremap(flash_start, flash_len);
 		if (!adapter->hw.flash_address)
 			goto err_flashmap;
+
+		/* Now that we're sure NV RAM is mappable, unmap it until needed. */
+		iounmap(adapter->hw.flash_address);
+		adapter->hw.flash_address = NULL;
+		spin_lock_init(&adapter->hw.flash_address_map_lock);
 	}
 
 	/* construct the net_device struct */
-- 
1.5.4.3


--------------030004090004060603020604--
