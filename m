Return-Path: <linux-kernel-owner+w=401wt.eu-S934961AbYBWAwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbYBWAwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763359AbYBWAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:55789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935065AbYBWAgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:31 -0500
Date: Fri, 22 Feb 2008 16:31:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Vosburgh <fubar@us.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 37/38] bonding: fix NULL pointer deref in startup processing
Message-ID: <20080223003140.GL7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bonding-fix-null-pointer-deref-in-startup-processing.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jay Vosburgh <fubar@us.ibm.com>

patch 4fe4763cd8cacd81d892193efb48b99c99c15323 in mainline.

	Fix the "are we creating a duplicate" check to not compare
the name if the name is NULL (meaning that the system should select
a name).  Bug reported by Benny Amorsen <benny+usenet@amorsen.dk>.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4883,14 +4883,16 @@ int bond_create(char *name, struct bond_
 	down_write(&bonding_rwsem);
 
 	/* Check to see if the bond already exists. */
-	list_for_each_entry_safe(bond, nxt, &bond_dev_list, bond_list)
-		if (strnicmp(bond->dev->name, name, IFNAMSIZ) == 0) {
-			printk(KERN_ERR DRV_NAME
+	if (name) {
+		list_for_each_entry_safe(bond, nxt, &bond_dev_list, bond_list)
+			if (strnicmp(bond->dev->name, name, IFNAMSIZ) == 0) {
+				printk(KERN_ERR DRV_NAME
 			       ": cannot add bond %s; it already exists\n",
-			       name);
-			res = -EPERM;
-			goto out_rtnl;
-		}
+				       name);
+				res = -EPERM;
+				goto out_rtnl;
+			}
+	}
 
 	bond_dev = alloc_netdev(sizeof(struct bonding), name ? name : "",
 				ether_setup);

-- 
