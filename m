Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZKLVUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZKLVUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZKLVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:20:17 -0500
Received: from relay1.sgi.com ([192.48.179.29]:47417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754163AbZKLVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:20:16 -0500
Message-ID: <4AFC7C11.1090701@sgi.com>
Date: Thu, 12 Nov 2009 13:20:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] INIT: Limit the number of per cpu INIT bootup messages
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112172006.809683000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121303261.13943@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0911121303261.13943@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, yes I agree, too much cut and paste.  Will update. -thanks!

David Rientjes wrote:
> On Thu, 12 Nov 2009, Mike Travis wrote:
> 
>> Limit the number of per cpu INIT messages when system is booting to
>> prevent clogging up the console output with repetitious messages.
>>
> 
> Needs a better changelog.  What did you do to effect that change?  It 
> looks like you're only emitting certain messages from the boot cpu.
> 
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  init/calibrate.c |   22 +++++++++++++---------
>>  kernel/cpu.c     |    5 ++---
>>  2 files changed, 15 insertions(+), 12 deletions(-)
>>
>> --- linux.orig/init/calibrate.c
>> +++ linux/init/calibrate.c
>> @@ -123,23 +123,26 @@
>>  {
>>  	unsigned long ticks, loopbit;
>>  	int lps_precision = LPS_PREC;
>> +	bool boot_cpu = (smp_processor_id() == 0);
>>  
>>  	if (preset_lpj) {
>>  		loops_per_jiffy = preset_lpj;
>> -		printk(KERN_INFO
>> -			"Calibrating delay loop (skipped) preset value.. ");
>> -	} else if ((smp_processor_id() == 0) && lpj_fine) {
>> +		if (boot_cpu)
>> +			pr_info("Calibrating delay loop (skipped) "
>> +				"preset value.. ");
> 
> Same comment as before about breaking printk strings into multiple lines 
> when not broken at '\n'.  All the other patches your series look good 
> after this, however.
> 
>> +	} else if ((boot_cpu) && lpj_fine) {
> 
> Parentheses around boot_cpu?
> 
>>  		loops_per_jiffy = lpj_fine;
>> -		printk(KERN_INFO
>> -			"Calibrating delay loop (skipped), "
>> +		pr_info("Calibrating delay loop (skipped), "
>>  			"value calculated using timer frequency.. ");
>>  	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
>> -		printk(KERN_INFO
>> -			"Calibrating delay using timer specific routine.. ");
>> +		if (boot_cpu)
>> +			pr_info("Calibrating delay using timer "
>> +				"specific routine.. ");
>>  	} else {
>>  		loops_per_jiffy = (1<<12);
>>  
>> -		printk(KERN_INFO "Calibrating delay loop... ");
>> +		if (boot_cpu)
>> +			pr_info("Calibrating delay loop... ");
>>  		while ((loops_per_jiffy <<= 1) != 0) {
>>  			/* wait for "start of" clock tick */
>>  			ticks = jiffies;
>> @@ -170,7 +173,8 @@
>>  				loops_per_jiffy &= ~loopbit;
>>  		}
>>  	}
>> -	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
>> +	if (boot_cpu)
>> +		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
>>  			loops_per_jiffy/(500000/HZ),
>>  			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
>>  }
>> --- linux.orig/kernel/cpu.c
>> +++ linux/kernel/cpu.c
>> @@ -392,10 +392,9 @@
>>  		if (cpu == first_cpu)
>>  			continue;
>>  		error = _cpu_down(cpu, 1);
>> -		if (!error) {
>> +		if (!error)
>>  			cpumask_set_cpu(cpu, frozen_cpus);
>> -			printk("CPU%d is down\n", cpu);
>> -		} else {
>> +		else {
>>  			printk(KERN_ERR "Error taking CPU%d down: %d\n",
>>  				cpu, error);
>>  			break;
