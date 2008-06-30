Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbYF3UZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbYF3UZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764341AbYF3UYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:24:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764309AbYF3UYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:24:47 -0400
Date: Mon, 30 Jun 2008 13:24:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fsl-diu-fb: Update Freescale DIU driver to use
 page_alloc_exact()
Message-Id: <20080630132426.a89c32b0.akpm@linux-foundation.org>
In-Reply-To: <1214325853-26150-1-git-send-email-timur@freescale.com>
References: <1214325853-26150-1-git-send-email-timur@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 11:44:13 -0500
Timur Tabi <timur@freescale.com> wrote:

> Update the Freescale DIU driver to use page_alloc_exact() to allocate a
> DMA buffer.  This also eliminates the rheap-based memory allocator.  We
> can do this now because commit 6ccf61f9 allows us to allocate 8MB physically-
> contiguous memory blocks.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> 
> My other patch, "Add alloc_pages_exact() and free_pages_exact()", must be
> applied first, otherwise drivers/video/fsl-diu-fb.c will not compile.
> 
>  drivers/video/fsl-diu-fb.c |   59 +++++++++++++++----------------------------
>  1 files changed, 21 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
> index 0a27853..d15d265 100644
> --- a/drivers/video/fsl-diu-fb.c
> +++ b/drivers/video/fsl-diu-fb.c
> @@ -279,58 +279,41 @@ static struct diu_hw dr = {
>  
>  static struct diu_pool pool;
>  
> -/*	To allocate memory for framebuffer. First try __get_free_pages(). If it
> - *	fails, try rh_alloc. The reason is __get_free_pages() cannot allocate
> - *	very large memory (more than 4MB). We don't want to allocate all memory
> - *	in rheap since small memory allocation/deallocation will fragment the
> - *	rheap and make the furture large allocation fail.
> +/**
> + * fsl_diu_alloc - allocate memory for the DIU
> + * @size: number of bytes to allocate
> + * @param: returned physical address of memory
> + *
> + * This function allocates a physically-contiguous block of memory.
>   */
> -
> -void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
> +static void *fsl_diu_alloc(size_t size, phys_addr_t *phys)
>  {
>  	void *virt;
>  
> -	pr_debug("size=%lu\n", size);
> +	pr_debug("size=%u\n", size);

Nope, this will generate warnings on some architectures.

The way to print a size_t is with %zu or %zd.  I guess the latter is for
ssize_t.


> -	virt = (void *)__get_free_pages(GFP_DMA | __GFP_ZERO, get_order(size));
> +	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
>  	if (virt) {
>  		*phys = virt_to_phys(virt);
> -		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
> -		return virt;
> -	}
> -	if (!diu_ops.diu_mem) {
> -		printk(KERN_INFO "%s: no diu_mem."
> -			" To reserve more memory, put 'diufb=15M' "
> -			"in the command line\n", __func__);
> -		return NULL;
> -	}
> -
> -	virt = (void *)rh_alloc(&diu_ops.diu_rh_info, size, "DIU");
> -	if (virt) {
> -		*phys = virt_to_bus(virt);
> -		memset(virt, 0, size);
> +		pr_debug("virt=%p, phys=%llx\n", virt, (uint64_t) *phys);

This is also incorrect.  We cannot pass u64 or uint64_t into printk at
all.  We do not know what type the architectures uses to implement
them.  It should be cast to a known type.  In this case `unsigned long
long'.


