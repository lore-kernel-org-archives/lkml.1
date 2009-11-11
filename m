Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZKKH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZKKH41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZKKH40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:56:26 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36136 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbZKKH4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:56:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911102151500.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> <Pine.LNX.4.64.0911102151500.2816@sister.anvils>
Message-Id: <20091111102400.FD36.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 16:56:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh

> @@ -1081,45 +1053,23 @@ static int try_to_unmap_file(struct page
>  	unsigned long max_nl_cursor = 0;
>  	unsigned long max_nl_size = 0;
>  	unsigned int mapcount;
> -	unsigned int mlocked = 0;
> -	int unlock = TTU_ACTION(flags) == TTU_MUNLOCK;
> -
> -	if (MLOCK_PAGES && unlikely(unlock))
> -		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
>  
>  	spin_lock(&mapping->i_mmap_lock);
>  	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> -		if (MLOCK_PAGES && unlikely(unlock)) {
> -			if (!((vma->vm_flags & VM_LOCKED) &&
> -						page_mapped_in_vma(page, vma)))
> -				continue;	/* must visit all vmas */
> -			ret = SWAP_MLOCK;
> -		} else {
> -			ret = try_to_unmap_one(page, vma, flags);
> -			if (ret == SWAP_FAIL || !page_mapped(page))
> -				goto out;
> -		}
> -		if (ret == SWAP_MLOCK) {
> -			mlocked = try_to_mlock_page(page, vma);
> -			if (mlocked)
> -				break;  /* stop if actually mlocked page */
> -		}
> +		ret = try_to_unmap_one(page, vma, flags);
> +		if (ret != SWAP_AGAIN || !page_mapped(page))
> +			goto out;
>  	}
>  
> -	if (mlocked)
> +	if (list_empty(&mapping->i_mmap_nonlinear))
>  		goto out;
>
> -	if (list_empty(&mapping->i_mmap_nonlinear))
> +	/* We don't bother to try to find the munlocked page in nonlinears */
> +	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
>  		goto out;

I have dumb question.
Does this shortcut exiting code makes any behavior change?




>  
>  	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
>  						shared.vm_set.list) {
> -		if (MLOCK_PAGES && unlikely(unlock)) {
> -			if (!(vma->vm_flags & VM_LOCKED))
> -				continue;	/* must visit all vmas */
> -			ret = SWAP_MLOCK;	/* leave mlocked == 0 */
> -			goto out;		/* no need to look further */
> -		}
>  		if (!MLOCK_PAGES && !(flags & TTU_IGNORE_MLOCK) &&
>  			(vma->vm_flags & VM_LOCKED))
>  			continue;
> @@ -1161,10 +1111,9 @@ static int try_to_unmap_file(struct page
>  			cursor = (unsigned long) vma->vm_private_data;
>  			while ( cursor < max_nl_cursor &&
>  				cursor < vma->vm_end - vma->vm_start) {
> -				ret = try_to_unmap_cluster(cursor, &mapcount,
> -								vma, page);
> -				if (ret == SWAP_MLOCK)
> -					mlocked = 2;	/* to return below */
> +				if (try_to_unmap_cluster(cursor, &mapcount,
> +						vma, page) == SWAP_MLOCK)
> +					ret = SWAP_MLOCK;
>  				cursor += CLUSTER_SIZE;
>  				vma->vm_private_data = (void *) cursor;
>  				if ((int)mapcount <= 0)
> @@ -1185,10 +1134,6 @@ static int try_to_unmap_file(struct page
>  		vma->vm_private_data = NULL;
>  out:
>  	spin_unlock(&mapping->i_mmap_lock);
> -	if (mlocked)
> -		ret = SWAP_MLOCK;	/* actually mlocked the page */
> -	else if (ret == SWAP_MLOCK)
> -		ret = SWAP_AGAIN;	/* saw VM_LOCKED vma */
>  	return ret;
>  }
>  


