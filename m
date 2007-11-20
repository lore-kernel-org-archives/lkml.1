Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbXKTNCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbXKTNCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXKTNCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:02:06 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:64815 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386AbXKTNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:02:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFtpQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 08:02:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
Message-ID: <20071120130201.GE10127@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011336.210236732@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071120011336.210236732@sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:00:08 up 16 days, 18:05,  2 users,  load average: 1.57, 1.93,
	2.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* clameter@sgi.com (clameter@sgi.com) wrote:
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  fs/nfs/iostat.h |    8 ++++----
>  fs/nfs/super.c  |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/fs/nfs/iostat.h
> ===================================================================
> --- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
> +++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
> @@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
>  	int cpu;
>  
>  	cpu = get_cpu();
> -	iostats = per_cpu_ptr(server->io_stats, cpu);
> +	iostats = CPU_PTR(server->io_stats, cpu);
>  	iostats->events[stat] ++;

Is there a way to change this into a CPU_ADD ?

>  	put_cpu_no_resched();

Why put_cpu_no_resched here ?

>  }
> @@ -139,7 +139,7 @@ static inline void nfs_add_server_stats(
>  	int cpu;
>  
>  	cpu = get_cpu();
> -	iostats = per_cpu_ptr(server->io_stats, cpu);
> +	iostats = CPU_PTR(server->io_stats, cpu);
>  	iostats->bytes[stat] += addend;
>  	put_cpu_no_resched();

Why put_cpu_no_resched here ?

>  }
> @@ -151,13 +151,13 @@ static inline void nfs_add_stats(struct 
>  
>  static inline struct nfs_iostats *nfs_alloc_iostats(void)
>  {
> -	return alloc_percpu(struct nfs_iostats);
> +	return CPU_ALLOC(struct nfs_iostats, GFP_KERNEL | __GFP_ZERO);
>  }
>  
>  static inline void nfs_free_iostats(struct nfs_iostats *stats)
>  {
>  	if (stats != NULL)
> -		free_percpu(stats);
> +		CPU_FREE(stats);
>  }
>  
>  #endif
> Index: linux-2.6/fs/nfs/super.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/super.c	2007-11-15 21:17:24.399404478 -0800
> +++ linux-2.6/fs/nfs/super.c	2007-11-15 21:25:33.171654143 -0800
> @@ -529,7 +529,7 @@ static int nfs_show_stats(struct seq_fil
>  		struct nfs_iostats *stats;
>  
>  		preempt_disable();
> -		stats = per_cpu_ptr(nfss->io_stats, cpu);
> +		stats = CPU_PTR(nfss->io_stats, cpu);
>  
>  		for (i = 0; i < __NFSIOS_COUNTSMAX; i++)
>  			totals.events[i] += stats->events[i];
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
