Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYJWJqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYJWJqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYJWJph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:45:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYJWJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:45:36 -0400
Date: Thu, 23 Oct 2008 11:46:21 +0200
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 6/7] work_on_cpu: use on
	x86/kernel/cpu/intel_cacheinfo.c
Message-ID: <20081023094621.GA7995@redhat.com>
References: <20081023005750.D0A11DDEF9@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023005750.D0A11DDEF9@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Rusty Russell wrote:
>
> +static int __cpuinit detect_cache_attributes(unsigned int cpu)
> +{
> +	int			retval;
> +
> +	if (num_cache_leaves == 0)
> +		return -ENOENT;
> +
> +	per_cpu(cpuid4_info, cpu) = kzalloc(
> +	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
> +	if (per_cpu(cpuid4_info, cpu) == NULL)
> +		return -ENOMEM;
> +
> +	retval = work_on_cpu(cpu, get_cpu_leaves, NULL);

This doesn't look right.

cache_add_dev()->cpuid4_cache_sysfs_init()->detect_cache_attributes()
is called by CPU_ONLINE under cpu_hotplug_begin(), this is deadlockable.

Yes, the caller (cpu_hotplug.active_writer) can safely take
get_online_cpus(), but if we have another pending work which needs
get_online_cpus(), we have the deadlock.

Oleg.

