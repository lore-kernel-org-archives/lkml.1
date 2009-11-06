Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZKFR3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZKFR3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZKFR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:29:11 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:55283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754757AbZKFR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:29:10 -0500
Date: Fri, 6 Nov 2009 12:27:50 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg : rewrite percpu countings with new
 interfaces
In-Reply-To: <20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911061220410.5187@V090114053VZO-1>
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com> <20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, KAMEZAWA Hiroyuki wrote:

> @@ -370,18 +322,13 @@ mem_cgroup_remove_exceeded(struct mem_cg
>  static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
>  {
>  	bool ret = false;
> -	int cpu;
>  	s64 val;
> -	struct mem_cgroup_stat_cpu *cpustat;
>
> -	cpu = get_cpu();
> -	cpustat = &mem->stat.cpustat[cpu];
> -	val = __mem_cgroup_stat_read_local(cpustat, MEMCG_EVENTS);
> +	val = __this_cpu_read(mem->cpustat->count[MEMCG_EVENTS]);
>  	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
> -		__mem_cgroup_stat_reset_safe(cpustat, MEMCG_EVENTS);
> +		__this_cpu_write(mem->cpustat->count[MEMCG_EVENTS], 0);
>  		ret = true;
>  	}
> -	put_cpu();
>  	return ret;

If you want to use the __this_cpu_xx versions then you need to manage
preempt on your own.

You need to keep preempt_disable/enable here because otherwise the per
cpu variable zeroed may be on a different cpu than the per cpu variable
where you got the value from.

> +static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
> +		enum mem_cgroup_stat_index idx)
> +{
> +	struct mem_cgroup_stat_cpu *cstat;
> +	int cpu;
> +	s64 ret = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		cstat = per_cpu_ptr(mem->cpustat, cpu);
> +		ret += cstat->count[idx];
> +	}

	== ret += per_cpu(mem->cpustat->cstat->count[idx], cpu)

>  static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
>  					 bool charge)
>  {
>  	int val = (charge) ? 1 : -1;
> -	struct mem_cgroup_stat *stat = &mem->stat;
> -	struct mem_cgroup_stat_cpu *cpustat;
> -	int cpu = get_cpu();
>
> -	cpustat = &stat->cpustat[cpu];
> -	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_SWAP, val);
> -	put_cpu();
> +	__this_cpu_add(mem->cpustat->count[MEMCG_NR_SWAP], val);
>  }

You do not disable preempt on your own so you have to use

	this_cpu_add()

There is no difference between __this_cpu_add and this_cpu_add on x86 but
they will differ on platforms that do not have atomic per cpu
instructions. The fallback for this_cpu_add is to protect the add with
preempt_disable()/enable. The fallback fro __this_cpu_add is just to rely
on the caller to ensure that preempt is disabled somehow.


> @@ -495,22 +460,17 @@ static void mem_cgroup_charge_statistics
>  					 bool charge)
>  {
>  	int val = (charge) ? 1 : -1;
> -	struct mem_cgroup_stat *stat = &mem->stat;
> -	struct mem_cgroup_stat_cpu *cpustat;
> -	int cpu = get_cpu();
>
> -	cpustat = &stat->cpustat[cpu];
>  	if (PageCgroupCache(pc))
> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_CACHE, val);
> +		__this_cpu_add(mem->cpustat->count[MEMCG_NR_CACHE], val);

Remove __
>  	else
> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_RSS, val);
> +		__this_cpu_add(mem->cpustat->count[MEMCG_NR_RSS], val);

Remove __
>
>  	if (charge)
> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_PGPGIN, 1);
> +		__this_cpu_inc(mem->cpustat->count[MEMCG_PGPGIN]);

Remove __
>  	else
> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_PGPGOUT, 1);
> -	__mem_cgroup_stat_add_safe(cpustat, MEMCG_EVENTS, 1);
> -	put_cpu();
> +		__this_cpu_inc(mem->cpustat->count[MEMCG_PGPGOUT]);
> +	__this_cpu_inc(mem->cpustat->count[MEMCG_EVENTS]);

Remove __

> -	/*
> -	 * Preemption is already disabled, we don't need get_cpu()
> -	 */
> -	cpu = smp_processor_id();
> -	stat = &mem->stat;
> -	cpustat = &stat->cpustat[cpu];
> -
> -	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, val);
> +	__this_cpu_add(mem->cpustat->count[MEMCG_NR_FILE_MAPPED], val);

Remove __


> @@ -1650,16 +1597,11 @@ static int mem_cgroup_move_account(struc
>
>  	page = pc->page;
>  	if (page_mapped(page) && !PageAnon(page)) {
> -		cpu = smp_processor_id();
>  		/* Update mapped_file data for mem_cgroup "from" */
> -		stat = &from->stat;
> -		cpustat = &stat->cpustat[cpu];
> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, -1);
> +		__this_cpu_dec(from->cpustat->count[MEMCG_NR_FILE_MAPPED]);

You can keep it here since the context already has preempt disabled it
seems.
