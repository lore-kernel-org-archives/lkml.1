Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYAJCWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYAJCWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbYAJCVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:21:52 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50016 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372AbYAJCVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:21:51 -0500
Date: Thu, 10 Jan 2008 07:51:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080110022133.GC15547@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
References: <20080108205939.323955454@redhat.com> <20080108210002.638347207@redhat.com> <20080109134132.ba7bb33c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080109134132.ba7bb33c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-01-09 13:41:32]:

> I like this patch set thank you.
> 
> On Tue, 08 Jan 2008 15:59:44 -0500
> Rik van Riel <riel@redhat.com> wrote:
> > Index: linux-2.6.24-rc6-mm1/mm/memcontrol.c
> > ===================================================================
> > --- linux-2.6.24-rc6-mm1.orig/mm/memcontrol.c	2008-01-07 11:55:09.000000000 -0500
> > +++ linux-2.6.24-rc6-mm1/mm/memcontrol.c	2008-01-07 17:32:53.000000000 -0500
> <snip>
> 
> > -enum mem_cgroup_zstat_index {
> > -	MEM_CGROUP_ZSTAT_ACTIVE,
> > -	MEM_CGROUP_ZSTAT_INACTIVE,
> > -
> > -	NR_MEM_CGROUP_ZSTAT,
> > -};
> > -
> >  struct mem_cgroup_per_zone {
> >  	/*
> >  	 * spin_lock to protect the per cgroup LRU
> >  	 */
> >  	spinlock_t		lru_lock;
> > -	struct list_head	active_list;
> > -	struct list_head	inactive_list;
> > -	unsigned long count[NR_MEM_CGROUP_ZSTAT];
> > +	struct list_head	lists[NR_LRU_LISTS];
> > +	unsigned long		count[NR_LRU_LISTS];
> >  };
> >  /* Macro for accessing counter */
> >  #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
> > @@ -160,6 +152,7 @@ struct page_cgroup {
> >  };
> >  #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
> >  #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
> > +#define PAGE_CGROUP_FLAG_FILE	(0x4)	/* page is file system backed */
> > 
> 
> Now, we don't have control_type and a feature for accounting only CACHE.
> Balbir-san, do you have some new plan ?
>

Hi, KAMEZAWA-San,

The control_type feature is gone. We still have cached page
accounting, but we do not allow control of only RSS pages anymore. We
need to control both RSS+cached pages. I do not understand your
question about new plan? Is it about adding back control_type?

 
> BTW, is it better to use PageSwapBacked(pc->page) rather than adding a new flag
> PAGE_CGROUP_FLAG_FILE ?
> 
> 
> PAGE_CGROUP_FLAG_ACTIVE is used because global reclaim can change
> ACTIVE/INACTIVE attribute without accessing memory cgroup.
> (Then, we cannot trust PageActive(pc->page))
> 

Yes, correct. A page active on the node's zone LRU need not be active
in the memory cgroup.

> ANON <-> FILE attribute can be changed dinamically (after added to LRU) ?
> 
> If no, using page_file_cache(pc->page) will be easy.
> 
> Thanks,
> -Kame
> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
