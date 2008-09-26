Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYIZRbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYIZRbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYIZRbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:31:25 -0400
Received: from dcs-mx1.cs.uiuc.edu ([128.174.252.81]:40257 "EHLO
	dcs-mx1.cs.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYIZRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:31:24 -0400
Date: Fri, 26 Sep 2008 12:31:20 -0500
From: Lin Tan <tammy000@gmail.com>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH git latest] drivers/net: fixing a datarace related to update_stats()
Message-ID: <20080926173120.GB19317@carmen.cs.uiuc.edu>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk> <20080922215617.GA13057@comet.dominikbrodowski.net> <20080922231227.2625dd09@lxorguk.ukuu.org.uk> <20080922222655.GA3792@isilmar.linta.de> <20080923001534.13031535@lxorguk.ukuu.org.uk> <20080926222920.f251696e.komurojun-mbn@nifty.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20080926222920.f251696e.komurojun-mbn@nifty.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Resending the corrected patch.

--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="update_stats.readytosend"

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
+++ b/drivers/net/pcmcia/3c589_cs.c	2008-09-26 11:07:04.000000000 -0500
@@ -920,6 +920,7 @@
     struct el3_private *lp = netdev_priv(dev);
     struct pcmcia_device *link = lp->p_dev;
     unsigned int ioaddr = dev->base_addr;
+    unsigned long flags;
     
     DEBUG(1, "%s: shutting down ethercard.\n", dev->name);
 
@@ -946,8 +947,11 @@
 	outw(0x0f00, ioaddr + WN0_IRQ);
         
 	/* Check if the card still exists */
-	if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000)
+	if ((inw(ioaddr+EL3_STATUS) & 0xe000) == 0x2000) {
+    	    spin_lock_irqsave(&lp->lock, flags);
 	    update_stats(dev);
+    	    spin_unlock_irqrestore(&lp->lock, flags);
+	}
     }
 
     link->open--;

--kORqDWCi7qDJ0mEj--
