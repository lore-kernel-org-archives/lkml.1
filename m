Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbXBGFob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbXBGFob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXBGFoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:44:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXBGFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:44:30 -0500
Date: Tue, 6 Feb 2007 21:44:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] smaps: add pages referenced count to smaps
Message-Id: <20070206214414.96b0336b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062121160.8623@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0702062122540.8623@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 21:27:03 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> @@ -190,18 +191,20 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
>  
>  	if (mss)
>  		seq_printf(m,
> -			   "Size:          %8lu kB\n"
> -			   "Rss:           %8lu kB\n"
> -			   "Shared_Clean:  %8lu kB\n"
> -			   "Shared_Dirty:  %8lu kB\n"
> -			   "Private_Clean: %8lu kB\n"
> -			   "Private_Dirty: %8lu kB\n",
> +			   "Size:           %8lu kB\n"
> +			   "Rss:            %8lu kB\n"
> +			   "Shared_Clean:   %8lu kB\n"
> +			   "Shared_Dirty:   %8lu kB\n"
> +			   "Private_Clean:  %8lu kB\n"
> +			   "Private_Dirty:  %8lu kB\n"
> +			   "Pgs_Referenced: %8li\n",

I guess we might as well make this %8lu kB as well?

>  			   (vma->vm_end - vma->vm_start) >> 10,
>  			   mss->resident >> 10,
>  			   mss->shared_clean  >> 10,
>  			   mss->shared_dirty  >> 10,
>  			   mss->private_clean >> 10,
> -			   mss->private_dirty >> 10);
> +			   mss->private_dirty >> 10,
> +			   mss->referenced);
>
> ...
>
> +	/* Accumulate the number of pages that have been accessed. */
> +	if (PageReferenced(page))
> +		mss->referenced++;

This is testing the software-referenced bit.  We want to be counting the
pte-referenced bits (pte_young).

Hence poking clear_refs should run pte_mkold().

Perhaps we should also be running ClearPageReferenced and counting pages
which are pte_young()||PageReferenced.

