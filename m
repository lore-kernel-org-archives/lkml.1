Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZF2Uf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZF2Uf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZF2Uft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:35:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:57498 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZF2Uft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:35:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,311,1243839600"; 
   d="scan'208";a="470604586"
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 13:34:04 -0700
Message-Id: <1246307644.4534.26298.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 23:47 -0700, Luming Yu wrote:
> Hello,
> 
> We need to use IPI shortcut to send lapic timer broadcast
> to avoid the latency of sending IPI one bye one on systems with many
> logical processors when NO_HZ is disabled.
> Without this patch,I have seen upstream kernel with RHEL 5 kernel
> config boot hang .
> 
> The patch also changes physflat_send_IPI_all to IPI shortcut mode.
> 
> Please review, and apply.
> 
> **The patch is enclosed in text attachment*
> **Using web client to send the patch* *
> **below is for review, please apply attached  patch*/
> 
> Thanks,
> Luming
> 
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
>  apic.c         |    4 +++-
>  apic_flat_64.c |    7 ++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0	2009-06-28
> 20:22:55.000000000 -0600
> +++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c	2009-06-29
> 00:21:44.000000000 -0600
> @@ -419,7 +419,9 @@
>  static void lapic_timer_broadcast(const struct cpumask *mask)
>  {
>  #ifdef CONFIG_SMP
> -	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
> +	if (cpus_empty(*mask))
> +		return;
> +	apic->send_IPI_all(LOCAL_TIMER_VECTOR);
>  #endif
>  }
> 

Hmm.. this change looks wrong. This will cause unnecessary timer
broadcasts when nohz is actually enabled. I mean, when nohz is enabled,
we want to send this interrupt broadcast to one or some subset of CPUs
and this change sends the interrupt to all CPUs.

On a 16 logical CPUs with nohz enabled, powertop without this patch I
see
Wakeups-from-idle per second : 11.6     interval: 15.0s
and with this patch I see
Wakeups-from-idle per second : 24.7     interval: 15.0s

Also, cat /proc/interrupts | grep LOC shows this problem where all CPUs
seem to get roughly same number of local APIC interrupts over a period
of time with this patch.

We should only do the allbutself when nohz is disabled with a big
unlikely() around that code.

Thanks,
Venki

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

