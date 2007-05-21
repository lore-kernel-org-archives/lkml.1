Return-Path: <linux-kernel-owner+w=401wt.eu-S935560AbXEUTx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935560AbXEUTx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765079AbXEUT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52686 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124AbXEUT3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:42 -0400
Message-Id: <20070521191721.927168000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael Chan" <mchan@broadcom.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 25/69] BNX2: Block MII access when ifdown.
Content-Disposition: inline; filename=bnx2-block-mii-access-when-ifdown.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

The device may be in D3hot state and should not allow MII register
access.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 drivers/net/bnx2.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.21.1.orig/drivers/net/bnx2.c
+++ linux-2.6.21.1/drivers/net/bnx2.c
@@ -5564,6 +5564,9 @@ bnx2_ioctl(struct net_device *dev, struc
 	case SIOCGMIIREG: {
 		u32 mii_regval;
 
+		if (!netif_running(dev))
+			return -EAGAIN;
+
 		spin_lock_bh(&bp->phy_lock);
 		err = bnx2_read_phy(bp, data->reg_num & 0x1f, &mii_regval);
 		spin_unlock_bh(&bp->phy_lock);
@@ -5577,6 +5580,9 @@ bnx2_ioctl(struct net_device *dev, struc
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
+		if (!netif_running(dev))
+			return -EAGAIN;
+
 		spin_lock_bh(&bp->phy_lock);
 		err = bnx2_write_phy(bp, data->reg_num & 0x1f, data->val_in);
 		spin_unlock_bh(&bp->phy_lock);

-- 
