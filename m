Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0CIVJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:09:26 -0500
Received: from virt1f.secure-wi.com ([209.216.201.8]:34608 "EHLO
	virt1f.secure-wi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0CIVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:09:24 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 16:09:24 EST
Message-ID: <4B96B771.9050903@wildturkeyranch.net>
Date: Tue, 09 Mar 2010 14:02:41 -0700
From: George Anzinger <george@wildturkeyranch.net>
Reply-To: george@wildturkeyranch.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: linux-kernel@vger.kernel.org,
       KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [Kgdb-bugreport] [PATCH] KGDB: add smp_mb() in synchronisation
 during exception handler exit
References: <1268158831-6976-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1268158831-6976-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/09/2010 11:20 AM,  Will Deacon was caught saying:
> KGDB uses atomic variables and busy-wait loops to co-ordinate between
> multiple CPUs on an SMP system. When an exception is handled, the primary
> CPU executes kgdb_handle_exception() whilst the others execute kgdb_wait.
>
> There comes a point when the waiters are waiting for the primary CPU to finish:
>
> 	/* Wait till primary CPU is done with debugging */
> (1)	while (atomic_read(&passive_cpu_wait[cpu]))
> 		cpu_relax();
>
> 	/* Do important KGDB stuff */
>
> 	/* Signal the primary CPU that we are done: */
> 	atomic_set(&cpu_in_kgdb[cpu], 0);
>
> In parallel to this, the primary CPU is doing:
>
> 	for (i = NR_CPUS-1; i>= 0; i--)
> 		atomic_set(&passive_cpu_wait[i], 0);
> 	/*
> 	 * Wait till all the CPUs have quit
> 	 * from the debugger.
> 	 */
> 	for_each_online_cpu(i) {
> (1)		while (atomic_read(&cpu_in_kgdb[i]))
> 			cpu_relax();
> 	}
>
> There is a potential deadlock situation at point (1) because the previous
> writes to the passive_cpu_wait variables by the primary CPU may not yet be
> visible to the other CPUs [for instance, they may be sitting in the local
> store buffer]. This means that the waiter CPUs will never exit the while loop
> and therefore never write to the cpu_in_kgdb variables, which the primary CPU
> is blocked on. Furthermore, because the primary CPU is aggressively performing
> reads, the store buffer may not necessarily drain so the system will deadlock.
>
> This deadlock has been experienced on a quad-core ARM11MPCore platform.
>
> The following patch addresses the issue by adding a memory barrier to the
> primary CPU before the polling loop, therefore forcing the previous atomic_sets
> to be visible before waiting for the waiters to finish.
>
> Cc: KGDB Mailing List<kgdb-bugreport@lists.sourceforge.net>
> Cc: Catalin Marinas<catalin.marinas@arm.com>
> Cc: Russell King - ARM Linux<linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Will Deacon<will.deacon@arm.com>
> ---
>   kernel/kgdb.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kgdb.c b/kernel/kgdb.c
> index 761fdd2..ee7694b 100644
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -1537,6 +1537,7 @@ acquirelock:
>   		 * Wait till all the CPUs have quit
>   		 * from the debugger.
>   		 */
> +		smp_mb();
>   		for_each_online_cpu(i) {
>   			while (atomic_read(&cpu_in_kgdb[i]))
>   				cpu_relax();
>    
Doesn't this have the same issue if this cpu gets to the while prior to 
the other cpu doing its write.  I would think the "smp_mb()" should be 
in the while loop not prior to it.

-- 
George Anzinger   george@wildturkeyranch.net


