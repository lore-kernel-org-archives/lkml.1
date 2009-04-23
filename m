Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZDWKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZDWKDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZDWKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:03:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43304 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbZDWKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p58evZoccYprRxz7qXwvLkOqRvHHgT4W2/AoSiol7+eup3O40nR778f2SJ9ivCS1kW
         V5S9clhlrBs5Q3Vn1YUvHv/fP1muqAXRI8rNSFICWkzEyHD7ps72uPybcnmHdw5cVJG8
         W8Y1jT0huTrQIiG1wLdz51bjdjW+h0iOnVxsI=
Date: Thu, 23 Apr 2009 12:03:35 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, Theodore Tso <tytso@mit.edu>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423100314.GB9756@linux>
References: <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:05:35AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Apr 2009 12:22:41 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
>  
> > Actually I was proposing something quite similar, if I've understood
> > well. Just add a hook in balance_dirty_pages() to throttle tasks in
> > cgroups that exhausted their IO BW.
> > 
> > The way to do so will be similar to the per-bdi write throttling, taking
> > in account the IO requests previously submitted per cgroup, the pages
> > dirtied per cgroup (considering that are not necessarily dirtied by the
> > owner of the page) and apply something like congestion_wait() to
> > throttle the tasks in the cgroups that exceeded the BW limit.
> > 
> > Maybe we can just introduce cgroup_dirty_limit() simply replicating what
> > we're doing for task_dirty_limit(), but using per cgroup statistics of
> > course.
> > 
> > I can change the io-throttle controller to do so. This feature should be
> > valid also for the proportional BW approach.
> > 
> > BTW Vivek's proposal to also dispatch IO requests according to cgroup
> > proportional BW limits can be still valid and it is worth to be tested
> > IMHO. But we must also find a way to say to the right cgroup: hey! stop
> > to waste the memory with dirty pages, because you've directly or
> > indirectly generated too much IO in the system and I'm throttling and/or
> > not scheduling your IO requests.
> > 
> > Objections?
> > 
> No objections. plz let me know my following understanding is right.
> 
>   1. dirty_ratio should be supported per cgroup.
>      - Memory cgroup should support dirty_ratio or dirty_ratio cgroup should be implemented.
>        For doing this, we can make use of page_cgroup.
> 
>        One good point of dirty-ratio cgroup is that dirty-ratio accounting is done
>        against a cgroup which made pages dirty not against a owner of the page. But
>        if dirty_ratio cgroup is completely independent from mem_cgroup, it cannot
>        be a help for memory reclaiming.
>        Then,
>          - memcg itself should have dirty_ratio check.
>          - like bdi/task_dirty_limit(), a cgroup (which is not memcg) can be used
>            another filter for dirty_ratio.

Agreed. We probably need two different dirty_ratio statistics: one to
check the dirty pages inside a memcg for memory reclaim, and another to
check how many dirty pages a cgroup has generated in the system.
Something similar to the task_struct->dirties and global dirty
statistics.

> 
>   2. dirty_ratio is not I/O BW control.

Agreed. They are two different problems. Maybe they could be connected,
but the connection can be made in userspace mounting dirty_ratio cgroup
and blockio subsystems together.

For example: give 10MB/s IO BW to cgroup A and also set a upper limit of
dirty pages this cgroup can generate in the system, i.e. 10% of the
system-wide reclaimable memory. If the dirty limit is exceeded the tasks
in this cgroup will start to actively writeback system-wide dirty pages
at the rate defined by the IO controller.

> 
>   3. I/O BW(limit) control cgroup should be implemented and it should be exsiting
>      in I/O scheduling layer or somewhere around. But it's not easy.

Agreed. Expecially for the "it's not easy" part. :)

> 
>   4. To track bufferred I/O, we have to add "tag" to pages which tell us who
>      generated the I/O. Now it's called blockio-cgroup and implementation details
>      are still under discussion.

OK.

> 
> So, current status is.
> 
>   A. memcg should support dirty_ratio for its own memory reclaim.
>      in plan.
> 
>   B. another cgroup can be implemnted to support cgroup_dirty_limit().
>      But relationship with "A" should be discussed.
>      no plan yet.
> 
>   C. I/O cgroup and bufferred I/O tracking system.
>      Now under patch review.

    D. I/O tracking system must be implemented as a common
       infrastructure and not a separate cgroup subsystem. This would
       allow to be easily reused also by other potential cgroup
       controllers, and avoid to introduce oddity, complexity in
       userspace (separate mountpoints, etc.)

> 
> And this I/O throttle is mainly for "C" discussion. 
> 
> Right ?

Right. In io-throttle v14 I also merged some of the blockio-cgroup
functionality, so IO throttle is mainly for C and D, but D should be
probably considered as a separate patchset.

-Andrea
