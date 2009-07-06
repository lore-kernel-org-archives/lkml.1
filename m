Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZGFIva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZGFIva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZGFIvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:51:22 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:36054 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZGFIvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:51:21 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mitake@dcl.info.waseda.ac.jp
Cc: fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
References: <20090701110620.GB15958@elte.hu>
	 <20090701.215304.864843820974206197.mitake@dcl.info.waseda.ac.jp>
	 <20090701154450.GC5097@nowhere>
	 <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 10:51:19 +0200
Message-Id: <1246870279.8143.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 14:20 +0900, mitake@dcl.info.waseda.ac.jp wrote:

> Thanks. I could install libelf with your way.
> 
> And sorry for my late response.
> Because adding counting spin lock to perfcounters is more difficult
> than I excepted...
> 
> When the process watched by perf tries to lock a spinlock
> this will be the nest of spinlock,
> because perfcounters subsystem also uses spinlock.
> 
> Is there any way to avoid the nest of lock?
> I want any advice...

swcounters should be able to deal with this recursion, but I have other
concerns with this.. see below.

> This is the temporal patch I wrote,
> 
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 5e970c7..f65a473 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -102,6 +102,7 @@ enum perf_sw_ids {
>  	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
>  	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
>  	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
> +	PERF_COUNT_SW_LOCK_ACQUIRES		= 7,
>  
>  	PERF_COUNT_SW_MAX,			/* non-ABI */
>  };
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index d55a50d..0261f9f 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -3754,6 +3754,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
>  	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
>  	case PERF_COUNT_SW_CONTEXT_SWITCHES:
>  	case PERF_COUNT_SW_CPU_MIGRATIONS:
> +	case PERF_COUNT_SW_LOCK_ACQUIRES:
>  		if (!counter->parent) {
>  			atomic_inc(&perf_swcounter_enabled[event]);
>  			counter->destroy = sw_perf_counter_destroy;
> diff --git a/kernel/spinlock.c b/kernel/spinlock.c
> index 7932653..394fc2d 100644
> --- a/kernel/spinlock.c
> +++ b/kernel/spinlock.c
> @@ -20,6 +20,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/debug_locks.h>
>  #include <linux/module.h>
> +#include <linux/perf_counter.h>
>  
>  int __lockfunc _spin_trylock(spinlock_t *lock)
>  {
> @@ -181,6 +182,9 @@ void __lockfunc _spin_lock(spinlock_t *lock)
>  	preempt_disable();
>  	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
>  	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
> +	perf_swcounter_event(PERF_COUNT_SW_LOCK_ACQUIRES,
> +			     1, 1, NULL, 0);
> +
>  }


Hrm.. very much the wrong place to put this hook..

Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
want to go there and put code like this on the lock hot-paths for !debug
kernels.

>  EXPORT_SYMBOL(_spin_lock);
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 2e03524..87511c0 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -52,6 +52,7 @@ static struct perf_counter_attr default_attrs[] = {
>    { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
>    { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS	},
>    { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS	},
> +  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_LOCK_ACQUIRES	},
>  
>    { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES	},
>    { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS	},
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 4d042f1..0cd4985 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -38,6 +38,7 @@ static struct event_symbol event_symbols[] = {
>    { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
>    { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
>    { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
> +  { CSW(LOCK_ACQUIRES),         "lock-acquires",	"lock"	},
>  };
>  
>  #define __PERF_COUNTER_FIELD(config, name) \
> @@ -66,6 +67,7 @@ static char *sw_event_names[] = {
>  	"CPU-migrations",
>  	"minor-faults",
>  	"major-faults",
> +	"lock-acquires",
>  };
>  
>  #define MAX_ALIASES 8

