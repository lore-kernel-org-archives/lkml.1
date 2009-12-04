Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZLDAgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZLDAgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZLDAgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:36:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49647 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZLDAgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:36:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed workload
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <1259878496.2345.57.camel@dhcp-100-19-198.bos.redhat.com>
References: <4B15CEE0.2030503@redhat.com> <1259878496.2345.57.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20091204092445.587D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 09:36:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-12-01 at 21:20 -0500, Rik van Riel wrote:
> 
> > This is reasonable, except for the fact that pages that are moved
> > to the inactive list without having the referenced bit cleared are
> > guaranteed to be moved back to the active list.
> > 
> > You'll be better off without that excess list movement, by simply
> > moving pages directly back onto the active list if the trylock
> > fails.
> > 
> 
> 
> The attached patch addresses this issue by changing page_check_address()
> to return -1 if the spin_trylock() fails and page_referenced_one() to
> return 1 in that path so the page gets moved back to the active list.
> 
> Also, BTW, check this out: an 8-CPU/16GB system running AIM 7 Compute
> has 196491 isolated_anon pages.  This means that ~6140 processes are
> somewhere down in try_to_free_pages() since we only isolate 32 pages at
> a time, this is out of 9000 processes...
> 
> 
> ---------------------------------------------------------------------
> active_anon:2140361 inactive_anon:453356 isolated_anon:196491
>  active_file:3438 inactive_file:1100 isolated_file:0
>  unevictable:2802 dirty:153 writeback:0 unstable:0
>  free:578920 slab_reclaimable:49214 slab_unreclaimable:93268
>  mapped:1105 shmem:0 pagetables:139100 bounce:0
> 
> Node 0 Normal free:1647892kB min:12500kB low:15624kB high:18748kB 
> active_anon:7835452kB inactive_anon:785764kB active_file:13672kB 
> inactive_file:4352kB unevictable:11208kB isolated(anon):785964kB 
> isolated(file):0kB present:12410880kB mlocked:11208kB dirty:604kB 
> writeback:0kB mapped:4344kB shmem:0kB slab_reclaimable:177792kB 
> slab_unreclaimable:368676kB kernel_stack:73256kB pagetables:489972kB 
> unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> 
> 202895 total pagecache pages
> 197629 pages in swap cache
> Swap cache stats: add 6954838, delete 6757209, find 1251447/2095005
> Free swap  = 65881196kB
> Total swap = 67354616kB
> 3997696 pages RAM
> 207046 pages reserved
> 1688629 pages shared
> 3016248 pages non-shared

This seems we have to improve reclaim bale out logic. the system already
have 1.5GB free pages. IOW, the system don't need swap-out anymore.



> @@ -352,9 +359,11 @@ static int page_referenced_one(struct page *page,
>  	if (address == -EFAULT)
>  		goto out;
>  
> -	pte = page_check_address(page, mm, address, &ptl, 0);
> +	pte = page_check_address(page, mm, address, &ptl, 0, trylock);
>  	if (!pte)
>  		goto out;
> +	else if (pte == (pte_t *)-1)
> +		return 1;
>  
>  	/*
>  	 * Don't want to elevate referenced for mlocked page that gets this far,

Sorry, NAK.
I have to say the same thing of Rik's previous mention. shrink_active_list()
ignore the return value of page_referenced(). then above 'return 1' is meaningless.

Umm, ok, I'll make the patch myself.


