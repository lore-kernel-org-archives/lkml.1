Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZDVAEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZDVAEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZDVADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:03:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50065 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDVADw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:03:52 -0400
Date: Wed, 22 Apr 2009 09:02:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add file based RSS accounting for memory resource
 controller (v3)
Message-Id: <20090422090218.6d451a08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090421132551.38e9960a.akpm@linux-foundation.org>
References: <20090416120316.GG7082@balbir.in.ibm.com>
	<20090417091459.dac2cc39.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417014042.GB18558@balbir.in.ibm.com>
	<20090417110350.3144183d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417034539.GD18558@balbir.in.ibm.com>
	<20090417124951.a8472c86.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417045623.GA3896@balbir.in.ibm.com>
	<20090417141726.a69ebdcc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417064726.GB3896@balbir.in.ibm.com>
	<20090417155608.eeed1f02.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417141837.GD3896@balbir.in.ibm.com>
	<20090421132551.38e9960a.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 13:25:51 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 17 Apr 2009 19:48:38 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> >
> > ...
> >
> > We currently don't track file RSS, the RSS we report is actually anon RSS.
> > All the file mapped pages, come in through the page cache and get accounted
> > there. This patch adds support for accounting file RSS pages. It should
> > 
> > 1. Help improve the metrics reported by the memory resource controller
> > 2. Will form the basis for a future shared memory accounting heuristic
> >    that has been proposed by Kamezawa.
> > 
> > Unfortunately, we cannot rename the existing "rss" keyword used in memory.stat
> > to "anon_rss". We however, add "mapped_file" data and hope to educate the end
> > user through documentation.
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> >
> > ...
> >
> > @@ -1096,6 +1135,10 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
> >  	struct mem_cgroup_per_zone *from_mz, *to_mz;
> >  	int nid, zid;
> >  	int ret = -EBUSY;
> > +	struct page *page;
> > +	int cpu;
> > +	struct mem_cgroup_stat *stat;
> > +	struct mem_cgroup_stat_cpu *cpustat;
> >  
> >  	VM_BUG_ON(from == to);
> >  	VM_BUG_ON(PageLRU(pc->page));
> > @@ -1116,6 +1159,23 @@ static int mem_cgroup_move_account(struct page_cgroup *pc,
> >  
> >  	res_counter_uncharge(&from->res, PAGE_SIZE);
> >  	mem_cgroup_charge_statistics(from, pc, false);
> > +
> > +	page = pc->page;
> > +	if (page_is_file_cache(page) && page_mapped(page)) {
> > +		cpu = smp_processor_id();
> > +		/* Update mapped_file data for mem_cgroup "from" */
> > +		stat = &from->stat;
> > +		cpustat = &stat->cpustat[cpu];
> > +		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
> > +						-1);
> > +
> > +		/* Update mapped_file data for mem_cgroup "to" */
> > +		stat = &to->stat;
> > +		cpustat = &stat->cpustat[cpu];
> > +		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
> > +						1);
> > +	}
> 
> This function (mem_cgroup_move_account()) does a trylock_page_cgroup()
> and if that fails it will bale out, and the newly-added code will not
> be executed.
yes. and returns -EBUSY.

> 
> What are the implications of this?  Does the missed accounting later get
> performed somewhere, or does the error remain in place?
> 
no error just -BUSY. the caller (now, only force_empty is the caller) will do retry.

> That trylock_page_cgroup() really sucks - trylocks usually do.  Could
> someone please raise a patch which completely documents the reasons for
> its presence, and for any other uncommented/unobvious trylocks?
> 
> Where appropriate, the comment should explain why the trylock isn't
> simply a bug - why it is safe and correct to omit the operations which
> we wished to perform.
> 
> Thanks.
> 
Hmm...maybe we can replace trylock with lock, here.

IIRC, this has been trylock because the old routine uses other locks
(mem_cgroup' zone mz->lru_lock) before calling this.
   mz->lru_lock
     lock_page_cgroup()
And there was other routine which calls lock_page_cgroup()->mz->lru_lock.
   lock_page_cgroup()
        -> mz->lru_lock.

So, I used trylock here. But now, the lock(mz->lru_lock) is removed.
I should check this.

Thank you for pointing out.

Regards,
-Kame

