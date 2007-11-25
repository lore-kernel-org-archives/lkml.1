Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXKYPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXKYPNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXKYPNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 10:13:07 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:32896 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXKYPNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:13:06 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: wferi@niif.hu
Subject: bonding sysfs output
Date: Sun, 25 Nov 2007 16:12:57 +0100
Message-ID: <87tznafjeu.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

Am I totally of the limit with the attached patch against
drivers/net/bonding/bond_sysfs.c?  I'd like to receive some comments,
as I'm not a kernel developer.

I propose it as a fix for trailing NULs and spaces like eg.

$ od -c /sys/class/net/bond0/bonding/slaves 
0000000   e   t   h   -   l   e   f   t       e   t   h   -   r   i   g
0000020   h   t      \n  \0
0000025

I'm afraid there're other problems with "++more++" handling, but let's
not consider those just yet.  Find the patch attached.  The first
hunks also renames buffer to buf, for consistency's shake.

The original version had varying behaviour for Not Applicable cases.
This patch also settles for empty files (not even a line feed) in
those cases, but I'm not sure about the general policy on this matter.

Regards,
Feri.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=bond_sysfs.patch

--- bond_sysfs.c.orig	2007-11-16 19:14:27.000000000 +0100
+++ bond_sysfs.c	2007-11-25 16:01:23.092973099 +0100
@@ -74,7 +74,7 @@
  * "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
-static ssize_t bonding_show_bonds(struct class *cls, char *buffer)
+static ssize_t bonding_show_bonds(struct class *cls, char *buf)
 {
 	int res = 0;
 	struct bonding *bond;
@@ -86,14 +86,13 @@
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buffer + res, "++more++");
+			res += sprintf(buf + res, "++more++ ");
 			break;
 		}
-		res += sprintf(buffer + res, "%s ",
+		res += sprintf(buf + res, "%s ",
 			       bond->dev->name);
 	}
-	res += sprintf(buffer + res, "\n");
-	res++;
+	if (res) buf[res-1] = '\n'; /* eat the leftover space */
 	up_read(&(bonding_rwsem));
 	return res;
 }
@@ -237,14 +236,13 @@
 			/* not enough space for another interface name */
 			if ((PAGE_SIZE - res) > 10)
 				res = PAGE_SIZE - 10;
-			res += sprintf(buf + res, "++more++");
+			res += sprintf(buf + res, "++more++ ");
 			break;
 		}
 		res += sprintf(buf + res, "%s ", slave->dev->name);
 	}
 	read_unlock_bh(&bond->lock);
-	res += sprintf(buf + res, "\n");
-	res++;
+	if (res) buf[res-1] = '\n'; /* eat the leftover space */
 	return res;
 }
 
@@ -401,7 +399,7 @@
 
 	return sprintf(buf, "%s %d\n",
 			bond_mode_tbl[bond->params.mode].modename,
-			bond->params.mode) + 1;
+			bond->params.mode);
 }
 
 static ssize_t bonding_store_mode(struct device *d,
@@ -452,17 +450,14 @@
 				      struct device_attribute *attr,
 				      char *buf)
 {
-	int count;
+	int count = 0;
 	struct bonding *bond = to_bond(d);
 
-	if ((bond->params.mode != BOND_MODE_XOR) &&
-	    (bond->params.mode != BOND_MODE_8023AD)) {
-		// Not Applicable
-		count = sprintf(buf, "NA\n") + 1;
-	} else {
+	if ((bond->params.mode == BOND_MODE_XOR) ||
+	    (bond->params.mode == BOND_MODE_8023AD)) {
 		count = sprintf(buf, "%s %d\n",
 			xmit_hashtype_tbl[bond->params.xmit_policy].modename,
-			bond->params.xmit_policy) + 1;
+			bond->params.xmit_policy);
 	}
 
 	return count;
@@ -522,7 +517,7 @@
 
 	return sprintf(buf, "%s %d\n",
 		       arp_validate_tbl[bond->params.arp_validate].modename,
-		       bond->params.arp_validate) + 1;
+		       bond->params.arp_validate);
 }
 
 static ssize_t bonding_store_arp_validate(struct device *d,
@@ -574,7 +569,7 @@
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.arp_interval) + 1;
+	return sprintf(buf, "%d\n", bond->params.arp_interval);
 }
 
 static ssize_t bonding_store_arp_interval(struct device *d,
@@ -671,10 +666,7 @@
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
 
@@ -775,7 +767,7 @@
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.downdelay * bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.downdelay * bond->params.miimon);
 }
 
 static ssize_t bonding_store_downdelay(struct device *d,
@@ -832,7 +824,7 @@
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.updelay * bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.updelay * bond->params.miimon);
 
 }
 
