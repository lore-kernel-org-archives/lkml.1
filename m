Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXBNATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXBNATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbXBNATW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:19:22 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:14284 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbXBNATV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:19:21 -0500
X-AuditID: d80ac287-9f8eabb000007e48-b7-45d2587fa3a2 
Date: Wed, 14 Feb 2007 00:19:06 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, tony.luck@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
In-Reply-To: <20070213144909.70943de2.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
 <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au>
 <20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com>
 <20070213144909.70943de2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 14 Feb 2007 00:19:01.0309 (UTC) FILETIME=[BA22EED0:01C74FCD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Don't check for pte swap entries when CONFIG_SWAP=n.
> And save 'present' in the vec array.
> 
> mm/built-in.o: In function `sys_mincore':
> (.text+0xe584): undefined reference to `swapper_space'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

What you've done there is fine, Randy, thank you.

But I just got out of bed to take another look, and indeed:
what is it doing in the none_mapped !vma->vm_file case?
passing back an uninitialized vector.

Easy enough to fix, but I'd say Nick's patch has by now exceeded
its embarrassment quota, and should be reverted from Linus' tree
for now: clearly none of us have been paying enough attention,
and other eyes are liable to find further errors lurking in it.

Hugh

> ---
>  mm/mincore.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-2.6.20-git9.orig/mm/mincore.c
> +++ linux-2.6.20-git9/mm/mincore.c
> @@ -111,6 +111,7 @@ static long do_mincore(unsigned long add
>  			present = mincore_page(vma->vm_file->f_mapping, pgoff);
>  
>  		} else { /* pte is a swap entry */
> +#ifdef CONFIG_SWAP
>  			swp_entry_t entry = pte_to_swp_entry(pte);
>  			if (is_migration_entry(entry)) {
>  				/* migration entries are always uptodate */
> @@ -119,7 +120,11 @@ static long do_mincore(unsigned long add
>  				pgoff = entry.val;
>  				present = mincore_page(&swapper_space, pgoff);
>  			}
> +#else
> +			present = 1;
> +#endif
>  		}
> +		vec[i] = present;
>  	}
>  	pte_unmap_unlock(ptep-1, ptl);
