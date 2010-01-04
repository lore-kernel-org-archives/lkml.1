Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703Ab0ADVi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0ADVi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472Ab0ADVi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:38:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:26895 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab0ADVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:38:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,500,1257148800"; 
   d="scan'208";a="584237475"
Date: Mon, 4 Jan 2010 13:38:52 -0800
From: mark gross <mgross@linux.intel.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, davidb@quicinc.com, pchidamb@quicinc.com
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Message-ID: <20100104213852.GA5031@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 05:20:27PM -0800, Daniel Walker wrote:
> From: Praveen Chidambaram <pchidamb@quicinc.com>
> 
> In some systems, the system bus speed can be varied, usually
> based on the current CPU frequency.  However, various device
> drivers and/or applications may need a faster system bus for I/O
> even though the CPU itself may be idle

What happened to the discussion around multiple platforms needing
multiple bus pm_qos_requirements?  

Is system bus freq too generic? (I'm worried about the name space)
Is this ok? (I'm asking linux-pm for input here.)
On X86 would this be analogous to FSB, Memory, or PCI bus frequencies?
What will happen when there are two buses each wanting a PM_QOS
parameter?  Is that a likely scenario?

Also, on your platform you have a throttling driver controlling the
frequency of some bus, that will use this value as a constraint on how
far it will throttle.  no?  I would be interested in seeing this driver
sometime.  (I just want to make sure no one bastardizes pm_qos into an
operating point thing.  I'm not sure I can justify why but I want to
avoid that.)

Lets have a on list discussion around the above.  Other than these I
don't see a problem with your patch.  I would like to know that other Si
vendors have a need for it other than just yours and the
abstraction/naming is compatible to them as well.

--mgross
> 
> Signed-off-by: Praveen Chidambaram <pchidamb@quicinc.com>
> Signed-off-by: David Brown <davidb@quicinc.com>
> Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> ---
>  include/linux/pm_qos_params.h |    3 ++-
>  kernel/pm_qos_params.c        |   32 +++++++++++++++++++++++++-------
>  2 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
> index d74f75e..091c13c 100644
> --- a/include/linux/pm_qos_params.h
> +++ b/include/linux/pm_qos_params.h
> @@ -10,8 +10,9 @@
>  #define PM_QOS_CPU_DMA_LATENCY 1
>  #define PM_QOS_NETWORK_LATENCY 2
>  #define PM_QOS_NETWORK_THROUGHPUT 3
> +#define PM_QOS_SYSTEM_BUS_FREQ 4
>  
> -#define PM_QOS_NUM_CLASSES 4
> +#define PM_QOS_NUM_CLASSES 5
>  #define PM_QOS_DEFAULT_VALUE -1
>  
>  int pm_qos_add_requirement(int qos, char *name, s32 value);
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index 3db49b9..8576f40 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -102,12 +102,24 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  	.comparitor = max_compare
>  };
>  
> +static BLOCKING_NOTIFIER_HEAD(system_bus_freq_notifier);
> +static struct pm_qos_object system_bus_freq_pm_qos = {
> +	.requirements =
> +		{LIST_HEAD_INIT(system_bus_freq_pm_qos.requirements.list)},
> +	.notifiers = &system_bus_freq_notifier,
> +	.name = "system_bus_freq",
> +	.default_value = 0,
> +	.target_value = ATOMIC_INIT(0),
> +	.comparitor = max_compare
> +};
> +
>  
> -static struct pm_qos_object *pm_qos_array[] = {
> -	&null_pm_qos,
> -	&cpu_dma_pm_qos,
> -	&network_lat_pm_qos,
> -	&network_throughput_pm_qos
> +static struct pm_qos_object *pm_qos_array[PM_QOS_NUM_CLASSES] = {
> +	[PM_QOS_RESERVED] = &null_pm_qos,
> +	[PM_QOS_CPU_DMA_LATENCY] = &cpu_dma_pm_qos,
> +	[PM_QOS_NETWORK_LATENCY] = &network_lat_pm_qos,
> +	[PM_QOS_NETWORK_THROUGHPUT] = &network_throughput_pm_qos,
> +	[PM_QOS_SYSTEM_BUS_FREQ] = &system_bus_freq_pm_qos,

I've never used or seen this syntax before.  Is it C99?  FWIW I like it.

>  };
>  
>  static DEFINE_SPINLOCK(pm_qos_lock);
> @@ -313,7 +325,7 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
>   * will register the notifier into a notification chain that gets called
>   * upon changes to the pm_qos_class target value.
>   */
> - int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
> +int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
>  {
>  	int retval;
>  
> @@ -409,9 +421,15 @@ static int __init pm_qos_power_init(void)
>  		return ret;
>  	}
>  	ret = register_pm_qos_misc(&network_throughput_pm_qos);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		printk(KERN_ERR
>  			"pm_qos_param: network_throughput setup failed\n");
> +		return ret;
> +	}
> +	ret = register_pm_qos_misc(&system_bus_freq_pm_qos);
> +	if (ret < 0)
> +		printk(KERN_ERR
> +			"pm_qos_param: system_bus_freq setup failed\n");
>  
>  	return ret;
>  }
> -- 
> 1.6.3.3
