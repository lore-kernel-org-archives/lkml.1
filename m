Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZLGAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZLGAVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZLGANp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:45 -0500
Received: from kroah.org ([198.145.64.141]:34577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410AbZLGANd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:54 2009
Message-Id: <20091207000654.200910138@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [077/119] sfc: Set ip_summed correctly for page buffers passed to GRO
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sfc-set-ip_summed-correctly-for-page-buffers-passed-to-gro.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 345056af41feeda506a8993474b9cbb2c66bc9fb ]

Page buffers containing packets with an incorrect checksum or using a
protocol not handled by hardware checksum offload were previously not
passed to LRO.  The conversion to GRO changed this, but did not set
the ip_summed value accordingly.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sfc/rx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -444,7 +444,8 @@ static void efx_rx_packet__check_len(str
  * the appropriate LRO method
  */
 static void efx_rx_packet_lro(struct efx_channel *channel,
-			      struct efx_rx_buffer *rx_buf)
+			      struct efx_rx_buffer *rx_buf,
+			      bool checksummed)
 {
 	struct napi_struct *napi = &channel->napi_str;
 
@@ -466,7 +467,8 @@ static void efx_rx_packet_lro(struct efx
 		skb->len = rx_buf->len;
 		skb->data_len = rx_buf->len;
 		skb->truesize += rx_buf->len;
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->ip_summed =
+			checksummed ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE;
 
 		napi_gro_frags(napi);
 
@@ -475,6 +477,7 @@ out:
 		rx_buf->page = NULL;
 	} else {
 		EFX_BUG_ON_PARANOID(!rx_buf->skb);
+		EFX_BUG_ON_PARANOID(!checksummed);
 
 		napi_gro_receive(napi, rx_buf->skb);
 		rx_buf->skb = NULL;
@@ -570,7 +573,7 @@ void __efx_rx_packet(struct efx_channel 
 	}
 
 	if (likely(checksummed || rx_buf->page)) {
-		efx_rx_packet_lro(channel, rx_buf);
+		efx_rx_packet_lro(channel, rx_buf, checksummed);
 		goto done;
 	}
 


