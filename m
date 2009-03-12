Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZCLQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZCLQT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZCLQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:19:49 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61386 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZCLQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:19:48 -0400
Date: Fri, 13 Mar 2009 01:19:50 +0900 (JST)
Message-Id: <20090313.011950.61509382.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090227.002436.106263719.anemo@mba.ocn.ne.jp>
References: <1234538938-23479-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20902251745t314c1e0cs114d2199ccc8cf36@mail.gmail.com>
	<20090227.002436.106263719.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 00:24:36 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > Can you explain how reserved channels work?  It looks like you are
> > working around the generic dma channel allocator, maybe it requires
> > updating to meet your needs.
...
> I need the reserved_chan to make channel 3 named "dma0chan3".  If I
> can chose chan_id for each channels in dma_device, the reserved_chan
> is not needed.

So, how about this?  If it was accepted, I can remove reserved_chan
from txx9dmac driver.

------------------------------------------------------
Subject: dmaengine: Use chan_id provided by DMA device driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

If chan_id was already given by the DMA device driver, use it.
Otherwise assign an incremental number for each channels.

This allows the DMA device driver to reserve some channel ID numbers.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 280a9d2..a3679a7 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -609,6 +609,7 @@ EXPORT_SYMBOL(dmaengine_put);
 int dma_async_device_register(struct dma_device *device)
 {
 	int chancnt = 0, rc;
+	unsigned int chan_id = 0;
 	struct dma_chan* chan;
 	atomic_t *idr_ref;
 
@@ -663,7 +664,9 @@ int dma_async_device_register(struct dma_device *device)
 			continue;
 		}
 
-		chan->chan_id = chancnt++;
+		if (!chan->chan_id)
+			chan->chan_id = chan_id++;
+		chancnt++;
 		chan->dev->device.class = &dma_devclass;
 		chan->dev->device.parent = device->dev;
 		chan->dev->chan = chan;
