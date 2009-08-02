Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZHBQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZHBQSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZHBQSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:18:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51397 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZHBQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:18:32 -0400
Message-ID: <2ffdbab4c235eda0f53d8d5bde2cf68c.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0908021704300.3945@sister.anvils>
References: <4A744C2A.6040009@gmail.com>
    <20090801200200.GB8514@balbir.in.ibm.com>
    <Pine.LNX.4.64.0908012305260.4581@sister.anvils>
    <20090801222602.GC8514@balbir.in.ibm.com>
    <Pine.LNX.4.64.0908021704300.3945@sister.anvils>
Date: Mon, 3 Aug 2009 01:18:28 +0900 (JST)
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sun, 2 Aug 2009, Balbir Singh wrote:
>> * Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-08-01 23:09:09]:
>> >
>> > Hmm, this a weird function, passed an argument just to tell it to do
>> > nothing.  Perhaps a placeholder for something more sensible to come?
>>
>> The argument is passed a result of a function, It no-ops quite
>> frequently for the root cgroup.
>
> The more often it no-ops, the sillier it is to be called in
> the first place: here's an updated patch which fixes that too.
>
>
> [PATCH mmotm] memory controller: soft limit organize cgroups v9 fix
>
> CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_PREEMPT=y mmotm fails to boot:
> Kernel panic - not syncing: No init found; after lots of scheduling
> while atomics, starting from when async_thread does sd_probe_async.
>
> mem_cgroup_soft_limit_check() was doing an unbalanced get_cpu():
> don't get_cpu if we won't need it, and put_cpu if we did get_cpu.
>
> And fix the silliness of passing it an "over_soft_limit" argument
> that just tells it to return false when false.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

nice fix, thank you very much.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> Fix to memory-controller-soft-limit-organize-cgroups-v9.patch
>
>  mm/memcontrol.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> --- mmotm/mm/memcontrol.c	2009-08-01 05:48:08.000000000 +0100
> +++ linux/mm/memcontrol.c	2009-08-02 16:56:02.000000000 +0100
> @@ -371,23 +371,21 @@ mem_cgroup_remove_exceeded(struct mem_cg
>  	spin_unlock(&mctz->lock);
>  }
>
> -static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem,
> -					bool over_soft_limit)
> +static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
>  {
>  	bool ret = false;
> -	int cpu = get_cpu();
> +	int cpu;
>  	s64 val;
>  	struct mem_cgroup_stat_cpu *cpustat;
>
> -	if (!over_soft_limit)
> -		return ret;
> -
> +	cpu = get_cpu();
>  	cpustat = &mem->stat.cpustat[cpu];
>  	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
>  	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
>  		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
>  		ret = true;
>  	}
> +	put_cpu();
>  	return ret;
>  }
>
> @@ -1342,7 +1340,7 @@ static int __mem_cgroup_try_charge(struc
>  	if (soft_fail_res) {
>  		mem_over_soft_limit =
>  			mem_cgroup_from_res_counter(soft_fail_res, res);
> -		if (mem_cgroup_soft_limit_check(mem_over_soft_limit, true))
> +		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
>  			mem_cgroup_update_tree(mem_over_soft_limit, page);
>  	}
>  	return 0;
> @@ -1873,7 +1871,7 @@ __mem_cgroup_uncharge_common(struct page
>  	mz = page_cgroup_zoneinfo(pc);
>  	unlock_page_cgroup(pc);
>
> -	if (mem_cgroup_soft_limit_check(mem, soft_limit_excess))
> +	if (soft_limit_excess && mem_cgroup_soft_limit_check(mem))
>  		mem_cgroup_update_tree(mem, page);
>  	/* at swapout, this memcg will be accessed to record to swap */
>  	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>


