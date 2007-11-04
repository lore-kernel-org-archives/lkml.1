Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbXKDVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbXKDVpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 16:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXKDVpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 16:45:32 -0500
Received: from mx28.mail.ru ([194.67.23.67]:8923 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXKDVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 16:45:31 -0500
Date: Sun, 4 Nov 2007 23:22:29 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 82596: free nonexistent resource fix
Message-ID: <20071104202225.GA14583@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During booting of last vanilla kernel I got:
Trying to free nonexistent resource...

This because of if "ENABLE_APRICOT" is on we do:
request_region(ioaddr,...)
if (checksum test failed)
  goto out1;
dev->base_addr = ioaddr;//<-here mistake

out1:
release_region(dev->base_addr,...)

Here patch which fixes this bug for me.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

diff --git a/drivers/net/82596.c b/drivers/net/82596.c
index bb30d5b..2797da7 100644
--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -1192,6 +1192,8 @@ struct net_device * __init i82596_probe(int unit)
 			goto out;
 		}
 
+		dev->base_addr = ioaddr;
+
 		for (i = 0; i < 8; i++) {
 			eth_addr[i] = inb(ioaddr + 8 + i);
 			checksum += eth_addr[i];
@@ -1209,7 +1211,6 @@ struct net_device * __init i82596_probe(int unit)
 			goto out1;
 		}
 
-		dev->base_addr = ioaddr;
 		dev->irq = 10;
 	}
 #endif

-- 
/Evgeniy

