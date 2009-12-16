Return-Path: <linux-kernel-owner+w=401wt.eu-S935180AbZLPSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180AbZLPSia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbZLPSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:38:24 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35982 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935160AbZLPSiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:19 -0500
Date: Wed, 16 Dec 2009 19:38:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cfq: Remove useless css reference get
Message-ID: <20091216183817.GW28252@kernel.dk>
References: <4B289C93.3070603@cn.fujitsu.com> <20091216163941.GA2807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216163941.GA2807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16 2009, Vivek Goyal wrote:
> On Wed, Dec 16, 2009 at 04:38:43PM +0800, Gui Jianfeng wrote:
> > There's no need to take css reference here, for the caller
> > has already called rcu_read_lock() to prevent cgroup from 
> > being removed.
> > 
> > Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Hi Gui,
> 
> How would an rcu lock protect against the possibility that blkiocg_destroy()
> has not already been called on another cpu? rcu lock will make sure that
> cgroup and blkio_cgroup object should still be around as long as I am
> holding rcu lock but will not protect against deletion path being executed
> on another cpu? So I don't want to end up in following situation.
> 
>      cpu1                      cpu2
> 
> rcu_read_lock()
> 			      blkiocg_destroy()
> 
> blkiocg_add_blkio_group()
> rcu_read_unlock()
> 
> I don't want to add blkg object on a potentially dead blkio_cgroup object
> which will go away. Does this protection is provided by generic cgroup
> code where blkiocg_destroy() will not be called if I have got cgroup
> pointer under rcu lock?

Hmm, looking at blkiocg_destroy(), it seems to free blkcg directly. You
need an RCU grace period to pass in between, if you expect blkcg to be
valid under rcu_read_lock() always. Or is ->destroy() called from an RCU
callback? Checks... OK, so it looks like cgroup guarantees
synchronize_rcu() before calling ->destroy(), so that should be safe.

Why is it doing both rcu_read_lock() and grabbing the update lock?

On the real topic, it'll of course only guarentee that blkcg is valid
inside the rcu read lock. If it needs to be valid afterwards, the
reference must be grabbed.

> Currently we are deriving cgroup information from task context so task is
> still inside cgroup, so cgroup can't be deleted anyway. What if I was 
> deriving cgroup information from bio, will taking css object reference be
> necessary in that case or just cgroup pointer under rcu lock is sufficient
> to preclude the race against cgroup deletion path?

It's guarenteed that ->destroy() cannot be called while someone is under
rcu_read_lock().

-- 
Jens Axboe

