Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXLBNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXLBNLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXLBNLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:11:25 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:46327 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbXLBNLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:11:24 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 5/5] net/bonding: Allow setting and querying xmit policy regardless of mode
References: <87wss3jin5.fsf@szonett.ki.iif.hu>
	<871wabkxcd.fsf@szonett.ki.iif.hu>
	<20071127194929.757e4ebe.randy.dunlap@oracle.com>
	<87bq9ekb8m.fsf@szonett.ki.iif.hu> <474D8B83.9050609@oracle.com>
	<87wss1c3d8.fsf_-_@szonett.ki.iif.hu> <26966.1196298795@death>
Date: Sun, 02 Dec 2007 14:11:13 +0100
In-Reply-To: <26966.1196298795@death> (Jay Vosburgh's message of "Wed, 28 Nov
	2007 17:13:15 -0800, Wed, 28 Nov 2007 17:01:23 -0800")
Message-ID: <87ir3hz1fy.fsf_-_@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency with the behaviour of the arp_ip_target option,
let /sys/class/net/bond0/bonding/xmit_hash_policy accept and report
current policy even if the bonding mode in effect does not use it.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/net/bonding/bond_sysfs.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 9de2c52..11b76b3 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -456,17 +456,11 @@ static ssize_t bonding_show_xmit_hash(struct device *d,
 				      struct device_attribute *attr,
 				      char *buf)
 {
-	int count = 0;
 	struct bonding *bond = to_bond(d);
 
-	if ((bond->params.mode == BOND_MODE_XOR) ||
-	    (bond->params.mode == BOND_MODE_8023AD)) {
-		count = sprintf(buf, "%s %d\n",
-			xmit_hashtype_tbl[bond->params.xmit_policy].modename,
-			bond->params.xmit_policy);
-	}
-
-	return count;
+	return sprintf(buf, "%s %d\n",
+		       xmit_hashtype_tbl[bond->params.xmit_policy].modename,
+		       bond->params.xmit_policy);
 }
 
 static ssize_t bonding_store_xmit_hash(struct device *d,
@@ -484,15 +478,6 @@ static ssize_t bonding_store_xmit_hash(struct device *d,
 		goto out;
 	}
 
-	if ((bond->params.mode != BOND_MODE_XOR) &&
-	    (bond->params.mode != BOND_MODE_8023AD)) {
-		printk(KERN_ERR DRV_NAME
-		       "%s: Transmit hash policy is irrelevant in this mode.\n",
-		       bond->dev->name);
-		ret = -EPERM;
-		goto out;
-	}
-
 	new_value = bond_parse_parm((char *)buf, xmit_hashtype_tbl);
 	if (new_value < 0)  {
 		printk(KERN_ERR DRV_NAME
-- 
1.4.4.4

