Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZJ2QAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZJ2QAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZJ2QAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:00:43 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57454 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752836AbZJ2QAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:00:42 -0400
Message-ID: <4AE9BC26.80503@sgi.com>
Date: Thu, 29 Oct 2009 09:00:38 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership information
References: <4AE90E43.2030709@jp.fujitsu.com>
In-Reply-To: <4AE90E43.2030709@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if this applies here, but one thing I've been doing is
to mark the msg level as DEBUG if system_state == SYSTEM_BOOTING
(which is where all the noise comes from), and INFO if the system
is running.  This way hotplug events are logged on the console.

Hidetoshi Seto wrote:
> The output of MCE banks ownership information on boot tend to be long on
> new processor which has many banks:
> 
>   CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
> 
> This patch changes this message to shorter format, in lower message level
> (KERN_INFO -> KERN_DEBUG), and replace "MCA" by "MCE":
> 
>   CPU 1 MCE banks map: ssCC PCss ssPP ssss ssss ss
> 
> where: s: shared, C: checked by CMCI, P: checked by poll.
> 
> (NOTE: This patch still use old format on the output when ownership is
>        updated, e.g. a cpu take over the ownership from hot-removed cpu.
> 
>   CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
>   CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss
> )
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |   29 +++++++++++++++++++++++------
>  1 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 7c78563..2b4c78b 100644
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
> +}
> +
>  static void print_update(char *type, int *hdr, int num)
>  {
>  	if (*hdr == 0)
> -		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
> +		pr_debug("CPU %d MCE banks map updated:", smp_processor_id());
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
> +	if (boot || hdr)
> +		print_banks_map(banks);
> +
> +	spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  }
>  
>  /*
