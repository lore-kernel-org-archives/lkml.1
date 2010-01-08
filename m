Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003Ab0AHTAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0AHTAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966Ab0AHTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:00:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3514 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0AHTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:00:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5855"; a="31650163"
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
From: Daniel Walker <dwalker@codeaurora.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
       Chidambaram@vger.kernel.org, Praveen <pchidamb@quicinc.com>,
       Brown@vger.kernel.org, David <davidb@quicinc.com>
In-Reply-To: <87ocl550x7.fsf@deeprootsystems.com>
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
	 <87ocl550x7.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 10:59:57 -0800
Message-ID: <1262977197.17207.51.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just adding some CC's ..

On Thu, 2010-01-07 at 08:34 -0800, Kevin Hilman wrote:
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


