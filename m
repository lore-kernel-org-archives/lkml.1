Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYJBImt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYJBImt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYJBIml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:42:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYJBIml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:42:41 -0400
Date: Thu, 2 Oct 2008 10:42:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq()
	functions
Message-ID: <20081002084214.GD26084@elte.hu>
References: <20081001114415.GA3281@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001114415.GA3281@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> Provide a means for UV interrupt MMRs to be setup with the message to 
> be sent when an MSI is raised.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
> This functionality is needed by drivers/misc/sgi-xp. And a patch will be
> submitted shortly.
> 
>  arch/x86/kernel/Makefile    |    2 
>  arch/x86/kernel/io_apic.c   |   95 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/uv_irq.c    |   50 +++++++++++++++++++++
>  include/asm-x86/uv/uv_irq.h |   34 ++++++++++++++
>  kernel/irq/chip.c           |    1 
>  5 files changed, 181 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/io_apic.c	2008-09-30 09:07:42.000000000 -0500
> +++ linux/arch/x86/kernel/io_apic.c	2008-09-30 12:54:12.000000000 -0500
> @@ -58,6 +58,8 @@
>  #include <asm/setup.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
> +#include <asm/uv/uv_hub.h>
> +#include <asm/uv/uv_irq.h>
>  
>  #include <mach_ipi.h>
>  #include <mach_apic.h>
> @@ -3694,6 +3696,99 @@ int arch_setup_ht_irq(unsigned int irq, 
>  }
>  #endif /* CONFIG_HT_IRQ */
>  
> +#ifdef CONFIG_X86_64
> +static void noop(unsigned int irq)
> +{
> +}
> +
> +static unsigned int noop_ret(unsigned int irq)
> +{
> +	return 0;
> +}
> +
> +static void ack_apic(unsigned int irq)
> +{
> +	ack_APIC_irq();
> +}
> +
> +static struct irq_chip uv_irq_chip = {
> +	.name		= "UV_MSI",
> +	.startup	= noop_ret,
> +	.shutdown	= noop,
> +	.enable		= noop,
> +	.disable	= noop,
> +	.ack		= noop,
> +	.mask		= noop,
> +	.unmask		= noop,
> +	.eoi		= ack_apic,
> +	.end		= noop,
> +};

hm, why isnt this in uv_irq.c?

> Index: linux/kernel/irq/chip.c
> ===================================================================
> --- linux.orig/kernel/irq/chip.c	2008-09-30 09:07:42.000000000 -0500
> +++ linux/kernel/irq/chip.c	2008-09-30 09:07:44.000000000 -0500
> @@ -79,6 +79,7 @@ void dynamic_irq_cleanup(unsigned int ir
>  	desc->chip_data = NULL;
>  	desc->handle_irq = handle_bad_irq;
>  	desc->chip = &no_irq_chip;
> +	desc->name = "none";
>  	spin_unlock_irqrestore(&desc->lock, flags);

unrelated change that belongs into a separate patch.

patch looks quite clean otherwise.

	Ingo
