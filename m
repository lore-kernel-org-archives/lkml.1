Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZKDQrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZKDQrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZKDQrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZKDQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:47:23 -0500
Date: Wed, 4 Nov 2009 11:47:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 06/20] blkio: Introduce cgroup interface
Message-ID: <20091104164706.GC2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-7-git-send-email-vgoyal@redhat.com> <x494opauxej.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494opauxej.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:23:16AM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > +void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> > +				struct blkio_group *blkg, void *key)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&blkcg->lock, flags);
> > +	rcu_assign_pointer(blkg->key, key);
> > +	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
> > +	spin_unlock_irqrestore(&blkcg->lock, flags);
> > +}
> 
> I took a look at the rcu stuff, and it seems to be in order.
> 
> > +/*
> > + * We cannot support shared io contexts, as we have no mean to support
> > + * two tasks with the same ioc in two different groups without major rework
> > + * of the main cic data structures.  For now we allow a task to change
> > + * its cgroup only if it's the only owner of its ioc.
> > + */
> 
> Interesting.  So is there no way at all to set the cgroup for a set of
> processes that are cloned using CLONE_IO?
> 

In the current patchset "no". This is bad and should be fixed. Thinking of
following.

- In case of CLONE_IO, when a tread moves, drop the reference to the sync
  queue and allow movement of the thread to a different group. Now once
  a new request comes in, a new queue will be setup again. Because two
  threads sharing the IO context are in two different groups, A sync queue
  will be setup for the group from which request comes first. So for some
  time we will have a situation where a thread is one group but its IO
  is going into a queue of a different group. This will be only temporary
  situation and correct itself once all the threads sharing io context
  move to same group.

The downside is that user might not know exactly which threads are sharing
IO context and might end up with some threads in one group and others in
different group.


> > +static int blkiocg_can_attach(struct cgroup_subsys *subsys,
> > +				struct cgroup *cgroup, struct task_struct *tsk,
> > +				bool threadgroup)
> > +{
> > +	struct io_context *ioc;
> > +	int ret = 0;
> > +
> > +	/* task_lock() is needed to avoid races with exit_io_context() */
> > +	task_lock(tsk);
> > +	ioc = tsk->io_context;
> > +	if (ioc && atomic_read(&ioc->nr_tasks) > 1)
> > +		ret = -EINVAL;
> > +	task_unlock(tsk);
> > +
> > +	return ret;
> > +}
> 
> This function's name implies that it returns a boolean.

Yes. Will change from int to bool. Thanks.

Vivek
