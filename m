Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZKFWga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZKFWga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbZKFWg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:36:29 -0500
Received: from kroah.org ([198.145.64.141]:56859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760178AbZKFWW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.491007280@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [43/99] libertas if_usb: Fix crash on 64-bit machines
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=libertas-if_usb-fix-crash-on-64-bit-machines.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Woodhouse <dwmw2@infradead.org>

commit e9024a059f2c17fb2bfab212ee9d31511d7b8e57 upstream.

On a 64-bit kernel, skb->tail is an offset, not a pointer. The libertas
usb driver passes it to usb_fill_bulk_urb() anyway, causing interesting
crashes. Fix that by using skb->data instead.

This highlights a problem with usb_fill_bulk_urb(). It doesn't notice
when dma_map_single() fails and return the error to its caller as it
should. In fact it _can't_ currently return the error, since it returns
void.

So this problem was showing up only at unmap time, after we'd already
suffered memory corruption by doing DMA to a bogus address.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -507,7 +507,7 @@ static int __if_usb_submit_rx_urb(struct
 	/* Fill the receive configuration URB and initialise the Rx call back */
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
 			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
-			  (void *) (skb->tail + (size_t) IPFIELD_ALIGN_OFFSET),
+			  skb->data + IPFIELD_ALIGN_OFFSET,
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
 			  cardp);
 


