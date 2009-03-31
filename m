Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbZCaQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbZCaQHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZCaQHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:07:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:40035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756189AbZCaQHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:07:22 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/Q65RHQpjQ23H+cNrHpVdr8/BxA5zm5sIVnnGLO/
	C9LOMGEIjx+PpY
Date: Tue, 31 Mar 2009 18:07:34 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH] dmaengine: fix regression introduced by
 d6103085dfd83c13db65c3bd7e182f021d77c541
Message-ID: <Pine.LNX.4.64.0903311755540.4806@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chan is an index variable, used to loop over a list of channels, and here 
it is used _after_ the loop, in which case it doesn't point to a DMA 
channel struct anymore. Dereferencing it leads to a corruption of a random 
memory location, which in my case was a pointer inside a clock struct. Fix 
it by using a local variable pointing to the DMA device.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

Guys, this was a _real_ bad joke, cost me almost a day, and that patch has 
been reviewed by two persons...

<rant>
So far 2.6.29(-next) has been very bad for me, regressions all over the 
place, lots of wasted time hunting them down:-(
</rant>

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 59e0fb2..92438e9 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -726,7 +726,7 @@ int dma_async_device_register(struct dma_device *device)
 		}
 	list_add_tail_rcu(&device->global_node, &dma_device_list);
 	if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
-		chan->device->privatecnt++;	/* Always private */
+		device->privatecnt++;	/* Always private */
 	dma_channel_rebalance();
 	mutex_unlock(&dma_list_mutex);
 
