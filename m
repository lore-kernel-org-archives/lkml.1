Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZESUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZESUyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZESUyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:54:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3417 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:54:08 -0400
Subject: Re: [PATCH] mm/slub.c: change printk()s to pr_*() notation
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200905191103.03749.hartleys@visionengravers.com>
References: <200905191103.03749.hartleys@visionengravers.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 13:54:06 -0700
Message-Id: <1242766446.28224.31.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 11:03 -0700, H Hartley Sweeten wrote:
> Change all the printk()s in mm/slub.c to the pr_*() notation.
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..2805b7f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -338,25 +338,25 @@ static void print_section(char *text, u8 *addr, unsigned int length)
>  
>  	for (i = 0; i < length; i++) {
>  		if (newline) {
> -			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
> +			pr_err("%8s 0x%p: ", text, addr + i);
>  			newline = 0;
>  		}
> -		printk(KERN_CONT " %02x", addr[i]);
> +		pr_cont(" %02x", addr[i]);
>  		offset = i % 16;
>  		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
>  		if (offset == 15) {
> -			printk(KERN_CONT " %s\n", ascii);
> +			pr_cont(" %s\n", ascii);
>  			newline = 1;
>  		}
>  	}
>  	if (!newline) {
>  		i %= 16;
>  		while (i < 16) {
> -			printk(KERN_CONT "   ");
> +			pr_cont("   ");
>  			ascii[i] = ' ';
>  			i++;
>  		}
> -		printk(KERN_CONT " %s\n", ascii);
> +		pr_cont(" %s\n", ascii);
>  	}
>  }

Perhaps this should be changed to print_hex_dump.

For the other changes, it might be useful to avoid
having string constants span multiple lines and
to align multi-line statements on the column after an
open parenthesis.  Statements that fit on a single
80 character line should be on a single line.

Some examples:

> @@ -416,7 +416,7 @@ static void print_tracking(struct kmem_cache *s, void *object)
>  
>  static void print_page_info(struct page *page)
>  {
> -	printk(KERN_ERR "INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
> +	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
>  		page, page->objects, page->inuse, page->freelist, page->flags);

(tabs with spaces) might be:

	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
	       page, page->objects, page->inuse, page->freelist, page->flags);

> @@ -998,7 +997,7 @@ static int __init setup_slub_debug(char *str)
> -			printk(KERN_ERR "slub_debug option '%c' "
> +			pr_err("slub_debug option '%c' "
>  				"unknown. skipped\n", *str);

Recombine strings (might be):
			pr_err("slub_debug option '%c' unknown. skipped\n",
			       *str);

> @@ -2431,8 +2430,8 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
>  	for_each_object(p, s, addr, page->objects) {
>  
>  		if (!test_bit(slab_index(p, s, addr), map)) {
> -			printk(KERN_ERR "INFO: Object 0x%p @offset=%tu\n",
> -							p, p - addr);
> +			pr_err("INFO: Object 0x%p @offset=%tu\n",
> +				p, p - addr);

Up to 80 char single line (might be):
			pr_err("INFO: Object 0x%p @offset=%tu\n", p, p - addr);

cheers, Joe

