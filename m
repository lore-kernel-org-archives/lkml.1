Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbXJRH5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbXJRH5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXJRH5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:57:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58654 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbXJRH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:57:11 -0400
Date: Thu, 18 Oct 2007 13:27:02 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071018075702.GB15281@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <20071016103506.GB16570@in.ibm.com> <20071017161308.GD6773@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017161308.GD6773@localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan, 
> Hi Gautham-
> 
> Gautham R Shenoy wrote:
> > Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
> > get_online_cpus and put_online_cpus instead as it highlights
> > the refcount semantics in these operations.
> 
> Something other than "get_online_cpus", please?  lock_cpu_hotplug()
> protects cpu_present_map as well as cpu_online_map.  For example, some
> of the powerpc code modified in this patch is made a bit less clear
> because it is manipulating cpu_present_map, not cpu_online_map.

A quick look at the code, and I am wondering why is lock_cpu_hotplug()
used there in the first place. It doesn't look like we require any 
protection against cpus coming up/ going down in the code below, 
since the cpu-hotplug operation doesn't affect the cpu_present_map. 

Can't we use another mutex here instead of the cpu_hotplug mutex here ?


> 
> 
> > Index: linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
> > ===================================================================
> > --- linux-2.6.23.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
> > +++ linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
> > @@ -151,7 +151,7 @@ static int pseries_add_processor(struct 
> >  	for (i = 0; i < nthreads; i++)
> >  		cpu_set(i, tmp);
> >  
> > -	lock_cpu_hotplug();
> > +	get_online_cpus();
> >  
> >  	BUG_ON(!cpus_subset(cpu_present_map, cpu_possible_map));
> >  
> > @@ -188,7 +188,7 @@ static int pseries_add_processor(struct 
> >  	}
> >  	err = 0;
> >  out_unlock:
> > -	unlock_cpu_hotplug();
> > +	put_online_cpus();
> >  	return err;
> >  }
> >  
> > @@ -209,7 +209,7 @@ static void pseries_remove_processor(str
> >  
> >  	nthreads = len / sizeof(u32);
> >  
> > -	lock_cpu_hotplug();
> > +	get_online_cpus();
> >  	for (i = 0; i < nthreads; i++) {
> >  		for_each_present_cpu(cpu) {
> >  			if (get_hard_smp_processor_id(cpu) != intserv[i])
> > @@ -223,7 +223,7 @@ static void pseries_remove_processor(str
> >  			printk(KERN_WARNING "Could not find cpu to remove "
> >  			       "with physical id 0x%x\n", intserv[i]);
> >  	}
> > -	unlock_cpu_hotplug();
> > +	put_online_cpus();
> >  }


-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
