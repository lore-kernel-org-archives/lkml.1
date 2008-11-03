Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYKCLOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYKCLOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYKCLNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:13:53 -0500
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:3094 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbYKCLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:13:53 -0500
Subject: [PATCH 1/8] p80211netdev.c fix netdev alloc to prevent oops on
	device start
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:09:34 +0000
Message-Id: <1225710574.3113.9.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a version of this patch is in the wlan-ng_devel tree

initializes netdev correctly to prevent an oops on device start.  

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211netdev.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index d229780..cc9cd4c 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -845,13 +845,11 @@ int wlan_setup(wlandevice_t *wlandev)
 		     (unsigned long)wlandev);
 
 	/* Allocate and initialize the struct device */
-	dev = kmalloc(sizeof(netdevice_t), GFP_ATOMIC);
+	dev = alloc_netdev(0,"wlan%d",ether_setup);
 	if ( dev == NULL ) {
 		WLAN_LOG_ERROR("Failed to alloc netdev.\n");
 		result = 1;
 	} else {
-		memset( dev, 0, sizeof(netdevice_t));
-		ether_setup(dev);
 		wlandev->netdev = dev;
 		dev->priv = wlandev;
 		dev->hard_start_xmit =	p80211knetdev_hard_start_xmit;
@@ -960,15 +958,9 @@ int register_wlandev(wlandevice_t *wlandev)
 
 	DBFENTER;
 
-	i = dev_alloc_name(wlandev->netdev, "wlan%d");
-	if (i >= 0) {
-		i = register_netdev(wlandev->netdev);
-	}
-	if (i != 0) {
-		return -EIO;
-	}
-
-	strcpy(wlandev->name, dev->name);
+	i = register_netdev(wlandev->netdev);
+	if (i)
+		return i;
 
 	DBFEXIT;
 	return 0;
-- 
1.5.6.5



