Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYFXH21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYFXH21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFXH2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:28:18 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48199 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbYFXH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:28:17 -0400
Message-ID: <4860A1EB.4070202@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2008 12:57:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: end migration fix (was  [bad page] memcg: another
 bad page at page migration (2.6.26-rc5-mm3 + patch collection))
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp> <20080624145127.539eb5ff.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080624145127.539eb5ff.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hi, Nishimura-san. thank you for all your help. 
> 
> I think this one is......hopefully.
> 
> ==
> 
> In general, mem_cgroup's charge on ANON page is removed when page_remove_rmap()
> is called.
> 
> At migration, the newpage is remapped again by remove_migration_ptes(). But
> pte may be already changed (by task exits).
> It is charged at page allocation but have no chance to be uncharged in that
> case because it is never added to rmap.
> 
> Handle that corner case in mem_cgroup_end_migration().
> 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> ---
>  mm/memcontrol.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> Index: test2-2.6.26-rc5-mm3/mm/memcontrol.c
> ===================================================================
> --- test2-2.6.26-rc5-mm3.orig/mm/memcontrol.c
> +++ test2-2.6.26-rc5-mm3/mm/memcontrol.c
> @@ -747,10 +747,22 @@ int mem_cgroup_prepare_migration(struct 
>  /* remove redundant charge if migration failed*/
>  void mem_cgroup_end_migration(struct page *newpage)
>  {
> -	/* At success, page->mapping is not NULL and nothing to do. */
> +	/*
> +	 * At success, page->mapping is not NULL.
> +	 * special rollback care is necessary when
> +	 * 1. at migration failure. (newpage->mapping is cleared in this case)
> +	 * 2. the newpage was moved but not remapped again because the task
> +	 *    exits and the newpage is obsolete. In this case, the new page
> +	 *    may be a swapcache. So, we just call mem_cgroup_uncharge_page()
> +	 *    always for avoiding mess. The  page_cgroup will be removed if
> +	 *    unnecessary. File cache pages is still on radix-tree. Don't
> +	 *    care it.
> +	 */
>  	if (!newpage->mapping)
>  		__mem_cgroup_uncharge_common(newpage,
>  					 MEM_CGROUP_CHARGE_TYPE_FORCE);
> +	else if (PageAnon(newpage))
> +		mem_cgroup_uncharge_page(newpage);
>  }

Definitely makes sense to me!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
