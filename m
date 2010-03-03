Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0CCGTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:19:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45806 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0CCGTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:19:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Mar 2010 15:15:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-Id: <20100303151549.5d3d686a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100303150137.f56d7084.nishimura@mxp.nes.nec.co.jp>
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
	<1267478620-5276-4-git-send-email-arighi@develer.com>
	<20100303111238.7133f8af.nishimura@mxp.nes.nec.co.jp>
	<20100303122906.9c613ab2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100303150137.f56d7084.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 15:01:37 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 3 Mar 2010 12:29:06 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 3 Mar 2010 11:12:38 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > > index fe09e51..f85acae 100644
> > > > --- a/mm/filemap.c
> > > > +++ b/mm/filemap.c
> > > > @@ -135,6 +135,7 @@ void __remove_from_page_cache(struct page *page)
> > > >  	 * having removed the page entirely.
> > > >  	 */
> > > >  	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
> > > > +		mem_cgroup_update_stat(page, MEM_CGROUP_STAT_FILE_DIRTY, -1);
> > > >  		dec_zone_page_state(page, NR_FILE_DIRTY);
> > > >  		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
> > > >  	}
> > > (snip)
> > > > @@ -1096,6 +1113,7 @@ int __set_page_dirty_no_writeback(struct page *page)
> > > >  void account_page_dirtied(struct page *page, struct address_space *mapping)
> > > >  {
> > > >  	if (mapping_cap_account_dirty(mapping)) {
> > > > +		mem_cgroup_update_stat(page, MEM_CGROUP_STAT_FILE_DIRTY, 1);
> > > >  		__inc_zone_page_state(page, NR_FILE_DIRTY);
> > > >  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
> > > >  		task_dirty_inc(current);
> > > As long as I can see, those two functions(at least) calls mem_cgroup_update_state(),
> > > which acquires page cgroup lock, under mapping->tree_lock.
> > > But as I fixed before in commit e767e056, page cgroup lock must not acquired under
> > > mapping->tree_lock.
> > > hmm, we should call those mem_cgroup_update_state() outside mapping->tree_lock,
> > > or add local_irq_save/restore() around lock/unlock_page_cgroup() to avoid dead-lock.
> > > 
> > Ah, good catch! But hmmmmmm...
> > This account_page_dirtted() seems to be called under IRQ-disabled.
> > About  __remove_from_page_cache(), I think page_cgroup should have its own DIRTY flag,
> > then, mem_cgroup_uncharge_page() can handle it automatically.
> > 
> > But. there are no guarantee that following never happens. 
> > 	lock_page_cgroup()
> > 	    <=== interrupt.
> > 	    -> mapping->tree_lock()
> > Even if mapping->tree_lock is held with IRQ-disabled.
> > Then, if we add local_irq_save(), we have to add it to all lock_page_cgroup().
> > 
> > Then, hm...some kind of new trick ? as..
> > (Follwoing patch is not tested!!)
> > 
> If we can verify that all callers of mem_cgroup_update_stat() have always either aquired
> or not aquired tree_lock, this direction will work fine.
> But if we can't, we have to add local_irq_save() to lock_page_cgroup() like below.
> 

Agreed.
Let's try how we can write a code in clean way. (we have time ;)
For now, to me, IRQ disabling while lock_page_cgroup() seems to be a little
over killing. What I really want is lockless code...but it seems impossible
under current implementation.

I wonder the fact "the page is never unchareged under us" can give us some chances
...Hmm.

Thanks,
-Kame

