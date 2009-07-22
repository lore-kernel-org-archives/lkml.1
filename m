Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZGVM6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZGVM6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZGVM6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:58:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbZGVM6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:58:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH] NET / skge: Enable WoL by default if supported
Date: Wed, 22 Jul 2009 14:58:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-rjw; KDE/4.2.4; x86_64; ; )
Cc: netdev@vger.kernel.org, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Guntsche <mike@it-loops.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221458.55616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If skge hardware is capable of waking up the system from sleep,
enable magic packet WoL during driver initialisation.

This makes WoL work without calling 'ethtool -s ethX wol g'
for each adapter.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Michael Guntsche <mike@it-loops.com>
---
 drivers/net/skge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/net/skge.c
===================================================================
--- linux-2.6.orig/drivers/net/skge.c
+++ linux-2.6/drivers/net/skge.c
@@ -3856,8 +3856,10 @@ static struct net_device *skge_devinit(s
 	skge->speed = -1;
 	skge->advertising = skge_supported_modes(hw);
 
-	if (device_may_wakeup(&hw->pdev->dev))
+	if (device_can_wakeup(&hw->pdev->dev)) {
 		skge->wol = wol_supported(hw) & WAKE_MAGIC;
+		device_set_wakeup_enable(&hw->pdev->dev, skge->wol);
+	}
 
 	hw->dev[port] = dev;
 
