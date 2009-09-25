Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628AbZIYF3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbZIYF3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZIYF3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:29:16 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36708 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYF3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:29:15 -0400
Date: Fri, 25 Sep 2009 10:59:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, peterz@infradead.org,
       jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20090925052911.GK4590@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
 <20090924143315.781cd0ac.akpm@linux-foundation.org>
 <20090925100952.55c2dd7a.kamezawa.hiroyu@jp.fujitsu.com>
 <20090925101821.1de8091a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090925101821.1de8091a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-09-25 10:18:21]:

> On Fri, 25 Sep 2009 10:09:52 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 24 Sep 2009 14:33:15 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > Test5 (Fairness for async writes, Buffered Write Vs Buffered Write)
> > > > ===================================================================
> > > > Fairness for async writes is tricky and biggest reason is that async writes
> > > > are cached in higher layers (page cahe) as well as possibly in file system
> > > > layer also (btrfs, xfs etc), and are dispatched to lower layers not necessarily
> > > > in proportional manner.
> > > > 
> > > > For example, consider two dd threads reading /dev/zero as input file and doing
> > > > writes of huge files. Very soon we will cross vm_dirty_ratio and dd thread will
> > > > be forced to write out some pages to disk before more pages can be dirtied. But
> > > > not necessarily dirty pages of same thread are picked. It can very well pick
> > > > the inode of lesser priority dd thread and do some writeout. So effectively
> > > > higher weight dd is doing writeouts of lower weight dd pages and we don't see
> > > > service differentation.
> > > > 
> > > > IOW, the core problem with buffered write fairness is that higher weight thread
> > > > does not throw enought IO traffic at IO controller to keep the queue
> > > > continuously backlogged. In my testing, there are many .2 to .8 second
> > > > intervals where higher weight queue is empty and in that duration lower weight
> > > > queue get lots of job done giving the impression that there was no service
> > > > differentiation.
> > > > 
> > > > In summary, from IO controller point of view async writes support is there.
> > > > Because page cache has not been designed in such a manner that higher 
> > > > prio/weight writer can do more write out as compared to lower prio/weight
> > > > writer, gettting service differentiation is hard and it is visible in some
> > > > cases and not visible in some cases.
> > > 
> > > Here's where it all falls to pieces.
> > > 
> > > For async writeback we just don't care about IO priorities.  Because
> > > from the point of view of the userspace task, the write was async!  It
> > > occurred at memory bandwidth speed.
> > > 
> > > It's only when the kernel's dirty memory thresholds start to get
> > > exceeded that we start to care about prioritisation.  And at that time,
> > > all dirty memory (within a memcg?) is equal - a high-ioprio dirty page
> > > consumes just as much memory as a low-ioprio dirty page.
> > > 
> > > So when balance_dirty_pages() hits, what do we want to do?
> > > 
> > > I suppose that all we can do is to block low-ioprio processes more
> > > agressively at the VFS layer, to reduce the rate at which they're
> > > dirtying memory so as to give high-ioprio processes more of the disk
> > > bandwidth.
> > > 
> > > But you've gone and implemented all of this stuff at the io-controller
> > > level and not at the VFS level so you're, umm, screwed.
> > > 
> > 
> > I think I must support dirty-ratio in memcg layer. But not yet.
> 

We need to add this to the TODO list.

> OR...I'll add a bufferred-write-cgroup to track bufferred writebacks.
> And add a control knob as
>   bufferred_write.nr_dirty_thresh
> to limit the number of dirty pages generetad via a cgroup.
> 
> Because memcg just records a owner of pages but not records who makes them
> dirty, this may be better. Maybe I can reuse page_cgroup and Ryo's blockio
> cgroup code.

Very good point, this is crucial for shared pages.

> 
> But I'm not sure how I should treat I/Os generated out by kswapd.
>

Account them to process 0 :)

-- 
	Balbir
