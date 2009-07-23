Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZGWEdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZGWEdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 00:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZGWEdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 00:33:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:45884 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbZGWEdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 00:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,251,1246863600"; 
   d="scan'208";a="710275653"
Subject: Re: linux-next: async_tx tree build failure
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090723120004.fac867eb.sfr@canb.auug.org.au>
References: <20090723120004.fac867eb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Date: Wed, 22 Jul 2009 21:33:40 -0700
Message-Id: <1248323620.24951.2.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 19:00 -0700, Stephen Rothwell wrote:
> Hi Dan,
> 
> Since next-20090623, the linux-next build (i386 allmodconfig) has failed
> like this:
> 
> crypto/async_tx/async_xor.c: In function ‘async_xor_init’:
> crypto/async_tx/async_xor.c:310: error: size of array ‘type name’ is negative
> 
> The failing line is this:
> 
> 	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
> 
> in async_xor_init() introduced by commit
> 0036731c88fdb5bf4f04a796a30b5e445fc57f54 ("async_tx: kill tx_set_src and
> tx_set_dest methods") in Feb, 2008.
> 
> Bisecting in the next-20090623 tree pointed to commit
> 3c30a9ca1fb95214e60e3bf43957971df6668033 ("dmaengine: move HIGHMEM64G
> restriction to ASYNC_TX_DMA") from the async_tx tree.  This is now commit
> f3c56e57f66a73a241299dbec1ad55491aa0e403.

Gah, yes that commit was half baked.  I have pushed out an updated tree
with the following fix:

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 95fe2c8..90dd3f8 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -300,7 +300,7 @@ EXPORT_SYMBOL_GPL(async_xor_zero_sum);
 
 static int __init async_xor_init(void)
 {
-	#ifdef CONFIG_DMA_ENGINE
+	#ifdef CONFIG_ASYNC_TX_DMA
 	/* To conserve stack space the input src_list (array of page pointers)
 	 * is reused to hold the array of dma addresses passed to the driver.
 	 * This conversion is only possible when dma_addr_t is less than the

Thanks,
Dan


