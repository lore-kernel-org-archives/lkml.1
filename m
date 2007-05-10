Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXEJNtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXEJNtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbXEJNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:49:04 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:37757 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754537AbXEJNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:49:03 -0400
Message-ID: <464322BC.50101@panasas.com>
Date: Thu, 10 May 2007 16:48:44 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] x86-64: update iommu/dma mapping functions to sg
 helpers
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972373765-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11787972373765-git-send-email-jens.axboe@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------030409060805010609010108"
X-OriginalArrivalTime: 10 May 2007 13:48:46.0121 (UTC) FILETIME=[EE0DA990:01C79309]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030409060805010609010108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
<snip>
> @@ -323,13 +324,17 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
>  {
>  	unsigned long iommu_start = alloc_iommu(pages);
>  	unsigned long iommu_page = iommu_start; 
> -	int i;
> +	struct scatterlist *s;
> +	int i, nelems;
>  
>  	if (iommu_start == -1)
>  		return -1;
> +
> +	nelems = stopat - start;
> +	while (start--)
> +		sg = sg_next(sg);

Ouch.  This will suck if we merge many times in a long list.
How about keeping and passing start as a struct scatterlist * rather
than an index? (see attached example, (compiles, bu untested though)


>  	
> -	for (i = start; i < stopat; i++) {
> -		struct scatterlist *s = &sg[i];
> +	for_each_sg(sg, s, nelems, i) {
>  		unsigned long pages, addr;
>  		unsigned long phys_addr = s->dma_address;


There seems to be a bug hiding here as now i is in [0, nelems) now,
not [start, stopat) so "if (i == start)" below should turn into "if (i == 0)"

this is fixed by comparing pointers instead way in the attached example.

>  		
> @@ -360,12 +365,14 @@ static inline int dma_map_cont(struct scatterlist *sg, int start, int stopat,
>  		      struct scatterlist *sout,
>  		      unsigned long pages, int need)
>  {
> -	if (!need) { 
> +	if (!need) {
>  		BUG_ON(stopat - start != 1);
> -		*sout = sg[start]; 
> -		sout->dma_length = sg[start].length; 
> +		while (--start)
> +			sg = sg_next(sg);

same efficiency issue as above.

> +		*sout = *sg;
> +		sout->dma_length = sg->length;
>  		return 0;
> -	} 
> +	}
>  	return __dma_map_cont(sg, start, stopat, sout, pages);
>  }
>  		
<snip>


--------------030409060805010609010108
Content-Type: text/plain;
 name="pci-gart-sg_chain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pci-gart-sg_chain.patch"

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 8bc2ed7..48ce635 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -319,27 +319,23 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 }
 
 /* Map multiple scatterlist entries continuous into the first. */
-static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
+static int __dma_map_cont(struct scatterlist *start, int nelems,
 		      struct scatterlist *sout, unsigned long pages)
 {
 	unsigned long iommu_start = alloc_iommu(pages);
 	unsigned long iommu_page = iommu_start; 
 	struct scatterlist *s;
-	int i, nelems;
+	int i;
 
 	if (iommu_start == -1)
 		return -1;
 
-	nelems = stopat - start;
-	while (start--)
-		sg = sg_next(sg);
-	
-	for_each_sg(sg, s, nelems, i) {
+	for_each_sg(start, s, nelems, i) {
 		unsigned long pages, addr;
 		unsigned long phys_addr = s->dma_address;
 		
-		BUG_ON(i > start && s->offset);
-		if (i == start) {
+		BUG_ON(s != start && s->offset);
+		if (s == start) {
 			*sout = *s; 
 			sout->dma_address = iommu_bus_base;
 			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
@@ -361,19 +357,17 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
 	return 0;
 }
 
-static inline int dma_map_cont(struct scatterlist *sg, int start, int stopat,
+static inline int dma_map_cont(struct scatterlist *start, int nelems,
 		      struct scatterlist *sout,
 		      unsigned long pages, int need)
 {
 	if (!need) {
-		BUG_ON(stopat - start != 1);
-		while (--start)
-			sg = sg_next(sg);
-		*sout = *sg;
-		sout->dma_length = sg->length;
+		BUG_ON(nelems != 1);
+		*sout = *start;
+		sout->dma_length = start->length;
 		return 0;
 	}
-	return __dma_map_cont(sg, start, stopat, sout, pages);
+	return __dma_map_cont(start, nelems, sout, pages);
 }
 		
 /*
@@ -387,7 +381,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
-	struct scatterlist *s, *ps;
+	struct scatterlist *s, *ps, *start_sg;
 
 	if (nents == 0) 
 		return 0;
@@ -397,6 +391,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 	out = 0;
 	start = 0;
+	start_sg = sg;
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = page_to_phys(s->page) + s->offset;
@@ -411,12 +406,13 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
 			    (ps->offset + ps->length) % PAGE_SIZE) { 
-				if (dma_map_cont(sg, start, i, sg+out, pages,
-						 need) < 0)
+				if (dma_map_cont(start_sg, i - start, sg+out,
+						  pages, need) < 0)
 					goto error;
 				out++;
 				pages = 0;
-				start = i;	
+				start = i;
+				start_sg = s;
 			}
 		}
 
@@ -424,7 +420,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 		pages += to_pages(s->offset, s->length);
 		ps = s;
 	}
-	if (dma_map_cont(sg, start, i, sg+out, pages, need) < 0)
+	if (dma_map_cont(start_sg, i - start, sg+out, pages, need) < 0)
 		goto error;
 	out++;
 	flush_gart();

--------------030409060805010609010108--
