Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYBKTK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYBKTK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBKTKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:10:49 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:25077 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYBKTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:10:47 -0500
Date: Mon, 11 Feb 2008 14:10:46 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: kyle@parisc-linux.org, Matthew Wilcox <matthew@wil.cx>,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]
	pcxl_dma_ops.alloc_noncoherent = pa11_dma_alloc_consistent?
Message-ID: <20080211191046.GD4516@phobos.i.cabal.ca>
References: <47B07685.5000606@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07685.5000606@tiscali.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 05:23:33PM +0100, Roel Kluin wrote:
>

How about just doing something like this:

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 9448d4e..63f9b7f 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -409,7 +409,7 @@ pcxl_dma_init(void)
 
 __initcall(pcxl_dma_init);
 
-static void * pa11_dma_alloc_consistent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag)
+static void * pcxl_dma_alloc_consistent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag)
 {
 	unsigned long vaddr;
 	unsigned long paddr;
@@ -435,7 +435,7 @@ static void * pa11_dma_alloc_consistent (struct device *dev, size_t size, dma_ad
 	return (void *)vaddr;
 }
 
-static void pa11_dma_free_consistent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
+static void pcxl_dma_free_consistent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
 {
 	int order;
 
@@ -548,9 +548,9 @@ static void pa11_dma_sync_sg_for_device(struct device *dev, struct scatterlist *
 
 struct hppa_dma_ops pcxl_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
-	.alloc_consistent =	pa11_dma_alloc_consistent,
-	.alloc_noncoherent =	pa11_dma_alloc_consistent,
-	.free_consistent =	pa11_dma_free_consistent,
+	.alloc_consistent =	pcxl_dma_alloc_consistent,
+	.alloc_noncoherent =	pcxl_dma_alloc_consistent,
+	.free_consistent =	pcxl_dma_free_consistent,
 	.map_single =		pa11_dma_map_single,
 	.unmap_single =		pa11_dma_unmap_single,
 	.map_sg =		pa11_dma_map_sg,
@@ -567,7 +567,7 @@ static void *fail_alloc_consistent(struct device *dev, size_t size,
 	return NULL;
 }
 
-static void *pa11_dma_alloc_noncoherent(struct device *dev, size_t size,
+static void *pcx_dma_alloc_noncoherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *addr;
@@ -579,7 +579,7 @@ static void *pa11_dma_alloc_noncoherent(struct device *dev, size_t size,
 	return addr;
 }
 
-static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
+static void pcx_dma_free_noncoherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t iova)
 {
 	free_pages((unsigned long)vaddr, get_order(size));
@@ -589,8 +589,8 @@ static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
 struct hppa_dma_ops pcx_dma_ops = {
 	.dma_supported =	pa11_dma_supported,
 	.alloc_consistent =	fail_alloc_consistent,
-	.alloc_noncoherent =	pa11_dma_alloc_noncoherent,
-	.free_consistent =	pa11_dma_free_noncoherent,
+	.alloc_noncoherent =	pcx_dma_alloc_noncoherent,
+	.free_consistent =	pcx_dma_free_noncoherent,
 	.map_single =		pa11_dma_map_single,
 	.unmap_single =		pa11_dma_unmap_single,
 	.map_sg =		pa11_dma_map_sg,
