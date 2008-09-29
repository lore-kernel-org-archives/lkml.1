Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYI2LoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYI2LoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 07:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYI2LoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 07:44:18 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61245 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYI2LoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 07:44:17 -0400
Date: Mon, 29 Sep 2008 20:33:07 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: Re: [PATCH 1/4] memcg: account swap cache under lock
Message-Id: <20080929203307.918e7990.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080929192123.5ce60c24.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com>
	<20080929192123.5ce60c24.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 19:21:23 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> While page-cache's charge/uncharge is done under page_lock(), swap-cache
> isn't. (anonymous page is charged when it's newly allocated.)
> 
> This patch moves do_swap_page()'s charge() call under lock.
> I don't see any bad problem *now* but this fix will be good for future
> for avoiding unneccesary racy state.
> 
> 
> Changelog: (v5) -> (v6)
>  - mark_page_accessed() is moved before lock_page().
>  - fixed missing unlock_page()
> (no changes in previous version)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Looks good to me.

	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

>  mm/memory.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> Index: mmotm-2.6.27-rc7+/mm/memory.c
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/mm/memory.c
> +++ mmotm-2.6.27-rc7+/mm/memory.c
> @@ -2326,16 +2326,17 @@ static int do_swap_page(struct mm_struct
>  		count_vm_event(PGMAJFAULT);
>  	}
>  
> +	mark_page_accessed(page);
> +
> +	lock_page(page);
> +	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> +
>  	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
> -		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
>  		ret = VM_FAULT_OOM;
> +		unlock_page(page);
>  		goto out;
>  	}
>  
> -	mark_page_accessed(page);
> -	lock_page(page);
> -	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> -
>  	/*
>  	 * Back out if somebody else already faulted in this pte.
>  	 */
> 
