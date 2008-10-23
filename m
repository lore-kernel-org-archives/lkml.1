Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYJWPLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYJWPLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYJWPK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:10:28 -0400
Received: from ozlabs.org ([203.10.76.45]:51731 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbYJWPK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:10:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 6/7] work_on_cpu: use on x86/kernel/cpu/intel_cacheinfo.c
Date: Fri, 24 Oct 2008 02:10:31 +1100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <20081023005750.D0A11DDEF9@ozlabs.org> <20081023094621.GA7995@redhat.com>
In-Reply-To: <20081023094621.GA7995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240210.31573.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 20:46:21 Oleg Nesterov wrote:
> On 10/23, Rusty Russell wrote:
> > +static int __cpuinit detect_cache_attributes(unsigned int cpu)
> > +{
> > +	int			retval;
> > +
> > +	if (num_cache_leaves == 0)
> > +		return -ENOENT;
> > +
> > +	per_cpu(cpuid4_info, cpu) = kzalloc(
> > +	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
> > +	if (per_cpu(cpuid4_info, cpu) == NULL)
> > +		return -ENOMEM;
> > +
> > +	retval = work_on_cpu(cpu, get_cpu_leaves, NULL);
>
> This doesn't look right.
>
> cache_add_dev()->cpuid4_cache_sysfs_init()->detect_cache_attributes()
> is called by CPU_ONLINE under cpu_hotplug_begin(), this is deadlockable.
>
> Yes, the caller (cpu_hotplug.active_writer) can safely take
> get_online_cpus(), but if we have another pending work which needs
> get_online_cpus(), we have the deadlock.

Hi Oleg,

   Nice catch.  Can we use smp_call_function here instead?

Rusty.

>
> Oleg.




