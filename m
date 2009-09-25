Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbZIYBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbZIYBUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZIYBUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:20:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46595 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZIYBUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:20:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Sep 2009 10:18:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-Id: <20090925101821.1de8091a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090925100952.55c2dd7a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	<20090924143315.781cd0ac.akpm@linux-foundation.org>
	<20090925100952.55c2dd7a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 10:09:52 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 24 Sep 2009 14:33:15 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Test5 (Fairness for async writes, Buffered Write Vs Buffered Write)
> > > ===================================================================
> > > Fairness for async writes is tricky and biggest reason is that async writes
> > > are cached in higher layers (page cahe) as well as possibly in file system
> > > layer also (btrfs, xfs etc), and are dispatched to lower layers not necessarily
> > > in proportional manner.
> > > 
> > > For example, consider two dd threads reading /dev/zero as input file and doing
> > > writes of huge files. Very soon we will cross vm_dirty_ratio and dd thread will
> > > be forced to write out some pages to disk before more pages can be dirtied. But
> > > not necessarily dirty pages of same thread are picked. It can very well pick
> > > the inode of lesser priority dd thread and do some writeout. So effectively
> > > higher weight dd is doing writeouts of lower weight dd pages and we don't see
> > > service differentation.
> > > 
> > > IOW, the core problem with buffered write fairness is that higher weight thread
> > > does not throw enought IO traffic at IO controller to keep the queue
> > > continuously backlogged. In my testing, there are many .2 to .8 second
> > > intervals where higher weight queue is empty and in that duration lower weight
> > > queue get lots of job done giving the impression that there was no service
> > > differentiation.
> > > 
> > > In summary, from IO controller point of view async writes support is there.
> > > Because page cache has not been designed in such a manner that higher 
> > > prio/weight writer can do more write out as compared to lower prio/weight
> > > writer, gettting service differentiation is hard and it is visible in some
> > > cases and not visible in some cases.
> > 
> > Here's where it all falls to pieces.
> > 
> > For async writeback we just don't care about IO priorities.  Because
> > from the point of view of the userspace task, the write was async!  It
> > occurred at memory bandwidth speed.
> > 
> > It's only when the kernel's dirty memory thresholds start to get
> > exceeded that we start to care about prioritisation.  And at that time,
> > all dirty memory (within a memcg?) is equal - a high-ioprio dirty page
> > consumes just as much memory as a low-ioprio dirty page.
> > 
> > So when balance_dirty_pages() hits, what do we want to do?
> > 
> > I suppose that all we can do is to block low-ioprio processes more
> > agressively at the VFS layer, to reduce the rate at which they're
> > dirtying memory so as to give high-ioprio processes more of the disk
> > bandwidth.
> > 
> > But you've gone and implemented all of this stuff at the io-controller
> > level and not at the VFS level so you're, umm, screwed.
> > 
> 
> I think I must support dirty-ratio in memcg layer. But not yet.

OR...I'll add a bufferred-write-cgroup to track bufferred writebacks.
And add a control knob as
  bufferred_write.nr_dirty_thresh
to limit the number of dirty pages generetad via a cgroup.

Because memcg just records a owner of pages but not records who makes them
dirty, this may be better. Maybe I can reuse page_cgroup and Ryo's blockio
cgroup code.

But I'm not sure how I should treat I/Os generated out by kswapd.

Thanks,
-Kame

