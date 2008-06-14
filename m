Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbYFNAMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbYFNAMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbYFNAMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588AbYFNAMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:21 -0400
Date: Fri, 13 Jun 2008 17:10:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 01/47] b43: Fix controller restart crash
Message-ID: <20080614001012.GA24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-controller-restart-crash.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

upstream commit: 3bf0a32e22fedc0b46443699db2d61ac2a883ac4

This fixes a kernel crash on rmmod, in the case where the controller
was restarted before doing the rmmod.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/b43/main.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3818,7 +3818,9 @@ static void b43_chip_reset(struct work_s
 			goto out;
 		}
 	}
-      out:
+out:
+	if (err)
+		wl->current_dev = NULL; /* Failed to init the dev. */
 	mutex_unlock(&wl->mutex);
 	if (err)
 		b43err(wl, "Controller restart FAILED\n");
@@ -3967,9 +3969,11 @@ static void b43_one_core_detach(struct s
 	struct b43_wldev *wldev;
 	struct b43_wl *wl;
 
+	/* Do not cancel ieee80211-workqueue based work here.
+	 * See comment in b43_remove(). */
+
 	wldev = ssb_get_drvdata(dev);
 	wl = wldev->wl;
-	cancel_work_sync(&wldev->restart_work);
 	b43_debugfs_remove_device(wldev);
 	b43_wireless_core_detach(wldev);
 	list_del(&wldev->list);
@@ -4152,6 +4156,10 @@ static void b43_remove(struct ssb_device
 	struct b43_wl *wl = ssb_get_devtypedata(dev);
 	struct b43_wldev *wldev = ssb_get_drvdata(dev);
 
+	/* We must cancel any work here before unregistering from ieee80211,
+	 * as the ieee80211 unreg will destroy the workqueue. */
+	cancel_work_sync(&wldev->restart_work);
+
 	B43_WARN_ON(!wl);
 	if (wl->current_dev == wldev)
 		ieee80211_unregister_hw(wl->hw);

-- 
