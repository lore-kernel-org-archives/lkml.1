Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZFIDTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZFIDTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 23:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZFIDTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 23:19:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59628 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZFIDTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 23:19:10 -0400
Date: Tue, 9 Jun 2009 13:19:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vasu Dev <vasu.dev@intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the net tree with the scsi tree
Message-Id: <20090609131910.3c6e78f2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the net tree got a conflict in
drivers/scsi/fcoe/fcoe.c between commit
1047f22108bd9bfedefd3ff014cb56691dfbaa3f ("[SCSI] fcoe: removes
fcoe_watchdog") from the scsi tree and commit
ab6b85c1d7a1bf6c2b27fb542a7b2404e45b7e24 ("fcoe: consolidates netdev
related config and cleanup for spma mode") from the net tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/fcoe/fcoe.c
index e606b48,f791348..0000000
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@@ -167,18 -219,30 +219,42 @@@ static int fcoe_lport_config(struct fc_
  }
  
  /**
 + * fcoe_queue_timer() - fcoe queue timer
 + * @lp: the fc_lport pointer
 + *
 + * Calls fcoe_check_wait_queue on timeout
 + *
 + */
 +static void fcoe_queue_timer(ulong lp)
 +{
 +	fcoe_check_wait_queue((struct fc_lport *)lp, NULL);
 +}
 +
 +/**
+  * fcoe_netdev_cleanup() - clean up netdev configurations
+  * @fc: ptr to the fcoe_softc
+  */
+ void fcoe_netdev_cleanup(struct fcoe_softc *fc)
+ {
+ 	u8 flogi_maddr[ETH_ALEN];
+ 
+ 	/* Don't listen for Ethernet packets anymore */
+ 	dev_remove_pack(&fc->fcoe_packet_type);
+ 	dev_remove_pack(&fc->fip_packet_type);
+ 
+ 	/* Delete secondary MAC addresses */
+ 	rtnl_lock();
+ 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
+ 	dev_unicast_delete(fc->real_dev, flogi_maddr);
+ 	if (!is_zero_ether_addr(fc->ctlr.data_src_addr))
+ 		dev_unicast_delete(fc->real_dev, fc->ctlr.data_src_addr);
+ 	if (fc->ctlr.spma)
+ 		dev_unicast_delete(fc->real_dev, fc->ctlr.ctl_src_addr);
+ 	dev_mc_delete(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+ 	rtnl_unlock();
+ }
+ 
+ /**
   * fcoe_netdev_config() - Set up netdev for SW FCoE
   * @lp : ptr to the fc_lport
   * @netdev : ptr to the associated netdevice struct
@@@ -248,11 -313,24 +325,25 @@@ static int fcoe_netdev_config(struct fc
  	}
  	skb_queue_head_init(&fc->fcoe_pending_queue);
  	fc->fcoe_pending_queue_active = 0;
 +	setup_timer(&fc->timer, fcoe_queue_timer, (unsigned long)lp);
  
+ 	/* look for SAN MAC address, if multiple SAN MACs exist, only
+ 	 * use the first one for SPMA */
+ 	rcu_read_lock();
+ 	for_each_dev_addr(netdev, ha) {
+ 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
+ 		    (is_valid_ether_addr(fc->ctlr.ctl_src_addr))) {
+ 			memcpy(fc->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
+ 			fc->ctlr.spma = 1;
+ 			break;
+ 		}
+ 	}
+ 	rcu_read_unlock();
+ 
  	/* setup Source Mac Address */
- 	memcpy(fc->ctlr.ctl_src_addr, fc->real_dev->dev_addr,
- 	       fc->real_dev->addr_len);
+ 	if (!fc->ctlr.spma)
+ 		memcpy(fc->ctlr.ctl_src_addr, fc->real_dev->dev_addr,
+ 		       fc->real_dev->addr_len);
  
  	wwnn = fcoe_wwn_from_mac(fc->real_dev->dev_addr, 1, 0);
  	fc_set_wwnn(lp, wwnn);
