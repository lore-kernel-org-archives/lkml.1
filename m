Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbZDWICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbZDWICe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbZDWHhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:37:18 -0400
Received: from sous-sol.org ([216.99.217.87]:47522 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757776AbZDWHhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:37:16 -0400
Message-Id: <20090423073135.490055568@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:22:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Brian Haley <brian.haley@hp.com>,
       Jay Vosburgh <fubar@us.ibm.com>, David S Miller <davem@davemloft.net>
Subject: [patch 100/100] Bonding: fix zero address hole bug in arp_ip_target list
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=bonding-fix-zero-address-hole-bug-in-arp_ip_target-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Brian Haley <brian.haley@hp.com>

upstream commit: 5a31bec014449dc9ca994e4c1dbf2802b7ca458a

Fix a zero address hole bug in the bonding arp_ip_target list
that was causing the bond to ignore ARP replies (bugz 13006).
Instead of just setting the array entry to zero, we now
copy any additional entries down one slot, putting the
zero entry at the end.  With this change we can now have
all the loops that walk the array stop when they hit a zero
since there will be no addresses after it.

Changes are based in part on code fragment provided in kernel:
bugzilla 13006:

	http://bugzilla.kernel.org/show_bug.cgi?id=13006

by Steve Howard <steve@astutenetworks.com>

Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 Documentation/networking/bonding.txt |    2 +-
 drivers/net/bonding/bond_main.c      |    5 ++---
 drivers/net/bonding/bond_sysfs.c     |   14 ++++++++------
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -1242,7 +1242,7 @@ monitoring is enabled, and vice-versa.
 To add ARP targets:
 # echo +192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
 # echo +192.168.0.101 > /sys/class/net/bond0/bonding/arp_ip_target
-	NOTE:  up to 10 target addresses may be specified.
+	NOTE:  up to 16 target addresses may be specified.
 
 To remove an ARP target:
 # echo -192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2565,7 +2565,7 @@ static void bond_arp_send_all(struct bon
 
 	for (i = 0; (i < BOND_MAX_ARP_TARGETS); i++) {
 		if (!targets[i])
-			continue;
+			break;
 		pr_debug("basa: target %x\n", targets[i]);
 		if (list_empty(&bond->vlan_list)) {
 			pr_debug("basa: empty vlan: arp_send\n");
@@ -2672,7 +2672,6 @@ static void bond_validate_arp(struct bon
 	int i;
 	__be32 *targets = bond->params.arp_targets;
 
-	targets = bond->params.arp_targets;
 	for (i = 0; (i < BOND_MAX_ARP_TARGETS) && targets[i]; i++) {
 		pr_debug("bva: sip %pI4 tip %pI4 t[%d] %pI4 bhti(tip) %d\n",
 			&sip, &tip, i, &targets[i], bond_has_this_ip(bond, tip));
@@ -3294,7 +3293,7 @@ static void bond_info_show_master(struct
 
 		for(i = 0; (i < BOND_MAX_ARP_TARGETS) ;i++) {
 			if (!bond->params.arp_targets[i])
-				continue;
+				break;
 			if (printed)
 				seq_printf(seq, ",");
 			seq_printf(seq, " %pI4", &bond->params.arp_targets[i]);
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -684,17 +684,15 @@ static ssize_t bonding_store_arp_targets
 			goto out;
 		}
 		/* look for an empty slot to put the target in, and check for dupes */
-		for (i = 0; (i < BOND_MAX_ARP_TARGETS); i++) {
+		for (i = 0; (i < BOND_MAX_ARP_TARGETS) && !done; i++) {
 			if (targets[i] == newtarget) { /* duplicate */
 				printk(KERN_ERR DRV_NAME
 				       ": %s: ARP target %pI4 is already present\n",
 				       bond->dev->name, &newtarget);
-				if (done)
-					targets[i] = 0;
 				ret = -EINVAL;
 				goto out;
 			}
-			if (targets[i] == 0 && !done) {
+			if (targets[i] == 0) {
 				printk(KERN_INFO DRV_NAME
 				       ": %s: adding ARP target %pI4.\n",
 				       bond->dev->name, &newtarget);
@@ -720,12 +718,16 @@ static ssize_t bonding_store_arp_targets
 			goto out;
 		}
 
-		for (i = 0; (i < BOND_MAX_ARP_TARGETS); i++) {
+		for (i = 0; (i < BOND_MAX_ARP_TARGETS) && !done; i++) {
 			if (targets[i] == newtarget) {
+				int j;
 				printk(KERN_INFO DRV_NAME
 				       ": %s: removing ARP target %pI4.\n",
 				       bond->dev->name, &newtarget);
-				targets[i] = 0;
+				for (j = i; (j < (BOND_MAX_ARP_TARGETS-1)) && targets[j+1]; j++)
+					targets[j] = targets[j+1];
+
+				targets[j] = 0;
 				done = 1;
 			}
 		}

