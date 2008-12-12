Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYLLLlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYLLLlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYLLLlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:41:44 -0500
Received: from ozlabs.org ([203.10.76.45]:55182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYLLLlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:41:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit as well as restrict the limit
Date: Fri, 12 Dec 2008 22:11:35 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.004085000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081211112807.004085000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812122211.36590.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 21:58:09 Mike Travis wrote:
> Impact: allow adding additional cpus.
> 
> Use maxcpus=NUM kernel parameter to extend the number of possible cpus as well
> as (currently) limit them.  Any cpus >= number of present cpus will disabled.
...

These two bits of logic are very similar: can we merge them?

> -	possible = num_processors + disabled_cpus;
> -	if (possible > NR_CPUS)
> -		possible = NR_CPUS;
> +	if (setup_max_cpus == -1)	/* not specified */
> +		possible = num_processors + disabled_cpus;
> +	else if (setup_max_cpus == 0)	/* UP mode forced */
> +		possible = 1;
> +	else				/* user specified */
> +		possible = setup_max_cpus;
> +
> +	if (possible > CONFIG_NR_CPUS) {
> +		printk(KERN_WARNING
> +			"%d Processors exceeds NR_CPUS limit of %d\n",
> +			possible, CONFIG_NR_CPUS);
> +		possible = CONFIG_NR_CPUS;
> +	}
...
> -extern unsigned int setup_max_cpus;
> +extern int setup_max_cpus;
> +static inline int maxcpus(void)
> +{
> +	int maxcpus = setup_max_cpus;
> +
> +	if (maxcpus == -1 || maxcpus > CONFIG_NR_CPUS)
> +		maxcpus = CONFIG_NR_CPUS;
> +	else if (maxcpus == 0)
> +		maxcpus = 1;
> +
> +	return maxcpus;
> +}

If this didn't trunacte to CONFIG_NR_CPUS, it could still be used here:

> @@ -425,7 +423,7 @@ static void __init smp_init(void)
>  
>  	/* FIXME: This should be done in userspace --RR */
>  	for_each_present_cpu(cpu) {
> -		if (num_online_cpus() >= setup_max_cpus)
> +		if (num_online_cpus() >= maxcpus())
>  			break;
>  		if (!cpu_online(cpu))
>  			cpu_up(cpu);

And it turns out noone actually uses the smp_cpus_done() arg, so
I don't know what the semantics are supposed to be.

> @@ -433,7 +431,7 @@ static void __init smp_init(void)
>  
>  	/* Any cleanup work */
>  	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
> -	smp_cpus_done(setup_max_cpus);
> +	smp_cpus_done(maxcpus());

Cheers,
Rusty.
