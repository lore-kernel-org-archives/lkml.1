Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbYEWQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbYEWQJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbYEWQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:09:39 -0400
Received: from saeurebad.de ([85.214.36.134]:54533 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbYEWQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:09:38 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>
Date: Fri, 23 May 2008 18:09:08 +0200
In-Reply-To: <20080523141759.GA1833@damson.getinternet.no> (Vegard Nossum's
	message of "Fri, 23 May 2008 16:17:59 +0200")
Message-ID: <87od6xngt7.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

Vegard Nossum <vegard.nossum@gmail.com> writes:

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 23 May 2008 15:53:03 +0200
> Subject: [PATCH] kmemcheck: SMP support
>
> This patch adds SMP support to kmemcheck, that is, the ability to boot
> more than one processor even when kmemcheck is enabled. (Previously,
> only one CPU would be booted even if more were present in the system.)
>
> On page fault, kmemcheck needs to pause all the other CPUs in the system
> in order to guarantee that no other CPU will modify the same memory
> location (which will otherwise be unprotected after we set the present
> bit of the PTE).
>
> Since the page fault can be taken with any irq state (i.e. enabled or
> disabled), we can't send a normal IPI broadcast since this can deadlock.
>
> Instead, we send an NMI. This is guaranteed to be received _except_ if
> the processor is already inside the NMI handler.
>
> This is of course not very efficient, and booting with maxcpus=1 is
> recommended, however, this allows the kernel to be configured with
> CONFIG_KMEMCHECK=y with close to zero overhead when kmemcheck is
> disabled. (It can still be runtime-enabled at any time, though.)
>
> The patch has been tested on real hardware.
>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/kernel/kmemcheck.c |  108 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 98 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
> index c0045e8..fdf8acb 100644
> --- a/arch/x86/kernel/kmemcheck.c
> +++ b/arch/x86/kernel/kmemcheck.c
> @@ -16,6 +16,7 @@
>  #include <linux/kmemcheck.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
>  #include <linux/page-flags.h>
>  #include <linux/percpu.h>
>  #include <linux/stacktrace.h>
> @@ -23,9 +24,12 @@
>  #include <asm/cacheflush.h>
>  #include <asm/kmemcheck.h>
>  #include <asm/pgtable.h>
> +#include <asm/smp.h>
>  #include <asm/string.h>
>  #include <asm/tlbflush.h>
>  
> +#include <mach_ipi.h>
> +
>  enum shadow {
>  	SHADOW_UNALLOCATED,
>  	SHADOW_UNINITIALIZED,
> @@ -240,18 +244,91 @@ static void do_wakeup(unsigned long data)
>  	}
>  }
>  
> +static atomic_t nmi_wait;
> +static atomic_t nmi_resume;
> +static atomic_t started;
> +static atomic_t finished;
> +
> +static int nmi_notifier(struct notifier_block *self,
> +	unsigned long val, void *data)
> +{
> +	struct die_args *args = (struct die_args *) data;
> +
> +	if (val != DIE_NMI_IPI || !atomic_read(&nmi_wait))
> +		return NOTIFY_DONE;
> +
> +	atomic_inc(&started);
> +
> +	/* Pause until the fault has been handled */
> +	while (!atomic_read(&nmi_resume))
> +		cpu_relax();
> +
> +	atomic_inc(&finished);
> +
> +	return NOTIFY_STOP;
> +}
> +
> +static void
> +pause_allbutself(void)
> +{
> +#ifdef CONFIG_SMP
> +	static spinlock_t nmi_spinlock;
> +
> +	int cpus;
> +	cpumask_t mask = cpu_online_map;
> +
> +	spin_lock(&nmi_spinlock);
> +
> +	cpus = num_online_cpus() - 1;
> +
> +	atomic_set(&started, 0);
> +	atomic_set(&finished, 0);
> +	atomic_set(&nmi_wait, 1);
> +	atomic_set(&nmi_resume, 0);
> +
> +	cpu_clear(safe_smp_processor_id(), mask);
> +	if (!cpus_empty(mask))
> +		send_IPI_mask(mask, NMI_VECTOR);
> +
> +	while (atomic_read(&started) != cpus)
> +		cpu_relax();
> +
> +	atomic_set(&nmi_wait, 0);
> +
> +	spin_unlock(&nmi_spinlock);
> +#endif
> +}
> +
> +static void
> +resume(void)
> +{
> +#ifdef CONFIG_SMP
> +	int cpus;
> +
> +	cpus = num_online_cpus() - 1;
> +
> +	atomic_set(&nmi_resume, 1);
> +
> +	while (atomic_read(&finished) != cpus)
> +		cpu_relax();
> +#endif
> +}

How about merging finished and started into one?  I.e. `paused'.

The notifiers increases `paused' before the waiting-loop and decreases
it again afterwards.

pause_allbutself() sends the IPIs and waits until `paused' reached the
number of CPUS.

resume() justs waits until `paused' reaches zero.

Would this work?  Will the NMI handler finish even when the CPU is
removed while the handler runs?

	Hannes
