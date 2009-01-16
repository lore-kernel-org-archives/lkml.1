Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZAPIMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZAPIMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZAPIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:12:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZAPIMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:12:33 -0500
Message-ID: <49704147.6000003@cn.fujitsu.com>
Date: Fri, 16 Jan 2009 16:11:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] trace_workqueue: use percpu data for workqueue stat
References: <496F25A8.5040303@cn.fujitsu.com> <c62985530901150509we244b70l4e7af5c6b6145f30@mail.gmail.com>
In-Reply-To: <c62985530901150509we244b70l4e7af5c6b6145f30@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> Hi Lai,
> 
> 2009/1/15 Lai Jiangshan <laijs@cn.fujitsu.com>:
>> Impact: make trace_workqueue works well on NUMA
>>
>> It's not correct when (num_possible_cpus() < nr_cpumask_bits):
>>        all_workqueue_stat = kmalloc(sizeof(struct workqueue_global_stats)
>>                                     * num_possible_cpus(), GFP_KERNEL);
> 
> 
> What is the difference between num_possible_cpus() and nr_cpumask_bits actually?
> It looks like nr_cpumask_bits binds to NR_CPUS on early time and after
> it is set to
> num_possible_cpus() , right?
> In this case num_possible_cpus() seems more relevant...no?
> 
> (I'm pretty sure I'm wrong.... :-)
> 

I wanted to reference to nr_cpu_ids, not nr_cpumask_bits(I made mistake yesterday)

init/main.c
static void __init setup_nr_cpu_ids(void)
{
	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
}
setup_nr_cpu_ids() is called directly in main.c, it's earlier than early_initcall.

So nr_cpu_ids is better than num_possible_cpus(), for maybe cpu_possible_mask=101B
nr_cpu_ids=3, num_possible_cpus()=2, We will access to invalid memory when we use
num_possible_cpus().

but percpu data as my patch shows is better than nr_cpu_ids.

Thanks, Lai.



