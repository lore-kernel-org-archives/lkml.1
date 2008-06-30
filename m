Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYF3Cja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYF3Cja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYF3CjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:39:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYF3CjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:39:20 -0400
Date: Mon, 30 Jun 2008 11:44:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
Message-Id: <20080630114439.da792361.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290120270.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290120270.21758@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:22:22 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru,
> so shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Should follow mmotm's vmscan-split-lru-lists-into-anon-file-sets.patch
> 
>  mm/memcontrol.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
> +++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
> @@ -560,6 +560,8 @@ static int mem_cgroup_charge_common(stru
>  		pc->flags = PAGE_CGROUP_FLAG_CACHE;
>  		if (page_is_file_cache(page))
>  			pc->flags |= PAGE_CGROUP_FLAG_FILE;
> +		else
> +			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
>  	} else
>  		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
>  
> 
Hmm, maybe no trouble but we'll have to care shmem's page is not marked as
PAGE_CGROUP_FLAG_CACHE but charged by mem_cgroup_charge_cache_page(). 
(I think why shmem is charged as cache is because shmem is used for tmpfs)

pc->flags |= PAGE_CGROUP_FLAG_FILE |  PAGE_CGROUP_FLAG_ACTIVE;

is bad ? (or not work ? I can't catch yet.)


And we have to change this again ;)
==
        [MEM_CGROUP_STAT_RSS] = { "anon/swapcache", PAGE_SIZE, },
==


Thanks,
-Kame


