Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZFSDZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZFSDZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZFSDZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:25:42 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43782 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZFSDZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:25:41 -0400
References: <4A3AF950.7090201@kernel.org>
Message-Id: <9EC284DE-A66B-4369-8802-31E4A8DDA156@oracle.com>
From: Andy Grover <andy.grover@oracle.com>
To: Tejun Heo <tj@kernel.org>
In-Reply-To: <4A3AF950.7090201@kernel.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH] percpu: use DEFINE_PER_CPU_SHARED_ALIGNED()
Date: Thu, 18 Jun 2009 20:23:37 -0700
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Frysinger <vapier@gentoo.org>, Tony Luck <tony.luck@intel.com>
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A3B04E6.0162:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack, thanks! -- Andy

On Jun 18, 2009, at 7:34 PM, Tejun Heo <tj@kernel.org> wrote:

> There are a few places where ___cacheline_aligned* is used with
> DEFINE_PER_CPU().  Use DEFINE_PER_CPU_SHARED_ALIGNED() instead.
>
> DEFINE_PER_CPU_SHARED_ALIGNED() applies alignment only on SMPs.  While
> all other converted places used _in_smp variant or only get compiled
> for SMP, net/rds used unconditional ____cacheline_aligned.  I don't
> see any reason these data structures should be aligned on UP and thus
> converted together.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Andy Grover <andy.grover@oracle.com>
> ---
> I committed the following patch to percpu#for-next git tree.  Please
> let me know if something doesn't look right.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
> http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=shortlog;h=for-next
>
> Thanks.
>
> arch/blackfin/mm/sram-alloc.c |    6 +++---
> arch/ia64/kernel/smp.c        |    3 ++-
> kernel/sched.c                |    4 ++--
> net/rds/ib_stats.c            |    2 +-
> net/rds/iw_stats.c            |    2 +-
> net/rds/page.c                |    2 +-
> 6 files changed, 10 insertions(+), 9 deletions(-)
>
> Index: work/arch/blackfin/mm/sram-alloc.c
> ===================================================================
> --- work.orig/arch/blackfin/mm/sram-alloc.c
> +++ work/arch/blackfin/mm/sram-alloc.c
> @@ -42,9 +42,9 @@
> #include <asm/mem_map.h>
> #include "blackfin_sram.h"
>
> -static DEFINE_PER_CPU(spinlock_t, l1sram_lock)  
> ____cacheline_aligned_in_smp;
> -static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock)  
> ____cacheline_aligned_in_smp;
> -static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock)  
> ____cacheline_aligned_in_smp;
> +static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1sram_lock);
> +static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1_data_sram_lock);
> +static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1_inst_sram_lock);
> static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
>
> /* the data structure for L1 scratchpad and DATA SRAM */
> Index: work/arch/ia64/kernel/smp.c
> ===================================================================
> --- work.orig/arch/ia64/kernel/smp.c
> +++ work/arch/ia64/kernel/smp.c
> @@ -58,7 +58,8 @@ static struct local_tlb_flush_counts {
>    unsigned int count;
> } __attribute__((__aligned__(32))) local_tlb_flush_counts[NR_CPUS];
>
> -static DEFINE_PER_CPU(unsigned short [NR_CPUS],  
> shadow_flush_counts) ____cacheline_aligned;
> +static DEFINE_PER_CPU_SHARED_ALIGNED(unsigned short [NR_CPUS],
> +                     shadow_flush_counts);
>
> #define IPI_CALL_FUNC        0
> #define IPI_CPU_STOP        1
> Index: work/kernel/sched.c
> ===================================================================
> --- work.orig/kernel/sched.c
> +++ work/kernel/sched.c
> @@ -318,12 +318,12 @@ struct task_group root_task_group;
> /* Default task group's sched entity on each cpu */
> static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
> /* Default task group's cfs_rq on each cpu */
> -static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq)  
> ____cacheline_aligned_in_smp;
> +static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_cfs_rq);
> #endif /* CONFIG_FAIR_GROUP_SCHED */
>
> #ifdef CONFIG_RT_GROUP_SCHED
> static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
> -static DEFINE_PER_CPU(struct rt_rq, init_rt_rq)  
> ____cacheline_aligned_in_smp;
> +static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
> #endif /* CONFIG_RT_GROUP_SCHED */
> #else /* !CONFIG_USER_SCHED */
> #define root_task_group init_task_group
> Index: work/net/rds/ib_stats.c
> ===================================================================
> --- work.orig/net/rds/ib_stats.c
> +++ work/net/rds/ib_stats.c
> @@ -37,7 +37,7 @@
> #include "rds.h"
> #include "ib.h"
>
> -DEFINE_PER_CPU(struct rds_ib_statistics, rds_ib_stats)  
> ____cacheline_aligned;
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics,  
> rds_ib_stats);
>
> static char *rds_ib_stat_names[] = {
>    "ib_connect_raced",
> Index: work/net/rds/iw_stats.c
> ===================================================================
> --- work.orig/net/rds/iw_stats.c
> +++ work/net/rds/iw_stats.c
> @@ -37,7 +37,7 @@
> #include "rds.h"
> #include "iw.h"
>
> -DEFINE_PER_CPU(struct rds_iw_statistics, rds_iw_stats)  
> ____cacheline_aligned;
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_iw_statistics,  
> rds_iw_stats);
>
> static char *rds_iw_stat_names[] = {
>    "iw_connect_raced",
> Index: work/net/rds/page.c
> ===================================================================
> --- work.orig/net/rds/page.c
> +++ work/net/rds/page.c
> @@ -39,7 +39,7 @@ struct rds_page_remainder {
>    unsigned long    r_offset;
> };
>
> -DEFINE_PER_CPU(struct rds_page_remainder, rds_page_remainders)  
> ____cacheline_aligned;
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_page_remainder,  
> rds_page_remainders);
>
> /*
>  * returns 0 on success or -errno on failure.
