Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZGCAZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZGCAZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZGCAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:24:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:33202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZGCAYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:24:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="529834841"
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3877989d0906300001u2f185fb0lcab5614e245efc21@mail.gmail.com>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <1246307644.4534.26298.camel@localhost.localdomain>
	 <3877989d0906300001u2f185fb0lcab5614e245efc21@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 17:23:03 -0700
Message-Id: <1246580583.4534.32443.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 00:01 -0700, Luming Yu wrote:
> Thanks for review. How about the following patch?
> 
> /**The patch is enclosed in text attachment**
> **Using web client to send the patch**
> **below is for review, please apply attached  patch*/
> 
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  apic.c         |    5 ++++-
>  apic_flat_64.c |    7 ++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> 
> --- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0	2009-06-29
> 23:45:05.000000000 -0600
> +++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c	2009-06-30
> 00:37:56.000000000 -0600
> @@ -419,7 +419,10 @@
>  static void lapic_timer_broadcast(const struct cpumask *mask)
>  {
>  #ifdef CONFIG_SMP
> -	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
> +	if (unlikely(cpumask_weight(mask) == num_online_cpus() -1))
> +		apic->send_IPI_all(LOCAL_TIMER_VECTOR);
> +	else
> +		apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
>  #endif
>  }

I dont think it is a good idea to pay the penalty for cpumask_weight and
num_online_cpus, for the more common tickless case to fix this problem
with less common no tickeless case.

We should be able to add an interface to get tick_nohz_enabled from
tick-sched.c and use that instead.

Thanks,
Venki

> 
> --- linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c.0	2009-06-29
> 00:13:26.000000000 -0600
> +++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-06-29
> 00:11:23.000000000 -0600
> @@ -274,7 +274,12 @@
> 
>  static void physflat_send_IPI_all(int vector)
>  {
> -	physflat_send_IPI_mask(cpu_online_mask, vector);
> +	if (vector == NMI_VECTOR) {
> +		physflat_send_IPI_mask(cpu_online_mask, vector);
> +	} else {
> +		__default_send_IPI_shortcut(APIC_DEST_ALLINC,
> +					    vector, apic->dest_logical);
> +	}
>  }
> 
>  static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)

