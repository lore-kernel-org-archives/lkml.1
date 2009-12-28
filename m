Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbZL1Gc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbZL1Gc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZL1Gc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:32:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZL1Gc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:32:27 -0500
Message-ID: <4B3850F4.4090203@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 14:32:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>
Subject: Re: [PATCH 2/4] cgroups: subsystem module loading interface
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203613.GC5683@andrew.cmu.edu>
In-Reply-To: <20091221203613.GC5683@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add interface between cgroups subsystem management and module loading
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch implements rudimentary module-loading support for cgroups - namely,
> a cgroup_load_subsys (similar to cgroup_init_subsys) for use as a module
> initcall, and a struct module pointer in struct cgroup_subsys.
> 
> Several functions that might be wanted by modules have had EXPORT_SYMBOL added
> to them, but it's unclear exactly which functions want it and which won't.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

Some small nitpicks:

> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2477,6 +2477,7 @@ int cgroup_add_file(struct cgroup *cgrp,
>  		error = PTR_ERR(dentry);
>  	return error;
>  }
> +EXPORT_SYMBOL_GPL(cgroup_add_file);

I got compile errors, because you forgot to include <linux/module.h>

...
> +	write_lock(&css_set_lock);
> +	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
> +		struct css_set *cg;
> +		struct hlist_node *node, *tmp;
> +		struct hlist_head *bucket = &css_set_table[i], *new_bucket;

Please add a blank line between variable declaration and other code.

And elsewhere in this patchset.

> +		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
> +			/* skip entries that we already rehashed */
> +			if (cg->subsys[ss->subsys_id])
> +				continue;
> +			/* remove existing entry */
> +			hlist_del(&cg->hlist);
> +			/* set new value */
> +			cg->subsys[ss->subsys_id] = css;
> +			/* recompute hash and restore entry */
> +			new_bucket = css_set_hash(cg->subsys);
> +			hlist_add_head(&cg->hlist, new_bucket);
> +		}
> +	}
> +	write_unlock(&css_set_lock);


