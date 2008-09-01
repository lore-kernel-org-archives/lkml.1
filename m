Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbYIAAin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbYIAAin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 20:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYIAAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 20:38:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:36183 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbYIAAid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 20:38:33 -0400
Subject: Re: [PATCH] prevent powerpc from invoking irq handlers on offline
	CPUs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, jwboyer@linux.vnet.ibm.com,
       tnt@246tNt.com, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       manfred@colorfullife.com, akpm@linux-foundation.org
In-Reply-To: <20080831173127.GA15296@linux.vnet.ibm.com>
References: <20080831173127.GA15296@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 10:34:44 +1000
Message-Id: <1220229284.13162.411.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-31 at 10:31 -0700, Paul E. McKenney wrote:
> Make powerpc refrain from clearing a given to-be-offlined CPU's bit in the
> cpu_online_mask until it has processed pending irqs.  This change
> prevents other CPUs from being blindsided by an apparently offline CPU
> nevertheless changing globally visible state.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

Sounds reasonable... the only possible worry here is if somebody tries
an IPI ... The IPI code will and the target CPU mask with the online
map, so it may try to send to the to-be-offlined CPU and timeout, no ?

Cheers,
Ben.

>  smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 5337ca7..1fedd7d 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -250,11 +250,11 @@ int generic_cpu_disable(void)
>  	if (cpu == boot_cpuid)
>  		return -EBUSY;
>  
> -	cpu_clear(cpu, cpu_online_map);
>  #ifdef CONFIG_PPC64
>  	vdso_data->processorCount--;
>  	fixup_irqs(cpu_online_map);
>  #endif
> +	cpu_clear(cpu, cpu_online_map);
>  	return 0;
>  }
>  

