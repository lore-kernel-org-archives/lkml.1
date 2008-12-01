Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYLARRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYLARRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYLARRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:17:42 -0500
Received: from sh.osrg.net ([192.16.179.4]:56642 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLARRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:17:42 -0500
Date: Tue, 2 Dec 2008 02:17:15 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org, tsbogend@alpha.franken.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081201143534.GB32565@elte.hu>
References: <20081201125501.GC21534@elte.hu>
	<20081201230926Q.fujita.tomonori@lab.ntt.co.jp>
	<20081201143534.GB32565@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081202021638K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 15:35:34 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Mon, 1 Dec 2008 13:55:01 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > On Mon, 1 Dec 2008 12:34:51 +0100
> > > > Joerg Roedel <joro@8bytes.org> wrote:
> > > > 
> > > > > On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> > > > > > Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> > > > > > handles this cases by falling back to GFP_DMA allocation. But for detecting
> > > > > > the problem it needs to get an indication from dma_mapping_error.
> > > > > > The bug is triggered by using a VMSPLIT option of 2G/2G.
> > > > > 
> > > > > Looks like your system uses swiotlb as the dma_ops backend. Its the only
> > > > > implementation providing the ops->mapping_error callback and does not
> > > > > use bad_dma_address as the error value.
> > > > 
> > > > I think that you misunderstand the problem.
> > > > 
> > > > He uses X86_32 so swiotlb should not be used (which is available on 
> > > > only X86_64 and IA64 for now).
> > > > 
> > > > b44 needs an address under 1GB so it sets device->dma_mask to 
> > > > DMA_30BIT_MASK. With VMSPLIT option of 2G/2G, I guess that b44 could 
> > > > get addresses above 1GB from the networking subsystem. In such case, 
> > > > nommu_map_single returns bad_dma_address properly, but on X86_32, 
> > > > dma_mapping_error always returns 0 (success). So b44 wrongly thinks 
> > > > that the address is under 1GB.
> > > > 
> > > > This patch fixes dma_mapping_error() to check a passed address
> > > > properly (compares it with bad_dma_address).
> > > > 
> > > > As I already wrote, the current git needs a patch modified slightly:
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=122797163405377&w=2
> > > 
> > > i have i queued up in x86/urgent, see below.
> > 
> > As I wrote, just removing #ifdef is better since:
> > 
> > 1) Xen people want swiotlb on X86_32. swiotlb uses ops->mapping_error
> > so X86_32 also needs to check ops->mapping_error.
> > 
> > 2) Removing #ifdef hack is always good.
> > 
> > 
> > But this patch fixes the bug and it works for now. And I think that 
> > Thomas tested it. So it's fine to commit this patch by me.
> 
> yeah, i included the tested patch.
> 
> > I'll send a patch to remove the ifdef on the top of this patch after 
> > this patch goes into mainline.
> 
> sure - or you can send it against tip/master straight away.

Ok, here you are.

Note that this is for 2.6.29 (not 2.6.28).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove ifdef CONFIG_X86_64 in dma_mapping_error

This removes ifdef CONFIG_X86_64 in dma_mapping_error():

1) Xen people plan to use swiotlb on X86_32 for Dom0 support. swiotlb
uses ops->mapping_error so X86_32 also needs to check
ops->mapping_error.

2) Removing #ifdef hack is almost always a good thing.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/dma-mapping.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index ecf8eaf..40d155d 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -72,12 +72,10 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_64
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-#endif
 	return (dma_addr == bad_dma_address);
 }
 
-- 
1.5.5.GIT

