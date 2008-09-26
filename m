Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYIZCdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYIZCdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYIZCdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:33:25 -0400
Received: from dcs-mx1.cs.uiuc.edu ([128.174.252.81]:60016 "EHLO
	dcs-mx1.cs.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYIZCdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:33:24 -0400
Date: Thu, 25 Sep 2008 21:33:22 -0500
From: Lin Tan <tammy000@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH git latest] drivers/net: fixing a datarace related to update_stats()
Message-ID: <20080926023322.GA16514@carmen.cs.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a datarace.

As indicated by the following comment, a lock must be held before calling 
function update_stats(). This rule is followed in some cases, but not in 
others. For example, the lock is held when the function is called in function 
el3_get_stats(), but the lock is NOT held when called in el3_close(). It can 
cause potential data races. 

/*
  ...
  
  Caller must hold the lock for this
*/
static void update_stats(struct net_device *dev)
{
...
}


Signed-off-by: Lin Tan <tammy000@gmail.com>

---

--- a/drivers/net/pcmcia/3c589_cs.c	2008-09-25 11:52:42.000000000 -0500
+++ b/drivers/net/pcmcia/3c589_cs.c	2008-09-25 13:01:44.000000000 -0500
@@ -920,6 +920,7 @@ static int el3_close(struct net_device *
     struct el3_private *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
     unsigned int ioaddr = dev->base_addr;
+    unsigned long flags;
     
     DEBUG(1, "%s: shutting down ethercard.\n", dev->name);
 
@@ -947,7 +948,9 @@ static int el3_close(struct net_device *
         
 	/* Check if the card still exists */
 	if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000)
+    	    spin_lock_irqsave(&lp->lock, flags);
 	    update_stats(dev);
+    	    spin_unlock_irqrestore(&lp->lock, flags);
     }
 
     link->open--;
