Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYI3DWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYI3DWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYI3DTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:62011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYI3DTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="342013746"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:19:52 -0700
Message-ID: <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:52.0996 (UTC) FILETIME=[679E7640:01C922AB]
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
index a076079..57c6d2f 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -366,6 +366,9 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	return 0;
 }
 
+static DEFINE_MUTEX(nvm_mutex);
+static pid_t nvm_owner = -1;
+
 /**
  *  e1000_acquire_swflag_ich8lan - Acquire software control flag
  *  @hw: pointer to the HW structure
@@ -379,6 +382,15 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
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
@@ -393,6 +405,8 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 
 	if (!timeout) {
 		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
+		nvm_owner = -1;
+		mutex_unlock(&nvm_mutex);
 		return -E1000_ERR_CONFIG;
 	}
 
@@ -414,6 +428,9 @@ static void e1000_release_swflag_ich8lan(struct e1000_hw *hw)
 	extcnf_ctrl = er32(EXTCNF_CTRL);
 	extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
 	ew32(EXTCNF_CTRL, extcnf_ctrl);
+
+	nvm_owner = -1;
+	mutex_unlock(&nvm_mutex);
 }
 
 /**

