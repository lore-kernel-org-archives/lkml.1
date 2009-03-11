Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZCKCLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZCKCLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZCKCKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:10:41 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:51233
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbZCKCKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:10:24 -0400
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next PATCH 2/2] igb: add PF to pool if adding a VLVF register
	value and the VFTA bit is
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, kvm@vger.kernel.org, yu.zhao@intel.com,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 10 Mar 2009 19:09:56 -0700
Message-ID: <20090311020956.23138.22191.stgit@lost.foo-projects.org>
In-Reply-To: <20090311020928.23138.20790.stgit@lost.foo-projects.org>
References: <20090311020928.23138.20790.stgit@lost.foo-projects.org>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

already set.

This patch addresses the unlikely situation that the PF adds a vlan
entry when the vlvf is full, and a vf later adds the vlan to the vlvf.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/e1000_mac.c |   21 ++++++++++++++-------
 drivers/net/igb/e1000_mac.h |    2 +-
 drivers/net/igb/igb_main.c  |    9 +++++++--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/igb/e1000_mac.c b/drivers/net/igb/e1000_mac.c
index 2804db0..f11592f 100644
--- a/drivers/net/igb/e1000_mac.c
+++ b/drivers/net/igb/e1000_mac.c
@@ -126,19 +126,26 @@ void igb_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
  *  Sets or clears a bit in the VLAN filter table array based on VLAN id
  *  and if we are adding or removing the filter
  **/
-void igb_vfta_set(struct e1000_hw *hw, u32 vid, bool add)
+s32 igb_vfta_set(struct e1000_hw *hw, u32 vid, bool add)
 {
 	u32 index = (vid >> E1000_VFTA_ENTRY_SHIFT) & E1000_VFTA_ENTRY_MASK;
 	u32 mask = 1 < (vid & E1000_VFTA_ENTRY_BIT_SHIFT_MASK);
-	u32 vfta;
+	u32 vfta = array_rd32(E1000_VFTA, index);
+	s32 ret_val = 0;
 
-	vfta = array_rd32(E1000_VFTA, index);
-	if (add)
-		vfta |= mask;
-	else
-		vfta &= ~mask;
+	/* bit was set/cleared before we started */
+	if ((!!(vfta & mask)) == add) {
+		ret_val = -E1000_ERR_CONFIG;
+	} else {
+		if (add)
+			vfta |= mask;
+		else
+			vfta &= ~mask;
+	}
 
 	igb_write_vfta(hw, index, vfta);
+
+	return ret_val;
 }
 
 /**
diff --git a/drivers/net/igb/e1000_mac.h b/drivers/net/igb/e1000_mac.h
index eccc353..a34de52 100644
--- a/drivers/net/igb/e1000_mac.h
+++ b/drivers/net/igb/e1000_mac.h
@@ -58,7 +58,7 @@ s32  igb_write_8bit_ctrl_reg(struct e1000_hw *hw, u32 reg,
 
 void igb_clear_hw_cntrs_base(struct e1000_hw *hw);
 void igb_clear_vfta(struct e1000_hw *hw);
-void igb_vfta_set(struct e1000_hw *hw, u32 vid, bool add);
+s32  igb_vfta_set(struct e1000_hw *hw, u32 vid, bool add);
 void igb_config_collision_dist(struct e1000_hw *hw);
 void igb_mta_set(struct e1000_hw *hw, u32 hash_value);
 void igb_put_hw_semaphore(struct e1000_hw *hw);
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 78558f8..579435d 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3894,10 +3894,15 @@ static s32 igb_vlvf_set(struct igb_adapter *adapter, u32 vid, bool add, u32 vf)
 
 			/* if !enabled we need to set this up in vfta */
 			if (!(reg & E1000_VLVF_VLANID_ENABLE)) {
-				/* add VID to filter table */
-				igb_vfta_set(hw, vid, true);
+				/* add VID to filter table, if bit already set
+				 * PF must have added it outside of table */
+				if (igb_vfta_set(hw, vid, true))
+					reg |= 1 << (E1000_VLVF_POOLSEL_SHIFT +
+						adapter->vfs_allocated_count);
 				reg |= E1000_VLVF_VLANID_ENABLE;
 			}
+			reg &= ~E1000_VLVF_VLANID_MASK;
+			reg |= vid;
 
 			wr32(E1000_VLVF(i), reg);
 			return 0;

