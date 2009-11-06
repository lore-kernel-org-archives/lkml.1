Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbZKFSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbZKFSoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbZKFSoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:44:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58997 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbZKFSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:44:33 -0500
Message-ID: <6aea93183b4d3582d4e3f1550f4695fe.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911061220410.5187@V090114053VZO-1>
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
    <20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0911061220410.5187@V090114053VZO-1>
Date: Sat, 7 Nov 2009 03:44:35 +0900 (JST)
Subject: Re: [PATCH 2/2] memcg : rewrite percpu countings with new
 interfaces
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 6 Nov 2009, KAMEZAWA Hiroyuki wrote:
>> -		__mem_cgroup_stat_reset_safe(cpustat, MEMCG_EVENTS);
>> +		__this_cpu_write(mem->cpustat->count[MEMCG_EVENTS], 0);
>>  		ret = true;
>>  	}
>> -	put_cpu();
>>  	return ret;
>
> If you want to use the __this_cpu_xx versions then you need to manage
> preempt on your own.
>
Ah, I see. I understand I haven't understood.

> You need to keep preempt_disable/enable here because otherwise the per
> cpu variable zeroed may be on a different cpu than the per cpu variable
> where you got the value from.
>
Thank you. I think I can do well in the next version.


>> +static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
>> +		enum mem_cgroup_stat_index idx)
>> +{
>> +	struct mem_cgroup_stat_cpu *cstat;
>> +	int cpu;
>> +	s64 ret = 0;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		cstat = per_cpu_ptr(mem->cpustat, cpu);
>> +		ret += cstat->count[idx];
>> +	}
>
> 	== ret += per_cpu(mem->cpustat->cstat->count[idx], cpu)
>
Hmm, Hmm. Will use that.

>>  static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
>>  					 bool charge)
>>  {
>>  	int val = (charge) ? 1 : -1;
>> -	struct mem_cgroup_stat *stat = &mem->stat;
>> -	struct mem_cgroup_stat_cpu *cpustat;
>> -	int cpu = get_cpu();
>>
>> -	cpustat = &stat->cpustat[cpu];
>> -	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_SWAP, val);
>> -	put_cpu();
>> +	__this_cpu_add(mem->cpustat->count[MEMCG_NR_SWAP], val);
>>  }
>
> You do not disable preempt on your own so you have to use
>
> 	this_cpu_add()
>
> There is no difference between __this_cpu_add and this_cpu_add on x86 but
> they will differ on platforms that do not have atomic per cpu
> instructions. The fallback for this_cpu_add is to protect the add with
> preempt_disable()/enable. The fallback fro __this_cpu_add is just to rely
> on the caller to ensure that preempt is disabled somehow.
>
Ok.


>> -	/*
>> -	 * Preemption is already disabled, we don't need get_cpu()
>> -	 */
>> -	cpu = smp_processor_id();
>> -	stat = &mem->stat;
>> -	cpustat = &stat->cpustat[cpu];
>> -
>> -	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, val);
>> +	__this_cpu_add(mem->cpustat->count[MEMCG_NR_FILE_MAPPED], val);
>
> Remove __
>
>
>> @@ -1650,16 +1597,11 @@ static int mem_cgroup_move_account(struc
>>
>>  	page = pc->page;
>>  	if (page_mapped(page) && !PageAnon(page)) {
>> -		cpu = smp_processor_id();
>>  		/* Update mapped_file data for mem_cgroup "from" */
>> -		stat = &from->stat;
>> -		cpustat = &stat->cpustat[cpu];
>> -		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, -1);
>> +		__this_cpu_dec(from->cpustat->count[MEMCG_NR_FILE_MAPPED]);
>
> You can keep it here since the context already has preempt disabled it
> seems.
>
Thank you for kindly review.

Regards,
-Kame



