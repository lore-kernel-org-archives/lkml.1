Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZG1XES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZG1XES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZG1XEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:15 -0400
Received: from kroah.org ([198.145.64.141]:43085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbZG1XEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:45 2009
Message-Id: <20090728225945.720514810@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:59:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/37] sky2: Fix checksum endianness
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=sky2-fix-checksum-endianness.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@ru.mvista.com>

[ Upstream commit b9389796fa4c87fbdff33816e317cdae5f36dd0b ]

sky2 driver on PowerPC targets floods kernel log with following errors:

  eth1: hw csum failure.
  Call Trace:
  [ef84b8a0] [c00075e4] show_stack+0x50/0x160 (unreliable)
  [ef84b8d0] [c02fa178] netdev_rx_csum_fault+0x3c/0x5c
  [ef84b8f0] [c02f6920] __skb_checksum_complete_head+0x7c/0x84
  [ef84b900] [c02f693c] __skb_checksum_complete+0x14/0x24
  [ef84b910] [c0337e08] tcp_v4_rcv+0x4c8/0x6f8
  [ef84b940] [c031a9c8] ip_local_deliver+0x98/0x210
  [ef84b960] [c031a788] ip_rcv+0x38c/0x534
  [ef84b990] [c0300338] netif_receive_skb+0x260/0x36c
  [ef84b9c0] [c025de00] sky2_poll+0x5dc/0xcf8
  [ef84ba20] [c02fb7fc] net_rx_action+0xc0/0x144

The NIC is Yukon-2 EC chip revision 1.

Converting checksum field from le16 to CPU byte order fixes the issue.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sky2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2393,7 +2393,7 @@ static int sky2_status_intr(struct sky2_
 			if (likely(status >> 16 == (status & 0xffff))) {
 				skb = sky2->rx_ring[sky2->rx_next].skb;
 				skb->ip_summed = CHECKSUM_COMPLETE;
-				skb->csum = status & 0xffff;
+				skb->csum = le16_to_cpu(status);
 			} else {
 				printk(KERN_NOTICE PFX "%s: hardware receive "
 				       "checksum problem (status = %#x)\n",


