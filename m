Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbYAPVWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbYAPVWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYAPVWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:22:15 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1827 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYAPVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:22:13 -0500
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Christoph Raisch <RAISCH@de.ibm.com>
Subject: Re: [ofa-general] [PATCH] IB/ipoib: Fix undefined symbol (priv->cm) if ipoib_cm disabled
X-Message-Flag: Warning: May contain useful information
References: <200801161444.35365.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 16 Jan 2008 13:22:07 -0800
In-Reply-To: <200801161444.35365.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 16 Jan 2008 14:44:35 +0100")
Message-ID: <adair1tzcsg.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jan 2008 21:22:08.0341 (UTC) FILETIME=[D9864850:01C85885]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for pointing this out!  I rolled the following into the
offending patch in my tree instead (I preferred avoiding #ifdefs in .c
files...)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 545c5a3..fe250c6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -505,6 +505,12 @@ static inline int ipoib_cm_has_srq(struct net_device *dev)
 	return !!priv->cm.srq;
 }
 
+static inline unsigned int ipoib_cm_max_mtu(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	return priv->cm.max_cm_mtu;
+}
+
 void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx);
 int ipoib_cm_dev_open(struct net_device *dev);
 void ipoib_cm_dev_stop(struct net_device *dev);
@@ -554,6 +560,11 @@ static inline int ipoib_cm_has_srq(struct net_device *dev)
 	return 0;
 }
 
+static inline unsigned int ipoib_cm_max_mtu(struct net_device *dev)
+{
+	return 0;
+}
+
 static inline
 void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e499626..d733045 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -183,7 +183,7 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 
 	/* dev->mtu > 2K ==> connected mode */
 	if (ipoib_cm_admin_enabled(dev)) {
-		if (new_mtu > priv->cm.max_cm_mtu)
+		if (new_mtu > ipoib_cm_max_mtu(dev))
 			return -EINVAL;
 
 		if (new_mtu > priv->mcast_mtu)
