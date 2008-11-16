Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKPLqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKPLqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYKPLqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:46:15 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34748 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731AbYKPLqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:46:14 -0500
Date: Sun, 16 Nov 2008 20:46:09 +0900 (JST)
Message-Id: <20081116.204609.65892670.taka@valinux.co.jp>
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: ryov@valinux.co.jp, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 6/8] bio-cgroup: The body of bio-cgroup
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <491D2251.7010702@oss.ntt.co.jp>
References: <20081113.121357.75173118738921642.ryov@valinux.co.jp>
	<20081113.121433.632868945383117577.ryov@valinux.co.jp>
	<491D2251.7010702@oss.ntt.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As you pointed out, cgroup iocontext stuff isn't well designed yet
since the current implementation of dm-iband doesn't need it.
I'd like to leave the iocontext stuff to you I/O scheduler guys
if you want to implement the bio-cgroup infrastructure to handle iocotexts
as the I/O schedulers expect.

> Hi,
> 
> Ryo Tsuruta wrote:
> >  
> > +void init_io_context(struct io_context *ioc)
> > +{
> > +	atomic_set(&ioc->refcount, 1);
> > +	atomic_set(&ioc->nr_tasks, 1);
> > +	spin_lock_init(&ioc->lock);
> > +	ioc->ioprio_changed = 0;
> > +	ioc->ioprio = 0;
> > +	ioc->last_waited = jiffies; /* doesn't matter... */
> > +	ioc->nr_batch_requests = 0; /* because this is 0 */
> > +	ioc->aic = NULL;
> > +	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
> > +	INIT_HLIST_HEAD(&ioc->cic_list);
> > +	ioc->ioc_data = NULL;
> > +}
> > +
> >  struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
> >  {
> >  	struct io_context *ret;
> >  
> >  	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
> > -	if (ret) {
> > -		atomic_set(&ret->refcount, 1);
> > -		atomic_set(&ret->nr_tasks, 1);
> > -		spin_lock_init(&ret->lock);
> > -		ret->ioprio_changed = 0;
> > -		ret->ioprio = 0;
> > -		ret->last_waited = jiffies; /* doesn't matter... */
> > -		ret->nr_batch_requests = 0; /* because this is 0 */
> > -		ret->aic = NULL;
> > -		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
> > -		INIT_HLIST_HEAD(&ret->cic_list);
> > -		ret->ioc_data = NULL;
> > -	}
> > +	if (ret)
> > +		init_io_context(ret);
> >  
> >  	return ret;
> >  }
> 
> 
> > +
> > +/* Create a new bio-cgroup. */
> > +static struct cgroup_subsys_state *
> > +bio_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
> > +{
> > +	struct bio_cgroup *biog;
> > +	struct io_context *ioc;
> > +	int ret;
> > +
> > +	if (!cgrp->parent) {
> > +		biog = &default_bio_cgroup;
> > +		init_io_context(biog->io_context);
> > +		/* Increment the referrence count not to be released ever. */
> > +		atomic_inc(&biog->io_context->refcount);
> > +		idr_init(&bio_cgroup_id);
> > +		return &biog->css;
> > +	}
> > +
> > +	biog = kzalloc(sizeof(*biog), GFP_KERNEL);
> > +	ioc = alloc_io_context(GFP_KERNEL, -1);
> > +	if (!ioc || !biog) {
> > +		ret = -ENOMEM;
> > +		goto out_err;
> > +	}
> > +	biog->io_context = ioc;
> 
> If I understand correctly io_contexts allocated by alloc_io_context() should
> be owned by some tasks. In this case, the newly created io_context has no
> owner though biog->io_context->nr_tasks == 1. With the cfq scheduler this may
> cause some problems especially when cic_free_func() is called because
> cfq_exit_io_context() would never be called. Am I wrong?

I think iocontext allocated for a certain cgroup should be owned by the
cgroup itself, whose code isn't implemented yet. I think you need to
enhance it a bit if the owner is a cgroup.

> > +retry:
> > +	if (!idr_pre_get(&bio_cgroup_id, GFP_KERNEL)) {
> > +		ret = -EAGAIN;
> > +		goto out_err;
> > +	}
> > +	spin_lock_irq(&bio_cgroup_idr_lock);
> > +	ret = idr_get_new_above(&bio_cgroup_id, (void *)biog, 1, &biog->id);
> > +	spin_unlock_irq(&bio_cgroup_idr_lock);
> > +	if (ret == -EAGAIN)
> > +		goto retry;
> > +	else if (ret)
> > +		goto out_err;
> > +
> > +	return &biog->css;
> > +out_err:
> > +	if (biog)
> > +		kfree(biog);
> > +	if (ioc)
> > +		put_io_context(ioc);
> > +	return ERR_PTR(ret);
> > +}
> > +
> > +/* Delete the bio-cgroup. */
> > +static void bio_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
> > +{
> > +	struct bio_cgroup *biog = cgroup_bio(cgrp);
> > +
> > +	put_io_context(biog->io_context);
> 
> Here, I suspects what will happen under the following condition:
> biog->io_context->refcount: 1 --> 0
> biog->io_context->nr_tasks: 1 --> 1
> ==> cfq_dtor() will be called but cfq_exit() has not be called yet.
> 
> > +
> > +	spin_lock_irq(&bio_cgroup_idr_lock);
> > +	idr_remove(&bio_cgroup_id, biog->id);
> > +	spin_unlock_irq(&bio_cgroup_idr_lock);
> > +
> > +	kfree(biog);
> > +}
> > +
> 
> > +
> > +/* Determine the iocontext of the bio-cgroup that issued a given bio. */
> > +struct io_context *get_bio_cgroup_iocontext(struct bio *bio)
> > +{
> > +	struct bio_cgroup *biog = NULL;
> > +	struct io_context *ioc;
> > +	int	id = 0;
> > +
> > +	id = get_bio_cgroup_id(bio);
> > +	if (id)
> > +		biog = find_bio_cgroup(id);
> > +	if (!biog)
> > +		biog = &default_bio_cgroup;
> > +	ioc = biog->io_context;	/* default io_context for this cgroup */
> > +	atomic_inc(&ioc->refcount);
> > +	return ioc;
> > +}
> > +EXPORT_SYMBOL(get_bio_cgroup_iocontext);
> 
> 
> Thanks,
> Takuya Yoshikawa

Thank you,
Hirokazu Takahashi.
