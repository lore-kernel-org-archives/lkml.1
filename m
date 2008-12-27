Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYL0AkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYL0AkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYL0Ajv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:39:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYL0Ajv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:39:51 -0500
Date: Fri, 26 Dec 2008 16:39:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-Id: <20081226163946.6d38e919.akpm@linux-foundation.org>
In-Reply-To: <20081225210235.GC5431@os.inf.tu-dresden.de>
References: <20081225210235.GC5431@os.inf.tu-dresden.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Dec 2008 22:02:35 +0100 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:

> Hi,
> 
> in 2.6.28, the flush_cache_vmap in vmap_page_range() is called with the end of
> the range twice. The following patch fixes this for me.
> 

Did this bug have any observeable runtime effects?  If so, what were
they?

> ---
>  vmalloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.28/mm/vmalloc.c	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28.a/mm/vmalloc.c	2008-12-25 21:45:43.118725744 +0100
> @@ -155,7 +155,7 @@
>  				pgprot_t prot, struct page **pages)
>  {
>  	pgd_t *pgd;
> -	unsigned long next;
> +	unsigned long next, start = addr;
>  	int err = 0;
>  	int nr = 0;
>  
> @@ -167,7 +167,7 @@
>  		if (err)
>  			break;
>  	} while (pgd++, addr = next, addr != end);
> -	flush_cache_vmap(addr, end);
> +	flush_cache_vmap(start, end);
>  
>  	if (unlikely(err))
>  		return err;

Well yeah.  This is what happens when functions modify their incoming
arguments.  It's a bad programming practice which leads directly to
exactly this sort of bug.

How about we fix that?


--- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
+++ a/mm/vmalloc.c
@@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
  *
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
-static int vmap_page_range(unsigned long addr, unsigned long end,
+static int vmap_page_range(unsigned long start_addr, unsigned long end,
 				pgprot_t prot, struct page **pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
+	unsigned long addr = start_addr;
 	int err = 0;
 	int nr = 0;
 
@@ -167,7 +168,7 @@ static int vmap_page_range(unsigned long
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	flush_cache_vmap(addr, end);
+	flush_cache_vmap(start_addr, end);
 
 	if (unlikely(err))
 		return err;
_

