Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYGGWuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYGGWuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYGGWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:50:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:12984 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbYGGWuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:50:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,318,1212390000"; 
   d="scan'208";a="406393903"
Subject: Re: [PATCH/RFC] DMA engine driver for Marvell XOR engine
From: Dan Williams <dan.j.williams@intel.com>
To: saeed <saeed@marvell.com>
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Nicolas Pitre <nico@cam.org>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Russell King <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.99.0807060021160.9671@ubuntu-saeed.il.marvell.com>
References: <7F38996F7185A24AB9071ED4950AD8C101BEE6CD@swsmsx413.ger.corp.intel.com>
	 <alpine.DEB.0.99.0807010430480.9671@ubuntu-saeed.il.marvell.com>
	 <e9c3a7c20807011641u2de28aa8k23fc2c74797adb2a@mail.gmail.com>
	 <alpine.DEB.0.99.0807060021160.9671@ubuntu-saeed.il.marvell.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 15:49:59 -0700
Message-Id: <1215470999.24400.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-07-06 at 04:23 -0700, saeed wrote:
> 
> > The admittedly ugly do { } while () loop in iop-adma.c assumed that
> > num_descs_in_pool is always > 1, and guarantees that idx is equal to
> > the count of allocated descriptors.  Since you changed it to a simple
> > while() loop then you should also replace idx with ->slots_allocated
> > in the rest of the routine i.e.:
> >
> >      return mv_chan->slots_allocated ? : -ENOMEM;
> done.
> Here is the updated patch:

checkpatch said:
ERROR: code indent should use tabs where possible
#636: FILE: drivers/dma/mv_xor.c:602:
+ ^Iidx = mv_chan->slots_allocated;$

WARNING: line over 80 characters
#672: FILE: drivers/dma/mv_xor.c:638:
+       return (mv_chan->slots_allocated > 0) ? mv_chan->slots_allocated : -ENOMEM;


...so I made the following quick edits before applying:

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 82f5631..f0c123c 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -599,7 +599,7 @@ static int mv_xor_alloc_chan_resources(struct dma_chan *chan)
 	int num_descs_in_pool = plat_data->pool_size/MV_XOR_SLOT_SIZE;
 
 	/* Allocate descriptor slots */
- 	idx = mv_chan->slots_allocated;
+	idx = mv_chan->slots_allocated;
 	while (idx < num_descs_in_pool) {
 		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 		if (!slot) {
@@ -635,7 +635,7 @@ static int mv_xor_alloc_chan_resources(struct dma_chan *chan)
 		"allocated %d descriptor slots last_used: %p\n",
 		mv_chan->slots_allocated, mv_chan->last_used);
 
-	return (mv_chan->slots_allocated > 0) ? mv_chan->slots_allocated : -ENOMEM;
+	return mv_chan->slots_allocated ? : -ENOMEM;
 }
 
 static struct dma_async_tx_descriptor *

--
Dan

