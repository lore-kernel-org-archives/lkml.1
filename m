Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYJBXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYJBXey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbYJBXdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:33:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:57967 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbYJBXdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="386973955"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 2.6.27-rc8 5/6] e1000e: debug contention on NVM SWFLAG
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
       arjan@linux.intel.com, airlied@gmail.com, davem@davemloft.net,
       jeff@garzik.org, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Thu, 02 Oct 2008 16:33:40 -0700
Message-ID: <20081002233340.12556.33137.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
References: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 23:33:40.0436 (UTC) FILETIME=[4CFB6940:01C924E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This patch adds a mutex to the e1000e driver that would help
catch any collisions of two e1000e threads accessing hardware
at the same time.

description and patch updated by Jesse

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/ich8lan.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index f4b6744..0b6095b 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -380,6 +380,9 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	return 0;
 }
 
+static DEFINE_MUTEX(nvm_mutex);
+static pid_t nvm_owner = -1;
+
 /**
  *  e1000_acquire_swflag_ich8lan - Acquire software control flag
  *  @hw: pointer to the HW structure
@@ -393,6 +396,15 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 	u32 extcnf_ctrl;
 	u32 timeout = PHY_CFG_TIMEOUT;
 
+	WARN_ON(preempt_count());
+
+	if (!mutex_trylock(&nvm_mutex)) {
+		WARN(1, KERN_ERR "e1000e mutex contention. Owned by pid %d\n",
+		     nvm_owner);
+		mutex_lock(&nvm_mutex);
+	}
+	nvm_owner = current->pid;
+
 	while (timeout) {
 		extcnf_ctrl = er32(EXTCNF_CTRL);
 		extcnf_ctrl |= E1000_EXTCNF_CTRL_SWFLAG;
@@ -407,6 +419,8 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 
 	if (!timeout) {
 		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
+		nvm_owner = -1;
+		mutex_unlock(&nvm_mutex);
 		return -E1000_ERR_CONFIG;
 	}
 
@@ -428,6 +442,9 @@ static void e1000_release_swflag_ich8lan(struct e1000_hw *hw)
 	extcnf_ctrl = er32(EXTCNF_CTRL);
 	extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
 	ew32(EXTCNF_CTRL, extcnf_ctrl);
+
+	nvm_owner = -1;
+	mutex_unlock(&nvm_mutex);
 }
 
 /**

