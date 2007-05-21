Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXEUHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXEUHOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXEUHOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:14:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38071 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXEUHOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:14:06 -0400
Date: Mon, 21 May 2007 09:13:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] x86-64: update iommu/dma mapping functions to sg   helpers
Message-ID: <20070521071322.GK14746@kernel.dk>
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972373765-git-send-email-jens.axboe@oracle.com> <464322BC.50101@panasas.com> <20070521063249.GE14746@kernel.dk> <465145BB.7050301@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465145BB.7050301@panasas.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Benny Halevy wrote:
> Jens Axboe wrote:
> > On Thu, May 10 2007, Benny Halevy wrote:
> >> @@ -411,12 +406,13 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
> >>  			   boundary and the new one doesn't have an offset. */
> >>  			if (!iommu_merge || !nextneed || !need || s->offset ||
> >>  			    (ps->offset + ps->length) % PAGE_SIZE) { 
> >> -				if (dma_map_cont(sg, start, i, sg+out, pages,
> >> -						 need) < 0)
> >> +				if (dma_map_cont(start_sg, i - start, sg+out,
> >> +						  pages, need) < 0)
> >>  					goto error;
> >>  				out++;
> >>  				pages = 0;
> >> -				start = i;	
> >> +				start = i;
> >> +				start_sg = s;
> >>  			}
> >>  		}
> >>  
> >> @@ -424,7 +420,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
> >>  		pages += to_pages(s->offset, s->length);
> >>  		ps = s;
> >>  	}
> >> -	if (dma_map_cont(sg, start, i, sg+out, pages, need) < 0)
> >> +	if (dma_map_cont(start_sg, i - start, sg+out, pages, need) < 0)
> >>  		goto error;
> >>  	out++;
> >>  	flush_gart();
> > 
> > Your patch is (very) buggy, the whole premise of doing chained sg
> > entries makes sg + int illegal!
> > 
> 
> You're right.  I'll send a fix asap.

Did you see this one, I cooked it up after sending that mail out. Please
review :-)

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 2e22a3a..b16384f 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -381,7 +381,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
-	struct scatterlist *s, *ps, *start_sg;
+	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
 	if (nents == 0) 
 		return 0;
@@ -391,7 +391,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 	out = 0;
 	start = 0;
-	start_sg = sg;
+	start_sg = sgmap = sg;
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = page_to_phys(s->page) + s->offset;
@@ -405,11 +405,12 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 			/* Can only merge when the last chunk ends on a page 
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
-			    (ps->offset + ps->length) % PAGE_SIZE) { 
-				if (dma_map_cont(start_sg, i - start, sg+out,
+			    (ps->offset + ps->length) % PAGE_SIZE) {
+				if (dma_map_cont(start_sg, i - start, sgmap,
 						  pages, need) < 0)
 					goto error;
 				out++;
+				sgmap = sg_next(sgmap);
 				pages = 0;
 				start = i;
 				start_sg = s;
@@ -420,7 +421,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 		pages += to_pages(s->offset, s->length);
 		ps = s;
 	}
-	if (dma_map_cont(start_sg, i - start, sg+out, pages, need) < 0)
+	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
 		goto error;
 	out++;
 	flush_gart();

-- 
Jens Axboe

