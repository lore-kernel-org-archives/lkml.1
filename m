Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYKLAgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYKLAgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYKLA0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:39 -0500
Received: from kroah.org ([198.145.64.141]:42436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753656AbYKLA0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:37 -0500
Date: Tue, 11 Nov 2008 16:23:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ron Rindjunsky <ron.rindjunsky@intel.com>,
       Esti Kummer <ester.kummer@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 28/49] iwlwifi: allow consecutive scans in unassociated
	state
Message-ID: <20081112002352.GC10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-allow-consecutive-scans-in-unassociated-state.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

commit 681c0050ea3ac2e90c83d5af397d73eed848a372 upstream

This patch allows consecutive scans requests when driver is in
unassociated state.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3214,13 +3214,15 @@ static int iwl4965_mac_hw_scan(struct ie
 
 	/* we don't schedule scan within next_scan_jiffies period */
 	if (priv->next_scan_jiffies &&
-			time_after(priv->next_scan_jiffies, jiffies)) {
+	    time_after(priv->next_scan_jiffies, jiffies)) {
+		IWL_DEBUG_SCAN("scan rejected: within next scan period\n");
 		rc = -EAGAIN;
 		goto out_unlock;
 	}
 	/* if we just finished scan ask for delay */
-	if (priv->last_scan_jiffies && time_after(priv->last_scan_jiffies +
-				IWL_DELAY_NEXT_SCAN, jiffies)) {
+	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
+	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
+		IWL_DEBUG_SCAN("scan rejected: within previous scan period\n");
 		rc = -EAGAIN;
 		goto out_unlock;
 	}

-- 
