Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXJYHOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXJYHOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXJYHO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:14:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14595 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbXJYHO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:14:26 -0400
Date: Thu, 25 Oct 2007 09:12:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Amit Shah <amitshah@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Panic in gart_map_sg
Message-ID: <20071025071239.GA5053@kernel.dk>
References: <877aabc40710250012se0afe99s819207e72726d333@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40710250012se0afe99s819207e72726d333@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, Amit Shah wrote:
> I get a kernel panic at gart_map_sg+0x201/0x470, which is around here:
> 
> 	out++;
> 	flush_gart();
> 	if (out < nents) {
> 		sgmap = sg_next(sgmap);
> 		sgmap->dma_length = 0;
> 	}
> 	return out;
> 
> 8e5:   e8 d6 fc ff ff          callq  5c0 <flush_gart>
>  8ea:   ff c3                   inc    %ebx
>  8ec:   41 39 df                cmp    %ebx,%r15d
>  8ef:   0f 8e 9d 00 00 00       jle    992 <gart_map_sg+0x292>
>  8f5:   31 c9                   xor    %ecx,%ecx
>  8f7:   f6 45 00 02             testb  $0x2,0x0(%rbp)
>  8fb:   0f 84 1f 02 00 00       je     b20 <gart_map_sg+0x420>
>  901:   c7 41 18 00 00 00 00    movl   $0x0,0x18(%rcx)
>  908:   e9 85 00 00 00          jmpq   992 <gart_map_sg+0x292>
>  90d:   0f 1f 00                nopl   (%rax)
>  910:   44 89 e0                mov    %r12d,%eax
>  913:   29 f0                   sub    %esi,%eax
>  915:   45 85 d2                test   %r10d,%r10d
>  918:   89 c6                   mov    %eax,%esi
>  91a:   0f 85 02 ff ff ff       jne    822 <gart_map_sg+0x122>
>  920:   ff ce                   dec    %esi
>  922:   75 65                   jne    989 <gart_map_sg+0x289>
> 
> 
> My system is an AMD Opteron 1216. I'm not sure if only adding a check
> for sgmap != NULL after sg_next is the right fix.

Tomo already nailed this one, see below.

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: pci-gart fix

map_sg could copy the last sg element to another position (if merging
some elements). It breaks sg chaining. This copies only
dma_address/length instead of the whole sg element.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

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

-- 
Jens Axboe

