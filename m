Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0CEWPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:15:05 -0500
Received: from trinity.develer.com ([83.149.158.210]:59906 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab0CEWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:15:01 -0500
Date: Fri, 5 Mar 2010 23:14:56 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 3/4] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100305221456.GB1578@linux>
References: <1267699215-4101-1-git-send-email-arighi@develer.com>
 <1267699215-4101-4-git-send-email-arighi@develer.com>
 <20100305101234.909001e8.nishimura@mxp.nes.nec.co.jp>
 <20100305105855.9b53176c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305105855.9b53176c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:58:55AM +0900, KAMEZAWA Hiroyuki wrote:
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

Right. I'll consider this in the next version of the patch.

Thanks,
-Andrea
