Return-Path: <linux-kernel-owner+w=401wt.eu-S935216AbZDIPxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216AbZDIPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935397AbZDIPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:53:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935163AbZDIPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:53:16 -0400
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 17:54:56 +0200
Message-Id: <1239292496.7647.607.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 17:47 +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The adaptive spinning mutexes will not always do what one would expect on
> virtualized architectures like s390. Especially the cpu_relax() loop in
> mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
> away by the hypervisor.
> We would end up in a cpu_relax() loop when there is no chance that the
> state of the mutex changes until the target cpu has been scheduled again by
> the hypervisor.
> For that reason we should change the default behaviour to no-spin on s390.
> 
> We do have an instruction which allows to yield the current cpu in favour of
> a different target cpu. Also we have an instruction which allows us to figure
> out if the target cpu is physically backed.
> 
> However we need to do some performance tests until we can come up with
> a solution that will do the right thing on s390.
> Until then make the old behaviour default for us.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/Kconfig            |    3 +++
>  arch/s390/Kconfig       |    1 +
>  kernel/sched_features.h |    4 ++++
>  3 files changed, 8 insertions(+)
> 
> Index: linux-2.6/arch/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/Kconfig
> +++ linux-2.6/arch/Kconfig
> @@ -109,3 +109,6 @@ config HAVE_CLK
>  
>  config HAVE_DMA_API_DEBUG
>  	bool
> +
> +config HAVE_DEFAULT_NO_SPIN_MUTEXES
> +	bool
> Index: linux-2.6/arch/s390/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/s390/Kconfig
> +++ linux-2.6/arch/s390/Kconfig
> @@ -82,6 +82,7 @@ config S390
>  	select USE_GENERIC_SMP_HELPERS if SMP
>  	select HAVE_SYSCALL_WRAPPERS
>  	select HAVE_FUNCTION_TRACER
> +	select HAVE_DEFAULT_NO_SPIN_MUTEXES
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
> Index: linux-2.6/kernel/sched_features.h
> ===================================================================
> --- linux-2.6.orig/kernel/sched_features.h
> +++ linux-2.6/kernel/sched_features.h
> @@ -14,4 +14,8 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
>  SCHED_FEAT(ASYM_EFF_LOAD, 1)
>  SCHED_FEAT(WAKEUP_OVERLAP, 0)
>  SCHED_FEAT(LAST_BUDDY, 1)
> +#ifdef CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES
> +SCHED_FEAT(OWNER_SPIN, 0)
> +#else
>  SCHED_FEAT(OWNER_SPIN, 1)
> +#endif

Hmm, I'd rather have you'd make the whole block in __mutex_lock_common
go away on that CONFIG thingy.

Would be nice though to get something working on s390, does it have a
monitor wait like ins where it can properly sleep so that another
virtual host can run?

If so, we could possibly do a monitor wait on the lock owner field
instead of spinning.
