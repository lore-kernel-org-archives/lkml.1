Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZDSPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZDSPrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbZDSPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 11:47:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61896 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbZDSPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 11:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Xpwar2JV3MNHFCk6e31fs2tQXMGH8qqTgA5JS5xu1OPYKOc/iIv15PrbHAv4LYcpZF
         u+JUi8kDBAiy1vA7TCSuI+7kV5GrY8SycKV/vVS81ZpNPn6PXgw7W5nyY8CZqqIUSjb1
         XslwffLwGr5Q2Uv4oEG797OEJuvqLpUVjNA1k=
Date: Sun, 19 Apr 2009 17:47:18 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090419154717.GB5514@linux>
Mail-Followup-To: Vivek Goyal <vgoyal@redhat.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417173955.GF29086@redhat.com> <20090417231244.GB6972@linux> <20090419134201.GF8493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419134201.GF8493@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 09:42:01AM -0400, Vivek Goyal wrote:
> > The difference between synchronous IO and writeback IO is that in the
> > first case the task itself is throttled via schedule_timeout_killable();
> > in the second case pdflush is never throttled, the IO requests instead
> > are simply added into a rbtree and dispatched asynchronously by another
> > kernel thread (kiothrottled) using a EDF-like scheduling. More exactly,
> > a deadline is evaluated for each writeback IO request looking at the
> > cgroup BW and iops/sec limits, then kiothrottled periodically selects
> > and dispatches the requests with an elapsed deadline.
> > 
> 
> Ok, i will look into the logic of translating cgroup BW limits into
> deadline. But as Nauman pointed out that we probably will run into 
> issues of tasks with in cgroup as we loose that notion of class and prio.

Correct. I've not addressed the IO class and priority inside cgroup, and
there is a lot of space for optimizations and tunings for this in the
io-throttle controller. In the current implementation the delay is only
imposed to the first task that hits the BW limit. This is not fair at
all.

Ideally the throttling should be distributed equally among the tasks
within the same cgroup that exhaust the available BW. With equally I
mean depending of a function of the previous generated IO, class and IO
priority.

The same concept of fairness (for ioprio and class) will be reflected to
the underlying IO scheduler (only CFQ at the moment) for the requests
that passed the BW limits.

This doesn't seem a bad idea, well.. at least in theory... :) Do you see
evident weak points? or motivations to move to another direction?

> 
> > > 
> > > If that's the case, will a process not see an increased rate of writes
> > > till we are not hitting dirty_background_ratio?
> > 
> > Correct. And this is a good behaviour IMHO. At the same time we have a
> > smooth BW usage (according to the cgroup limits I mean) even in presence
> > of writeback IO only.
> > 
> 
> Hmm.., I am not able to understand this. The very fact that you will see
> a high rate of async writes (more than specified by cgroup max BW), till
> you hit dirty_background_ratio, isn't it against the goals of max bw
> controller? You wanted to see a consistent view of rate even if spare BW
> is available, and this scenario goes against that? 

The goal of the io-throttle controller is to guarantee a constant BW for
the IO to the block devices. If you write data in cache, buffers, etc.
you shouldn't be affected by any IO limitation, but you will be when the
data is be written out to the disk.

OTOH if an application needs a predictable IO BW, we can always set a
max limit and use direct IO.

> 
> Think of an hypothetical configuration of 10G RAM with dirty ratio say
> set to 20%. Assume not much of write out is taking place in the system.
> So for first 2G of writes, application will be able to write it at cpu
> speed and no throttling will kick in and a cgroup will easily cross it
> max BW? 

Yes.

>   
> > > 
> > > Secondly, if above is giving acceptable performance resutls, then we
> > > should be able to provide max bw control at IO scheduler level (along
> > > with proportional bw control)?
> > > 
> > > So instead of doing max bw and proportional bw implementation in two
> > > places with the help of different controllers, I think we can do it
> > > with the help of one controller at one place. 
> > > 
> > > Please do have a look at my patches also to figure out if that's possible
> > > or not. I think it should be possible.
> > > 
> > > Keeping both at single place should simplify the things.
> > 
> > Absolutely agree to do both proportional and max BW limiting in a single
> > place. I still need to figure which is the best place, if the IO
> > scheduler in the elevator, when the IO requests are submitted. A natural
> > way IMHO is to control the submission of requests, also Andrew seemed to
> > be convinced about this approach. Anyway, I've already scheduled to test
> > your patchset and I'd like to see if it's possible to merge our works,
> > or select the best from ours patchsets.
> > 
> 
> Are we not already controlling submission of request (at crude level).
> If application is doing writeout at high rate, then it hits vm_dirty_ratio
> hits and this application is forced to do write out and hence it is slowed
> down and is not allowed to submit writes at high rate.
> 
> Just that it is not a very fair scheme right now as during right out
> a high prio/high weight cgroup application can start writing out some
> other cgroups' pages.
> 
> For this we probably need to have some combination of solutions like
> per cgroup upper limit on dirty pages. Secondly probably if an application
> is slowed down because of hitting vm_drity_ratio, it should try to
> write out the inode it is dirtying first instead of picking any random
> inode and associated pages. This will ensure that a high weight
> application can quickly get through the write outs and see higher
> throughput from the disk.

For the first, I submitted a patchset some months ago to provide this
feature in the memory controller:

https://lists.linux-foundation.org/pipermail/containers/2008-September/013140.html

We focused on the best interface to use for setting the dirty pages
limit, but we didn't finalize it. I can rework on that and repost an
updated version. Now that we have the dirty_ratio/dirty_bytes to set the
global limit I think we can use the same interface and the same semantic
within the cgroup fs, something like:

  memory.dirty_ratio
  memory.dirty_bytes

For the second point something like this should be enough to force tasks
to write out only the inode they're actually dirtying when they hit the
vm_dirty_ratio limit. But it should be tested carefully and may cause
heavy performance regressions.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2630937..1e07c9d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -543,7 +543,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * been flushed to permanent storage.
 		 */
 		if (bdi_nr_reclaimable) {
-			writeback_inodes(&wbc);
+			sync_inode(mapping->host, &wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);

