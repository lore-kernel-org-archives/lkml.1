Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZESDkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZESDkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 23:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZESDkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 23:40:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48776 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZESDkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 23:40:01 -0400
Date: Tue, 19 May 2009 13:39:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Vasu Dev <vasu.dev@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
       Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Chris Leech <christopher.leech@intel.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20090519133958.31ec120b.sfr@canb.auug.org.au>
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
6401bdcad536cc00589c38e7e1c140d3acc00087 ("[SCSI] fcoe: fip: add
multicast filter to receive FIP advertisements") from Linus' tree and
commit 184dd3459bb334d9061b58faed3610d08d6c7ff8 ("fcoe: adds spma mode
support") from the net tree.

There is another trivial conflict between commit
dd3fd72e692c8af007f70df4433c0cffe8582d8b ("[SCSI] fcoe: fix spelling
typos and bad comments") from Linus' tree and commit
ab6b85c1d7a1bf6c2b27fb542a7b2404e45b7e24 ("fcoe: consolidates netdev
related config and cleanup for spma mode") from the net tree.

Just context changes.  I fixed them up (see below) and can carry them for
a while.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/fcoe/fcoe.c
index 03e1926,f2d1612..0000000
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@@ -136,8 -136,61 +136,60 @@@ static struct scsi_host_template fcoe_s
  };
  
  /**
+  * fcoe_fip_recv - handle a received FIP frame.
+  * @skb: the receive skb
+  * @dev: associated &net_device
+  * @ptype: the &packet_type structure which was used to register this handler.
+  * @orig_dev: original receive &net_device, in case @dev is a bond.
+  *
+  * Returns: 0 for success
+  */
+ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
+ 			 struct packet_type *ptype,
+ 			 struct net_device *orig_dev)
+ {
+ 	struct fcoe_softc *fc;
+ 
+ 	fc = container_of(ptype, struct fcoe_softc, fip_packet_type);
+ 	fcoe_ctlr_recv(&fc->ctlr, skb);
+ 	return 0;
+ }
+ 
+ /**
+  * fcoe_fip_send() - send an Ethernet-encapsulated FIP frame.
+  * @fip: FCoE controller.
+  * @skb: FIP Packet.
+  */
+ static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
+ {
+ 	skb->dev = fcoe_from_ctlr(fip)->real_dev;
+ 	dev_queue_xmit(skb);
+ }
+ 
+ /**
+  * fcoe_update_src_mac() - Update Ethernet MAC filters.
+  * @fip: FCoE controller.
+  * @old: Unicast MAC address to delete if the MAC is non-zero.
+  * @new: Unicast MAC address to add.
+  *
+  * Remove any previously-set unicast MAC filter.
+  * Add secondary FCoE MAC address filter for our OUI.
+  */
+ static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new)
+ {
+ 	struct fcoe_softc *fc;
+ 
+ 	fc = fcoe_from_ctlr(fip);
+ 	rtnl_lock();
+ 	if (!is_zero_ether_addr(old))
+ 		dev_unicast_delete(fc->real_dev, old, ETH_ALEN);
+ 	dev_unicast_add(fc->real_dev, new, ETH_ALEN);
+ 	rtnl_unlock();
+ }
+ 
+ /**
   * fcoe_lport_config() - sets up the fc_lport
   * @lp: ptr to the fc_lport
 - * @shost: ptr to the parent scsi host
   *
   * Returns: 0 for success
   */
@@@ -255,7 -349,8 +348,9 @@@ static int fcoe_netdev_config(struct fc
  	rtnl_lock();
  	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
  	dev_unicast_add(fc->real_dev, flogi_maddr, ETH_ALEN);
 +	dev_mc_add(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
+ 	if (fc->ctlr.spma)
+ 		dev_unicast_add(fc->real_dev, fc->ctlr.ctl_src_addr, ETH_ALEN);
  	rtnl_unlock();
  
  	/*
@@@ -370,17 -470,7 +470,7 @@@ static int fcoe_if_destroy(struct net_d
  	if (lp->emp)
  		fc_exch_mgr_free(lp->emp);
  
- 	/* Delete secondary MAC addresses */
- 	rtnl_lock();
- 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
- 	dev_unicast_delete(fc->real_dev, flogi_maddr, ETH_ALEN);
- 	if (!is_zero_ether_addr(fc->ctlr.data_src_addr))
- 		dev_unicast_delete(fc->real_dev,
- 				   fc->ctlr.data_src_addr, ETH_ALEN);
- 	dev_mc_delete(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
- 	rtnl_unlock();
- 
 -	/* Free the per-CPU revieve threads */
 +	/* Free the per-CPU receive threads */
  	fcoe_percpu_clean(lp);
  
  	/* Free existing skbs */
