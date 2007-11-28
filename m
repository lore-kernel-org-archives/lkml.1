Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXK1AuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXK1AuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXK1AuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:50:00 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:51636 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117AbXK1At6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:49:58 -0500
From: =?us-ascii?Q?=3D=3Futf-8=3Fq=3FFerenc=5FW=3DC3=3DA1gner=3F=3D?= 
	<wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, wferi@niif.hu
Subject: [PATCH 1/3] Remove trailing NULs from network bonding sysfs interface.
Date: Wed, 28 Nov 2007 01:49:54 +0100
Message-ID: <871wabkxcd.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove trailing spaces from multivalued files.

This fixes output like for example:

$ od -c /sys/class/net/bond0/bonding/slaves
0000000   e   t   h   -   l   e   f   t       e   t   h   -   r   i   g
0000020   h   t      \n  \0
0000025

It mostly entails deleting '+1'-s after sprintf() calls: the return value
of sprintf is the number of characters printed, without the closing NUL,
ie. exactly what the sysfs interface requires.  The three multivalue
cases are different, because they also have to swallow back a trailing
space.

Signed-off-by: Ferenc Wágner <wferi@niif.hu>
---
 drivers/net/bonding/bond_sysfs.c |   66 +++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index b29330d..a3f1b4a 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -86,14 +86,13 @@ static ssize_t bonding_show_bonds(struct class *cls, char *buffer)
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buffer + res, "++more++");
+			res += sprintf(buffer + res, "++more++ ");
 			break;
 		}
 		res += sprintf(buffer + res, "%s ",
 			       bond->dev->name);
 	}
-	res += sprintf(buffer + res, "\n");
-	res++;
+	if (res) buffer[res-1] = '\n'; /* eat the leftover space */
 	up_read(&(bonding_rwsem));
 	return res;
 }
@@ -235,14 +234,13 @@ static ssize_t bonding_show_slaves(struct device *d,
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buf + res, "++more++");
+			res += sprintf(buf + res, "++more++ ");
 			break;
 		}
 		res += sprintf(buf + res, "%s ", slave->dev->name);
 	}
 	read_unlock(&bond->lock);
-	res += sprintf(buf + res, "\n");
-	res++;
+	if (res) buf[res-1] = '\n'; /* eat the leftover space */
 	return res;
 }
 
@@ -406,7 +404,7 @@ static ssize_t bonding_show_mode(struct device *d,
 
 	return sprintf(buf, "%s %d\n",
 			bond_mode_tbl[bond->params.mode].modename,
-			bond->params.mode) + 1;
+			bond->params.mode);
 }
 
 static ssize_t bonding_store_mode(struct device *d,
@@ -463,11 +461,11 @@ static ssize_t bonding_show_xmit_hash(struct device *d,
 	if ((bond->params.mode != BOND_MODE_XOR) &&
 	    (bond->params.mode != BOND_MODE_8023AD)) {
 		// Not Applicable
-		count = sprintf(buf, "NA\n") + 1;
+		count = sprintf(buf, "NA\n");
 	} else {
 		count = sprintf(buf, "%s %d\n",
 			xmit_hashtype_tbl[bond->params.xmit_policy].modename,
-			bond->params.xmit_policy) + 1;
+			bond->params.xmit_policy);
 	}
 
 	return count;
@@ -527,7 +525,7 @@ static ssize_t bonding_show_arp_validate(struct device *d,
 
 	return sprintf(buf, "%s %d\n",
 		       arp_validate_tbl[bond->params.arp_validate].modename,
-		       bond->params.arp_validate) + 1;
+		       bond->params.arp_validate);
 }
 
 static ssize_t bonding_store_arp_validate(struct device *d,
@@ -627,7 +625,7 @@ static ssize_t bonding_show_arp_interval(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.arp_interval) + 1;
+	return sprintf(buf, "%d\n", bond->params.arp_interval);
 }
 
 static ssize_t bonding_store_arp_interval(struct device *d,
@@ -711,10 +709,7 @@ static ssize_t bonding_show_arp_targets(struct device *d,
 			res += sprintf(buf + res, "%u.%u.%u.%u ",
 			       NIPQUAD(bond->params.arp_targets[i]));
 	}
-	if (res)
-		res--;  /* eat the leftover space */
-	res += sprintf(buf + res, "\n");
-	res++;
+	if (res) buf[res-1] = '\n'; /* eat the leftover space */
 	return res;
 }
 
