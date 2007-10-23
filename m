Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbXJWWrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbXJWWrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXJWWri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:47:38 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:41811 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXJWWrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:47:37 -0400
To: kamalesh@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, apw@shadowen.org,
       tomof@acm.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <471E110C.20404@linux.vnet.ibm.com>
References: <471E110C.20404@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071024074200K.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 24 Oct 2007 07:42:00 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 20:49:40 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi,
> 
> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> over the AMD box
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> PGD 10185b067 PUD 10075b067 PMD 0 

Does this work?


diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c56e9ee..ae7e016 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -338,7 +338,6 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
 		
 		BUG_ON(s != start && s->offset);
 		if (s == start) {
-			*sout = *s; 
 			sout->dma_address = iommu_bus_base;
 			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
 			sout->dma_length = s->length;
@@ -365,7 +364,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
 {
 	if (!need) {
 		BUG_ON(nelems != 1);
-		*sout = *start;
+		sout->dma_address = start->dma_address;
 		sout->dma_length = start->length;
 		return 0;
 	}
-- 
1.5.2.4

