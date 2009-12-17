Return-Path: <linux-kernel-owner+w=401wt.eu-S935627AbZLQERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbZLQERT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936159AbZLQEFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:31 -0500
Received: from kroah.org ([198.145.64.141]:55931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936129AbZLQEF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.668679326@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       Vivek Natarajan <vnatarajan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [121/151] mac80211: Fix dynamic power save for scanning.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Vivek Natarajan <vnatarajan@atheros.com>

Upstream commit: 7c3f4bbedc241ddcd3abe1f419c356e625231da1

Not only ps_sdata but also IEEE80211_CONF_PS is to be considered
before restoring PS in scan_ps_disable(). For instance, when ps_sdata
is set but CONF_PS is not set just because the dynamic timer is still
running, a sw scan leads to setting of CONF_PS in scan_ps_disable
instead of restarting the dynamic PS timer.
Also for the above case, a null data frame is to be sent after
returning to operating channel which was not happening with the
current implementation. This patch fixes this too.


Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/scan.c        |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -808,6 +808,7 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool pspolling;
+	bool scan_ps_enabled;
 	/*
 	 * PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -196,7 +196,8 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 static void ieee80211_scan_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	bool ps = false;
+
+	local->scan_ps_enabled = false;
 
 	/* FIXME: what to do when local->pspolling is true? */
 
@@ -204,12 +205,13 @@ static void ieee80211_scan_ps_enable(str
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		ps = true;
+		local->scan_ps_enabled = true;
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
-	if (!ps || !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+	if (!(local->scan_ps_enabled) ||
+	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
 		 * frame because AP knows that we are sleeping. But if the
@@ -230,7 +232,7 @@ static void ieee80211_scan_ps_disable(st
 
 	if (!local->ps_sdata)
 		ieee80211_send_nullfunc(local, sdata, 0);
-	else {
+	else if (local->scan_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
 		 * will send a nullfunc frame with the powersave bit set
@@ -246,6 +248,16 @@ static void ieee80211_scan_ps_disable(st
 		 */
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
+		/*
+		 * If IEEE80211_CONF_PS was not set and the dynamic_ps_timer
+		 * had been running before leaving the operating channel,
+		 * restart the timer now and send a nullfunc frame to inform
+		 * the AP that we are awake.
+		 */
+		ieee80211_send_nullfunc(local, sdata, 0);
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 }
 


