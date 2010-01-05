Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567Ab0AEAsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0AEAsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771Ab0AEAsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:48:33 -0500
Received: from kroah.org ([198.145.64.141]:34289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab0AEAfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/97] mac80211: fix propagation of failed hardware reconfigurations
Date: Mon,  4 Jan 2010 16:32:54 -0800
Message-Id: <1262651630-7354-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 24feda0084722189468a65e20019cdd8ef99702b upstream.

mac80211 does not propagate failed hardware reconfiguration
requests. For suspend and resume this is important due to all
the possible issues that can come out of the suspend <-> resume
cycle. Not propagating the error means cfg80211 will assume
the resume for the device went through fine and mac80211 will
continue on trying to poke at the hardware, enable timers,
queue work, and so on for a device which is completley
unfunctional.

The least we can do is to propagate device start issues and
warn when this occurs upon resume. A side effect of this patch
is we also now propagate the start errors upon harware
reconfigurations (non-suspend), but this should also be desirable
anyway, there is not point in continuing to reconfigure a
device if mac80211 was unable to start the device.

For further details refer to the thread:

http://marc.info/?t=126151038700001&r=1&w=2

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/util.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cbc5d20..51e0bd2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1031,7 +1031,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* restart hardware */
 	if (local->open_count) {
+		/*
+		 * Upon resume hardware can sometimes be goofy due to
+		 * various platform / driver / bus issues, so restarting
+		 * the device may at times not work immediately. Propagate
+		 * the error.
+		 */
 		res = drv_start(local);
+		if (res) {
+			WARN(local->suspended, "Harware became unavailable "
+			     "upon resume. This is could be a software issue"
+			     "prior to suspend or a harware issue\n");
+			return res;
+		}
 
 		ieee80211_led_radio(local, true);
 	}
-- 
1.6.6

