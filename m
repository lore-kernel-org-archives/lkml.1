Return-Path: <linux-kernel-owner+w=401wt.eu-S934712AbYBGVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbYBGVJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933555AbYBGUxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:53:17 -0500
Received: from ns.suse.de ([195.135.220.2]:45847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbYBGUxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:53:13 -0500
Date: Thu, 7 Feb 2008 12:48:02 -0800
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
       Michael@hera.kernel.org, linux-wireless@vger.kernel.org,
       bcm43xx-dev@lists.berlios.de, Buesch <mb@bu3sch.de>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 35/45] b43legacy: fix suspend/resume
Message-ID: <20080207204802.GJ16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43legacy-fix-suspend-resume.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefano Brivio <stefano.brivio@polimi.it>

patch ada50731c0346bf900dc387edd3a6961297bf2d3 in mainline.

This patch makes suspend/resume work with the b43legacy driver.
We must not overwrite the MAC addresses in the init function, as this
would also overwrite the MAC on resume. With an all-zero MAC the device
firmware is not able to ACK any received packets anymore.
Fix this by moving the initializion stuff that must be done on init but
not on resume to the start function.
Also zero out filter_flags to make sure we don't have some flags
from a previous instance for a tiny timeframe until mac80211 reconfigures
them.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3215,8 +3215,6 @@ static int b43legacy_wireless_core_init(
 	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, 0x0414, 0x01F4);
 
 	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
-	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43legacy_upload_card_macaddress(dev);
 	b43legacy_security_init(dev);
 	b43legacy_rng_init(wl);
@@ -3311,6 +3309,13 @@ static int b43legacy_start(struct ieee80
 	int did_init = 0;
 	int err = 0;
 
+	/* Kill all old instance specific information to make sure
+	 * the card won't use it in the short timeframe between start
+	 * and mac80211 reconfiguring it. */
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	wl->filter_flags = 0;
+
 	mutex_lock(&wl->mutex);
 
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {

-- 
