Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYLAM4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYLAM4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYLAMzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:55:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYLAMzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:55:20 -0500
Date: Mon, 1 Dec 2008 13:55:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joro@8bytes.org, tsbogend@alpha.franken.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
Message-ID: <20081201125501.GC21534@elte.hu>
References: <20081129124627.F2ABDFA8C8@solo.franken.de> <20081201113451.GA24323@8bytes.org> <20081201210110L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201210110L.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 1 Dec 2008 12:34:51 +0100
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> > > Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> > > handles this cases by falling back to GFP_DMA allocation. But for detecting
> > > the problem it needs to get an indication from dma_mapping_error.
> > > The bug is triggered by using a VMSPLIT option of 2G/2G.
> > 
> > Looks like your system uses swiotlb as the dma_ops backend. Its the only
> > implementation providing the ops->mapping_error callback and does not
> > use bad_dma_address as the error value.
> 
> I think that you misunderstand the problem.
> 
> He uses X86_32 so swiotlb should not be used (which is available on 
> only X86_64 and IA64 for now).
> 
> b44 needs an address under 1GB so it sets device->dma_mask to 
> DMA_30BIT_MASK. With VMSPLIT option of 2G/2G, I guess that b44 could 
> get addresses above 1GB from the networking subsystem. In such case, 
> nommu_map_single returns bad_dma_address properly, but on X86_32, 
> dma_mapping_error always returns 0 (success). So b44 wrongly thinks 
> that the address is under 1GB.
> 
> This patch fixes dma_mapping_error() to check a passed address
> properly (compares it with bad_dma_address).
> 
> As I already wrote, the current git needs a patch modified slightly:
> 
> http://marc.info/?l=linux-kernel&m=122797163405377&w=2

i have i queued up in x86/urgent, see below.

	Ingo

-------------->
>From 7b1dedca42ac0d0d0be01e39d8461bb53a2389b3 Mon Sep 17 00:00:00 2001
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Sat, 29 Nov 2008 13:46:27 +0100
Subject: [PATCH] x86: fix dma_mapping_error for 32bit x86

Devices like b44 ethernet can't dma from addresses above 1GB. The driver
handles this cases by falling back to GFP_DMA allocation. But for detecting
the problem it needs to get an indication from dma_mapping_error.
The bug is triggered by using a VMSPLIT option of 2G/2G.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/dma-mapping.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 7f225a4..097794f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -71,15 +71,13 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_32
-	return 0;
-#else
+#ifdef CONFIG_X86_64
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-	return (dma_addr == bad_dma_address);
 #endif
+	return (dma_addr == bad_dma_address);
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
