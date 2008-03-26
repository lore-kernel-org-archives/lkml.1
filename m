Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYCZGu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYCZGu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYCZGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:50:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYCZGuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:50:46 -0400
Date: Wed, 26 Mar 2008 07:50:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in
	intel_cacheinfo
Message-ID: <20080326065023.GG18301@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325220651.683748000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Travis <travis@sgi.com> wrote:

> * Change the following static arrays sized by NR_CPUS to
>   per_cpu data variables:
> 
> 	_cpuid4_info *cpuid4_info[NR_CPUS];
> 	_index_kobject *index_kobject[NR_CPUS];
> 	kobject * cache_kobject[NR_CPUS];
> 
> * Remove the local NR_CPUS array with a kmalloc'd region in
>   show_shared_cpu_map().

thanks Travis, i've applied this to x86.git.

one observation:

>  static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>  {
> -	char mask_str[NR_CPUS];
> -	cpumask_scnprintf(mask_str, NR_CPUS, this_leaf->shared_cpu_map);
> -	return sprintf(buf, "%s\n", mask_str);
> +	int n = 0;
> +	int len = cpumask_scnprintf_len(nr_cpu_ids);
> +	char *mask_str = kmalloc(len, GFP_KERNEL);
> +
> +	if (mask_str) {
> +		cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
> +		n = sprintf(buf, "%s\n", mask_str);
> +		kfree(mask_str);
> +	}
> +	return n;

the other changes look good, but this one looks a bit ugly and complex. 
We basically want to sprintf shared_cpu_map into 'buf', but we do that 
by first allocating a temporary buffer, print a string into it, then 
print that string into another buffer ...

this very much smells like an API bug in cpumask_scnprintf() - why dont 
you create a cpumask_scnprintf_ptr() API that takes a pointer to a 
cpumask? Then this change would become a trivial and much more readable:

 -	char mask_str[NR_CPUS];
 -	cpumask_scnprintf(mask_str, NR_CPUS, this_leaf->shared_cpu_map);
 -	return sprintf(buf, "%s\n", mask_str);
 +	return cpumask_scnprintf_ptr(buf, NR_CPUS, &this_leaf->shared_cpu_map);

	Ingo
