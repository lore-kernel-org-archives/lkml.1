Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbXBNWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbXBNWxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXBNWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:53:17 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:61105 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbXBNWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:53:16 -0500
Date: Wed, 14 Feb 2007 14:49:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       "Hugh Dickins <hugh@veritas.com> Andrew Morton" 
	<akpm@linux-foundation.org>,
       "Torvalds@linux-foundation.org Torvalds" 
	<torvalds@linux-foundation.org>
Subject: Re: CONFIG_SWAP=n broken in latest tree
Message-Id: <20070214144915.42fa803d.randy.dunlap@oracle.com>
In-Reply-To: <adak5ykz7jy.fsf@cisco.com>
References: <adak5ykz7jy.fsf@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 14:41:05 -0800 Roland Dreier wrote:

> Commit 42da9cbd ("mm: mincore anon") breaks CONFIG_SWAP=n builds with:
> 
>     mm/built-in.o: In function `sys_mincore':
>     (.text+0xe2c4): undefined reference to `swapper_space'
> 
> because swapper_space is used unconditionally in mm/mincore.c but only
> defined in swap_state.c, which isn't built if CONFIG_SWAP=n.
> 
> I'd include a patch but I'm not sure what the right fix is really --
> the naively obvious thing to do would be to add an #ifdef to mincore.c
> like the below, but I don't know this area at all well enough to be
> confident in the fix.
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 95c5f49..266506f 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -109,8 +109,9 @@ static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pag
>  		} else if (pte_file(pte)) {
>  			pgoff = pte_to_pgoff(pte);
>  			present = mincore_page(vma->vm_file->f_mapping, pgoff);
> -
> -		} else { /* pte is a swap entry */
> +		}
> +#ifdef CONFIG_SWAP
> +		else { /* pte is a swap entry */
>  			swp_entry_t entry = pte_to_swp_entry(pte);
>  			if (is_migration_entry(entry)) {
>  				/* migration entries are always uptodate */
> @@ -120,6 +121,7 @@ static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pag
>  				present = mincore_page(&swapper_space, pgoff);
>  			}
>  		}
> +#endif /* CONFIG_SWAP */
>  	}
>  	pte_unmap_unlock(ptep-1, ptl);
>  
> -

We've beat this almost to death... just need some patch merged.

or reverted.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
