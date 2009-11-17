Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZKQRQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZKQRQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZKQRQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:16:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37195 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754610AbZKQRQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:16:02 -0500
Message-ID: <4B02DA52.1080407@sgi.com>
Date: Tue, 17 Nov 2009 09:16:02 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: Limit the number of per cpu MCE bootup messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210727.456553000@alcatraz.americas.sgi.com> <20091116212251.GB2221@elte.hu> <4B01C59A.9050507@sgi.com> <4B024C76.9050005@jp.fujitsu.com>
In-Reply-To: <4B024C76.9050005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hidetoshi Seto wrote:
> Mike Travis wrote:
>>
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>
>>>> @@ -83,6 +86,7 @@
>>>>      unsigned long flags;
>>>>      int hdr = 0;
>>>>      int i;
>>>> +    char buf[120];
>>> that constant is not particularly nice, is it?
>>>
>>>     Ingo
>> I'm up for suggestions.  I just noticed that during testing, the
>> MCE Banks messages overflowed 80 chars but I didn't actually
>> check to see what the longest might be.
>>
>> Should I trim it to 80?  Or use a different constant?
> 
> I think you could calculate the size using MAX_NR_BANKS.
> 
> But I'd like to change the format to shorter one at same time, 
> So how about the following?
> 
> 
> Thanks,
> H.Seto
> 
> ===
> 
> [PATCH] x86, mce: rework output of MCE banks ownership information
> 
> The output of MCE banks ownership information on boot tend
> to be long on new processor which has many banks:
> 
>   CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
> 
> This message can fill up the console output when the number
> of cpus is large.
> 
> This patch suppress this info message on boot, and introduce
> debug message in shorter format instead, like:
> 
>   CPU 1 MCE banks map: ssCC PCss ssPP ssss ssss ss
> 
>   where: s: shared, C: checked by cmci, P: checked by poll.
> 
> This patch still keep the info when ownership is updated.
> E.g. if a cpu take over the ownership from hot-removed cpu,
> both message will be shown:
> 
>   CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
>   CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss
> 
> v2:
>   - stop changing the level of message on update
>   - change the number of banks message on boot to debug level
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c       |    6 +++---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   29 +++++++++++++++++++++++------
>  2 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 5f277ca..8627976 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1229,11 +1229,11 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
>  
>  	b = cap & MCG_BANKCNT_MASK;
>  	if (!banks)
> -		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
> +		pr_debug("mce: CPU supports %d MCE banks\n", b);
>  
>  	if (b > MAX_NR_BANKS) {
> -		printk(KERN_WARNING
> -		       "MCE: Using only %u machine check banks out of %u\n",
> +		pr_warning(
> +			"MCE: Using only %u machine check banks out of %u\n",
>  			MAX_NR_BANKS, b);
>  		b = MAX_NR_BANKS;
>  	}
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 7c78563..448a38b 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -64,12 +64,25 @@ static void intel_threshold_interrupt(void)
>  	mce_notify_irq();
>  }
>  
> +static void print_banks_map(int banks)
> +{
> +	int i;
> +
> +	pr_debug("CPU %d MCE banks map:", smp_processor_id());
> +	for (i = 0; i < banks; i++) {
> +		pr_cont("%s%s", (i % 4) ? "" : " ",
> +			test_bit(i, __get_cpu_var(mce_banks_owned)) ? "C" :
> +			test_bit(i, __get_cpu_var(mce_poll_banks)) ? "P" : "s");
> +	}
> +	pr_cont("\n");

The problem here is that if pr_debug is not in effect, then the pr_cont("\n")
outputs a newline in the middle of other messages.  I had introduced a new
macro (pr_debug_cont) but it was just as easy to buffer the message and then
print the entire thing with pr_debug().

I think pr_cont() should be reserved for when you actually want a partial
line printed before the end of the line, and not a means to stitch together
a complete line, but I may be in the minority.

This might also be another candidate for printing the needed information via
/sys or /proc ... in which case as Ingo has pointed out, the debug bootup
messages should be simple even to the point of voluminous, and the reports
compacted. 

> +}
> +
>  static void print_update(char *type, int *hdr, int num)
>  {
>  	if (*hdr == 0)
> -		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
> +		pr_info("CPU %d MCE banks map updated:", smp_processor_id());
>  	*hdr = 1;
> -	printk(KERN_CONT " %s:%d", type, num);
> +	pr_cont(" %s:%d", type, num);
>  }
>  
>  /*
> @@ -85,6 +98,7 @@ static void cmci_discover(int banks, int boot)
>  	int i;
>  
>  	spin_lock_irqsave(&cmci_discover_lock, flags);
> +
>  	for (i = 0; i < banks; i++) {
>  		u64 val;
>  
> @@ -95,7 +109,7 @@ static void cmci_discover(int banks, int boot)
>  
>  		/* Already owned by someone else? */
>  		if (val & CMCI_EN) {
> -			if (test_and_clear_bit(i, owned) || boot)
> +			if (test_and_clear_bit(i, owned) && !boot)
>  				print_update("SHD", &hdr, i);
>  			__clear_bit(i, __get_cpu_var(mce_poll_banks));
>  			continue;
> @@ -107,16 +121,19 @@ static void cmci_discover(int banks, int boot)
>  
>  		/* Did the enable bit stick? -- the bank supports CMCI */
>  		if (val & CMCI_EN) {
> -			if (!test_and_set_bit(i, owned) || boot)
> +			if (!test_and_set_bit(i, owned) && !boot)
>  				print_update("CMCI", &hdr, i);
>  			__clear_bit(i, __get_cpu_var(mce_poll_banks));
>  		} else {
>  			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
>  		}
>  	}
> -	spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  	if (hdr)
> -		printk(KERN_CONT "\n");
> +		pr_cont("\n");

Here again an extraneous newline will be printed in the middle of other messages.

> +	if (hdr || boot)
> +		print_banks_map(banks);
> +
> +	spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  }
>  
>  /*
