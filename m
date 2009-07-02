Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZGBXy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZGBXy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbZGBXyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:54:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbZGBXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:54:17 -0400
Date: Thu, 2 Jul 2009 16:54:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@google.com
Subject: Re: [PATCH 2/2] Ensures correct concurrent opening/reading of
 pidlists across pid namespaces
Message-Id: <20090702165413.f4a21471.akpm@linux-foundation.org>
In-Reply-To: <20090702232625.3969.54444.stgit@menage.mtv.corp.google.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232625.3969.54444.stgit@menage.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jul 2009 16:26:25 -0700
Paul Menage <menage@google.com> wrote:

> Ensures correct concurrent opening/reading of pidlists across pid namespaces
> 
> Previously there was the problem in which two processes from different pid
> namespaces reading the tasks or procs file could result in one process seeing
> results from the other's namespace. Rather than one pidlist for each file in a
> cgroup, we now keep a list of pidlists keyed by namespace and file type (tasks
> versus procs) in which entries are placed on demand. Each pidlist has its own
> lock, and that the pidlists themselves are passed around in the seq_file's
> private pointer means we don't have to touch the cgroup or its master list
> except when creating and destroying entries.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Reviewed-by: Paul Menage <menage@google.com>
> Signed-off-by: Paul Menage <menage@google.com>

The way these patches were sent states that you were their primary
author.  Is that accurate?  If not, they should have had

From: Ben Blum <bblum@google.com>

at the very top of the changelog.

>
> ...
>
>  /**
> + * find the appropriate pidlist for our purpose (given procs vs tasks)
> + * returns with the lock on that pidlist already held, and takes care
> + * of the use count, or returns NULL with no locks held if we're out of
> + * memory.
> + */

Comment purports to be kerneldoc, but isn't.

> +static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
> +						  enum cgroup_filetype type)
> +{
> +	struct cgroup_pidlist *l;
> +	/* don't need task_nsproxy() if we're looking at ourself */
> +	struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
> +	mutex_lock(&cgrp->pidlist_mutex);
> +	list_for_each_entry(l, &cgrp->pidlists, links) {
> +		if (l->key.type == type && l->key.ns == ns) {
> +			/* found a matching list - drop the extra refcount */
> +			put_pid_ns(ns);
> +			/* make sure l doesn't vanish out from under us */

This looks fishy.

> +			down_write(&l->mutex);
> +			mutex_unlock(&cgrp->pidlist_mutex);
> +			l->use_count++;
> +			return l;

The caller of cgroup_pidlist_find() must ensure that l->use_count > 0,
otherwise cgroup_pidlist_find() cannot safely use `l' - it could be
freed at any time.  But if l->use_count > 0, there is no risk of `l'
"vanishing out from under us".

I'm probably wrong there, but that's the usual pattern and this code
looks like it's doing something different.  Please check?

> +		}
> +	}
> +	/* entry not found; create a new one */
> +	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
> +	if (!l) {
> +		mutex_unlock(&cgrp->pidlist_mutex);
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
> +
>
> ...
>

