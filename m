Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZBJIvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZBJIvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZBJIvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:51:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37433 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZBJIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:51:40 -0500
Date: Tue, 10 Feb 2009 17:50:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID v2
Message-Id: <20090210175019.b100b279.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090210080700.GC16317@balbir.in.ibm.com>
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090209145557.d0754a9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090210080700.GC16317@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 13:37:00 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-09 14:55:57]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >  static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
> >  {
> > -	struct mem_cgroup *mem;
> > +	unsigned short id;
> > +	struct mem_cgroup *mem = NULL;
> >  	swp_entry_t ent;
> > 
> >  	if (!PageSwapCache(page))
> >  		return NULL;
> > 
> >  	ent.val = page_private(page);
> > -	mem = lookup_swap_cgroup(ent);
> > -	if (!mem)
> > -		return NULL;
> > +	id = lookup_swap_cgroup(ent);
> > +	rcu_read_lock();
> > +	mem = mem_cgroup_lookup(id);
> >  	if (!css_tryget(&mem->css))
> > -		return NULL;
> > +		mem = NULL;
> 
> This part is a bit confusing. If the page got swapped out and the CSS
> it belonged to got swapped out, we set mem to NULL. Is this so that it
> can be charged to root cgroup?
IIUC, this charge will go to "current" process's cgroup.

> If so, could you please add a comment indicating the same.
> 
Ah yes, I'll add some comments.


> > +	rcu_read_unlock();
> >  	return mem;
> >  }
> > 
> > @@ -1275,12 +1296,20 @@ int mem_cgroup_cache_charge(struct page 
> > 
> >  	if (do_swap_account && !ret && PageSwapCache(page)) {
> >  		swp_entry_t ent = {.val = page_private(page)};
> > +		unsigned short id;
> >  		/* avoid double counting */
> > -		mem = swap_cgroup_record(ent, NULL);
> > +		id = swap_cgroup_record(ent, 0);
> > +		rcu_read_lock();
> > +		mem = mem_cgroup_lookup(id);
> >  		if (mem) {
> > +			/*
> > +			 * Recorded ID can be obsolete. We avoid calling
> > +			 * css_tryget()
> > +			 */
> >  			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
> >  			mem_cgroup_put(mem);
> >  		}
> 
> If !mem, do we leak charge?
No, it just means some other thread removed the ID before us.

> BTW, We no longer hold css references if the page is swapped out?
> 
The situation is a bit complicated.
When cgroup is obsolete but its mem_cgroup is alive (because of reference
from swap), css_tryget() always fails. swap_cgroup_record() is atomic
compare-and-exchange, so I think we can trust mem_cgroup_put/get refcnt
management and doesn't need to rely on css's refcnt at swap management.


Thanks,
-Kame

