Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYKOFZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYKOFZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYKOFYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:51 -0500
Received: from kroah.org ([198.145.64.141]:50439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751877AbYKOFYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:48 -0500
Date: Fri, 14 Nov 2008 21:22:46 -0800
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
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>,
       Holger Macht <hmacht@novell.com>
Subject: [patch 02/22] iwlagn: avoid sleep in softirq context
Message-ID: <20081115052246.GC3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlagn-avoid-sleep-in-softirq-context.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 964d2777438bf7687324243d38ade538d9bbfe3c upstream.

__ieee80211_tasklet_handler -> __ieee80211_rx ->
	__ieee80211_rx_handle_packet -> ieee80211_invoke_rx_handlers ->
	ieee80211_rx_h_decrypt -> ieee80211_crypto_tkip_decrypt ->
	ieee80211_tkip_decrypt_data -> iwl4965_mac_update_tkip_key ->
	iwl_scan_cancel_timeout -> msleep

Ooops!

Avoid the sleep by changing iwl_scan_cancel_timeout with
iwl_scan_cancel and simply returning on failure if the scan persists.
This will cause hardware decryption to fail and we'll handle a few more
frames with software decryption.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Holger Macht <hmacht@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3275,7 +3275,11 @@ static void iwl4965_mac_update_tkip_key(
 		return;
 	}
 
-	iwl_scan_cancel_timeout(priv, 100);
+	if (iwl_scan_cancel(priv)) {
+		/* cancel scan failed, just live w/ bad key and rely
+		   briefly on SW decryption */
+		return;
+	}
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);

-- 
