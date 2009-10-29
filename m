Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZJ2A7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZJ2A7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZJ2A7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:59:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54654 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZJ2A7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:59:12 -0400
Date: Thu, 29 Oct 2009 09:50:51 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Lee.Schermerhorn@hp.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH] memcg: fix wrong pointer initialization at page
 migration when memcg is disabled.
Message-Id: <20091029095051.7812e5ad.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091029093013.cd58f3a5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091029093013.cd58f3a5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 09:30:13 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> Lee Schermerhorn reported that he saw bad pointer dereference
> in mem_cgroup_end_migration() when he disabled memcg by boot option.
> 
> memcg's page migration logic works as
> 
> 	mem_cgroup_prepare_migration(page, &ptr);
> 	do page migration
> 	mem_cgroup_end_migration(page, ptr);
> 
> Now, ptr is not initialized in prepare_migration when memcg is disabled
> by boot option. This causes panic in end_migration. This patch fixes it.
> 
> Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.32-rc5/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/mm/memcontrol.c
> +++ linux-2.6.32-rc5/mm/memcontrol.c
> @@ -1990,7 +1990,8 @@ int mem_cgroup_prepare_migration(struct 
>  	struct page_cgroup *pc;
>  	struct mem_cgroup *mem = NULL;
>  	int ret = 0;
> -
> +	/* this pointer will be checked at end_migration */
> +	*ptr = NULL;
>  	if (mem_cgroup_disabled())
>  		return 0;
>  
> 
I thought unmap_and_move() itself initializes "mem" to NULL, but it doesn't...
I personaly prefer initializing "mem" to NULL in unmap_and_move(), but anyway
I think this patch is also correct.

	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

And I think we should send a fix for this bug to -stable too.


Thanks,
Daisuke Nishimura.
