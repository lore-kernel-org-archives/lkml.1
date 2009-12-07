Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZLGAOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZLGAOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbZLGAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:13 -0500
Received: from kroah.org ([198.145.64.141]:34770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795AbZLGAOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000659.497334186@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Kossifidis <mickflemm@gmail.com>,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>
Subject: [107/119] ath5k: Linear PCDAC code fixes
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=ath5k-linear-pcdac-code-fixes.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nick Kossifidis <mick@madwifi-project.org>

commit d1cb0bdac180a4afdd3c001acb2618d2a62d9abe upstream.

* Set correct xpd curve indices for high/low gain curves during
   rfbuffer setup on RF5112B with both calibration curves available.

 * Don't return zero min power when we have the same pcdac value
   twice because it breaks interpolation. Instead return the right
   x barrier as we do when we have equal power levels for 2 different
   pcdac values.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/phy.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -740,13 +740,22 @@ int ath5k_hw_rfregs_init(struct ath5k_hw
 						AR5K_RF_XPD_GAIN, true);
 
 		} else {
-			/* TODO: Set high and low gain bits */
-			ath5k_hw_rfb_op(ah, rf_regs,
-						ee->ee_x_gain[ee_mode],
+			u8 *pdg_curve_to_idx = ee->ee_pdc_to_idx[ee_mode];
+			if (ee->ee_pd_gains[ee_mode] > 1) {
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
 						AR5K_RF_PD_GAIN_LO, true);
-			ath5k_hw_rfb_op(ah, rf_regs,
-						ee->ee_x_gain[ee_mode],
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[1],
 						AR5K_RF_PD_GAIN_HI, true);
+			} else {
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
+						AR5K_RF_PD_GAIN_LO, true);
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
+						AR5K_RF_PD_GAIN_HI, true);
+			}
 
 			/* Lower synth voltage on Rev 2 */
 			ath5k_hw_rfb_op(ah, rf_regs, 2,
@@ -1897,8 +1906,9 @@ ath5k_get_linear_pcdac_min(const u8 *ste
 	s16 min_pwrL, min_pwrR;
 	s16 pwr_i;
 
-	if (WARN_ON(stepL[0] == stepL[1] || stepR[0] == stepR[1]))
-		return 0;
+	/* Some vendors write the same pcdac value twice !!! */
+	if (stepL[0] == stepL[1] || stepR[0] == stepR[1])
+		return max(pwrL[0], pwrR[0]);
 
 	if (pwrL[0] == pwrL[1])
 		min_pwrL = pwrL[0];


