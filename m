Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYFSVdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYFSVdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYFSVb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:31:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:42664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYFSVb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:31:56 -0400
Date: Thu, 19 Jun 2008 14:29:50 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, virtualization@lists.linux-foundation.org,
       Mark McLoughlin <markmc@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 05/15] virtio_net: Fix skb->csum_start computation
Message-ID: <20080619212950.GF20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="virtio_net-fix-skb-csum_start-computation.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mark McLoughlin <markmc@redhat.com>

commit 23cde76d801246a702e7a84c3fe3d655b35c89a1 upstream.

hdr->csum_start is the offset from the start of the ethernet
header to the transport layer checksum field. skb->csum_start
is the offset from skb->head.

skb_partial_csum_set() assumes that skb->data points to the
ethernet header - i.e. it computes skb->csum_start by adding
the headroom to hdr->csum_start.

Since eth_type_trans() skb_pull()s the ethernet header,
skb_partial_csum_set() should be called before
eth_type_trans().

(Without this patch, GSO packets from a guest to the world outside the
host are corrupted).

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/virtio_net.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -83,9 +83,7 @@ static void receive_skb(struct net_devic
 	BUG_ON(len > MAX_PACKET_LEN);
 
 	skb_trim(skb, len);
-	skb->protocol = eth_type_trans(skb, dev);
-	pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
-		 ntohs(skb->protocol), skb->len, skb->pkt_type);
+
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
 
@@ -95,6 +93,10 @@ static void receive_skb(struct net_devic
 			goto frame_err;
 	}
 
+	skb->protocol = eth_type_trans(skb, dev);
+	pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
+		 ntohs(skb->protocol), skb->len, skb->pkt_type);
+
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {

-- 
