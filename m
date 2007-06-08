Return-Path: <linux-kernel-owner+w=401wt.eu-S938817AbXFHHik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938817AbXFHHik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967772AbXFHHXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55113 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967762AbXFHHXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:52 -0400
Message-Id: <20070608072156.701592000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Auke Kok <auke-jan.h.kok@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Doug Chapman <doug.chapman@hp.com>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/54] e1000: disable polling before registering netdevice
Content-Disposition: inline; filename=e1000-disable-polling-before-registering-netdevice.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Auke Kok <auke-jan.h.kok@intel.com>

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
 1 file changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.21.4.orig/drivers/net/e1000/e1000_main.c
+++ linux-2.6.21.4/drivers/net/e1000/e1000_main.c
@@ -1153,13 +1153,16 @@ e1000_probe(struct pci_dev *pdev,
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
 
 	DPRINTK(PROBE, INFO, "Intel(R) PRO/1000 Network Connection\n");
 

-- 
