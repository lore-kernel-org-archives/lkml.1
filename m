Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbZAONna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbZAONna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765364AbZAONnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:43:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765260AbZAONnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:43:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] mark_page_accessed() in do_swap_page() move latter than memcg charge
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, menage@google.com,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090115212030.EBE9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <Pine.LNX.4.64.0901151145470.11108@blonde.anvils> <20090115212030.EBE9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20090115224112.EBEC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 15 Jan 2009 22:43:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (CC to Rik and Nick)
> 
> Hi
> 
> Thank you reviewing.
> 
> > > mark_page_accessed() update reclaim_stat statics.
> > > but currently, memcg charge is called after mark_page_accessed().
> > > 
> > > then, mark_page_accessed() don't update memcg statics correctly.
> > 
> > Statics?  "Stats" is a good abbreviation for statistics,
> > but statics are something else.
> 
> Doh! your are definitly right. thanks.
> 
> > > ---
> > >  mm/memory.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > Index: b/mm/memory.c
> > > ===================================================================
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -2426,8 +2426,6 @@ static int do_swap_page(struct mm_struct
> > >  		count_vm_event(PGMAJFAULT);
> > >  	}
> > >  
> > > -	mark_page_accessed(page);
> > > -
> > >  	lock_page(page);
> > >  	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> > >  
> > > @@ -2480,6 +2478,8 @@ static int do_swap_page(struct mm_struct
> > >  		try_to_free_swap(page);
> > >  	unlock_page(page);
> > >  
> > > +	mark_page_accessed(page);
> > > +
> > >  	if (write_access) {
> > >  		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
> > >  		if (ret & VM_FAULT_ERROR)
> > 
> > This catches my eye, because I'd discussed with Nick and was going to
> > send in a patch which entirely _removes_ this mark_page_accessed call
> > from do_swap_page (and replaces follow_page's mark_page_accessed call
> > by a pte_mkyoung): they seem inconsistent to me, in the light of
> > bf3f3bc5e734706730c12a323f9b2068052aa1f0 mm: don't mark_page_accessed
> > in fault path.
> 
> Actually, bf3f3bc5e734706730c12a323f9b2068052aa1f0 only remove 
> the mark_page_accessed() in filemap_fault().
> current mmotm's do_swap_page() still have mark_page_accessed().
> 
> but your suggestion is very worth.
> ok, I'm thinking and sorting out again.
> 
> Rik's commit 9ff473b9a72942c5ac0ad35607cae28d8d59ed7a vmscan: evict streaming IO first
> does "reclaim stastics don't only update at reclaim, but also at fault and read/write.
> it makes proper anon/file reclaim balancing stastics value before starting actual reclaim".
> and it depend on fault path calling mark_page_accessed(). 
> 
> Then, we need following change. I think.
> 
>   - Remove calling mark_page_accessed() in do_swap_page().
>     it makes consistency against filemap_fault().
>   - Add calling update_page_reclaim_stat() into do_swap_page() and 
>     filemap_fault().
> 
> Am I overlooking something?

Doh! please ignore last mail's patch. I forgot grab zone->lru_lock.
it's perfectly buggy.

I'll make it again tommorow.


