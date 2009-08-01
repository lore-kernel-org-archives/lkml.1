Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZHAWok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZHAWok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZHAWoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:44:39 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51476 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZHAWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:44:39 -0400
Date: Sun, 2 Aug 2009 04:14:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
Message-ID: <20090801224426.GD8514@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A744C2A.6040009@gmail.com>
 <20090801200200.GB8514@balbir.in.ibm.com>
 <Pine.LNX.4.64.0908012305260.4581@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908012305260.4581@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-08-01 23:09:09]:

> I've just finished chasing something similar (without qemu),
> and was about to post this:
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
> Hmm, this a weird function, passed an argument just to tell it to do
> nothing.  Perhaps a placeholder for something more sensible to come?
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> Fix to memory-controller-soft-limit-organize-cgroups-v9.patch
> 
>  mm/memcontrol.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- mmotm/mm/memcontrol.c	2009-08-01 05:48:08.000000000 +0100
> +++ linux/mm/memcontrol.c	2009-08-01 21:45:37.000000000 +0100
> @@ -375,19 +375,21 @@ static bool mem_cgroup_soft_limit_check(
>  					bool over_soft_limit)
>  {
>  	bool ret = false;
> -	int cpu = get_cpu();
> +	int cpu;
>  	s64 val;
>  	struct mem_cgroup_stat_cpu *cpustat;
> 
>  	if (!over_soft_limit)
>  		return ret;
> 
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

I can confirm that this fixes the problem with CONFIG_PREEMPT enabled.

Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
