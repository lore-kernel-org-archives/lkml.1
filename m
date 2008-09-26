Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYIZCMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYIZCMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYIZCLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:11:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:20386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbYIZCLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="340664111"
Date: Thu, 25 Sep 2008 19:11:40 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251911140.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e: debug contention on NVM SWFLAG

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
index f1a6e55..2b1aa2a 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -382,6 +382,9 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	return 0;
 }
 
+static DEFINE_MUTEX(nvm_mutex);
+static pid_t nvm_owner = -1;
+
 /**
  *  e1000_acquire_swflag_ich8lan - Acquire software control flag
  *  @hw: pointer to the HW structure
@@ -395,6 +398,15 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
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
@@ -409,6 +421,8 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 
 	if (!timeout) {
 		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
+		nvm_owner = -1;
+		mutex_unlock(&nvm_mutex);
 		return -E1000_ERR_CONFIG;
 	}
 
@@ -430,6 +444,9 @@ static void e1000_release_swflag_ich8lan(struct e1000_hw *hw)
 	extcnf_ctrl = er32(EXTCNF_CTRL);
 	extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
 	ew32(EXTCNF_CTRL, extcnf_ctrl);
+
+	nvm_owner = -1;
+	mutex_unlock(&nvm_mutex);
 }
 
 /**
