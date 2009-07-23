Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZGWGxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZGWGxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZGWGxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:53:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48079 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZGWGxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:53:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 15:51:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Move the cgroup debug subsys into cgroup.c to
 access internal state
Message-Id: <20090723155120.04d8750f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722195035.7481.85657.stgit@menage.mtv.corp.google.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	<20090722195035.7481.85657.stgit@menage.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 12:50:35 -0700
Paul Menage <menage@google.com> wrote:

> Move the cgroup debug subsys into cgroup.c to access internal state
> 
> While it's architecturally clean to have the cgroup debug subsystem be
> completely independent of the cgroups framework, it limits its
> usefulness for debugging the contents of internal data structures.
> Move the debug subsystem code into the scope of all the cgroups data
> structures to make more detailed debugging possible.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> 
>  kernel/Makefile       |    1 
>  kernel/cgroup.c       |   88 +++++++++++++++++++++++++++++++++++++++++
>  kernel/cgroup_debug.c |  105 -------------------------------------------------
>  3 files changed, 88 insertions(+), 106 deletions(-)
>  delete mode 100644 kernel/cgroup_debug.c
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index ecbd483..251adfe 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -58,7 +58,6 @@ obj-$(CONFIG_KEXEC) += kexec.o
>  obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
>  obj-$(CONFIG_COMPAT) += compat.o
>  obj-$(CONFIG_CGROUPS) += cgroup.o
> -obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
>  obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
>  obj-$(CONFIG_CPUSETS) += cpuset.o
>  obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index abca7e5..6306757 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3762,3 +3762,91 @@ css_get_next(struct cgroup_subsys *ss, int id,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_CGROUP_DEBUG
> +static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
> +						   struct cgroup *cont)
> +{
> +	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
> +
> +	if (!css)
> +		return ERR_PTR(-ENOMEM);
> +
> +	return css;
> +}
> +
> +static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
> +{
> +	kfree(cont->subsys[debug_subsys_id]);
> +}
> +
> +static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return atomic_read(&cont->count);
> +}
> +
> +static u64 debug_taskcount_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return cgroup_task_count(cont);
> +}
> +
> +static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return (u64)(long)current->cgroups;
> +}
> +
> +static u64 current_css_set_refcount_read(struct cgroup *cont,
> +					   struct cftype *cft)
> +{
> +	u64 count;
> +
> +	rcu_read_lock();
> +	count = atomic_read(&current->cgroups->refcount);
> +	rcu_read_unlock();
> +	return count;
> +}




> +
> +static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
> +}
> +
> +static struct cftype debug_files[] =  {
> +	{
> +		.name = "cgroup_refcount",
> +		.read_u64 = cgroup_refcount_read,
> +	},
> +	{
> +		.name = "taskcount",
> +		.read_u64 = debug_taskcount_read,
> +	},
> +
> +	{
> +		.name = "current_css_set",
> +		.read_u64 = current_css_set_read,
> +	},
> +
> +	{
> +		.name = "current_css_set_refcount",
> +		.read_u64 = current_css_set_refcount_read,
> +	},
> +
> +	{
> +		.name = "releasable",
> +		.read_u64 = releasable_read,
> +	},
> +};
> +
> +static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
> +{
> +	return cgroup_add_files(cont, ss, debug_files,
> +				ARRAY_SIZE(debug_files));
> +}
> +
> +struct cgroup_subsys debug_subsys = {
> +	.name = "debug",
> +	.create = debug_create,
> +	.destroy = debug_destroy,
> +	.populate = debug_populate,
> +	.subsys_id = debug_subsys_id,
> +};
> +#endif /* CONFIG_CGROUP_DEBUG */
> diff --git a/kernel/cgroup_debug.c b/kernel/cgroup_debug.c
> deleted file mode 100644
> index 0c92d79..0000000
> --- a/kernel/cgroup_debug.c
> +++ /dev/null
> @@ -1,105 +0,0 @@
> -/*
> - * kernel/cgroup_debug.c - Example cgroup subsystem that
> - * exposes debug info
> - *
> - * Copyright (C) Google Inc, 2007
> - *
> - * Developed by Paul Menage (menage@google.com)
> - *
> - */
> -
> -#include <linux/cgroup.h>
> -#include <linux/fs.h>
> -#include <linux/slab.h>
> -#include <linux/rcupdate.h>
> -
> -#include <asm/atomic.h>
> -
> -static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
> -						   struct cgroup *cont)
> -{
> -	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
> -
> -	if (!css)
> -		return ERR_PTR(-ENOMEM);
> -
> -	return css;
> -}
> -
> -static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
> -{
> -	kfree(cont->subsys[debug_subsys_id]);
> -}
> -
> -static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
> -{
> -	return atomic_read(&cont->count);
> -}
> -
> -static u64 taskcount_read(struct cgroup *cont, struct cftype *cft)
> -{
> -	u64 count;
> -
> -	count = cgroup_task_count(cont);
> -	return count;
> -}
> -
> -static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
> -{
> -	return (u64)(long)current->cgroups;
> -}
> -
> -static u64 current_css_set_refcount_read(struct cgroup *cont,
> -					   struct cftype *cft)
> -{
> -	u64 count;
> -
> -	rcu_read_lock();
> -	count = atomic_read(&current->cgroups->refcount);
> -	rcu_read_unlock();
> -	return count;
> -}
> -
> -static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
> -{
> -	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
> -}
> -
> -static struct cftype files[] =  {
> -	{
> -		.name = "cgroup_refcount",
> -		.read_u64 = cgroup_refcount_read,
> -	},
> -	{
> -		.name = "taskcount",
> -		.read_u64 = taskcount_read,
> -	},
> -
> -	{
> -		.name = "current_css_set",
> -		.read_u64 = current_css_set_read,
> -	},
> -
> -	{
> -		.name = "current_css_set_refcount",
> -		.read_u64 = current_css_set_refcount_read,
> -	},
> -
> -	{
> -		.name = "releasable",
> -		.read_u64 = releasable_read,
> -	},
> -};
> -
> -static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
> -{
> -	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
> -}
> -
> -struct cgroup_subsys debug_subsys = {
> -	.name = "debug",
> -	.create = debug_create,
> -	.destroy = debug_destroy,
> -	.populate = debug_populate,
> -	.subsys_id = debug_subsys_id,
> -};
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

