Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYKAQ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYKAQ7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYKAQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:59:44 -0400
Received: from colo.lackof.org ([198.49.126.79]:47448 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKAQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:59:43 -0400
Date: Sat, 1 Nov 2008 10:59:31 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-parisc@vger.kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: remove dead BIO_VMERGE_BOUNDARY and
	BIO_VMERGE_MAX_SIZE definitions
Message-ID: <20081101165931.GC13302@colo.lackof.org>
References: <20081024143826Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024143826Z.fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 02:41:01PM +0900, FUJITA Tomonori wrote:
> The block layer dropped the virtual merge feature
> (b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY and
> BIO_VMERGE_MAX_SIZE definitions are meaningless now.

Sweet!
I've never liked the fact that the block layer did this but recognize
it was useful to maximize the number of SG entries used for
each IO sent to the storage controller.

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  arch/parisc/include/asm/io.h |    6 ------
>  arch/parisc/kernel/setup.c   |    5 -----
>  drivers/parisc/ccio-dma.c    |    2 --
>  drivers/parisc/sba_iommu.c   |    2 --
>  4 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
> index 55ddb18..b92efb3 100644
> --- a/arch/parisc/include/asm/io.h
> +++ b/arch/parisc/include/asm/io.h
> @@ -4,12 +4,6 @@
>  #include <linux/types.h>
>  #include <asm/pgtable.h>
>  
> -extern unsigned long parisc_vmerge_boundary;
> -extern unsigned long parisc_vmerge_max_size;
> -
> -#define BIO_VMERGE_BOUNDARY	parisc_vmerge_boundary
> -#define BIO_VMERGE_MAX_SIZE	parisc_vmerge_max_size
> -
>  #define virt_to_phys(a) ((unsigned long)__pa(a))
>  #define phys_to_virt(a) __va(a)
>  #define virt_to_bus virt_to_phys
> diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
> index 7d27853..8d8b024 100644
> --- a/arch/parisc/kernel/setup.c
> +++ b/arch/parisc/kernel/setup.c
> @@ -58,11 +58,6 @@ int parisc_bus_is_phys __read_mostly = 1;	/* Assume no IOMMU is present */
>  EXPORT_SYMBOL(parisc_bus_is_phys);
>  #endif
>  
> -/* This sets the vmerge boundary and size, it's here because it has to
> - * be available on all platforms (zero means no-virtual merging) */
> -unsigned long parisc_vmerge_boundary = 0;
> -unsigned long parisc_vmerge_max_size = 0;
> -
>  void __init setup_cmdline(char **cmdline_p)
>  {
>  	extern unsigned int boot_args[];
> diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> index dcc1e99..62cc21d 100644
> --- a/drivers/parisc/ccio-dma.c
> +++ b/drivers/parisc/ccio-dma.c
> @@ -1578,8 +1578,6 @@ static int __init ccio_probe(struct parisc_device *dev)
>  
>  	ioc_count++;
>  
> -	parisc_vmerge_boundary = IOVP_SIZE;
> -	parisc_vmerge_max_size = BITS_PER_LONG * IOVP_SIZE;
>  	parisc_has_iommu();
>  	return 0;
>  }
> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> index bc73b96..bdc9a0a 100644
> --- a/drivers/parisc/sba_iommu.c
> +++ b/drivers/parisc/sba_iommu.c
> @@ -1979,8 +1979,6 @@ sba_driver_callback(struct parisc_device *dev)
>  	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
>  #endif
>  
> -	parisc_vmerge_boundary = IOVP_SIZE;
> -	parisc_vmerge_max_size = IOVP_SIZE * BITS_PER_LONG;
>  	parisc_has_iommu();
>  	return 0;
>  }
> -- 
> 1.5.4.2
