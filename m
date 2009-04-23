Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZDWAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZDWAH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZDWAHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:07:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41519 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDWAHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:07:12 -0400
Date: Thu, 23 Apr 2009 09:05:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
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
Message-Id: <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090422102239.GA1935@linux>
References: <20090421140631.GF19186@mit.edu>
	<20090421143130.GA22626@linux>
	<20090421163537.GI19186@mit.edu>
	<20090421172317.GM19637@balbir.in.ibm.com>
	<20090421174620.GD15541@mit.edu>
	<20090421181429.GO19637@balbir.in.ibm.com>
	<20090421191401.GF15541@mit.edu>
	<20090421204905.GA5573@linux>
	<20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102239.GA1935@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 12:22:41 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:
 
> Actually I was proposing something quite similar, if I've understood
> well. Just add a hook in balance_dirty_pages() to throttle tasks in
> cgroups that exhausted their IO BW.
> 
> The way to do so will be similar to the per-bdi write throttling, taking
> in account the IO requests previously submitted per cgroup, the pages
> dirtied per cgroup (considering that are not necessarily dirtied by the
> owner of the page) and apply something like congestion_wait() to
> throttle the tasks in the cgroups that exceeded the BW limit.
> 
> Maybe we can just introduce cgroup_dirty_limit() simply replicating what
> we're doing for task_dirty_limit(), but using per cgroup statistics of
> course.
> 
> I can change the io-throttle controller to do so. This feature should be
> valid also for the proportional BW approach.
> 
> BTW Vivek's proposal to also dispatch IO requests according to cgroup
> proportional BW limits can be still valid and it is worth to be tested
> IMHO. But we must also find a way to say to the right cgroup: hey! stop
> to waste the memory with dirty pages, because you've directly or
> indirectly generated too much IO in the system and I'm throttling and/or
> not scheduling your IO requests.
> 
> Objections?
> 
No objections. plz let me know my following understanding is right.

  1. dirty_ratio should be supported per cgroup.
     - Memory cgroup should support dirty_ratio or dirty_ratio cgroup should be implemented.
       For doing this, we can make use of page_cgroup.

       One good point of dirty-ratio cgroup is that dirty-ratio accounting is done
       against a cgroup which made pages dirty not against a owner of the page. But
       if dirty_ratio cgroup is completely independent from mem_cgroup, it cannot
       be a help for memory reclaiming.
       Then,
         - memcg itself should have dirty_ratio check.
         - like bdi/task_dirty_limit(), a cgroup (which is not memcg) can be used
           another filter for dirty_ratio.

  2. dirty_ratio is not I/O BW control.

  3. I/O BW(limit) control cgroup should be implemented and it should be exsiting
     in I/O scheduling layer or somewhere around. But it's not easy.

  4. To track bufferred I/O, we have to add "tag" to pages which tell us who
     generated the I/O. Now it's called blockio-cgroup and implementation details
     are still under discussion.

So, current status is.

  A. memcg should support dirty_ratio for its own memory reclaim.
     in plan.

  B. another cgroup can be implemnted to support cgroup_dirty_limit().
     But relationship with "A" should be discussed.
     no plan yet.

  C. I/O cgroup and bufferred I/O tracking system.
     Now under patch review.

And this I/O throttle is mainly for "C" discussion. 

Right ?

-Kame



Regards,
-Kame




