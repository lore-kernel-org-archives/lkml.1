Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0CHRKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:10:17 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:36807 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0CHRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:10:11 -0500
Date: Mon, 8 Mar 2010 18:10:20 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
Message-ID: <20100308171020.GC2557@osiris.boeblingen.de.ibm.com>
References: <1268063603-7425-1-git-send-email-tj@kernel.org>
 <1268063603-7425-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268063603-7425-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:53:21AM +0900, Tejun Heo wrote:
> Reimplement stop_machine using cpuhog.  As cpuhogs are guaranteed to
> be available for all online cpus, stop_machine_create/destroy() are no
> longer necessary and removed.
> 
> With resource management and synchronization handled by cpuhog, the
> new implementation is much simpler.  Asking the cpuhog to execute the
> stop_cpu() state machine on all online cpus with cpu hotplug disabled
> is enough.
> 
> stop_machine itself doesn't need to manage any global resources
> anymore, so all per-instance information is rolled into struct
> stop_machine_data and the mutex and all static data variables are
> removed.
> 
> The previous implementation created and destroyed RT workqueues as
> necessary which made stop_machine() calls highly expensive on very
> large machines.  According to Dimitri Sivanich, preventing the dynamic
> creation/destruction makes booting faster more than twice on very
> large machines.  cpuhog resources are preallocated for all online cpus
> and should have the same effect.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/s390/kernel/time.c      |    1 -
>  drivers/xen/manage.c         |   14 +---
>  include/linux/stop_machine.h |   20 -----
>  kernel/cpu.c                 |    8 --
>  kernel/module.c              |   14 +---
>  kernel/stop_machine.c        |  162 ++++++++++--------------------------------
>  6 files changed, 42 insertions(+), 177 deletions(-)
> 
> diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
> index 65065ac..afe429e 100644
> --- a/arch/s390/kernel/time.c
> +++ b/arch/s390/kernel/time.c
> @@ -397,7 +397,6 @@ static void __init time_init_wq(void)
>  	if (time_sync_wq)
>  		return;
>  	time_sync_wq = create_singlethread_workqueue("timesync");
> -	stop_machine_create();
>  }
> 
>  /*

The reason we introduced stop_machine_create/destroy was to have a non-failing
variant that doesn't rely on I/O.
If we ever see a timesync machine check no I/O will succeed (it blocks) until
clocks have been synchronized. That means also that we rely on the non-blocking
semantics that those functions must have that are called via stop_machine.
This isn't true anymore with the cpu hog infrastructure:
if passed a blocking function that could wait on I/O we won't see any progress
anymore and the machine is dead.
