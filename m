Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXHKTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXHKTGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbXHKS6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:40 -0400
Received: from 1wt.eu ([62.212.114.60]:1584 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762681AbXHKS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:32 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184835.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:58 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Auke Kok <auke-jan.h.kok@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Doug Chapman <doug.chapman@hp.com>, Jeff Garzik <jeff@garzik.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 06/28] e1000: disable polling before registering netdevice
Content-Disposition: inline; filename=0006-PATCH-e1000-disable-polling-before-registering-ne.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To assure the symmetry of poll enable/disable in up/down, we should
initialize the netdevice to be poll_disabled at load time. Doing
this after register_netdevice leaves us open to another race, so
lets move all the netif_* calls above register_netdevice so the
stack starts out how we expect it to be.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Doug Chapman <doug.chapman@hp.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/e1000/e1000_main.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index c6259c7..40bdcf9 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1157,13 +1157,16 @@ e1000_probe(struct pci_dev *pdev,
 	    !e1000_check_mng_mode(&adapter->hw))
 		e1000_get_hw_control(adapter);
 
-	strcpy(netdev->name, "eth%d");
-	if ((err = register_netdev(netdev)))
-		goto err_register;
-
 	/* tell the stack to leave us alone until e1000_open() is called */
 	netif_carrier_off(netdev);
 	netif_stop_queue(netdev);
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_disable(netdev);
+#endif
+
+	strcpy(netdev->name, "eth%d");
+	if ((err = register_netdev(netdev)))
+		goto err_register;
 
 	DPRINTK(PROBE, INFO, "Intel(R) PRO/1000 Network Connection
");
 
-- 
1.5.2.4

-- 
