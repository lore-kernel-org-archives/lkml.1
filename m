Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZE0Eb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZE0Eb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZE0Ebq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:31:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44356 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZE0Ebp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:31:45 -0400
Message-ID: <4A1CC228.9070404@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:31:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/31] x86: MCE: Print header/footer only once for multiple
 MCEs
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com> <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com> <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com> <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com> <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com> <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com> <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com> <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com> <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com> <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com> <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com> <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com
 >
In-Reply-To: <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When multiple MCEs are printed print the "HARDWARE ERROR" header
> and "This is not a software error" footer only once. This
> makes the output much more compact with many CPUs.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 8c55c86..94dddc7 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -176,11 +176,13 @@ void mce_log(struct mce *mce)
>  	set_bit(0, &notify_user);
>  }
>  
> -static void print_mce(struct mce *m)
> +static void print_mce(struct mce *m, int *first)
>  {
> -	printk(KERN_EMERG "\n"
> -	       KERN_EMERG "HARDWARE ERROR\n"
> -	       KERN_EMERG
> +	if (*first) {
> +		printk(KERN_EMERG "\n" KERN_EMERG "HARDWARE ERROR\n");
> +		*first = 0;
> +	}
> +	printk(KERN_EMERG
>  	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
>  	       m->extcpu, m->mcgstatus, m->bank, m->status);
>  	if (m->ip) {

Why don't you have print_mce_head?

I suppose one possible benefit not to have it and do like this is that we
can suppress printing header if there is no log to print.
But on the other hand footer is always printed.

> @@ -200,9 +202,12 @@ static void print_mce(struct mce *m)
>  	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
>  			m->cpuvendor, m->cpuid, m->time, m->socketid,
>  			m->apicid);
> -	printk(KERN_EMERG "This is not a software problem!\n");
> -	printk(KERN_EMERG "Run through mcelog --ascii to decode "
> -	       "and contact your hardware vendor\n");
> +}
> +
> +static void print_mce_tail(void)
> +{
> +	printk(KERN_EMERG "This is not a software problem!\n"
> +	       KERN_EMERG "Run through mcelog --ascii to decode and contact your hardware vendor\n");
>  }
>  
>  #define PANIC_TIMEOUT 5 /* 5 seconds */

And if there is no log, do we still need to run mcelog?

> @@ -225,6 +230,7 @@ static void wait_for_panic(void)
>  static void mce_panic(char *msg, struct mce *final, char *exp)
>  {
>  	int i;
> +	int first = 1;
>  
>  	/*
>  	 * Make sure only one CPU runs in machine check panic
> @@ -240,7 +246,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  		struct mce *m = &mcelog.entry[i];
>  		if ((m->status & MCI_STATUS_VAL) &&
>  			!(m->status & MCI_STATUS_UC))
> -			print_mce(m);
> +			print_mce(m, &first);
>  	}
>  	/* Now print uncorrected but with the final one last */
>  	for (i = 0; i < MCE_LOG_LEN; i++) {
> @@ -248,12 +254,13 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  		if (!(m->status & MCI_STATUS_VAL))
>  			continue;
>  		if (!final || memcmp(m, final, sizeof(struct mce)))
> -			print_mce(m);
> +			print_mce(m, &first);
>  	}
>  	if (final)
> -		print_mce(final);
> +		print_mce(final, &first);
>  	if (cpu_missing)
>  		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
> +	print_mce_tail();
>  	if (exp)
>  		printk(KERN_EMERG "Machine check: %s\n", exp);
>  	if (mce_panic_timeout < panic_timeout)

If mce_panic is only caller of mce_log_tail (and possible mce_log_head),
it would be better to use printk directly than having such sub-function.


Thanks,
H.Seto

