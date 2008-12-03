Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYLCUKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYLCUKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYLCTyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:23 -0500
Received: from kroah.org ([198.145.64.141]:60200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753638AbYLCTyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:21 -0500
Date: Wed, 3 Dec 2008 11:52:37 -0800
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 051/104] e1000e: Use device_set_wakeup_enable
Message-ID: <20081203195237.GZ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="e1000e-use-device_set_wakeup_enable.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 6ff68026f4757d68461b7fbeca5c944e1f5f8b44 upstream.

Since dev->power.should_wakeup bit is used by the PCI core to
decide whether the device should wake up the system from sleep
states, set/unset this bit whenever WOL is enabled/disabled using
e1000_set_wol().  Accordingly, use device_can_wakeup() for checking
if wake-up is supported by the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/ethtool.c |    8 ++++++--
 drivers/net/e1000e/netdev.c  |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -1681,7 +1681,8 @@ static void e1000_get_wol(struct net_dev
 	wol->supported = 0;
 	wol->wolopts = 0;
 
-	if (!(adapter->flags & FLAG_HAS_WOL))
+	if (!(adapter->flags & FLAG_HAS_WOL) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return;
 
 	wol->supported = WAKE_UCAST | WAKE_MCAST |
@@ -1719,7 +1720,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & WAKE_MAGICSECURE)
 		return -EOPNOTSUPP;
 
-	if (!(adapter->flags & FLAG_HAS_WOL))
+	if (!(adapter->flags & FLAG_HAS_WOL) ||
+	    !device_can_wakeup(&adapter->pdev->dev))
 		return wol->wolopts ? -EOPNOTSUPP : 0;
 
 	/* these settings will always override what we currently have */
@@ -1738,6 +1740,8 @@ static int e1000_set_wol(struct net_devi
 	if (wol->wolopts & WAKE_ARP)
 		adapter->wol |= E1000_WUFC_ARP;
 
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
 	return 0;
 }
 
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4616,6 +4616,7 @@ static int __devinit e1000_probe(struct 
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
 
 	/* reset the hardware with the new settings */
 	e1000e_reset(adapter);

