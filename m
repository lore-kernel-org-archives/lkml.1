Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752Ab0A0AHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0A0AHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972Ab0AZXnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:00 -0500
Received: from kroah.org ([198.145.64.141]:35074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0AZXm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.367237418@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [04/98] sfc: Fix DMA mapping cleanup in case of an error in TSO
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Turton <nturton@solarflare.com>

commit a7ebd27a13757248863cd61e541af7fa9e7727ee upstream.

We need buffer->len to remain valid to work out the correct address to
be unmapped.  We therefore need to clear buffer->len after the unmap
operation.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sfc/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/sfc/tx.c
+++ b/drivers/net/sfc/tx.c
@@ -821,8 +821,6 @@ static void efx_enqueue_unwind(struct ef
 					   tx_queue->efx->type->txd_ring_mask];
 		efx_tsoh_free(tx_queue, buffer);
 		EFX_BUG_ON_PARANOID(buffer->skb);
-		buffer->len = 0;
-		buffer->continuation = true;
 		if (buffer->unmap_len) {
 			unmap_addr = (buffer->dma_addr + buffer->len -
 				      buffer->unmap_len);
@@ -836,6 +834,8 @@ static void efx_enqueue_unwind(struct ef
 					       PCI_DMA_TODEVICE);
 			buffer->unmap_len = 0;
 		}
+		buffer->len = 0;
+		buffer->continuation = true;
 	}
 }
 


