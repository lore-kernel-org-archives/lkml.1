Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZKDPYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZKDPYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZKDPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:24:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447AbZKDPYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:24:08 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 06/20] blkio: Introduce cgroup interface
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-7-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 10:23:16 -0500
In-Reply-To: <1257291837-6246-7-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:43 -0500")
Message-ID: <x494opauxej.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> +void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> +				struct blkio_group *blkg, void *key)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&blkcg->lock, flags);
> +	rcu_assign_pointer(blkg->key, key);
> +	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
> +	spin_unlock_irqrestore(&blkcg->lock, flags);
> +}

I took a look at the rcu stuff, and it seems to be in order.

> +/*
> + * We cannot support shared io contexts, as we have no mean to support
> + * two tasks with the same ioc in two different groups without major rework
> + * of the main cic data structures.  For now we allow a task to change
> + * its cgroup only if it's the only owner of its ioc.
> + */

Interesting.  So is there no way at all to set the cgroup for a set of
processes that are cloned using CLONE_IO?

> +static int blkiocg_can_attach(struct cgroup_subsys *subsys,
> +				struct cgroup *cgroup, struct task_struct *tsk,
> +				bool threadgroup)
> +{
> +	struct io_context *ioc;
> +	int ret = 0;
> +
> +	/* task_lock() is needed to avoid races with exit_io_context() */
> +	task_lock(tsk);
> +	ioc = tsk->io_context;
> +	if (ioc && atomic_read(&ioc->nr_tasks) > 1)
> +		ret = -EINVAL;
> +	task_unlock(tsk);
> +
> +	return ret;
> +}

This function's name implies that it returns a boolean.

Cheers,
Jeff
