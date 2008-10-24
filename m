Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYJXDEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYJXDEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYJXDEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:04:35 -0400
Received: from ozlabs.org ([203.10.76.45]:44301 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbYJXDEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:04:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Date: Fri, 24 Oct 2008 14:04:35 +1100
User-Agent: KMail/1.9.10
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com>
In-Reply-To: <20081023143605.GN5255@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241404.35932.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 01:36:05 Gautham R Shenoy wrote:
> OK, how about doing the following? That will solve the problem
> of deadlock you pointed out in patch 6.
>
> 		get_online_cpus();
> 		if (likely(per_cpu(cpu_state, cpuid) == CPU_ONLINE)) {
> 			schedule_work_on(cpu, &wfc.work);
> 			flush_work(&wfc.work);
> 		} else if (per_cpu(cpu_state, cpuid) != CPU_DEAD)) {
> 			/*
> 			 * We're the CPU-Hotplug thread. Call the
> 			 * function synchronously so that we don't
> 			 * deadlock with any pending work-item blocked
> 			 * on get_online_cpus()
> 			 */
> 			 cpumask_t  orignal_mask = current->cpus_allowed;
> 			 set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu);
> 			 wfc.ret = fn(arg);
> 			 set_cpus_allowed_ptr(current, &original_mask);
> 		}

Hi Gautham, Oleg,

Unfortunately that's exactly what I'm trying to get away from: another cpumask 
on the stack :(

The cpu hotplug thread is just whoever wrote 0 to "online" in sys.  And in 
fact it already plays with its cpumask, which should be fixed too.

I think we should BUG_ON(per_cpu(cpu_state, cpuid) != CPU_DEAD) to ensure we 
never use work_on_cpu in the hotplug cpu path.  Then we use 
smp_call_function() for that hard intel_cacheinfo case.  Finally, we fix the 
cpu hotplug path to use schedule_work_on() itself rather than playing games 
with cpumask.

If you agree, I'll spin the patches...

Thanks for the brainpower,
Rusty.
