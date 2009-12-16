Return-Path: <linux-kernel-owner+w=401wt.eu-S964958AbZLPTkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbZLPTkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935487AbZLPTkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935447AbZLPTkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:40:33 -0500
Date: Wed, 16 Dec 2009 14:40:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cfq: Remove useless css reference get
Message-ID: <20091216194024.GB2807@redhat.com>
References: <4B289C93.3070603@cn.fujitsu.com> <20091216163941.GA2807@redhat.com> <20091216183817.GW28252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216183817.GW28252@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:38:17PM +0100, Jens Axboe wrote:
> On Wed, Dec 16 2009, Vivek Goyal wrote:
> > On Wed, Dec 16, 2009 at 04:38:43PM +0800, Gui Jianfeng wrote:
> > > There's no need to take css reference here, for the caller
> > > has already called rcu_read_lock() to prevent cgroup from 
> > > being removed.
> > > 
> > > Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> > > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Hi Gui,
> > 
> > How would an rcu lock protect against the possibility that blkiocg_destroy()
> > has not already been called on another cpu? rcu lock will make sure that
> > cgroup and blkio_cgroup object should still be around as long as I am
> > holding rcu lock but will not protect against deletion path being executed
> > on another cpu? So I don't want to end up in following situation.
> > 
> >      cpu1                      cpu2
> > 
> > rcu_read_lock()
> > 			      blkiocg_destroy()
> > 
> > blkiocg_add_blkio_group()
> > rcu_read_unlock()
> > 
> > I don't want to add blkg object on a potentially dead blkio_cgroup object
> > which will go away. Does this protection is provided by generic cgroup
> > code where blkiocg_destroy() will not be called if I have got cgroup
> > pointer under rcu lock?
> 
> Hmm, looking at blkiocg_destroy(), it seems to free blkcg directly. You
> need an RCU grace period to pass in between, if you expect blkcg to be
> valid under rcu_read_lock() always. Or is ->destroy() called from an RCU
> callback? Checks... OK, so it looks like cgroup guarantees
> synchronize_rcu() before calling ->destroy(), so that should be safe.

Ok. Thanks Jens. So then I don't have to worry about ->destroy() being called
and blkcg being freed while I am trying to access this blkcg from CFQ under
rcu.

> 
> Why is it doing both rcu_read_lock() and grabbing the update lock?
> 

Are you referring to "blkio_list_lock"?

rcu_read_lock() is taken to protect "key". When cfq adds a blkio_group,
to the hash list in blkio_cgroup, it passes "cfqd" as the key. If somebody
is removing cgroup, we call back into CFQ to notify that cgroup is going
away so destroy associated cfq_group object. Now it can happen that both
elevator switch and cgroup removal is happening at same time and they both
can try to remove destroy cfq_group/blkio_group objects.

blkio_group list is protected by blkcg->lock and cfqd->cfqg_list is
protected by request queue lock. We always take request queue lock first
and then blkcg->lock to add or remove a blkio_group.

In cgroup removal path, we take blkcg->lock first and now can't take
request queue lock as it can lead to deadlock. So in cgroup removal path
we rely on accessing key (cfqd) under rcu and call CFQ to remove group
after dropping blkcg->lock. CFQ will take cfqd->queue lock and destroy
the group.

Because cfqd is rcu protected, we should do synchronize_rcu() in
cfq_exit_queue() to make sure that cfqd, hence cfqd->queue hence
cfqd->queue->lock object are still valid. But as we discussed in private
mail, synchronize_rcu() unconditionally was intorducing boot delays,
especially for megaraid driver. Replacing synchronize_rcu() with
call_rcu() will not help as cfqd will be around but cfqd->queue and
cfqd->queue->lock might have disappeared. So this is one problem which
needs to be fixed.

One solution is to do synchronize_rcu() only if we have some cfq_groups
alive. So during boot there will be only one group which will always be
cleaned up by cfq exit (cgroup userspace is not around yet). And we will
avoid delays in boot path as well as get rid of above race condition.

About taking blkio_list_lock, under rcu, may be we can drop it and make 
blkio_list rcu protected. But then we need to make sure that cfq does not
go away until one rcu grace period is over and blkio_unlink_group_fn()
function and key (cfqd, cfqd->queue)  objects are valid.

I guess, if we fix synchronize_rcu() issue in cfq_exit_queue(), it will
make sure that under rcu, cfqd and cfqd->queue objects are valid, and that
means cfq is still around and blkio_unlink_group_fn() is valid and we
don't need to take blkio_list_lock. Having said that, taking this lock was
not fixing the problem anyway. I was taking this lock here to make sure
cfq can't exit and unregister the io control policy while a cgroup is
going away. 

> On the real topic, it'll of course only guarentee that blkcg is valid
> inside the rcu read lock. If it needs to be valid afterwards, the
> reference must be grabbed.
> 

I guess for the time being we are fine. Because, after rcu read lock is
dropped, if blkcg is going away (due to cgroup deletion), it will cleanup
all the blkio_group (hence cfq_group) objects first on blkcg->blkg_list
and that will make sure all associated cfq_group objects for that cgroup are
gone and then we don't have to access blkcg anymore.


> > Currently we are deriving cgroup information from task context so task is
> > still inside cgroup, so cgroup can't be deleted anyway. What if I was 
> > deriving cgroup information from bio, will taking css object reference be
> > necessary in that case or just cgroup pointer under rcu lock is sufficient
> > to preclude the race against cgroup deletion path?
> 
> It's guarenteed that ->destroy() cannot be called while someone is under
> rcu_read_lock().
> 

Thanks
Vivek