@@ -896,7 +888,7 @@
 
 	return sprintf(buf, "%s %d\n",
 		bond_lacp_tbl[bond->params.lacp_fast].modename,
-		bond->params.lacp_fast) + 1;
+		bond->params.lacp_fast);
 }
 
 static ssize_t bonding_store_lacp(struct device *d,
@@ -952,7 +944,7 @@
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.miimon) + 1;
+	return sprintf(buf, "%d\n", bond->params.miimon);
 }
 
 static ssize_t bonding_store_miimon(struct device *d,
@@ -1053,9 +1045,7 @@
 	struct bonding *bond = to_bond(d);
 
 	if (bond->primary_slave)
-		count = sprintf(buf, "%s\n", bond->primary_slave->dev->name) + 1;
-	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "%s\n", bond->primary_slave->dev->name);
 
 	return count;
 }
@@ -1116,7 +1106,7 @@
 {
 	struct bonding *bond = to_bond(d);
 
-	return sprintf(buf, "%d\n", bond->params.use_carrier) + 1;
+	return sprintf(buf, "%d\n", bond->params.use_carrier);
 }
 
 static ssize_t bonding_store_carrier(struct device *d,
@@ -1158,7 +1148,7 @@
 {
 	struct slave *curr;
 	struct bonding *bond = to_bond(d);
-	int count;
+	int count = 0;
 
 
 	read_lock(&bond->curr_slave_lock);
@@ -1166,9 +1156,7 @@
 	read_unlock(&bond->curr_slave_lock);
 
 	if (USES_PRIMARY(bond->params.mode) && curr)
-		count = sprintf(buf, "%s\n", curr->dev->name) + 1;
-	else
-		count = sprintf(buf, "\n") + 1;
+		count = sprintf(buf, "%s\n", curr->dev->name);
 	return count;
 }
 
@@ -1259,7 +1247,7 @@
 	curr = bond->curr_active_slave;
 	read_unlock(&bond->curr_slave_lock);
 
-	return sprintf(buf, "%s\n", (curr) ? "up" : "down") + 1;
+	return sprintf(buf, "%s\n", (curr) ? "up" : "down");
 }
 static DEVICE_ATTR(mii_status, S_IRUGO, bonding_show_mii_status, NULL);
 
@@ -1276,10 +1264,8 @@
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.aggregator_id) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.aggregator_id);
 	}
-	else
-		count = sprintf(buf, "\n") + 1;
 
 	return count;
 }
@@ -1298,10 +1284,8 @@
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0: ad_info.ports) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0: ad_info.ports);
 	}
-	else
-		count = sprintf(buf, "\n") + 1;
 
 	return count;
 }
@@ -1320,10 +1304,8 @@
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.actor_key) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.actor_key);
 	}
-	else
-		count = sprintf(buf, "\n") + 1;
 
 	return count;
 }
@@ -1342,10 +1324,8 @@
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
-		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.partner_key) + 1;
+		count = sprintf(buf, "%d\n", (bond_3ad_get_active_agg_info(bond, &ad_info)) ?  0 : ad_info.partner_key);
 	}
-	else
-		count = sprintf(buf, "\n") + 1;
 
 	return count;
 }
@@ -1371,11 +1351,9 @@
 				       ad_info.partner_system[2],
 				       ad_info.partner_system[3],
 				       ad_info.partner_system[4],
-				       ad_info.partner_system[5]) + 1;
+				       ad_info.partner_system[5]);
 		}
 	}
-	else
-		count = sprintf(buf, "\n") + 1;
 
 	return count;
 }

--=-=-=--
