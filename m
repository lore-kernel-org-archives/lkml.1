Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYKAKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYKAKeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKAKeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:34:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33368 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYKAKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:34:04 -0400
Date: Sat, 1 Nov 2008 10:33:55 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Li Xiaodong <lixd@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]swap-zero-page-bug
In-Reply-To: <2C69C7D31680437FB174C65D043E2455@fujitsulixd>
Message-ID: <Pine.LNX.4.64.0811011012020.21848@blonde.site>
References: <2C69C7D31680437FB174C65D043E2455@fujitsulixd>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Li Xiaodong wrote:

> According to Documentation/filesystems/proc.txt, kernel should swap one page
> as vm.page-cluster is 0, while it seems not like so in mm/swapfile.c:
>      ...
> 	int our_page_cluster = page_cluster;
> 	...
> 	if (!our_page_cluster)  /* no readahead */
>                 return 0;
> 	...
> 
> It is better to remove that checkpoint.

No, page_cluster 0 allows swapin one page at a time, but disallows
swapin readahead (better named readaround) i.e. disallows reading
more than the one page actually requested.

Compare with how valid_swaphandles() is used from swapin_readahead():
there's actually one extra call to read_swap_cache_async() - because
we must ignore failure on the readaround but not on the page requested.

That "return 0" avoids the overhead of a pointlessly doubled
read_swap_cache_async() when there's only one page to be read.

Your patch might be needed if you'd found that swapin of one page
was not working at all - but you'd be making a stronger case if
you'd found that, I think!

Hugh
