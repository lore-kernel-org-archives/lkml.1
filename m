Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbZEFWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbZEFWSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbZEFVzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:22 -0400
Received: from kroah.org ([198.145.64.141]:57458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761594AbZEFVzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:03 2009
Message-Id: <20090506214802.953643370@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:23 -0700
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
       alan@lxorguk.ukuu.org.uk, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 55/58] rndis_wlan: fix initialization order for workqueue&workers
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=rndis_wlan-fix-initialization-order-for-workqueue-workers.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit e805e4d0b53506dff4255a2792483f094e7fcd2c upstream.

rndis_wext_link_change() might be called from rndis_command() at
initialization stage and priv->workqueue/priv->work have not been
initialized yet. This causes invalid opcode at rndis_wext_bind on
some brands of bcm4320.

Fix by initializing workqueue/workers in rndis_wext_bind() before
rndis_command is used.

This bug has existed since 2.6.25, reported at:
	http://bugzilla.kernel.org/show_bug.cgi?id=12794

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rndis_wlan.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2550,6 +2550,11 @@ static int rndis_wext_bind(struct usbnet
 	mutex_init(&priv->command_lock);
 	spin_lock_init(&priv->stats_lock);
 
+	/* because rndis_command() sleeps we need to use workqueue */
+	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
+	INIT_WORK(&priv->work, rndis_wext_worker);
+	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
+
 	/* try bind rndis_host */
 	retval = generic_rndis_bind(usbdev, intf, FLAG_RNDIS_PHYM_WIRELESS);
 	if (retval < 0)
@@ -2594,16 +2599,17 @@ static int rndis_wext_bind(struct usbnet
 	disassociate(usbdev, 1);
 	netif_carrier_off(usbdev->net);
 
-	/* because rndis_command() sleeps we need to use workqueue */
-	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
-	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
 		round_jiffies_relative(STATS_UPDATE_JIFFIES));
-	INIT_WORK(&priv->work, rndis_wext_worker);
 
 	return 0;
 
 fail:
+	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_work_sync(&priv->work);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+
 	kfree(priv);
 	return retval;
 }


