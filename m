Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0CKW1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:27:08 -0500
Received: from trinity.develer.com ([83.149.158.210]:60503 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0CKW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:27:05 -0500
Date: Thu, 11 Mar 2010 23:27:01 +0100
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 4/5] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100311222701.GC2427@linux>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
 <1268175636-4673-5-git-send-email-arighi@develer.com>
 <20100310222338.GB3009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100310222338.GB3009@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 05:23:39PM -0500, Vivek Goyal wrote:
> On Wed, Mar 10, 2010 at 12:00:35AM +0100, Andrea Righi wrote:
> 
> [..]
> 
> > - * Currently used to update mapped file statistics, but the routine can be
> > - * generalized to update other statistics as well.
> > + * mem_cgroup_update_page_stat() - update memcg file cache's accounting
> > + * @page:	the page involved in a file cache operation.
> > + * @idx:	the particular file cache statistic.
> > + * @charge:	true to increment, false to decrement the statistic specified
> > + *		by @idx.
> > + *
> > + * Update memory cgroup file cache's accounting.
> >   */
> > -void mem_cgroup_update_file_mapped(struct page *page, int val)
> > +void mem_cgroup_update_page_stat(struct page *page,
> > +			enum mem_cgroup_write_page_stat_item idx, bool charge)
> >  {
> > -	struct mem_cgroup *mem;
> >  	struct page_cgroup *pc;
> >  	unsigned long flags;
> >  
> > +	if (mem_cgroup_disabled())
> > +		return;
> >  	pc = lookup_page_cgroup(page);
> > -	if (unlikely(!pc))
> > +	if (unlikely(!pc) || !PageCgroupUsed(pc))
> >  		return;
> > -
> >  	lock_page_cgroup(pc, flags);
> > -	mem = pc->mem_cgroup;
> > -	if (!mem)
> > -		goto done;
> > -
> > -	if (!PageCgroupUsed(pc))
> > -		goto done;
> > -
> > -	/*
> > -	 * Preemption is already disabled. We can use __this_cpu_xxx
> > -	 */
> > -	__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED], val);
> > -
> > -done:
> > +	__mem_cgroup_update_page_stat(pc, idx, charge);
> >  	unlock_page_cgroup(pc, flags);
> >  }
> > +EXPORT_SYMBOL_GPL(mem_cgroup_update_page_stat_unlocked);
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c:1600: error: ‘mem_cgroup_update_page_stat_unlocked’
> undeclared here (not in a function)
> mm/memcontrol.c:1600: warning: type defaults to ‘int’ in declaration of
> ‘mem_cgroup_update_page_stat_unlocked’
> make[1]: *** [mm/memcontrol.o] Error 1
> make: *** [mm] Error 2

Thanks! Will fix in the next version.

(mmh... why I didn't see this? probably because I'm building a static kernel...)

-Andrea
