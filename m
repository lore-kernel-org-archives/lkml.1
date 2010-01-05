Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507Ab0AEUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0AEUGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438Ab0AEUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:18 -0500
Received: from kroah.org ([198.145.64.141]:49999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab0AEUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.708742663@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Martin Decky <martin@decky.cz>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [21/39] hostap: Revert a toxic part of the conversion to net_device_ops
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Decky <martin@decky.cz>

commit e484c16f6212f7f06407382efa4d3ad214b6c589 upstream.

As the hostap driver was converted to use net_device_ops, a mistake was
made in hostap_main.c (commit 5ae4efbcd2611562a8b93596be034e63495706a5).
Originally, the tx_queue_len was set to 0 for every other interface than
HOSTAP_INTERFACE_MASTER, but the new fragment of code sets tx_queue_len to
0 only for HOSTAP_INTERFACE_MASTER. The opposite of the previous
behavior makes the driver to drop all packets in AP mode.

Change the way 0 is assigned to tx_queue_len according to the original
logic.

Signed-off-by: Martin Decky <martin@decky.cz>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/hostap/hostap_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -875,15 +875,16 @@ void hostap_setup_dev(struct net_device 
 
 	switch(type) {
 	case HOSTAP_INTERFACE_AP:
+		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_mgmt_netdev_ops;
 		dev->type = ARPHRD_IEEE80211;
 		dev->header_ops = &hostap_80211_ops;
 		break;
 	case HOSTAP_INTERFACE_MASTER:
-		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_master_ops;
 		break;
 	default:
+		dev->tx_queue_len = 0;	/* use main radio device queue */
 		dev->netdev_ops = &hostap_netdev_ops;
 	}
 