@@ -815,7 +810,7 @@ static ssize_t bonding_show_downdelay(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.downdelay * bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.downdelay * bond->params.miimon);
 }
 
 static ssize_t bonding_store_downdelay(struct device *d,
@@ -872,7 +867,7 @@ static ssize_t bonding_show_updelay(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.updelay * bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.updelay * bond->params.miimon);
 
 }
 
@@ -936,7 +931,7 @@ static ssize_t bonding_show_lacp(struct device *d,
 
 	return sprintf(buf, "%s %d\n",
 		bond_lacp_tbl[bond->params.lacp_fast].modename,
-		bond->params.lacp_fast) + 1;
+		bond->params.lacp_fast);
 }
 
 static ssize_t bonding_store_lacp(struct device *d,
@@ -992,7 +987,7 @@ static ssize_t bonding_show_miimon(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.miimon);
 }
 
 static ssize_t bonding_store_miimon(struct device *d,
@@ -1083,9 +1078,9 @@ static ssize_t bonding_show_primary(struct device *d,
 	struct bonding *bond = to_bond(d);
 
 	if (bond->primary_slave)
-		count = sprintf(buf, "%s\n", bond->primary_slave->dev->name) + 1;
+		count = sprintf(buf, "%s\n", bond->primary_slave->dev->name);
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
@@ -1149,7 +1144,7 @@ static ssize_t bonding_show_carrier(struct device *d,
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.use_carrier) + 1;
+	return sprintf(buf, "%d\n", bond->params.use_carrier);
 }
 
 static ssize_t bonding_store_carrier(struct device *d,
@@ -1198,9 +1193,9 @@ static ssize_t bonding_show_active_slave(struct device *d,
 	read_unlock(&bond->curr_slave_lock);
 
 	if (USES_PRIMARY(bond->params.mode) && curr)
-		count = sprintf(buf, "%s\n", curr->dev->name) + 1;
+		count = sprintf(buf, "%s\n", curr->dev->name);
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 	return count;
 }
 
@@ -1295,7 +1290,7 @@ static ssize_t bonding_show_mii_status(struct device *d,
 	curr = bond->curr_active_slave;
 	read_unlock(&bond->curr_slave_lock);
 
-	return sprintf(buf, "%s\n", (curr) ? "up" : "down") + 1;
+	return sprintf(buf, "%s\n", (curr) ? "up" : "down");
 }
 static DEVICE_ATTR(mii_status, S_IRUGO, bonding_show_mii_status, NULL);
 
@@ -1312,10 +1307,10 @@ static ssize_t bonding_show_ad_aggregator(struct device *d,
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.aggregator_id) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.aggregator_id);
 	}
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
@@ -1334,10 +1329,10 @@ static ssize_t bonding_show_ad_num_ports(struct device *d,
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0: ad_info.ports) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0: ad_info.ports);
 	}
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
@@ -1356,10 +1351,10 @@ static ssize_t bonding_show_ad_actor_key(struct device *d,
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.actor_key) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.actor_key);
 	}
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
@@ -1378,10 +1373,10 @@ static ssize_t bonding_show_ad_partner_key(struct device *d,
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.partner_key) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.partner_key);
 	}
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
@@ -1403,12 +1398,11 @@ static ssize_t bonding_show_ad_partner_mac(struct device *d,
 		struct ad_info ad_info;
 		if (!bond_3ad_get_active_agg_info(bond, &ad_info)) {
 			count = sprintf(buf,"%s\n",
-					print_mac(mac, ad_info.partner_system))
-				+ 1;
+					print_mac(mac, ad_info.partner_system));
 		}
 	}
 	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "\n");
 
 	return count;
 }
-- 
1.4.4.4

