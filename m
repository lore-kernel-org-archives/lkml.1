Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbYKMJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbYKMJyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYKMJyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:54:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMJyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:54:05 -0500
Date: Thu, 13 Nov 2008 10:53:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Message-ID: <20081113095345.GM25479@elte.hu>
References: <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu> <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu> <491BD0BA.5070008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491BD0BA.5070008@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> reduce the #ifdef numbers

> Index: linux-2.6/arch/x86/include/asm/hpet.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/hpet.h
> +++ linux-2.6/arch/x86/include/asm/hpet.h
> @@ -72,8 +72,15 @@ extern void hpet_disable(void);
>  extern unsigned long hpet_readl(unsigned long a);
>  extern void force_hpet_resume(void);
>  
> +#ifdef CONFIG_SPARSE_IRQ
> +extern void hpet_msi_unmaskx(unsigned int irq, struct irq_desc **descp);
> +extern void hpet_msi_maskx(unsigned int irq, struct irq_desc **descp);
> +#define hpet_msi_unmask hpet_msi_unmaskx
> +#define hpet_msi_mask hpet_msi_maskx
> +#else
>  extern void hpet_msi_unmask(unsigned int irq);
>  extern void hpet_msi_mask(unsigned int irq);
> +#endif
>  extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
>  extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);

please use inlines instead of #define's.

> Index: linux-2.6/arch/x86/kernel/hpet.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/hpet.c
> +++ linux-2.6/arch/x86/kernel/hpet.c
> @@ -347,7 +347,7 @@ static int hpet_legacy_next_event(unsign
>  static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
>  static struct hpet_dev	*hpet_devs;
>  
> -void hpet_msi_unmask(unsigned int irq)
> +void hpet_msi_unmaskx(unsigned int irq, struct irq_desc **descp)
>  {
>  	struct hpet_dev *hdev = get_irq_data(irq);
>  	unsigned long cfg;
> @@ -358,7 +358,7 @@ void hpet_msi_unmask(unsigned int irq)
>  	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
>  }
>  
> -void hpet_msi_mask(unsigned int irq)
> +void hpet_msi_maskx(unsigned int irq, struct irq_desc **descp)

please name it hpet_msi_mask_desc() - 'maskx' sounds quirky.

>  {
>  	unsigned long cfg;
>  	struct hpet_dev *hdev = get_irq_data(irq);
> @@ -369,6 +369,21 @@ void hpet_msi_mask(unsigned int irq)
>  	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
>  }
>  
> +#ifndef CONFIG_SPARSE_IRQ
> +void hpet_msi_unmask(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	hpet_msi_unmaskx(irq, &desc);
> +}
> +void hpet_msi_mask(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	hpet_msi_maskx(irq, &desc);
> +}
> +#endif
> +
>  void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
>  {
>  	struct hpet_dev *hdev = get_irq_data(irq);

it still looks ugly to me: couldnt we make it completely #ifdef-free, 
by just adding the new API variants?

i.e. leave these present unconditionally:

>  extern void hpet_msi_unmask(unsigned int irq);
>  extern void hpet_msi_mask(unsigned int irq);

and just _add_ these (unconditionally):

> +extern void hpet_msi_unmask_desc(unsigned int irq, struct irq_desc **descp);
> +extern void hpet_msi_mask_desc(unsigned int irq, struct irq_desc **descp);

that gives us zero #ifdefs and much nicer to read patches. Am i 
missing something why this isnt possible?

	Ingo
