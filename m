Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYLSV0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYLSV0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLSVZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:25:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbYLSVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:25:54 -0500
Date: Fri, 19 Dec 2008 13:24:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, hugh@veritas.com,
       paulus@samba.org, wd@denx.de, dzu@denx.de, yanok@emcraft.com,
       miltonm@bga.com, viro@zeniv.linux.org.uk,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] mm/shmem.c: fix division by zero
Message-Id: <20081219132440.2f50bfad.akpm@linux-foundation.org>
In-Reply-To: <200812190844.57996.yur@emcraft.com>
References: <200812190844.57996.yur@emcraft.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 08:44:57 +0300
Yuri Tikhonov <yur@emcraft.com> wrote:

> 
> The following patch fixes division by zero, which we have in
> shmem_truncate_range() and shmem_unuse_inode(), if use big
> PAGE_SIZE values (e.g. 256KB on ppc44x).
> 
> With 256KB PAGE_SIZE the ENTRIES_PER_PAGEPAGE constant becomes
> too large (0x1.0000.0000), so this patch just changes the types
> from 'ulong' to 'ullong' where it's necessary.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> ---
>  mm/shmem.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0ed0752..99d7c91 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -57,7 +57,7 @@
>  #include <asm/pgtable.h>
>  
>  #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
> -#define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
> +#define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
>  #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
>  
>  #define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
> @@ -95,7 +95,7 @@ static unsigned long shmem_default_max_inodes(void)
>  }
>  #endif
>  
> -static int shmem_getpage(struct inode *inode, unsigned long idx,
> +static int shmem_getpage(struct inode *inode, unsigned long long idx,
>  			 struct page **pagep, enum sgp_type sgp, int *type);
>  
>  static inline struct page *shmem_dir_alloc(gfp_t gfp_mask)
> @@ -533,7 +533,7 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>  	int punch_hole;
>  	spinlock_t *needs_lock;
>  	spinlock_t *punch_lock;
> -	unsigned long upper_limit;
> +	unsigned long long upper_limit;
>  
>  	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
>  	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> @@ -1175,7 +1175,7 @@ static inline struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
>   * vm. If we swap it in we mark it dirty since we also free the swap
>   * entry since a page cannot live in both the swap and page cache
>   */
> -static int shmem_getpage(struct inode *inode, unsigned long idx,
> +static int shmem_getpage(struct inode *inode, unsigned long long idx,
>  			struct page **pagep, enum sgp_type sgp, int *type)
>  {
>  	struct address_space *mapping = inode->i_mapping;

umm, ok, maybe.  I guess that it would be more appropriate to use
loff_t in here, and things like

	if (!diroff && !offset && upper_limit >= stage) {

need a bit of thought (`stage' is still unsigned long).

I'll queue the patch as-is pending review from Hugh.  Thanks.
