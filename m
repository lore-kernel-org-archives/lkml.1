Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZDOIYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZDOIYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbZDOIYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:24:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791AbZDOIYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:24:02 -0400
Date: Wed, 15 Apr 2009 10:22:08 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: [PATCH 3/3] net: bonding: add slave device addresses in mode alb
Message-ID: <20090415082208.GD21342@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415081720.GA21342@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When in mode alb, add all device addresses which belong to an enslaved slave
device to the bond device. This ensures that all mac addresses will be
treated as local and bonding in this mode will work fine in bridge.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 drivers/net/bonding/bond_main.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 99610f3..4025dd0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1385,6 +1385,11 @@ static void bond_setup_by_slave(struct net_device *bond_dev,
 	bond->setup_by_slave = 1;
 }
 
+static bool should_copy_dev_addrs(const struct bonding *bond)
+{
+	return (bond->params.mode == BOND_MODE_ALB);
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 {
@@ -1510,6 +1515,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 	 */
 	new_slave->original_flags = slave_dev->flags;
 
+	if (should_copy_dev_addrs(bond)) {
+		res = dev_addr_add_multiple(bond_dev, slave_dev);
+		if (res)
+			goto err_free;
+	}
+
 	/*
 	 * Save slave's original ("permanent") mac address for modes
 	 * that need it, and for restoring it upon release, and then
@@ -1527,7 +1538,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 		res = dev_set_mac_address(slave_dev, &addr);
 		if (res) {
 			pr_debug("Error %d calling set_mac_address\n", res);
-			goto err_free;
+			goto err_remove_dev_addrs;
 		}
 	}
 
@@ -1769,6 +1780,10 @@ err_restore_mac:
 		dev_set_mac_address(slave_dev, &addr);
 	}
 
+err_remove_dev_addrs:
+	if (should_copy_dev_addrs(bond))
+		dev_addr_del_multiple(bond_dev, slave_dev);
+
 err_free:
 	kfree(new_slave);
 
@@ -1954,6 +1969,9 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 	/* close slave before restoring its mac address */
 	dev_close(slave_dev);
 
+	if (should_copy_dev_addrs(bond))
+		dev_addr_del_multiple(bond_dev, slave_dev);
+
 	if (bond->params.fail_over_mac != BOND_FOM_ACTIVE) {
 		/* restore original ("permanent") mac address */
 		memcpy(addr.sa_data, slave->perm_hwaddr, ETH_ALEN);
@@ -2090,6 +2108,9 @@ static int bond_release_all(struct net_device *bond_dev)
 		/* close slave before restoring its mac address */
 		dev_close(slave_dev);
 
+		if (should_copy_dev_addrs(bond))
+			dev_addr_del_multiple(bond_dev, slave_dev);
+
 		if (!bond->params.fail_over_mac) {
 			/* restore original ("permanent") mac address*/
 			memcpy(addr.sa_data, slave->perm_hwaddr, ETH_ALEN);
-- 
1.6.0.6

