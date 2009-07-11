Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZGKV7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZGKV7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZGKV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:59:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51849 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGKV7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:59:33 -0400
Date: Sat, 11 Jul 2009 16:59:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Ben Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH 2/3] Ensures correct concurrent opening/reading of
	pidlists across pid namespaces
Message-ID: <20090711215933.GB29503@us.ibm.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com> <20090710230200.16778.89212.stgit@hastromil.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710230200.16778.89212.stgit@hastromil.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ben Blum (bblum@google.com):
...
> +static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
> +						  enum cgroup_filetype type)
> +{
> +	struct cgroup_pidlist *l;
> +	/* don't need task_nsproxy() if we're looking at ourself */
> +	struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
> +	/*
> +	 * We can't drop the pidlist_mutex before taking the l->mutex in case
> +	 * the last ref-holder is trying to remove l from the list at the same
> +	 * time. Holding the pidlist_mutex precludes somebody taking whichever
> +	 * list we find out from under us - compare release_pid_array().
> +	 */
> +	mutex_lock(&cgrp->pidlist_mutex);
> +	list_for_each_entry(l, &cgrp->pidlists, links) {
> +		if (l->key.type == type && l->key.ns == ns) {
> +			/* found a matching list - drop the extra refcount */
> +			put_pid_ns(ns);
> +			/* make sure l doesn't vanish out from under us */
> +			down_write(&l->mutex);
> +			mutex_unlock(&cgrp->pidlist_mutex);
> +			l->use_count++;
> +			return l;
> +		}
> +	}
> +	/* entry not found; create a new one */
> +	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
> +	if (!l) {
> +		mutex_unlock(&cgrp->pidlist_mutex);

Again, you need to put_pid_ns(ns) here.

> +		return l;
> +	}
> +	init_rwsem(&l->mutex);
> +	down_write(&l->mutex);
> +	l->key.type = type;
> +	l->key.ns = ns;
> +	l->use_count = 0; /* don't increment here */
> +	l->list = NULL;
> +	l->owner = cgrp;
> +	list_add(&l->links, &cgrp->pidlists);
> +	mutex_unlock(&cgrp->pidlist_mutex);
> +	return l;
> +}
