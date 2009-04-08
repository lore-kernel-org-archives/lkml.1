Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZDHDoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZDHDoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZDHDoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:44:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58792 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDHDoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:44:07 -0400
Message-ID: <49DC1D7E.4010802@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 12:43:58 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU
References: <20090407506.675031434@firstfloor.org> <20090407150654.071D21D046E@basil.firstfloor.org>
In-Reply-To: <20090407150654.071D21D046E@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Impact: bug fix
> 
> The polling timer while running per CPU still uses a global next_interval
> variable, which lead to some CPUs either polling too fast or too slow.
> This was not a serious problem because all errors get picked up eventually,
> but it's still better to avoid it. Turn next_interval into a per cpu variable.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:57.000000000 +0200
> +++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:16.000000000 +0200
> @@ -452,13 +452,14 @@
>   */
>  
>  static int check_interval = 5 * 60; /* 5 minutes */
> -static int next_interval; /* in jiffies */
> +static DEFINE_PER_CPU(int, next_interval); /* in jiffies */
>  static void mcheck_timer(unsigned long);
>  static DEFINE_PER_CPU(struct timer_list, mce_timer);
>  
>  static void mcheck_timer(unsigned long data)
>  {
>  	struct timer_list *t = &per_cpu(mce_timer, data);
> +	int *n;
>  
>  	WARN_ON(smp_processor_id() != data);
>  
> @@ -470,14 +471,14 @@
>  	 * Alert userspace if needed.  If we logged an MCE, reduce the
>  	 * polling interval, otherwise increase the polling interval.
>  	 */
> +	n = &__get_cpu_var(next_interval);
>  	if (mce_notify_user()) {
> -		next_interval = max(next_interval/2, HZ/100);
> +		*n = max(*n/2, HZ/100);
>  	} else {
> -		next_interval = min(next_interval * 2,
> -				(int)round_jiffies_relative(check_interval*HZ));
> +		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
>  	}
>  
> -	t->expires = jiffies + next_interval;
> +	t->expires = jiffies + *n;
>  	add_timer(t);
>  }
>  
> @@ -632,14 +633,14 @@
>  static void mce_init_timer(void)
>  {
>  	struct timer_list *t = &__get_cpu_var(mce_timer);
> +	int *n = &__get_cpu_var(next_interval);
>  
> -	/* data race harmless because everyone sets to the same value */
> -	if (!next_interval)
> -		next_interval = check_interval * HZ;
> -	if (!next_interval)

[plan A]
Add
	if (!check_interval)
		return;

Or...

> +	if (!*n)
> +		*n = check_interval * HZ;
> +	if (!*n)
>  		return;
>  	setup_timer(t, mcheck_timer, smp_processor_id());
> -	t->expires = round_jiffies(jiffies + next_interval);
> +	t->expires = round_jiffies(jiffies + *n);
>  	add_timer(t);
>  }
>  
> @@ -907,7 +908,6 @@
>  /* Reinit MCEs after user configuration changes */
>  static void mce_restart(void)
>  {
> -	next_interval = check_interval * HZ;
>  	on_each_cpu(mce_cpu_restart, NULL, 1);
>  }
>  

[plan B]
Don't remove this line.

Take A or B, or we cannot stop polling timer by setting check_interval
to 0 via sysfs and then the timer will spin with 0 interval.


Thanks,
H.Seto

> @@ -1110,7 +1110,8 @@
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> -		t->expires = round_jiffies(jiffies + next_interval);
> +		t->expires = round_jiffies(jiffies +
> +						__get_cpu_var(next_interval));
>  		add_timer_on(t, cpu);
>  		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
>  		break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
