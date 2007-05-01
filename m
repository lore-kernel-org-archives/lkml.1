Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbXEALrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbXEALrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXEALrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:47:14 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4707 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXEALrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:47:12 -0400
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 07:47:12 EDT
Date: Tue, 1 May 2007 06:24:14 -0500 (CDT)
Message-Id: <200705011124.l41BOEG4007662@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] e100 rx: or s and el bits
To: Scott Feldman <sfeldma@pobox.com>, Jeff Garzik <jeff@garzik.org>
Cc: <e1000-devel@lists.sourceforge.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In commit d52df4a35af569071fda3f4eb08e47cc7023f094, the description
talks about emulating another driver by setting addtional bits and
the being unable to test when submitted.  Seeing the & operator to
set more bits made me suspicious, and indeed the bits are defined
in positive logic:

	cb_s      = 0x4000,
	cb_el     = 0x8000,

So anding those together would be 0.   I'm guessing they should
be or'd, but don't have hardware here to test, much like the
committed patch.  In fact, I'll let someone else do the compile
test too.  I'll update the comment.

(It looks like the end of list and s bits would not be set
in the template nor cleared when linking in recieve skbs, so
as long as the kernel can keep up with the 100Mb card we 
wouldn't see the adapter go off the linked list, possibly
explaining any successful use of this patch written against
2.6.14).

Signed-off-by: Milton Miller <miltonm@bga.com>


--- linux-2.6/drivers/net/e100.c.orig	2007-05-01 05:19:17.000000000 -0500
+++ linux-2.6/drivers/net/e100.c	2007-05-01 05:22:14.000000000 -0500
@@ -947,7 +947,7 @@ static void e100_get_defaults(struct nic
 		((nic->mac >= mac_82558_D101_A4) ? cb_cid : cb_i));
 
 	/* Template for a freshly allocated RFD */
-	nic->blank_rfd.command = cpu_to_le16(cb_el & cb_s);
+	nic->blank_rfd.command = cpu_to_le16(cb_el | cb_s);
 	nic->blank_rfd.rbd = 0xFFFFFFFF;
 	nic->blank_rfd.size = cpu_to_le16(VLAN_ETH_FRAME_LEN);
 
@@ -1769,13 +1769,13 @@ static int e100_rx_alloc_skb(struct nic 
 	}
 
 	/* Link the RFD to end of RFA by linking previous RFD to
-	 * this one, and clearing EL bit of previous.  */
+	 * this one, and clearing EL and S bit of previous.  */
 	if(rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
 		put_unaligned(cpu_to_le32(rx->dma_addr),
 			(u32 *)&prev_rfd->link);
 		wmb();
-		prev_rfd->command &= ~cpu_to_le16(cb_el & cb_s);
+		prev_rfd->command &= ~cpu_to_le16(cb_el | cb_s);
 		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
 			sizeof(struct rfd), PCI_DMA_TODEVICE);
 	}
