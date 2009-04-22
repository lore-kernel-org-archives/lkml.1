Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZDVKW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZDVKW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZDVKWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:22:47 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:41223 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZDVKWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BBN/71q0skJOiDL+hmL4o9YFV/6502S/SM78MiAnkeFdb0QEBVWm8t5F6vgoo/kHdI
         okVHiwPzYMpGyro7ahtndnGzNVrlEAKhrbo6T6fxFjUi/0kQtbYcwyCOE4zy5FaJcSJ/
         Eyj5gmGITRsveeF6irDnRD0FcdCw4VuLOWfA8=
Date: Wed, 22 Apr 2009 12:22:41 +0200
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
Message-ID: <20090422102239.GA1935@linux>
References: <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux> <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:21:53AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Apr 2009 09:33:49 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> 
> > > And this should be probably strictly connected to the IO controller. If
> > > we throttle or delay the dispatching/submission of some IO requests
> > > without throttling the dirty pages rate a cgroup could completely waste
> > > its own available memory with dirty (hard and slow to reclaim) pages.
> > > 
> > > That is in part the approach I used in io-throttle v12, adding a hook in
> > > balance_dirty_pages_ratelimited_nr() to throttle the current task when
> > > cgroup's IO limit are exceeded. Argh!
> > > 
> > > So, another proposal could be to re-add in io-throttle v14 the old hook
> > > also in balance_dirty_pages_ratelimited_nr().
> > > 
> > > In this way io-throttle would:
> > > 
> > > - use page_cgroup infrastructure and page_cgroup->flags to encode the
> > >   cgroup id that firstly dirtied a generic page
> > > - account and opportunely throttle sync and writeback IO requests in
> > >   submit_bio()
> > > - at the same time throttle the tasks in
> > >   balance_dirty_pages_ratelimited_nr() if the cgroup they belong has
> > >   exhausted the IO BW (or quota, share, etc. in case of proportional BW
> > >   limit)
> > > 
> > 
> > IMHO, io-controller should just work as I/O subsystem as bdi. Now, per-bdi dirty_ratio
> > is suppoted and it seems to work well.  
> > 
> > Can't we write a function like  bdi_writeout_fraction() ?;
> > It will be a simple choice.
> > 
> One more thing, if you want dirty_ratio for throttoling I/O not for supporing page reclaim,
> Something like task_dirty_limit() will be apporpriate.
> 
> Thanks,
> -Kame

Actually I was proposing something quite similar, if I've understood
well. Just add a hook in balance_dirty_pages() to throttle tasks in
cgroups that exhausted their IO BW.

The way to do so will be similar to the per-bdi write throttling, taking
in account the IO requests previously submitted per cgroup, the pages
dirtied per cgroup (considering that are not necessarily dirtied by the
owner of the page) and apply something like congestion_wait() to
throttle the tasks in the cgroups that exceeded the BW limit.

Maybe we can just introduce cgroup_dirty_limit() simply replicating what
we're doing for task_dirty_limit(), but using per cgroup statistics of
course.

I can change the io-throttle controller to do so. This feature should be
valid also for the proportional BW approach.

BTW Vivek's proposal to also dispatch IO requests according to cgroup
proportional BW limits can be still valid and it is worth to be tested
IMHO. But we must also find a way to say to the right cgroup: hey! stop
to waste the memory with dirty pages, because you've directly or
indirectly generated too much IO in the system and I'm throttling and/or
not scheduling your IO requests.

Objections?

-Andrea
