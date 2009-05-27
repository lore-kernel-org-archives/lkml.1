Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbZE0Xnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbZE0Xnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZE0Xnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:43:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbZE0Xnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:43:40 -0400
Date: Wed, 27 May 2009 16:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] mark dma_sync_single and dma_sync_sg as deprecated
Message-Id: <20090527164305.82b1c1ab.akpm@linux-foundation.org>
In-Reply-To: <20090519125630Y.fujita.tomonori@lab.ntt.co.jp>
References: <20090519125630Y.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 13:00:37 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> dma_sync_single() and dma_sync_sg() have been described as "Backwards
> compat, remove in 2.7.x" for a long time (since 2.6.5).
> 
> This marks dma_sync_single() and dma_sync_sg() as deprecated so the
> users get notified before removing them.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/dma-mapping.h |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 8083b6a..197ddc4 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -107,9 +107,20 @@ static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
>  #include <asm-generic/dma-mapping-broken.h>
>  #endif
>  
> -/* Backwards compat, remove in 2.7.x */
> -#define dma_sync_single		dma_sync_single_for_cpu
> -#define dma_sync_sg		dma_sync_sg_for_cpu
> +/* for backwards compatibility, removed soon */
> +static inline void __deprecated dma_sync_single(struct device *dev,
> +						dma_addr_t addr, size_t size,
> +						enum dma_data_direction dir)
> +{
> +	dma_sync_single_for_cpu(dev, addr, size, dir);
> +}
> +
> +static inline void __deprecated dma_sync_sg(struct device *dev,
> +					    struct scatterlist *sg, int nelems,
> +					    enum dma_data_direction dir)
> +{
> +	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
> +}
>  
>  static inline u64 dma_get_mask(struct device *dev)
>  {

I dunno.  There are still several callers to dma_sync_single() and
dma_sync_sg() in various drivers and adding the warning will just
irritate people.  It would be better to make an effort to convert those
callsites before filling everyone's screens with yet more warnings.

Most of the offenders are in USB, so let's optimistically cc those fine
folks.

