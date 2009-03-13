Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZCMX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZCMX1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZCMX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:27:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56976 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCMX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:27:12 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Miller <davem@davemloft.net>
cc: jesper@krogh.cc, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@redhat.com, aowi@novozymes.com
Subject: Re: Regression in bonding between 2.6.26.8 and 2.6.27.6 - bisected - twice
In-reply-to: <20090313.161217.52045656.davem@davemloft.net>
References: <49AA8B4F.8090405@krogh.cc> <9712.1236279072@death.nxdomain.ibm.com> <49B581D3.6060807@krogh.cc> <20090313.161217.52045656.davem@davemloft.net>
Comments: In-reply-to David Miller <davem@davemloft.net>
   message dated "Fri, 13 Mar 2009 16:12:17 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
Date: Fri, 13 Mar 2009 16:27:16 -0700
Message-ID: <8799.1236986836@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

>From: Jesper Krogh <jesper@krogh.cc>
>Date: Mon, 09 Mar 2009 21:53:39 +0100
>
>> Jay Vosburgh wrote:
>> > 	However, I did find another bug I introduced during the "mii
>> > refactor" patch that you mentioned as being the original source of the
>> > problem.  That bug will cause 802.3ad to not notice speed changes.
>> > 	Could you test the patch below on your 2.6.68.7 and/or 2.6.27.19
>> > and see if it resolves your problem (without the forcedeth patch)?
>> 
>> There was something missing from the header to make it compile.. I found that in a later version. Patch below fixed the problem (without the forcedeth patch).
>
>Jay please resend this with proper signoffs etc. if you want
>me to apply it.

	I posted it again with the usual stuff a day or two after I
posted the test patch; I'll append it to the end of this email.  Note
that the below patch has a minor cosmetic change from the test patch.

	I believe this fix should go to -stable for 2.6.26 and 2.6.27,
but it'll need the change Jesper added to pick up a macro that was added
to mainline:

diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index fb730ec..b1315e4 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -248,6 +248,14 @@ static inline struct bonding
*bond_get_bond_by_slave(struct slave *slave)
        return (struct bonding *)slave->dev->master->priv;
 }

+static inline bool bond_is_lb(const struct bonding *bond)
+{
+        return bond->params.mode == BOND_MODE_TLB
+                || bond->params.mode == BOND_MODE_ALB;
+}
+
+
+
 #define BOND_FOM_NONE                  0
 #define BOND_FOM_ACTIVE                        1
 #define BOND_FOM_FOLLOW                        2

	The above fragment isn't needed for mainline, only for -stable.

	-J

From: Jay Vosburgh <fubar@us.ibm.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: [PATCH net-next-2.6] bonding: Fix updating of speed/duplex changes
Date: 	Fri, 06 Mar 2009 15:27:33 -0800


	This patch corrects an omission from the following commit:

commit f0c76d61779b153dbfb955db3f144c62d02173c2
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Wed Jul 2 18:21:58 2008 -0700

    bonding: refactor mii monitor

	The un-refactored code checked the link speed and duplex of
every slave on every pass; the refactored code did not do so.

	The 802.3ad and balance-alb/tlb modes utilize the speed and
duplex information, and require it to be kept up to date.  This patch
adds a notifier check to perform the appropriate updating when the slave
device speed changes.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
---
 drivers/net/bonding/bond_main.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index bfe1ed8..dce3cf9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3545,11 +3545,26 @@ static int bond_slave_netdev_event(unsigned long event, struct net_device *slave
 		}
 		break;
 	case NETDEV_CHANGE:
-		/*
-		 * TODO: is this what we get if somebody
-		 * sets up a hierarchical bond, then rmmod's
-		 * one of the slave bonding devices?
-		 */
+		if (bond->params.mode == BOND_MODE_8023AD || bond_is_lb(bond)) {
+			struct slave *slave;
+
+			slave = bond_get_slave_by_dev(bond, slave_dev);
+			if (slave) {
+				u16 old_speed = slave->speed;
+				u16 old_duplex = slave->duplex;
+
+				bond_update_speed_duplex(slave);
+
+				if (bond_is_lb(bond))
+					break;
+
+				if (old_speed != slave->speed)
+					bond_3ad_adapter_speed_changed(slave);
+				if (old_duplex != slave->duplex)
+					bond_3ad_adapter_duplex_changed(slave);
+			}
+		}
+
 		break;
 	case NETDEV_DOWN:
 		/*
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
