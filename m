Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbYJEQko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbYJEQko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbYJEQhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:37:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35299 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760249AbYJEQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:37:34 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 11/19] mptlan: Kill unused NAA workaround code
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:37:29 +0100
Message-ID: <20081005163722.3799.34108.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This triggers false bug reports as it does a bogus kmalloc with locks held
but is never really compiled

Closes #8329

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/message/fusion/mptlan.c |  108 ---------------------------------------
 1 files changed, 0 insertions(+), 108 deletions(-)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index a1abf95..603ffd0 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -77,12 +77,6 @@ MODULE_VERSION(my_VERSION);
  *  Fusion MPT LAN private structures
  */
 
-struct NAA_Hosed {
-	u16 NAA;
-	u8 ieee[FC_ALEN];
-	struct NAA_Hosed *next;
-};
-
 struct BufferControl {
 	struct sk_buff	*skb;
 	dma_addr_t	dma;
@@ -159,11 +153,6 @@ static u8 LanCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u32 max_buckets_out = 127;
 static u32 tx_max_out_p = 127 - 16;
 
-#ifdef QLOGIC_NAA_WORKAROUND
-static struct NAA_Hosed *mpt_bad_naa = NULL;
-DEFINE_RWLOCK(bad_naa_lock);
-#endif
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	lan_reply - Handle all data sent from the hardware.
@@ -780,30 +769,6 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 //			ctx, skb, skb->data));
 
 	mac = skb_mac_header(skb);
-#ifdef QLOGIC_NAA_WORKAROUND
-{
-	struct NAA_Hosed *nh;
-
-	/* Munge the NAA for Tx packets to QLogic boards, which don't follow
-	   RFC 2625. The longer I look at this, the more my opinion of Qlogic
-	   drops. */
-	read_lock_irq(&bad_naa_lock);
-	for (nh = mpt_bad_naa; nh != NULL; nh=nh->next) {
-		if ((nh->ieee[0] == mac[0]) &&
-		    (nh->ieee[1] == mac[1]) &&
-		    (nh->ieee[2] == mac[2]) &&
-		    (nh->ieee[3] == mac[3]) &&
-		    (nh->ieee[4] == mac[4]) &&
-		    (nh->ieee[5] == mac[5])) {
-			cur_naa = nh->NAA;
-			dlprintk ((KERN_INFO "mptlan/sdu_send: using NAA value "
-				  "= %04x.\n", cur_naa));
-			break;
-		}
-	}
-	read_unlock_irq(&bad_naa_lock);
-}
-#endif
 
 	pTrans->TransactionDetails[0] = cpu_to_le32((cur_naa         << 16) |
 						    (mac[0] <<  8) |
@@ -1572,79 +1537,6 @@ mpt_lan_type_trans(struct sk_buff *skb, struct net_device *dev)
 
 	fcllc = (struct fcllc *)skb->data;
 
-#ifdef QLOGIC_NAA_WORKAROUND
-{
-	u16 source_naa = fch->stype, found = 0;
-
-	/* Workaround for QLogic not following RFC 2625 in regards to the NAA
-	   value. */
-
-	if ((source_naa & 0xF000) == 0)
-		source_naa = swab16(source_naa);
-
-	if (fcllc->ethertype == htons(ETH_P_ARP))
-	    dlprintk ((KERN_INFO "mptlan/type_trans: got arp req/rep w/ naa of "
-		      "%04x.\n", source_naa));
-
-	if ((fcllc->ethertype == htons(ETH_P_ARP)) &&
-	   ((source_naa >> 12) !=  MPT_LAN_NAA_RFC2625)){
-		struct NAA_Hosed *nh, *prevnh;
-		int i;
-
-		dlprintk ((KERN_INFO "mptlan/type_trans: ARP Req/Rep from "
-			  "system with non-RFC 2625 NAA value (%04x).\n",
-			  source_naa));
-
-		write_lock_irq(&bad_naa_lock);
-		for (prevnh = nh = mpt_bad_naa; nh != NULL;
-		     prevnh=nh, nh=nh->next) {
-			if ((nh->ieee[0] == fch->saddr[0]) &&
-			    (nh->ieee[1] == fch->saddr[1]) &&
-			    (nh->ieee[2] == fch->saddr[2]) &&
-			    (nh->ieee[3] == fch->saddr[3]) &&
-			    (nh->ieee[4] == fch->saddr[4]) &&
-			    (nh->ieee[5] == fch->saddr[5])) {
-				found = 1;
-				dlprintk ((KERN_INFO "mptlan/type_trans: ARP Re"
-					 "q/Rep w/ bad NAA from system already"
-					 " in DB.\n"));
-				break;
-			}
-		}
-
-		if ((!found) && (nh == NULL)) {
-
-			nh = kmalloc(sizeof(struct NAA_Hosed), GFP_KERNEL);
-			dlprintk ((KERN_INFO "mptlan/type_trans: ARP Req/Rep w/"
-				 " bad NAA from system not yet in DB.\n"));
-
-			if (nh != NULL) {
-				nh->next = NULL;
-				if (!mpt_bad_naa)
-					mpt_bad_naa = nh;
-				if (prevnh)
-					prevnh->next = nh;
-
-				nh->NAA = source_naa; /* Set the S_NAA value. */
-				for (i = 0; i < FC_ALEN; i++)
-					nh->ieee[i] = fch->saddr[i];
-				dlprintk ((KERN_INFO "Got ARP from %02x:%02x:%02x:%02x:"
-					  "%02x:%02x with non-compliant S_NAA value.\n",
-					  fch->saddr[0], fch->saddr[1], fch->saddr[2],
-					  fch->saddr[3], fch->saddr[4],fch->saddr[5]));
-			} else {
-				printk (KERN_ERR "mptlan/type_trans: Unable to"
-					" kmalloc a NAA_Hosed struct.\n");
-			}
-		} else if (!found) {
-			printk (KERN_ERR "mptlan/type_trans: found not"
-				" set, but nh isn't null. Evil "
-				"funkiness abounds.\n");
-		}
-		write_unlock_irq(&bad_naa_lock);
-	}
-}
-#endif
 
 	/* Strip the SNAP header from ARP packets since we don't
 	 * pass them through to the 802.2/SNAP layers.

