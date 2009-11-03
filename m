Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578AbZKCF51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbZKCF51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZKCF51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:57:27 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60848 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZKCF50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:57:26 -0500
Date: Tue, 3 Nov 2009 11:27:23 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH 14/14] cpumask: don't recommend set_cpus_allowed hack
	in Documentation/cpu-hotplug.txt
Message-ID: <20091103055723.GA19322@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200911031459.06857.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911031459.06857.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Nov 03, 2009 at 02:59:06PM +1030, Rusty Russell wrote:
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Ashok Raj <ashok.raj@intel.com>
> ---
>  Documentation/cpu-hotplug.txt |   49 ++++++++++++++----------------------------
>  1 file changed, 17 insertions(+), 32 deletions(-)
> 
> diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -309,41 +309,26 @@ A: The following are what is required fo
> 
>  Q: I need to ensure that a particular cpu is not removed when there is some
>     work specific to this cpu is in progress.
> -A: First switch the current thread context to preferred cpu
> +A: There are two ways.  If your code can be run in interrupt context, use
> +   smp_call_function_single(), otherwise use work_on_cpu().  Note that
> +   work_on_cpu() can fail due to out of memory:
> 
>  	int my_func_on_cpu(int cpu)
>  	{
> +		int err;
> +		cpu_hotplug_lock();
		^^^^^^^^^^^^^^^^^^^
This needs to be get_online_cpus();
> +		if (!cpu_online(cpu))
> +			err = -EINVAL;
> +		else
> +#if NEEDS_BLOCKING
> +			err = work_on_cpu(cpu, __my_func_on_cpu, NULL);
> +#else
> +			smp_call_function_single(cpu, __my_func_on_cpu, &err,
> +						 true);
> +#endif
> +		cpu_hotplug_unlock();
		^^^^^^^^^^^^^^^^^^^^^
And this one should be put_online_cpus();

> +		return err;
> +	}
> 
>  Q: How do we determine how many CPUs are available for hotplug.
>  A: There is no clear spec defined way from ACPI that can give us that

-- 
Thanks and Regards
gautham
