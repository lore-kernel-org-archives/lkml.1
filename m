Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZI1IDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZI1IDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZI1IDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:03:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45340 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZI1IDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:03:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC06D96.4000508@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 17:02:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v2] x86, mce, inject: Make injected mce valid only during
 faked handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC05A57.1080505@jp.fujitsu.com> <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
>>> mce.finished is enabled only during faked MCE handler call and
>>> protected by IRQ disabling. This make it impossible for real
>>> machine_check_poll to consume it.
>> Are there the reverse case - is it possible that the faked handler
>> call might consume real error which is not handled yet by the real
>> machine_check_poll?
> 
> Yes. It's possible at least in theory. But whole mce-inject.c is used
> for testing only. The faked handler call will not occur on real system.

Just I concerned that it may confuse the mce test suite.

>>> +#define MCJ_LOADED		(1 << MCJ_LOADED_BIT)
>> I'd like to see a patch to replace MCJ_* to MCE_INJ_* before
>> adding new flag.
> 
> MCX_ prefix is the naming convention used all over the mce.h, such as
> MCG_, MCI_, MCM_, if we want to change MCJ_ into MCE_INJ_, we should
> consider changing all these into similar style to keep consistent. 

That is bad naming convention, isn't it?
I don't mind considering changing all those.

>> Why
>>   clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
>>   set_bit(MCJ_LOADED_BIT, (unsigned long *)&i->inject_flags);
>> cannot be
>>   m->inject_flags &= ~MCJ_LOADED;
>>   m->inject_flags |= MCJ_LOADED;
>> ?
> 
> Because they may be write on one CPU and read on another CPU, atomic
> operation is safer for this.

I think such read should not happen while write is on flight.
We already have many barriers all around.

>> I think the "finished" is not good name. (I suppose it is named
>> after "loading data to structure have been finished" or so.)
> 
> No. Its name is not invented for injecting. It stands for the MCE record
> writing to mce log buffer has finished. That is, it is named according
> to normal path, not testing path.

I know it.
I just point that there is a bad name since early times.

>> I believe what you want to do here is "make mce_rdmsrl()/mce_wrmsrl()
>> to refer faked data only during faked handler call."
>> Then what we have to do is making a flag to indicate that "now
>> in faked handler call," for an example:
>>
>>     309         if (__get_cpu_var(mce_fake_in_progress)) {
>>
>> and:
>> 	local_irq_save(flags);
>> 	__get_cpu_var(mce_fake_in_progress) = 1;
>> 	machine_check_poll(0, &b);
>> 	__get_cpu_var(mce_fake_in_progress) = 0;
>> 	local_irq_restore(flags);
> 
> I don't think this method is better than the original one. They are just
> equivalent. 

No, you changed usage of .finished, and transfer the functionality of the
flag to newly introduced MCJ_LOADED.
We can keep .finished as is, and introduce one new flag for this.

>>>  static void raise_exception(struct mce *m, struct pt_regs *pregs)
>>> @@ -69,9 +71,11 @@ static void raise_exception(struct mce *
>>>  	}
>>>  	/* in mcheck exeception handler, irq will be disabled */
>>>  	local_irq_save(flags);
>>> +	m->finished = 1;
>>>  	do_machine_check(pregs, 0);
>>> -	local_irq_restore(flags);
>>>  	m->finished = 0;
>>> +	clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
>>> +	local_irq_restore(flags);
>>>  }
>>>  
>>>  static cpumask_t mce_inject_cpumask;
>>> @@ -89,6 +93,8 @@ static int mce_raise_notify(struct notif
>>>  		raise_exception(m, args->regs);
>>>  	else if (m->status)
>>>  		raise_poll(m);
>>> +	else
>>> +		clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
>>>  	return NOTIFY_STOP;
>>>  }
>>>  
>>> @@ -129,7 +135,7 @@ static int raise_local(void)
>>>  		mce_notify_irq();
>>>  		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
>>>  	} else
>>> -		m->finished = 0;
>>> +		clear_bit(MCJ_LOADED_BIT, (unsigned long *)&m->inject_flags);
>>>  
>>>  	return ret;
>>>  }
>>> @@ -152,10 +158,13 @@ static void raise_mce(struct mce *m)
>>>  		cpu_clear(get_cpu(), mce_inject_cpumask);
>>>  		for_each_online_cpu(cpu) {
>>>  			struct mce *mcpu = &per_cpu(injectm, cpu);
>>> -			if (!mcpu->finished ||
>>> +			if (!test_bit(MCJ_LOADED_BIT,
>>> +				      (unsigned long *)&mcpu->inject_flags) ||
>>>  			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
>>>  				cpu_clear(cpu, mce_inject_cpumask);
>>>  		}
>>> +		/* make sure needed data is available on other CPUs */
>>> +		smp_mb();
>> What data are you taking care here for?
> 
> For mce_inject_cpumask.

OK, it seems fair enough.
I'd like to see this change in a separate patch with proper description.


Thanks,
H.Seto


