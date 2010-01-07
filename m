Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460Ab0AGUw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0AGUw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113Ab0AGUw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:52:29 -0500
Received: from mga06.intel.com ([134.134.136.21]:13034 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222Ab0AGUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:52:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,237,1262592000"; 
   d="scan'208";a="482224368"
Date: Thu, 7 Jan 2010 12:52:27 -0800
From: mark gross <mgross@linux.intel.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Message-ID: <20100107205227.GA5703@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
 <87ocl550x7.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ocl550x7.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 08:34:28AM -0800, Kevin Hilman wrote:
> Daniel Walker <dwalker@codeaurora.org> writes:
> 
> > From: Praveen Chidambaram <pchidamb@quicinc.com>
> >
> > In some systems, the system bus speed can be varied, usually
> > based on the current CPU frequency.  However, various device
> > drivers and/or applications may need a faster system bus for I/O
> > even though the CPU itself may be idle.
> >
> > Signed-off-by: Praveen Chidambaram <pchidamb@quicinc.com>
> > Signed-off-by: David Brown <davidb@quicinc.com>
> > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> 
> I think some type of bus parameter is a good idea and something we
> would use on TI OMAP as well.  However, I also have two concerns with
> this approach.
> 
> 1) The constraint should be in throughput, not in frequency
> 2) It doesn't handle multiple busses (as Mark Gross pointed out)
> 
> For (1), I don't like the idea of forcing drivers to know about the
> underlying bus frequency.  The same driver could be in use across a
> family of SoCs (or even different SoCs), each having different bus
> frequencies.  For this driver to be portable, the driver should
> express its constraints in terms of throughput, not underlying bus
> frequency.

This makes sense, as throttling constraints should be based on things
that are invariant to bus width.

> 
> For (2), I'm not sure what the best way to handle this in PM QoS is.
> Lately, I've been thinking that PM QoS is not the right place for
> this.  My idea (currenly only in my head) is the that busses in the
> LDM (platform_bus, etc.)  should have constraints associated with
> them.  That way, constraints can be set using a 'struct device' and
> the bus they are attatched to will inherit the constraints directly.
> This automatically solves the problem of multiple busses and allows
> the possibility for different bus types to handle the constraints
> differently.

Sounds a bit like the range timers implementation.  One question, what
would a throttling constraint changes API look like if not pm_qos?

I think adding a bandwidth throttling constraint to struct device may be
a good thing, but I'm not sure if there isn't a place for the PM_QOS
interface yet.  i.e. perhaps if this happens, then we should look at
evolving the pm_qos api to handle multiple constraint's per class and
multiple buses, multiple nic's etc...

--mgross


> 
> Kevin
> 
> 
> > ---
> >  include/linux/pm_qos_params.h |    3 ++-
> >  kernel/pm_qos_params.c        |   32 +++++++++++++++++++++++++-------
> >  2 files changed, 27 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
> > index d74f75e..091c13c 100644
> > --- a/include/linux/pm_qos_params.h
> > +++ b/include/linux/pm_qos_params.h
> > @@ -10,8 +10,9 @@
> >  #define PM_QOS_CPU_DMA_LATENCY 1
> >  #define PM_QOS_NETWORK_LATENCY 2
> >  #define PM_QOS_NETWORK_THROUGHPUT 3
> > +#define PM_QOS_SYSTEM_BUS_FREQ 4
> >  
> > -#define PM_QOS_NUM_CLASSES 4
> > +#define PM_QOS_NUM_CLASSES 5
> >  #define PM_QOS_DEFAULT_VALUE -1
> >  
> >  int pm_qos_add_requirement(int qos, char *name, s32 value);
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index 3db49b9..8576f40 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -102,12 +102,24 @@ static struct pm_qos_object network_throughput_pm_qos = {
> >  	.comparitor = max_compare
> >  };
> >  
> > +static BLOCKING_NOTIFIER_HEAD(system_bus_freq_notifier);
> > +static struct pm_qos_object system_bus_freq_pm_qos = {
> > +	.requirements =
> > +		{LIST_HEAD_INIT(system_bus_freq_pm_qos.requirements.list)},
> > +	.notifiers = &system_bus_freq_notifier,
> > +	.name = "system_bus_freq",
> > +	.default_value = 0,
> > +	.target_value = ATOMIC_INIT(0),
> > +	.comparitor = max_compare
> > +};
> > +
> >  
> > -static struct pm_qos_object *pm_qos_array[] = {
> > -	&null_pm_qos,
> > -	&cpu_dma_pm_qos,
> > -	&network_lat_pm_qos,
> > -	&network_throughput_pm_qos
> > +static struct pm_qos_object *pm_qos_array[PM_QOS_NUM_CLASSES] = {
> > +	[PM_QOS_RESERVED] = &null_pm_qos,
> > +	[PM_QOS_CPU_DMA_LATENCY] = &cpu_dma_pm_qos,
> > +	[PM_QOS_NETWORK_LATENCY] = &network_lat_pm_qos,
> > +	[PM_QOS_NETWORK_THROUGHPUT] = &network_throughput_pm_qos,
> > +	[PM_QOS_SYSTEM_BUS_FREQ] = &system_bus_freq_pm_qos,
> >  };
> >  
> >  static DEFINE_SPINLOCK(pm_qos_lock);
> > @@ -313,7 +325,7 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
> >   * will register the notifier into a notification chain that gets called
> >   * upon changes to the pm_qos_class target value.
> >   */
> > - int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
> > +int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
> >  {
> >  	int retval;
> >  
> > @@ -409,9 +421,15 @@ static int __init pm_qos_power_init(void)
> >  		return ret;
> >  	}
> >  	ret = register_pm_qos_misc(&network_throughput_pm_qos);
> > -	if (ret < 0)
> > +	if (ret < 0) {
> >  		printk(KERN_ERR
> >  			"pm_qos_param: network_throughput setup failed\n");
> > +		return ret;
> > +	}
> > +	ret = register_pm_qos_misc(&system_bus_freq_pm_qos);
> > +	if (ret < 0)
> > +		printk(KERN_ERR
> > +			"pm_qos_param: system_bus_freq setup failed\n");
> >  
> >  	return ret;
> >  }
> > -- 
> > 1.6.3.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
