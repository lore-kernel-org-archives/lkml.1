Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYGBFKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYGBFKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYGBFKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:10:25 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43677 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbYGBFKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:10:24 -0400
Date: Wed, 2 Jul 2008 08:10:00 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Larry.Finger@lwfinger.net,
       stefano.brivio@polimi.it, linville@tuxdriver.com
Cc: David Howells <dhowells@redhat.com>, torvalds@linuxfoundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [RFC: 2.6 patch] remove the switch in b43legacy_dma_init()
Message-ID: <20080702051000.GF32598@cs181140183.pp.htv.fi>
References: <20080613130952.26794.26092.stgit@warthog.procyon.org.uk> <20080613130958.26794.23426.stgit@warthog.procyon.org.uk> <20080630161825.294d3d2c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080630161825.294d3d2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 04:18:25PM -0700, Andrew Morton wrote:
> On Fri, 13 Jun 2008 14:09:58 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Provide __ucmpdi2() for MN10300 so that allmodconfig can be built.
> 
> Well...  x86 has this problem as well, and when it pops up we address
> it by going in and looking at the codesite which is generating the call
> and fixing it.  And I do mean "fixing", because it's often the case
> that the caller was doing something silly and inefficient.

In this case I'd blame the gcc 3.4 fork used by MN10300.

> So are you sure that we should do this, rather than massaging the
> callers?

Patch to fix the callers (if wanted) is below.

cu
Adrian


<--  snip  -->


The gcc 3.4 fork used to compile the MN10300 port emits unwanted 
__ucmpdi2() calls for this switch on a 64bit value.

Fix it by transforming the switch to equivalent "if ... else if ..."
statements.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a89c72d736986777b2cc4e07589aa46e957c15a5 
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index c990f87..794dc83 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1028,19 +1028,15 @@ int b43legacy_dma_init(struct b43legacy_wldev *dev)
 	enum b43legacy_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
-	switch (dmamask) {
-	default:
-		B43legacy_WARN_ON(1);
-	case DMA_30BIT_MASK:
+
+	if (dmamask == DMA_30BIT_MASK)
 		type = B43legacy_DMA_30BIT;
-		break;
-	case DMA_32BIT_MASK:
+	else if (dmamask == DMA_32BIT_MASK)
 		type = B43legacy_DMA_32BIT;
-		break;
-	case DMA_64BIT_MASK:
+	else if (dmamask == DMA_64BIT_MASK)
 		type = B43legacy_DMA_64BIT;
-		break;
-	}
+	else
+		B43legacy_WARN_ON(1);
 
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {

