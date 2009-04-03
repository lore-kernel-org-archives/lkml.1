Return-Path: <linux-kernel-owner+w=401wt.eu-S934763AbZDCPRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763AbZDCPRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbZDCPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:16:52 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38693 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbZDCPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:16:51 -0400
Message-ID: <49D627E4.6070008@oracle.com>
Date: Fri, 03 Apr 2009 08:14:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/2] sched: Nominate idle load balancer from a semi-idle
 package.
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com> <20090402123829.14569.67639.stgit@sofia.in.ibm.com> <1238687531.3099.30.camel@ht.satnam> <20090403145924.GB9563@in.ibm.com>
In-Reply-To: <20090403145924.GB9563@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49D62800.0117:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> Hi Jaswinder,
> Thanks for the review. Comments interspersed.
> 
> 
> On Thu, Apr 02, 2009 at 09:22:11PM +0530, Jaswinder Singh Rajput wrote:
>> Here are some minor issues:
>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>> index 706517c..4fc1ec0 100644
>>> --- a/kernel/sched.c
>>> +++ b/kernel/sched.c
> 
>>>  } nohz ____cacheline_aligned = {
>>>  	.load_balancer = ATOMIC_INIT(-1),
>>>  };
>>>  
>>> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
>>> +/**
>> ^^^^^^
>> This comment is not valid and even Randy send patches to fix these
>> comments and also shared the error messages because of these comments by
>> your earlier patches. Replace it with /*
> 
> I think you're referring to this: http://lkml.org/lkml/2009/3/29/7
> I had missed this patch. Thanks for pointing it out.
> 
> I think Randy's patch was addressing the issue of structs
> not requiring a /** style comments. But in this case,
> it's a function, and hence needs kernel-doc style notation. Or am I
> missing something here ? Point about the single-line
> short function description is well taken.

If you want to use kernel-doc for functions or structs or unions
or enums, do so.  Just use the correct syntax, please.

If it's not kernel-doc, don't use /** to begin the comment block.


>>> + * lowest_flag_domain: Returns the lowest sched_domain
>>> + * that has the given flag set for a particular cpu.
>>> + * @cpu: The cpu whose lowest level of sched domain is to
>>> + * be returned.
>>> + *
>>> + * @flag: The flag to check for the lowest sched_domain
>>> + * for the given cpu
>>> + */
>>> +static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
>>> +{
>>> +	struct sched_domain *sd;
>>> +
>>> +	for_each_domain(cpu, sd)
>>> +		if (sd && (sd->flags & flag))
>>> +			break;
>>> +
>>> +	return sd;
>>> +}
>>> +
>>> +/**
>> Ditto.
>>
> 
> Ditto :-)
> 
>>> + * for_each_flag_domain: Iterates over all the scheduler domains
>>> + * for a given cpu that has the 'flag' set, starting from
>>> + * the lowest to the highest.
>>> + * @cpu: The cpu whose domains we're iterating over.
>>> + * @sd: variable holding the value of the power_savings_sd
>>> + * for cpu
>> This can be come in one line:
> Agreed. Will correct this.
> 
>> + * @sd: variable holding the value of the power_savings_sd for cpu
>>
>>> + */
>>> +#define for_each_flag_domain(cpu, sd, flag) \
>>> +	for (sd = lowest_flag_domain(cpu, flag); \
>>> +		(sd && (sd->flags & flag)); sd = sd->parent)
>>> +
>>> +static inline int is_semi_idle_group(struct sched_group *ilb_group)
>>> +{
>>> +	cpumask_and(nohz.tmpmask, nohz.cpu_mask, sched_group_cpus(ilb_group));
>>> +
>>> +	/*
>>> +	 * A sched_group is semi-idle when it has atleast one busy cpu
>>> +	 * and atleast one idle cpu.
>>> +	 */
>>> +	if (!(cpumask_empty(nohz.tmpmask) ||
>>> +		cpumask_equal(nohz.tmpmask, sched_group_cpus(ilb_group))))
>>> +		return 1;
>>> +
>>> +	return 0;
>>> +}
>>> +/**
>> Ditto.
>>
> 
> Ditto!
>>> + * find_new_ilb: Finds or nominates a new idle load balancer.
>>> + * @cpu: The cpu which is nominating a new idle_load_balancer.
>>> + *
>>> + * This algorithm picks the idle load balancer such that it belongs to a
>>> + * semi-idle powersavings sched_domain. The idea is to try and avoid
>>> + * completely idle packages/cores just for the purpose of idle load balancing
>>> + * when there are other idle cpu's which are better suited for that job.
>>> + */
>>> +static int find_new_ilb(int cpu)


-- 
~Randy
