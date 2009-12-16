Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbZLPDQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbZLPDQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbZLPDQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:16:08 -0500
Received: from relay3.sgi.com ([192.48.152.1]:32836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755137AbZLPDQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:16:04 -0500
Message-ID: <4B2850E9.3070605@sgi.com>
Date: Tue, 15 Dec 2009 19:15:53 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: rework output of MCE banks ownership information
References: <4B26EBB0.3090507@jp.fujitsu.com> <4B27DFE9.2030308@sgi.com> <4B284C01.70307@jp.fujitsu.com>
In-Reply-To: <4B284C01.70307@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right, I did not notice the inversion of the boot
flag.  I tested your latest on a UV system and it appears
to work fine.

You can add my Ack.

Thanks!
Mike


Hidetoshi Seto wrote:
> (2009/12/16 4:13), Mike Travis wrote:
>> Hidetoshi Seto wrote:
>>> The output of MCE banks ownership information on boot tend
>>> to be long on new processor which has many banks:
>>>
>>>   CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>>>
>>> This message can fill up the console output when the number
>>> of cpus is large.
>>>
>>> This patch suppress this info message on boot, and introduce
>>> debug message in shorter format instead, like:
>>>
>>>   CPU 1 MCE banks map: ssCC PCss ssPP ssss ssss ss
>>>
>>>   where: s: shared, C: checked by cmci, P: checked by poll.
>>>
>>> This patch still keep the info when ownership is updated.
>>> E.g. when a cpu take over the ownership from hot-removed cpu,
>>> both message will be shown:
>>>
>>>   CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
>>>   CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss
>>>
>>> v2:
>>>   - stop changing the level of message on update
>>>   - change the number of banks message on boot to debug level
>>>
>>> v3:
>>>   - avoid use of pr_cont with pr_debug in print_banks_map()
>>>
>>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>>> Cc: Mike Travis <travis@sgi.com>
>>> ---
>>>  arch/x86/kernel/cpu/mcheck/mce.c       |    6 +++---
>>>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   30 ++++++++++++++++++++++++------
>>>  2 files changed, 27 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>>> index a8aacd4..8d6afea 100644
>>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>>> @@ -1229,11 +1229,11 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
>>>  
>>>  	b = cap & MCG_BANKCNT_MASK;
>>>  	if (!banks)
>>> -		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
>>> +		pr_debug("mce: CPU supports %d MCE banks\n", b);
>>>  
>>>  	if (b > MAX_NR_BANKS) {
>>> -		printk(KERN_WARNING
>>> -		       "MCE: Using only %u machine check banks out of %u\n",
>>> +		pr_warning(
>>> +			"MCE: Using only %u machine check banks out of %u\n",
>>>  			MAX_NR_BANKS, b);
>>>  		b = MAX_NR_BANKS;
>>>  	}
>>> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>>> index 7c78563..234e473 100644
>>> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
>>> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>>> @@ -64,12 +64,26 @@ static void intel_threshold_interrupt(void)
>>>  	mce_notify_irq();
>>>  }
>>>  
>>> +static void print_banks_map(int banks)
>>> +{
>>> +	char buf[32 + MAX_NR_BANKS * 5 / 4]; /* 72 if MAX_NR_BANKS == 32 */
>>> +	int i, n, ln = sizeof(buf);
>>> +
>>> +	n = snprintf(buf, ln, "CPU %d MCE banks map:", smp_processor_id());
>>> +	for (i = 0; i < banks; i++) {
>>> +		n += snprintf(&buf[n], ln - n, "%s%s", (i % 4) ? "" : " ",
>>> +			test_bit(i, __get_cpu_var(mce_banks_owned)) ? "C" :
>>> +			test_bit(i, __get_cpu_var(mce_poll_banks)) ? "P" : "s");
>>> +	}
>>> +	pr_debug("%s\n", buf);
>>> +}
>>> +
>>>  static void print_update(char *type, int *hdr, int num)
>>>  {
>>>  	if (*hdr == 0)
>>> -		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
>>> +		pr_info("CPU %d MCE banks map updated:", smp_processor_id());
>>>  	*hdr = 1;
>>> -	printk(KERN_CONT " %s:%d", type, num);
>>> +	pr_cont(" %s:%d", type, num);
>> This pr_cont will cause problems.  If debug printout is not enabled then
>> the "%s:%d" will be interspersed with the output of the "Booting processors"
>> line.
> 
> As I described in the patch description, my patch modified cmci_discover()
> not to call this print_update() while boot.  Now this print_update() is
> only called on hotplug events, never be called on boot.
> 
> And the level of message here is still info, so use of pr_cont with pr_info
> have no problem because it is not with pr_debug.
> 
> OTOH print_banks_map() is called on boot, but it does not use pr_cont().
> 
>> Ideally the output looks like:
>>
>> [    2.100837] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
>> [    2.614888] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
>> [    3.196690] Booting Node   2, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
>> [    3.777600] Booting Node   3, Processors  #24 #25 #26 #27 #28 #29 #30 #31 Ok.
>> [    4.359413] Booting Node   0, Processors  #32 #33 #34 #35 #36 #37 #38 #39 Ok.
>> [    4.940339] Booting Node   1, Processors  #40 #41 #42 #43 #44 #45 #46 #47 Ok.
>> [    5.522072] Booting Node   2, Processors  #48 #49 #50 #51 #52 #53 #54 #55 Ok.
>> [    6.106016] Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
>>
>> Currently the output looks like:
>>
>>
>> [    0.722553] Booting Node   0, Processors  #1
>> [    0.811625] CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    0.812071]  #2
>> [    0.907468] CPU 2 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    0.907918]  #3
>> [    1.003311] CPU 3 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    1.003750]  #4
>> [    1.099154] CPU 4 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    1.099550]  #5
>> [    1.194995] CPU 5 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    1.195375]  #6
>> [    1.290837] CPU 6 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    1.291284]  #7
>> [    1.386680] CPU 7 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
>> [    1.387162]  Ok.
>> [    1.404836] Booting Node   1, Processors  #8
>> [    1.490509] CPU 8 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:7 CMCI:8 CMCI:9 CMCI:12 CMCI:13 CMCI:14 CMCI:15 CMCI:16 CMCI:17 CMCI:18 CMCI:19 CMCI:20 CMCI:21
>> [    1.490942]  #9
>> [    1.590350] CPU 9 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
> 
> What wrong happen if my patch applied?
> Why your change on print_update() is needed?
> 
>>>  }
>>>  
>>>  /*
>>> @@ -85,6 +99,7 @@ static void cmci_discover(int banks, int boot)
>>>  	int i;
>>>  
>>>  	spin_lock_irqsave(&cmci_discover_lock, flags);
>>> +
>>>  	for (i = 0; i < banks; i++) {
>>>  		u64 val;
>>>  
>>> @@ -95,7 +110,7 @@ static void cmci_discover(int banks, int boot)
>>>  
>>>  		/* Already owned by someone else? */
>>>  		if (val & CMCI_EN) {
>>> -			if (test_and_clear_bit(i, owned) || boot)
>>> +			if (test_and_clear_bit(i, owned) && !boot)
>>>  				print_update("SHD", &hdr, i);
>>>  			__clear_bit(i, __get_cpu_var(mce_poll_banks));
>>>  			continue;
>>> @@ -107,16 +122,19 @@ static void cmci_discover(int banks, int boot)
>>>  
>>>  		/* Did the enable bit stick? -- the bank supports CMCI */
>>>  		if (val & CMCI_EN) {
>>> -			if (!test_and_set_bit(i, owned) || boot)
>>> +			if (!test_and_set_bit(i, owned) && !boot)
>>>  				print_update("CMCI", &hdr, i);
>>>  			__clear_bit(i, __get_cpu_var(mce_poll_banks));
>>>  		} else {
>>>  			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
>>>  		}
>>>  	}
>>> -	spin_unlock_irqrestore(&cmci_discover_lock, flags);
>>>  	if (hdr)
>>> -		printk(KERN_CONT "\n");
>>> +		pr_cont("\n");
>>> +	if (hdr || boot)
>>> +		print_banks_map(banks);
>>> +
>>> +	spin_unlock_irqrestore(&cmci_discover_lock, flags);
>>>  }
>>>  
>>>  /*
>> The real question to ask here is if this output really adds anything to
>> system bringup?  If it's informational only, then it should be available
>> online after the system is booted.  If it can be attached to an error,
>> then the information should only be printed in the case of that error.
>> Removing from the console log informational only ("chatty") type output
>> is the goal of this patch series.
>>
>> Thanks,
>> Mike
> 
> It will be hard for kernel to determine whether the status is error or
> not, without something like processor hardware specification catalog etc.
> 
> Maybe we could have alternative way to access the information in future,
> e.g. sysfs.  And then we could get rid of the debug message.
> 
> 
> Thanks,
> H.Seto
