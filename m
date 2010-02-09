Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0BIXW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 18:22:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab0BIXWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 18:22:24 -0500
Date: Tue, 9 Feb 2010 15:22:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Make vm_max_readahead configurable at run-time
Message-Id: <20100209152214.2b8bd2ad.akpm@linux-foundation.org>
In-Reply-To: <201002091659.27037.knikanth@suse.de>
References: <201002091659.27037.knikanth@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010 16:59:26 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> Make vm_max_readahead configurable at run-time. Expose a sysctl knob
> in procfs to change it. This would ensure that new disks added would
> use this value as their default read_ahead_kb.
> 

hm, I guess that's useful.

> +int sysctl_vm_max_readahead_handler(struct ctl_table *, int,
> +					void __user *, size_t *, loff_t *);

I don't particuarly like the practice of leaving out the identifiers. 
They're useful for documentation purposes and it's irritating when you
look at a declaration for some real reason, only to find that the identifiers
were left out.

>  int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
>  			pgoff_t offset, unsigned long nr_to_read);
> Index: linux-2.6/mm/backing-dev.c
> ===================================================================
> --- linux-2.6.orig/mm/backing-dev.c
> +++ linux-2.6/mm/backing-dev.c
> @@ -18,7 +18,7 @@ EXPORT_SYMBOL(default_unplug_io_fn);
>  
>  struct backing_dev_info default_backing_dev_info = {
>  	.name		= "default",
> -	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
> +	.ra_pages	= INITIAL_VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
>  	.state		= 0,
>  	.capabilities	= BDI_CAP_MAP_COPY,
>  	.unplug_io_fn	= default_unplug_io_fn,
> Index: linux-2.6/mm/readahead.c
> ===================================================================
> --- linux-2.6.orig/mm/readahead.c
> +++ linux-2.6/mm/readahead.c
> @@ -17,6 +17,19 @@
>  #include <linux/pagevec.h>
>  #include <linux/pagemap.h>
>  
> +unsigned long vm_max_readahead = INITIAL_VM_MAX_READAHEAD;
> +
> +int sysctl_vm_max_readahead_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +	proc_doulongvec_minmax(table, write, buffer, length, ppos);
> +
> +	default_backing_dev_info.ra_pages =
> +			vm_max_readahead >> (PAGE_CACHE_SHIFT - 10);
> +
> +	return 0;
> +}

Hang on.  This doesn't only affect newly-added disks.  It also affects
presently-mounted filesystems which are using default_backing_dev_info.
xfs, btrfs, blockdevs, nilfs, raw, mtd.

What's the effect of this change?  (It should be in the changelog)

>  #endif
> -
> +	{
> +		.procname	= "max_readahead_kb",
> +		.data		= &vm_max_readahead,
> +		.maxlen		= sizeof(vm_max_readahead),
> +		.mode		= 0644,
> +		.proc_handler	= sysctl_vm_max_readahead_handler,
> +	},

It'd be nice if the in-kernel and /proc/identifiers were more similar. 
That would require that vm_max_readahead be renamed to
vm_max_readahead_kb.  We could not bother, I guess.  But
vm_max_readahead_kb is a better identifier.

>  	{ }
>  };
>  
> Index: linux-2.6/Documentation/sysctl/vm.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/sysctl/vm.txt
> +++ linux-2.6/Documentation/sysctl/vm.txt
> @@ -31,6 +31,7 @@ Currently, these files are in /proc/sys/
>  - laptop_mode
>  - legacy_va_layout
>  - lowmem_reserve_ratio
> +- max_readahead_kb
>  - max_map_count
>  - memory_failure_early_kill
>  - memory_failure_recovery
> @@ -263,6 +264,12 @@ The minimum value is 1 (1/1 -> 100%).
>  
>  ==============================================================
>  
> +max_readahead_kb:
> +
> +This file contains the default maximum readahead that would be used.
> +

I think we could provide a more detailed description than this, please.
