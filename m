Return-Path: <linux-kernel-owner+w=401wt.eu-S1161664AbXDYHm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161664AbXDYHm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161667AbXDYHm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:42:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161664AbXDYHm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:42:27 -0400
Date: Wed, 25 Apr 2007 00:42:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] syctl for selecting global zonelist[] order
Message-Id: <20070425004214.e21da2d8.akpm@linux-foundation.org>
In-Reply-To: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 12:19:46 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Make zonelist policy selectable from sysctl.
> 
> Assume 2 node NUMA, only node(0) has ZONE_DMA (ZONE_DMA32).
> 
> In this case, default (node0's) zonelist order is
> 
> Node(0)'s NORMAL -> Node(0)'s DMA -> Node(1)"s NORMAL.
> 
> This means Node(0)'s DMA is used before Node(1)'s NORMAL.
> 
> In some server, some application uses large memory allcation.
> This exhaust memory in the above order.
> Then....sometimes OOM_KILL will occur when 32bit device requires memory.
> 
> This patch adds sysctl for rebuilding zonelist after boot and doesn't change
> default zonelist order.

hm.  Why don't we use that ordering all the time?  Does the present ordering have
any advantage?

> command:
> %echo 0 > /proc/sys/vm/better_locality

Who could resist having better locality? ;)

> Will rebuild zonelist in following order.
> 
> Node(0)'s NORMAL -> Node(1)'s NORMAL -> Node(0)'s DMA.
> 
> if set better_locality == 1 (default), zonelist is
> Node(0)'s NORMAL -> Node(0)'s DMA -> Node(1)'s NORMAL.
> 
> Maybe useful in some users with heavy memory pressure and mlocks.
> 
> ...
>
>  extern int percpu_pagelist_fraction;
>  extern int compat_log;
> +#ifdef CONFIG_NUMA
> +extern int sysctl_better_locality;
> +#endif

The ifdef isn't needed here.  If something went wrong, we'll find out at
link-time.
  
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  static int maxolduid = 65535;
> @@ -845,6 +848,15 @@ static ctl_table vm_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &one_hundred,
>  	},
> +	{
> +		.ctl_name	= VM_BETTER_LOCALITY,

Please don't add new sysctls: use CTL_UNNUMBERED here.

> +		.procname	= "better_locality",
> +		.data		= &sysctl_better_locality,
> +		.maxlen		= sizeof(sysctl_better_locality),
> +		.mode		= 0644,
> +		.proc_handler	= &sysctl_better_locality_handler,
> +		.strategy	= &sysctl_intvec,
> +	},
>
> ..
>
> +static void build_zonelists(pg_data_t *pgdat)
> +{
> +	if (sysctl_better_locality) {
> +		build_zonelists_locality_aware(pgdat);
> +	} else {
> +		build_zonelists_zone_aware(pgdat);
> +	}

Remove all the braces please.

> @@ -207,6 +207,7 @@ enum
>  	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
>  	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
>  	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
> +	VM_BETTER_LOCALITY=36,	 /* create locality-preference zonelist */

This can go away.
