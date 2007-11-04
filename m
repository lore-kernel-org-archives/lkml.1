Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbXKDIpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbXKDIpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 03:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXKDIpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 03:45:00 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27246 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbXKDIo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 03:44:59 -0500
Date: Sun, 4 Nov 2007 09:44:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to  boot: kernel BUG at include/linux/scatterlist.h:49!
Message-ID: <20071104084456.GJ28340@kernel.dk>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> <472BA567.8040301@s5r6.in-berlin.de> <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com> <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103160404.GH28340@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03 2007, Jens Axboe wrote:
> On Sat, Nov 03 2007, Stefan Richter wrote:
> > Torsten Kaiser wrote:
> > > On 11/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > >> To which extent do you need IEEE 1394 drivers?
> > > 
> > > Using eth1394 as primary network connection on this computer.
> > > So switching to the new stack is currently not an option,
> > 
> > That's right.
> > 
> > > Looking that calltrace upwards, it seems replacing the
> > > memset(dma->sglist,...) with sg_init_table(...) would fix the BUG_ON()
> > > as that inits the SG_MAGIC.
> > 
> > Yes, this should be the first thing to be fixed.
> 
> It's probably enough. Only if you use chaining do you need to convert to
> using for_each_sg() and so on.

Did a grep over ieee1394/, this seems to be all you need.

diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index f5f4983..7c4eb39 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -103,8 +103,7 @@ int dma_region_alloc(struct dma_region *dma, unsigned long n_bytes,
 		goto err;
 	}
 
-	/* just to be safe - this will become unnecessary once sglist->address goes away */
-	memset(dma->sglist, 0, dma->n_pages * sizeof(*dma->sglist));
+	sg_init_table(dma->sglist, dma->n_pages);
 
 	/* fill scatter/gather list with pages */
 	for (i = 0; i < dma->n_pages; i++) {

-- 
Jens Axboe

