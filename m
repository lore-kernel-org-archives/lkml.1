Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYLTXwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYLTXwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLTXwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:52:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:1177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbYLTXwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:52:12 -0500
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Dec 2008 18:52:12 EST
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <20081219160145.672392000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
	 <20081219160145.672392000@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Sat, 20 Dec 2008 23:22:39 +0000
Message-Id: <1229815359.2723.19.camel@hashbaz.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.4.253
X-SA-Exim-Mail-From: bhutchings@solarflare.com
Subject: Re: [PATCH 7/8] cpumask: convert misc driver functions
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 08:01 -0800, Mike Travis wrote:
[...]
> --- linux-2.6-for-ingo.orig/drivers/net/sfc/efx.c
> +++ linux-2.6-for-ingo/drivers/net/sfc/efx.c
> @@ -809,19 +809,18 @@ static void efx_fini_io(struct efx_nic *
>  /* Get number of RX queues wanted.  Return number of online CPU
>   * packages in the expectation that an IRQ balancer will spread
>   * interrupts across them. */
> -static int efx_wanted_rx_queues(void)
> +static int efx_wanted_rx_queues(struct cpumask *scratch)
>  {
> -	cpumask_t core_mask;
>  	int count;
>  	int cpu;
>  
> -	cpus_clear(core_mask);
> +	cpumask_clear(scratch);
>  	count = 0;
>  	for_each_online_cpu(cpu) {
> -		if (!cpu_isset(cpu, core_mask)) {
> +		if (!cpumask_test_cpu(cpu, scratch)) {
>  			++count;
> -			cpus_or(core_mask, core_mask,
> -				topology_core_siblings(cpu));
> +			cpumask_or(scratch, scratch,
> +				   topology_core_cpumask(cpu));
>  		}
>  	}
>  
> @@ -831,7 +830,7 @@ static int efx_wanted_rx_queues(void)
>  /* Probe the number and type of interrupts we are able to obtain, and
>   * the resulting numbers of channels and RX queues.
>   */
> -static void efx_probe_interrupts(struct efx_nic *efx)
> +static void efx_probe_interrupts(struct efx_nic *efx, struct cpumask *scratch)
>  {
>  	int max_channels =
>  		min_t(int, efx->type->phys_addr_channels, EFX_MAX_CHANNELS);
> @@ -845,7 +844,8 @@ static void efx_probe_interrupts(struct 
>  		 * (or as specified by the rss_cpus module parameter).
>  		 * We will need one channel per interrupt.
>  		 */
> -		wanted_ints = rss_cpus ? rss_cpus : efx_wanted_rx_queues();
> +		wanted_ints = rss_cpus ? rss_cpus :
> +					 efx_wanted_rx_queues(scratch);
>  		efx->n_rx_queues = min(wanted_ints, max_channels);
>  
>  		for (i = 0; i < efx->n_rx_queues; i++)
> @@ -923,24 +923,29 @@ static void efx_set_channels(struct efx_
>  static int efx_probe_nic(struct efx_nic *efx)
>  {
>  	int rc;
> +	cpumask_var_t scratch;
>  
>  	EFX_LOG(efx, "creating NIC\n");
>  
> +	if (!alloc_cpumask_var(&scratch, GFP_KERNEL))
> +		return -ENOMEM;
> +
>  	/* Carry out hardware-type specific initialisation */
>  	rc = falcon_probe_nic(efx);
>  	if (rc)
> -		return rc;
> +		goto out;
>  
>  	/* Determine the number of channels and RX queues by trying to hook
>  	 * in MSI-X interrupts. */
> -	efx_probe_interrupts(efx);
> +	efx_probe_interrupts(efx, scratch);
>  
>  	efx_set_channels(efx);
>  
>  	/* Initialise the interrupt moderation settings */
>  	efx_init_irq_moderation(efx, tx_irq_mod_usec, rx_irq_mod_usec);
> -
> -	return 0;
> +out:
> +	free_cpumask_var(scratch);
> +	return rc;
>  }
>  
>  static void efx_remove_nic(struct efx_nic *efx)
[...]

I assume you're moving the allocation up to efx_probe_nic() because
efx_wanted_rx_queues() and efx_probe_interrupts() cannot return failure.
It really isn't worth exposing that detail up the call chain though.  I
think it's acceptable for efx_wanted_rx_queues() to log an error message
and return 1 in the exceedingly unlikely case that the allocation fails.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


