Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbZFIKS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbZFIKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbZFIKQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:16:17 -0400
Received: from kroah.org ([198.145.64.141]:59853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760055AbZFIKQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:16:15 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:55 2009
Message-Id: <20090609094055.080659270@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:01 -0700
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
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/87] bonding: fix alb mode locking regression
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=bonding-fix-alb-mode-locking-regression.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Vosburgh <fubar@us.ibm.com>

[ Upstream commit 815bcc2719c12b6f5b511706e2d19728e07f0b02 ]

Fix locking issue in alb MAC address management; removed
incorrect locking and replaced with correct locking.  This bug was
introduced in commit 059fe7a578fba5bbb0fdc0365bfcf6218fa25eb0
("bonding: Convert locks to _bh, rework alb locking for new locking")

	Bug reported by Paul Smith <paul@mad-scientist.net>, who also
tested the fix.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_alb.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1739,9 +1739,6 @@ int bond_alb_set_mac_address(struct net_
 		}
 	}
 
-	write_unlock_bh(&bond->curr_slave_lock);
-	read_unlock(&bond->lock);
-
 	if (swap_slave) {
 		alb_swap_mac_addr(bond, swap_slave, bond->curr_active_slave);
 		alb_fasten_mac_swap(bond, swap_slave, bond->curr_active_slave);
@@ -1749,16 +1746,15 @@ int bond_alb_set_mac_address(struct net_
 		alb_set_slave_mac_addr(bond->curr_active_slave, bond_dev->dev_addr,
 				       bond->alb_info.rlb_enabled);
 
+		read_lock(&bond->lock);
 		alb_send_learning_packets(bond->curr_active_slave, bond_dev->dev_addr);
 		if (bond->alb_info.rlb_enabled) {
 			/* inform clients mac address has changed */
 			rlb_req_update_slave_clients(bond, bond->curr_active_slave);
 		}
+		read_unlock(&bond->lock);
 	}
 
-	read_lock(&bond->lock);
-	write_lock_bh(&bond->curr_slave_lock);
-
 	return 0;
 }
 


