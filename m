Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYHCJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYHCJXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYHCJXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 05:23:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41353 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYHCJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 05:23:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<m1fxpm8x3n.fsf@frodo.ebiederm.org>
	<86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
	<m18wve7gbt.fsf@frodo.ebiederm.org>
	<86802c440808030125v32c6a83aoe3c09eea6a6cce08@mail.gmail.com>
Date: Sun, 03 Aug 2008 02:15:54 -0700
In-Reply-To: <86802c440808030125v32c6a83aoe3c09eea6a6cce08@mail.gmail.com>
	(Yinghai Lu's message of "Sun, 3 Aug 2008 01:25:09 -0700")
Message-ID: <m1vdyi4fxx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0042]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> how about
>
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index f4c8a03..aa6888c 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -47,19 +47,73 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
>   *
>   * Controller mappings for all interrupt sources:
>   */
> -struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
> -       [0 ... NR_IRQS-1] = {
> -               .status = IRQ_DISABLED,
> -               .chip = &no_irq_chip,
> -               .handle_irq = handle_bad_irq,
> -               .depth = 1,
> -               .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
> +static irq_desc **irq_desc_ptr;
> +DEFINE_DYN_ARRAY(irq_desc_ptr, sizeof(struct irq_desc *), nr_irqs,
> PAGE_SIZE, NULL);
> +
> +#define NR_IRQ_DESC    4096
> +
> +static struct irq_desc irq_desc__init = {
> +       .irq = -1;

Do you perhaps mean 0xffffffffU ?

> +       .status = IRQ_DISABLED,
> +       .chip = &no_irq_chip,
> +       .handle_irq = handle_bad_irq,
> +       .depth = 1,
> +       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
>  #ifdef CONFIG_SMP
> -               .affinity = CPU_MASK_ALL
> +       .affinity = CPU_MASK_ALL
>  #endif
> -       }
>  };
>
> +static int nr_irq_desc = NR_IRQ_DESC;
> +
> +static int __init parse_nr_irq_desc(char *arg)
> +{
> +        if (arg)
> +                nr_irq_desc = simple_strtoul(arg, NULL, 0);
> +        return 0;
> +}
> +
> +early_param("nr_irq_desc", parse_nr_irq_desc);
> +
> +static void __init init_work(void *data)
> +{
> +       struct dyn_array *da = data;
> +       int i;
> +       struct  irq_desc *desc;
> +
> +       desc = *da->name;
> +
> +       for (i = 0; i < *da->nr; i++)
> +               memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
> +}
> +
> +static struct irq_desc *irq_desc;
> +DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irq_desc,
> PAGE_SIZE, init_work);
> +
> +struct irq_desc *get_irq_desc(int irq)

Ugh.  This has the wrong type.  It must be unsigned int irq.
> +{
> +       struct irq_desc *desc;
> +       int i;
> +
> +       desc = irq_desc_ptr[irq];
> +
> +       if (desc)
> +               return desc;
> +
> +       for (i = 0; i < nr_irq_desc; i++) {
> +               if (irq_desc[i]->irq != -1)

Which makes this line wrong.
> +                       continue;
> +
> +               desc = &irq_desc[i];
> +               desc->irq = irq;
> +               irq_desc_ptr[irq] = desc;
> +
> +               return desc;
> +       }
> +
> +       panic("please boot with nr_irq_desc=%d\n", nr_irq_desc * 2);
> +}
> +
>  /*
>   * What should we do if we get a hw irq event on an illegal vector?
>   * Each architecture has to answer this themself.
>
>
> and later use get_irq_desc(i) instead irq_desc + i;

That is the general idea.

Eric

