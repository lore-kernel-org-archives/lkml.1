Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0CEGdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:33:07 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42819 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0CEGdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:33:04 -0500
Date: Fri, 5 Mar 2010 12:02:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 2/4] page_cgroup: introduce file cache flags
Message-ID: <20100305063249.GH3073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1267699215-4101-1-git-send-email-arighi@develer.com>
 <1267699215-4101-3-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1267699215-4101-3-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <arighi@develer.com> [2010-03-04 11:40:13]:

> Introduce page_cgroup flags to keep track of file cache pages.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---

Looks good


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

>  include/linux/page_cgroup.h |   49 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 30b0813..1b79ded 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -39,6 +39,12 @@ enum {
>  	PCG_CACHE, /* charged as cache */
>  	PCG_USED, /* this object is in use. */
>  	PCG_ACCT_LRU, /* page has been accounted for */
> +	PCG_MIGRATE_LOCK, /* used for mutual execution of account migration */
> +	PCG_ACCT_FILE_MAPPED, /* page is accounted as file rss*/
> +	PCG_ACCT_DIRTY, /* page is dirty */
> +	PCG_ACCT_WRITEBACK, /* page is being written back to disk */
> +	PCG_ACCT_WRITEBACK_TEMP, /* page is used as temporary buffer for FUSE */
> +	PCG_ACCT_UNSTABLE_NFS, /* NFS page not yet committed to the server */
>  };
> 
>  #define TESTPCGFLAG(uname, lname)			\
> @@ -73,6 +79,27 @@ CLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  TESTPCGFLAG(AcctLRU, ACCT_LRU)
>  TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
> 
> +/* File cache and dirty memory flags */
> +TESTPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
> +SETPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
> +CLEARPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
> +
> +TESTPCGFLAG(Dirty, ACCT_DIRTY)
> +SETPCGFLAG(Dirty, ACCT_DIRTY)
> +CLEARPCGFLAG(Dirty, ACCT_DIRTY)
> +
> +TESTPCGFLAG(Writeback, ACCT_WRITEBACK)
> +SETPCGFLAG(Writeback, ACCT_WRITEBACK)
> +CLEARPCGFLAG(Writeback, ACCT_WRITEBACK)
> +
> +TESTPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
> +SETPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
> +CLEARPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
> +
> +TESTPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
> +SETPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
> +CLEARPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
> +
>  static inline int page_cgroup_nid(struct page_cgroup *pc)
>  {
>  	return page_to_nid(pc->page);
> @@ -83,6 +110,9 @@ static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
>  	return page_zonenum(pc->page);
>  }
> 
> +/*
> + * lock_page_cgroup() should not be held under mapping->tree_lock
> + */

May be a DEBUG WARN_ON would be appropriate here?

>  static inline void lock_page_cgroup(struct page_cgroup *pc)
>  {
>  	bit_spin_lock(PCG_LOCK, &pc->flags);
> @@ -93,6 +123,25 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
>  	bit_spin_unlock(PCG_LOCK, &pc->flags);
>  }
> 
> +/*
> + * Lock order is
> + *     lock_page_cgroup()
> + *             lock_page_cgroup_migrate()
> + *
> + * This lock is not be lock for charge/uncharge but for account moving.
> + * i.e. overwrite pc->mem_cgroup. The lock owner should guarantee by itself
> + * the page is uncharged while we hold this.
> + */
> +static inline void lock_page_cgroup_migrate(struct page_cgroup *pc)
> +{
> +	bit_spin_lock(PCG_MIGRATE_LOCK, &pc->flags);
> +}
> +
> +static inline void unlock_page_cgroup_migrate(struct page_cgroup *pc)
> +{
> +	bit_spin_unlock(PCG_MIGRATE_LOCK, &pc->flags);
> +}
> +
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct page_cgroup;
> 
> -- 
> 1.6.3.3
> 

-- 
	Three Cheers,
	Balbir
