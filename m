Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZFZRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZFZRAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbZFZRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:00:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:58002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938AbZFZRAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:00:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,297,1243839600"; 
   d="scan'208";a="425586359"
Subject: Re: possible recursive locking detected at kmem_cache_free
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>, "mingo@elte.hu" <mingo@elte.hu>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0906261036080.21067@melkki.cs.Helsinki.FI>
References: <20090625185942.GA29401@linux-os.sc.intel.com>
	 <20090625123750.734b7f50.akpm@linux-foundation.org>
	 <20090625215541.GB29401@linux-os.sc.intel.com>
	 <Pine.LNX.4.64.0906261036080.21067@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 09:58:22 -0700
Message-Id: <1246035502.4534.21747.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 00:37 -0700, Pekka J Enberg wrote:
> Hi Venki,
> 
> On Thu, 25 Jun 2009, Pallipadi, Venkatesh wrote:
> > > > Not sure if this has been reported elsewhere. I started seeing this with git
> > > > kernel from this morning on a system with RedHat EL5 base installation with
> > > > ext3 root file system. Attached is the config I am using.
> > > > 
> > > > Let me know if you need any more details. This seems to be at every boot. I
> > > > am trying the bisect right now.
> > > > 
> > > 
> > > Thanks.  Let's cc Pekka.
> > > 
> > 
> > git bisect result.
> 
> Thanks! I think I just broke lockdep annotations for slab. Does this patch 
> fix things?
> 

Yes. This patch helps.

Thanks,
Venki

> 			Pekka
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index e74a16e..37ee532 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1544,9 +1544,6 @@ void __init kmem_cache_init(void)
>  	}
>  
>  	g_cpucache_up = EARLY;
> -
> -	/* Annotate slab for lockdep -- annotate the malloc caches */
> -	init_lock_keys();
>  }
>  
>  void __init kmem_cache_init_late(void)
> @@ -1563,6 +1560,9 @@ void __init kmem_cache_init_late(void)
>  	/* Done! */
>  	g_cpucache_up = FULL;
>  
> +	/* Annotate slab for lockdep -- annotate the malloc caches */
> +	init_lock_keys();
> +
>  	/*
>  	 * Register a cpu startup notifier callback that initializes
>  	 * cpu_cache_get for all new cpus

