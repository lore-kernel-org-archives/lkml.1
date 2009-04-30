Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbZD3RHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbZD3RHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762985AbZD3RHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:13 -0400
Received: from kroah.org ([198.145.64.141]:39078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbZD3RHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:38 2009
Message-Id: <20090430165738.476519331@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:55:50 -0700
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
       alan@lxorguk.ukuu.org.uk, Jay Vosburgh <fubar@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/88] bonding: Fix updating of speed/duplex changes
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=bonding-fix-updating-of-speed-duplex-changes.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Vosburgh <fubar@us.ibm.com>

[ Upstream commit 17d04500e2528217de5fe967599f98ee84348a9c ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |   25 ++++++++++++++++++++-----
 drivers/net/bonding/bonding.h   |    6 ++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -248,6 +248,12 @@ static inline struct bonding *bond_get_b
 	return (struct bonding *)slave->dev->master->priv;
 }
 
+static inline bool bond_is_lb(const struct bonding *bond)
+{
+        return bond->params.mode == BOND_MODE_TLB
+                || bond->params.mode == BOND_MODE_ALB;
+}
+
 #define BOND_FOM_NONE			0
 #define BOND_FOM_ACTIVE			1
 #define BOND_FOM_FOLLOW			2
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3536,11 +3536,26 @@ static int bond_slave_netdev_event(unsig
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


