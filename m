Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZLRPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZLRPIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZLRPIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:08:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbZLRPId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:08:33 -0500
Date: Fri, 18 Dec 2009 10:08:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Remove useless css reference get
Message-ID: <20091218150825.GA3123@redhat.com>
References: <4B289C93.3070603@cn.fujitsu.com> <20091216163941.GA2807@redhat.com> <4B29C834.8090407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B29C834.8090407@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 01:57:08PM +0800, Li Zefan wrote:
> 于 2009年12月17日 00:39, Vivek Goyal 写道:
> > On Wed, Dec 16, 2009 at 04:38:43PM +0800, Gui Jianfeng wrote:
> >> There's no need to take css reference here, for the caller
> >> has already called rcu_read_lock() to prevent cgroup from 
> >> being removed.
> >>
> >> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
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
> > 
> > Currently we are deriving cgroup information from task context so task is
> > still inside cgroup, so cgroup can't be deleted anyway. What if I was 
> > deriving cgroup information from bio, will taking css object reference be
> > necessary in that case or just cgroup pointer under rcu lock is sufficient
> > to preclude the race against cgroup deletion path?
> > 
> 
> We pass a cgroup ptr to cfq_find_alloc_cfqg(), which means the cgroup is
> valid. As long as it's safe to access the cgroup, it's safe to access the
> corresponding blkio_cgroup.
> 

Ok.

> But if you still want blkio_cgroup to be valid after dropping rcu_read_lock
> (or cgroup_mutex), you need to call css_get() first. Note you don't need
> to call css_tryget(). css_tryget() is only needed in mem_cgroup, because
> mem_cgroup is a bit special, in that a mem_cgroup can remain valid after
> a cgroup is destroyed.
> 
> If a user tries to rmdir a cgroup when its css refcnt > 0, EBUSY will be
> returned.

Ok. I was not taking a reference to css object because I don't want to
stop deletion of cgroup just because there might be some pending IO from 
that group which has not finished yet. So if some task issues some IO and
it exits or moves to a different cgroup, then user should be able to
delete the cgroup even if there is pending IO in that cgroup.

That's the reason I don't take a reference to css object and once cgroup
deletion call comes (->destroy()), I just call CFQ to unlink the group and let
cgroup and blkio_cgroup go away. cfq_group and blkio_group objects will still
be around till all the pending IO in that group is finished and cfq_group
will be freed after that automatically (all rq and cfqq references gone).

Thanks
Vivek
