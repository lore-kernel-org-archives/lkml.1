Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJRTEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJRTEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYJRTC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:02:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:38086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYJRTC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:02:58 -0400
Date: Sat, 18 Oct 2008 11:34:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 05/17] ath9k/mac80211: disallow fragmentation in ath9k,
	report to userspace
Message-ID: <20081018183406.GF14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath9k-mac80211-disallow-fragmentation-in-ath9k-report-to-userspace.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit 4233df6b748193d45f79fb7448991a473061a65d upstream

As I've reported, ath9k currently fails utterly when fragmentation
is enabled. This makes ath9k "support" hardware fragmentation by
not supporting fragmentation at all to avoid the double-free issue.
The patch also changes mac80211 to report errors from the driver
operation to userspace.

That hack in ath9k should be removed once the rate control algorithm
it has is fixed, and we can at that time consider removing the hw
fragmentation support entirely since it's not used by any driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/main.c |    8 +++++++-
 net/mac80211/wext.c               |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1007,6 +1007,11 @@ static int ath9k_ampdu_action(struct iee
 	return ret;
 }
 
+static int ath9k_no_fragmentation(struct ieee80211_hw *hw, u32 value)
+{
+	return -EOPNOTSUPP;
+}
+
 static struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -1031,7 +1036,8 @@ static struct ieee80211_ops ath9k_ops = 
 	.get_tsf 	    = ath9k_get_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.tx_last_beacon     = NULL,
-	.ampdu_action       = ath9k_ampdu_action
+	.ampdu_action       = ath9k_ampdu_action,
+	.set_frag_threshold = ath9k_no_fragmentation,
 };
 
 void ath_get_beaconconfig(struct ath_softc *sc,
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -804,7 +804,7 @@ static int ieee80211_ioctl_siwfrag(struc
 	 * configure it here */
 
 	if (local->ops->set_frag_threshold)
-		local->ops->set_frag_threshold(
+		return local->ops->set_frag_threshold(
 			local_to_hw(local),
 			local->fragmentation_threshold);
 

-- 
