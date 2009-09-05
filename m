Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbZIEA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbZIEA34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934710AbZIEA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:29:51 -0400
Received: from kroah.org ([198.145.64.141]:42197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621AbZIEAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.788421893@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stanislaw Gruszka <sgruszka@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 35/71] iwl3945: fix rfkill switch
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=iwl3945-fix-rfkill-switch.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>

(Not needed upstream, due to the major rewrite in 2.6.31)

Due to rfkill and iwlwifi mishmash of SW / HW killswitch representation,
we have race conditions which make unable turn wifi radio on, after enable
and disable again killswitch. I can observe this problem on my laptop
with iwl3945 device.

In rfkill core HW switch and SW switch are separate 'states'. Device can
be only in one of 3 states: RFKILL_STATE_SOFT_BLOCKED, RFKILL_STATE_UNBLOCKED,
RFKILL_STATE_HARD_BLOCKED. Whereas in iwlwifi driver we have separate bits
STATUS_RF_KILL_HW and STATUS_RF_KILL_SW for HW and SW switches - radio can be
turned on, only if both bits are cleared.

In this particular race conditions, radio can not be turned on if in driver
STATUS_RF_KILL_SW bit is set, and rfkill core is in state
RFKILL_STATE_HARD_BLOCKED, because rfkill core is unable to call
rfkill->toggle_radio(). This situation can be entered in case:

- killswitch is turned on
- rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
  also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
- iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
  force rfkill to move to RFKILL_STATE_HARD_BLOCKED
- killsiwtch is turend off
- driver clear STATUS_RF_KILL_HW
- rfkill core is unable to clear STATUS_RF_KILL_SW in driver

Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
cause move to the same situation.

In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
This is a quite small fix for 2.6.30.x in iwlwifi driver. We are changing
internal rfkill state to always have below relations true:

STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_HARD_BLOCKED
STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_UNBLOCKED

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: John W. Linville <linville@tuxdriver.com>


---
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -53,22 +53,31 @@ static int iwl_rfkill_soft_rf_kill(void 
 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
 		if (iwl_is_rfkill_hw(priv)) {
+			/* pass error to rfkill core, make it state HARD
+			 * BLOCKED (rfkill->mutex taken) and disable
+			 * software kill switch */
 			err = -EBUSY;
-			goto out_unlock;
+			priv->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
 		}
 		iwl_radio_kill_sw_enable_radio(priv);
 		break;
 	case RFKILL_STATE_SOFT_BLOCKED:
 		iwl_radio_kill_sw_disable_radio(priv);
+		/* rfkill->mutex is taken */
+		if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
+			/* force rfkill core state to be SOFT BLOCKED,
+			 * otherwise core will be unable to disable software
+			 * kill switch */
+			priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
+		}
 		break;
 	default:
 		IWL_WARN(priv, "we received unexpected RFKILL state %d\n",
 			state);
 		break;
 	}
-out_unlock:
-	mutex_unlock(&priv->mutex);
 
+	mutex_unlock(&priv->mutex);
 	return err;
 }
 
@@ -132,14 +141,11 @@ void iwl_rfkill_set_hw_state(struct iwl_
 	if (!priv->rfkill)
 		return;
 
-	if (iwl_is_rfkill_hw(priv)) {
+	if (iwl_is_rfkill_sw(priv))
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
+	else if (iwl_is_rfkill_hw(priv))
 		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
-		return;
-	}
-
-	if (!iwl_is_rfkill_sw(priv))
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 	else
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
+		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 }
 EXPORT_SYMBOL(iwl_rfkill_set_hw_state);


