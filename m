Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0BDRel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:34:41 -0500
Received: from kroah.org ([198.145.64.141]:34650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933027Ab0BDRVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:42 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:59 2010
Message-Id: <20100204171459.393442905@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [19/74] e1000/e1000e: dont use small hardware rx buffers
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 9926146b15fd96d78a4f7c32e7a26d50639369f4 upstream.

When testing the "e1000: enhance frame fragment detection" (and e1000e)
patches we found some bugs with reducing the MTU size.  The 1024 byte
descriptor used with the 1000 mtu test also (re) introduced the
(originally) reported bug, and causes us to need the e1000_clean_tx_irq
"enhance frame fragment detection" fix.

So what has occured here is that 2.6.32 is only vulnerable for mtu <
1500 due to the jumbo specific routines in both e1000 and e1000e.
So, 2.6.32 needs the 2kB buffer len fix for those smaller MTUs, but
is not vulnerable to the original issue reported.  It has been pointed
out that this vulnerability needs to be patched in older kernels that
don't have the e1000 jumbo routine.  Without the jumbo routines, we
need the "enhance frame fragment detection" fix the e1000, old
e1000e is only vulnerable for < 1500 mtu, and needs a similar
fix.  We split the patches up to provide easy backport paths.

There is only a slight bit of extra code when this fix and the
original "enhance frame fragment detection" fixes are applied, so
please apply both, even though it is a bit of overkill.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000/e1000_main.c |   20 +-------------------
 drivers/net/e1000e/netdev.c    |   20 +-------------------
 2 files changed, 2 insertions(+), 38 deletions(-)

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1698,18 +1698,6 @@ static void e1000_setup_rctl(struct e100
 	rctl &= ~E1000_RCTL_SZ_4096;
 	rctl |= E1000_RCTL_BSEX;
 	switch (adapter->rx_buffer_len) {
-		case E1000_RXBUFFER_256:
-			rctl |= E1000_RCTL_SZ_256;
-			rctl &= ~E1000_RCTL_BSEX;
-			break;
-		case E1000_RXBUFFER_512:
-			rctl |= E1000_RCTL_SZ_512;
-			rctl &= ~E1000_RCTL_BSEX;
-			break;
-		case E1000_RXBUFFER_1024:
-			rctl |= E1000_RCTL_SZ_1024;
-			rctl &= ~E1000_RCTL_BSEX;
-			break;
 		case E1000_RXBUFFER_2048:
 		default:
 			rctl |= E1000_RCTL_SZ_2048;
@@ -3154,13 +3142,7 @@ static int e1000_change_mtu(struct net_d
 	 *  however with the new *_jumbo_rx* routines, jumbo receives will use
 	 *  fragmented skbs */
 
-	if (max_frame <= E1000_RXBUFFER_256)
-		adapter->rx_buffer_len = E1000_RXBUFFER_256;
-	else if (max_frame <= E1000_RXBUFFER_512)
-		adapter->rx_buffer_len = E1000_RXBUFFER_512;
-	else if (max_frame <= E1000_RXBUFFER_1024)
-		adapter->rx_buffer_len = E1000_RXBUFFER_1024;
-	else if (max_frame <= E1000_RXBUFFER_2048)
+	if (max_frame <= E1000_RXBUFFER_2048)
 		adapter->rx_buffer_len = E1000_RXBUFFER_2048;
 	else
 #if (PAGE_SIZE >= E1000_RXBUFFER_16384)
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -2347,18 +2347,6 @@ static void e1000_setup_rctl(struct e100
 	rctl &= ~E1000_RCTL_SZ_4096;
 	rctl |= E1000_RCTL_BSEX;
 	switch (adapter->rx_buffer_len) {
-	case 256:
-		rctl |= E1000_RCTL_SZ_256;
-		rctl &= ~E1000_RCTL_BSEX;
-		break;
-	case 512:
-		rctl |= E1000_RCTL_SZ_512;
-		rctl &= ~E1000_RCTL_BSEX;
-		break;
-	case 1024:
-		rctl |= E1000_RCTL_SZ_1024;
-		rctl &= ~E1000_RCTL_BSEX;
-		break;
 	case 2048:
 	default:
 		rctl |= E1000_RCTL_SZ_2048;
@@ -4338,13 +4326,7 @@ static int e1000_change_mtu(struct net_d
 	 * fragmented skbs
 	 */
 
-	if (max_frame <= 256)
-		adapter->rx_buffer_len = 256;
-	else if (max_frame <= 512)
-		adapter->rx_buffer_len = 512;
-	else if (max_frame <= 1024)
-		adapter->rx_buffer_len = 1024;
-	else if (max_frame <= 2048)
+	if (max_frame <= 2048)
 		adapter->rx_buffer_len = 2048;
 	else
 		adapter->rx_buffer_len = 4096;


