Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZBIKSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZBIKSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZBIKRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:17:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZBIKRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:17:42 -0500
Date: Mon, 9 Feb 2009 11:17:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of
	2fdf66b491ac706657946442789ec644cc317e1a
Message-ID: <20090209101723.GH20467@elte.hu>
References: <200902071809.39175.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071809.39175.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Impact: fix powernow-k8 when acpi=off (or other error).
> 
> There was a spurious change introduced into powernow-k8 in this patch:
> the cause if that we try to "restore" the cpus_allowed we never saved.
> 
> See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
> acpi=off" from Yinghai for the bug report.
> 
> Cc: Mike Travis <travis@sgi.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -1142,8 +1142,7 @@ static int __cpuinit powernowk8_cpu_init
>  	data->cpu = pol->cpu;
>  	data->currpstate = HW_PSTATE_INVALID;
>  
> -	rc = powernow_k8_cpu_init_acpi(data);
> -	if (rc) {
> +	if (powernow_k8_cpu_init_acpi(data)) {
>  		/*
>  		 * Use the PSB BIOS structure. This is only availabe on
>  		 * an UP version, and is deprecated by AMD.
> @@ -1161,17 +1160,20 @@ static int __cpuinit powernowk8_cpu_init
>  			       "ACPI maintainers and complain to your BIOS "
>  			       "vendor.\n");
>  #endif
> -			goto err_out;
> +			kfree(data);
> +			return -ENODEV;
>  		}
>  		if (pol->cpu != 0) {
>  			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
>  			       "CPU other than CPU0. Complain to your BIOS "
>  			       "vendor.\n");
> -			goto err_out;
> +			kfree(data);
> +			return -ENODEV;
>  		}
>  		rc = find_psb_table(data);
>  		if (rc) {
> -			goto err_out;
> +			kfree(data);
> +			return -ENODEV;
>  		}

hm, why the 3-way duplication of this pattern:

> +			kfree(data);
> +			return -ENODEV;

because it's a straight revert?

	Ingo
