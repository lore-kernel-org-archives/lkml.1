Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0CEHBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:01:48 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56856 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0CEHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:01:47 -0500
Date: Fri, 5 Mar 2010 12:31:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrea Righi <arighi@develer.com>, Vivek Goyal <vgoyal@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 3/4] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100305070133.GJ3073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1267699215-4101-1-git-send-email-arighi@develer.com>
 <1267699215-4101-4-git-send-email-arighi@develer.com>
 <20100305101234.909001e8.nishimura@mxp.nes.nec.co.jp>
 <20100305105855.9b53176c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100305105855.9b53176c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-05 10:58:55]:

> On Fri, 5 Mar 2010 10:12:34 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Thu,  4 Mar 2010 11:40:14 +0100, Andrea Righi <arighi@develer.com> wrote:
> > > Infrastructure to account dirty pages per cgroup and add dirty limit
> > >  static int mem_cgroup_count_children_cb(struct mem_cgroup *mem, void *data)
> > >  {
> > >  	int *val = data;
> > > @@ -1275,34 +1423,70 @@ static void record_last_oom(struct mem_cgroup *mem)
> > >  }
> > >  
> > >  /*
> > > - * Currently used to update mapped file statistics, but the routine can be
> > > - * generalized to update other statistics as well.
> > > + * Generalized routine to update file cache's status for memcg.
> > > + *
> > > + * Before calling this, mapping->tree_lock should be held and preemption is
> > > + * disabled.  Then, it's guarnteed that the page is not uncharged while we
> > > + * access page_cgroup. We can make use of that.
> > >   */
> > IIUC, mapping->tree_lock is held with irq disabled, so I think "mapping->tree_lock
> > should be held with irq disabled" would be enouth.
> > And, as far as I can see, callers of this function have not ensured this yet in [4/4].
> > 
> > how about:
> > 
> > 	void mem_cgroup_update_stat_locked(...)
> > 	{
> > 		...
> > 	}
> > 
> > 	void mem_cgroup_update_stat_unlocked(mapping, ...)
> > 	{
> > 		spin_lock_irqsave(mapping->tree_lock, ...);
> > 		mem_cgroup_update_stat_locked();
> > 		spin_unlock_irqrestore(...);
> > 	}
> >
> Rather than tree_lock, lock_page_cgroup() can be used if tree_lock is not held.
> 
> 		lock_page_cgroup();
> 		mem_cgroup_update_stat_locked();
> 		unlock_page_cgroup();
> 
> Andrea-san, FILE_MAPPED is updated without treelock, at least. You can't depend
> on migration_lock about FILE_MAPPED.
>

FILE_MAPPED is updated under pte lock in the rmap context and
page_cgroup lock within update_file_mapped.
 

-- 
	Three Cheers,
	Balbir
