Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZJJHPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZJJHPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZJJHPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:15:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZJJHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:15:11 -0400
Subject: Re: [PATCH RFC] sched: add notifier for process migration
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4ACFBC98.4070701@goop.org>
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>
	 <4ACFBC98.4070701@goop.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Oct 2009 09:14:23 +0200
Message-Id: <1255158863.7866.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 15:43 -0700, Jeremy Fitzhardinge wrote:

> OK, concretely:
> 
>    1. allocate a page and fixmap it into userspace
>    2. keep an array of structures containing tsc->cycle_t
>       (pvclock_vcpu_time_info) params, indexed by cpu
>    3. register those structures with the hypervisor so it can update
>       them as either the pcpus change freq and/or the vcpus get moved to
>       different pcpus
>    4. associate a "migration_count" with each structure (ie, how many
>       times this cpu has had tasks migrated off it)
> 
> The algorithm is basically:
> 
>     do {
>         cpu = vgetcpu();    	/* get current cpu */
>         ti = &timeinfo[cpu];	/* get scaling+offset for tsc */
> 
>         /* !!! migration race */
> 
>         migration_count = ti->migration_count;
>         version = ti->version;
> 
>         barrier();
> 
>         local_time_info = *ti;
> 
>         tsc = rdtsc();
>         cycles = compute_cycles_from_tsc(tsc, &local_time_info);
> 
>         barrier();
> 
>         cpu1 = vgetcpu();
> 
>     /* loop if anything changed under our feet:
>         - we changed cpus (if we got migrated at "!!! migration race" above
>            then the migration_count test won't pick it up)
>         - the time info changed
>         - we got migrated to a different cpu (we need to check this as well
>            as cpu != cpu1 in case we got migrated from A->B->A)
>      */
> 
>     } while(unlikely(cpu1 != cpu ||
>     		 timeinfo->version != version ||
>     		 timeinfo->migration_count != migration_count));
> 
>     return cycles;
>       
> 
> This is executed in usermode as part of vsyscall gettimeofday via the
> clocksource.vread function.

Why not do something like:

    struct {
	u64 tsc;
	u32 aux;
    } tscp = rdtscp();

    local_time_info = timeinfo[tscp_cpu(tscp)];

    /* yay, consistent tsc and timeinfo !! */

?
