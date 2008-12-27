Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYL0MDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYL0MDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYL0MDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:03:31 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:34916 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYL0MDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:03:30 -0500
Date: Sat, 27 Dec 2008 13:03:28 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-ID: <20081227120328.GE5431@os.inf.tu-dresden.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
References: <20081225210235.GC5431@os.inf.tu-dresden.de> <20081226163946.6d38e919.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081226163946.6d38e919.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri Dec 26, 2008 at 16:39:46 -0800, Andrew Morton wrote:
> On Thu, 25 Dec 2008 22:02:35 +0100 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:
> 
> > Hi,
> > 
> > in 2.6.28, the flush_cache_vmap in vmap_page_range() is called with the end of
> > the range twice. The following patch fixes this for me.
> > 
> 
> Did this bug have any observeable runtime effects?  If so, what were
> they?

Just in my own code, i.e. it doesn't have any effects to the kernel
itself.
 
> Well yeah.  This is what happens when functions modify their incoming
> arguments.  It's a bad programming practice which leads directly to
> exactly this sort of bug.
> 
> How about we fix that?

fine.

> --- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
> +++ a/mm/vmalloc.c
> @@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
>   *
>   * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
>   */
> -static int vmap_page_range(unsigned long addr, unsigned long end,
> +static int vmap_page_range(unsigned long start_addr, unsigned long end,
>  				pgprot_t prot, struct page **pages)
>  {
>  	pgd_t *pgd;
>  	unsigned long next;
> +	unsigned long addr = start_addr;
>  	int err = 0;
>  	int nr = 0;
>  
> @@ -167,7 +168,7 @@ static int vmap_page_range(unsigned long
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> -	flush_cache_vmap(addr, end);
> +	flush_cache_vmap(start_addr, end);
>  
>  	if (unlikely(err))
>  		return err;

Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
