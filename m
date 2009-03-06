Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZCFKQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZCFKQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZCFKQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:16:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52920 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZCFKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:16:00 -0500
Date: Fri, 6 Mar 2009 19:14:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] Memory controller soft limit reclaim on contention
 (v4)
Message-Id: <20090306191436.ceeb6e42.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306100155.GC5482@balbir.in.ibm.com>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306092353.21063.11068.sendpatchset@localhost.localdomain>
	<20090306185124.51a52519.kamezawa.hiroyu@jp.fujitsu.com>
	<20090306100155.GC5482@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 15:31:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:


> > > +		if (wait)
> > > +			wait_for_completion(&mem->wait_on_soft_reclaim);
> > >  	}
> > What ???? Why we have to wait here...holding mmap->sem...This is too bad.
> >
> 
> Since mmap_sem is no longer used for pthread_mutex*, I was not sure.
> That is why I added the comment asking for more review and see what
> people think about it. We get here only when
> 
> 1. The memcg is over its soft limit
> 2. Tasks/threads belonging to memcg are faulting in more pages
> 
> The idea is to throttle them. If we did reclaim inline, like we do for
> hard limits, we can still end up holding mmap_sem for a long time.
> 
This "throttle" is hard to measuer the effect and IIUC, not implemneted in
vmscan.c ...for global try_to_free_pages() yet.
Under memory shortage. before reaching here, the thread already called
try_to_free_pages() or check some memory shorage conditions because
it called alloc_pages(). So, waiting here is redundant and gives it
too much penaly.


> > > +	/*
> > > +	 * This loop can run a while, specially if mem_cgroup's continuously
> > > +	 * keep exceeding their soft limit and putting the system under
> > > +	 * pressure
> > > +	 */
> > > +	do {
> > > +		mem = mem_cgroup_get_largest_soft_limit_exceeding_node();
> > > +		if (!mem)
> > > +			break;
> > > +		usage = mem_cgroup_get_node_zone_usage(mem, zone, nid);
> > > +		if (!usage)
> > > +			goto skip_reclaim;
> > 
> > Why this works well ? if "mem" is the laragest, it will be inserted again
> > as the largest. Do I miss any ?
> >
> 
> No that is correct, but when reclaim is initiated from a different
> zone/node combination, we still want mem to show up. 
....
your logic is
==
   nr_reclaimd = 0;
   do {
      mem = select victim.
      remvoe victim from the RBtree (the largest usage one is selected)
      if (victim is not good)
          goto  skip this.
      reclaimed += shirnk_zone.
      
skip_this:
      if (mem is still exceeds soft limit)
           insert RB tree again.
   } while(!nr_reclaimed)
==
When this exits loop ?

Thanks,
-Kame

