Return-Path: <linux-kernel-owner+w=401wt.eu-S936104AbXJQQNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104AbXJQQNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763486AbXJQQNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:13:18 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:54882 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128AbXJQQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:13:16 -0400
Date: Wed, 17 Oct 2007 11:13:08 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071017161308.GD6773@localdomain>
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103506.GB16570@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gautham-

Gautham R Shenoy wrote:
> Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> get_online_cpus and put_online_cpus instead as it highlights
> the refcount semantics in these operations.

Something other than "get_online_cpus", please?  lock_cpu_hotplug()
protects cpu_present_map as well as cpu_online_map.  For example, some
of the powerpc code modified in this patch is made a bit less clear
because it is manipulating cpu_present_map, not cpu_online_map.


> Index: linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
> ===================================================================
> --- linux-2.6.23.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
> +++ linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
> @@ -151,7 +151,7 @@ static int pseries_add_processor(struct 
>  	for (i = 0; i < nthreads; i++)
>  		cpu_set(i, tmp);
>  
> -	lock_cpu_hotplug();
> +	get_online_cpus();
>  
>  	BUG_ON(!cpus_subset(cpu_present_map, cpu_possible_map));
>  
> @@ -188,7 +188,7 @@ static int pseries_add_processor(struct 
>  	}
>  	err = 0;
>  out_unlock:
> -	unlock_cpu_hotplug();
> +	put_online_cpus();
>  	return err;
>  }
>  
> @@ -209,7 +209,7 @@ static void pseries_remove_processor(str
>  
>  	nthreads = len / sizeof(u32);
>  
> -	lock_cpu_hotplug();
> +	get_online_cpus();
>  	for (i = 0; i < nthreads; i++) {
>  		for_each_present_cpu(cpu) {
>  			if (get_hard_smp_processor_id(cpu) != intserv[i])
> @@ -223,7 +223,7 @@ static void pseries_remove_processor(str
>  			printk(KERN_WARNING "Could not find cpu to remove "
>  			       "with physical id 0x%x\n", intserv[i]);
>  	}
> -	unlock_cpu_hotplug();
> +	put_online_cpus();
>  }
