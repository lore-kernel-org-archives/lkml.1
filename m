Return-Path: <linux-kernel-owner+w=401wt.eu-S935000AbYBGVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000AbYBGVGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbYBGUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:38645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762393AbYBGUwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:47 -0500
Date: Thu, 7 Feb 2008 12:47:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/45] b43: Fix suspend/resume
Message-ID: <20080207204752.GF16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-suspend-resume.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

patch 7be1bb6b798d506693d2d8668e801951996b5a4a in mainline.

This patch makes suspend/resume work with the b43 driver.
We must not overwrite the MAC addresses in the init function, as this
would also overwrite the MAC on resume. With an all-zero MAC the device
firmware is not able to ACK any received packets anymore.
Fix this by moving the initializion stuff that must be done on init but
not on resume to the start function.
Also zero out filter_flags to make sure we don't have some flags
from a previous instance for a tiny timeframe until mac80211 reconfigures
them.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3395,8 +3395,6 @@ static int b43_wireless_core_init(struct
 	b43_bluetooth_coext_enable(dev);
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
-	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	b43_rng_init(wl);
@@ -3493,6 +3491,13 @@ static int b43_start(struct ieee80211_hw
 	int did_init = 0;
 	int err = 0;
 
+	/* Kill all old instance specific information to make sure
+	 * the card won't use it in the short timeframe between start
+	 * and mac80211 reconfiguring it. */
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	wl->filter_flags = 0;
+
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43_rfkill_init(dev);

-- 
