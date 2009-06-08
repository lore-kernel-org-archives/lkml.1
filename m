Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZFHBSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZFHBSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFHBR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:17:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54975 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZFHBR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:17:58 -0400
Message-ID: <4A2C66BF.5000401@jp.fujitsu.com>
Date: Mon, 08 Jun 2009 10:17:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>	 <4A28C2E2.4090309@jp.fujitsu.com>	 <1244189284.8361.514.camel@yhuang-dev.sh.intel.com>	 <4A28D738.8010202@jp.fujitsu.com> <1244191174.8361.517.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244191174.8361.517.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-06-05 at 16:28 +0800, Hidetoshi Seto wrote:
>> Huang Ying wrote:
>>> On Fri, 2009-06-05 at 15:01 +0800, Hidetoshi Seto wrote:
>>>> Huang Ying wrote:
>>>>>  struct mce_log {
>>>>> -	char signature[12]; /* "MACHINECHECK" */
>>>>> +	char signature[12]; /* "MACHINECHEC2" */
>>>>>  	unsigned len;	    /* = MCE_LOG_LEN */
>>>>> -	unsigned next;
>>>>>  	unsigned flags;
>>>>>  	unsigned pad0;
>>>>> -	struct mce entry[MCE_LOG_LEN];
>>>>> +	struct mce_log_cpu *mcelog_cpus;
>>>>>  };
>>>> What is this *mcelog_cpus to be used for?
>>>> It seems it will point one of per-CPU buffers (maybe cpu#0's buffer)
>>>> if I have read the following mce_log_init() correctly.
>>> It is mainly used by something like kdump, which can search
>>> "MACHINECHEC2", and analyze mce_log. mcelog_cpus can help kdump find the
>>> real mcelog storage.
>> Hum, but it help tools only to find one of buffers, not to find all.
>>
>> I think it would be better help for tools if we have another signature
>> on struct mce_log_cpu, e.g.: 
>>
>>  +struct mce_log_cpu {
>> + 	char signature[**];	/* "MCE_LOG_CPU_VER_1" or so */
>> +	__u32 cpuid;		/* cpuid or extcpu, same as struct mce */
>>  +	int head;
>>  +	int tail;
>>  +	unsigned long flags;
>>  +	struct mce entry[MCE_LOG_LEN];
>>  +};
>>
>> How about this?
> 
> +	mcelog.mcelog_cpus = &per_cpu_var(mce_log_cpus);
> 
> So mcelog.mcelog_cpus are pointed to the buffers of all CPUs, not just
> that of one CPU. You can find them by analyzing PER cpu data structure.

I thought that the signature is used to find the structure without such
analyzing.  If a tool can analyze PER cpu data, then it likely know
where the mce_log_cpu is, so mcelog.mcelog_cpus will not be required.

#define per_cpu_var(var) per_cpu__##var

#define per_cpu(var, cpu) \
        (*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))

OK, I have mistook per_cpu_var() for per_cpu(). 
Then mcelog.mcelog_cpus does not point any of the buffers, but tells where
the buffer is locating in each of PER cpu data.
Tools have to get per_cpu_offset(cpu) to know where the PER cpu data
allocated.  According to pcpu_alloc_bootmem(), it might consider NUMA.
Anyway It will take a bit more effort.

So still I think the mcelog.mcelog_cpus is mostly pointless.


Thanks,
H.Seto

