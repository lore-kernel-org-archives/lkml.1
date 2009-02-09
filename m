Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZBIKgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZBIKgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBIKgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:36:36 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:64112 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBIKgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <20090209091604.GE31890@elte.hu>
References: <20090208192405.8084.89231.stgit@vmbox.hanneseder.net>
	 <20090208230910.GH31509@parisc-linux.org>
	 <20090209091604.GE31890@elte.hu>
Date: Mon, 9 Feb 2009 11:36:33 +0100
Message-ID: <154e089b0902090236y1e4f382dlddb6815312e51d39@mail.gmail.com>
Subject: Re: [PATCH] kernel/irq: fix sparse warning: make symbol static
From: Hannes Eder <hannes@hanneseder.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 10:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matthew Wilcox <matthew@wil.cx> wrote:
>
>> On Sun, Feb 08, 2009 at 08:24:47PM +0100, Hannes Eder wrote:
>> > -static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
>> > +static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
>>
>> Does this not introduce a checkpatch warning about a line being longer
>> than 80 columns?  Three acceptable ways to fix this:
>
> It does - 81 cols. We could ignore it (it's close enough to the limit), but:

That's why I thought I ignore that warning.

> ----------------->
> From 548c8933801c9ee347b6f1bad2491e4286a4f3a2 Mon Sep 17 00:00:00 2001
> From: Hannes Eder <hannes@hanneseder.net>
> Date: Sun, 8 Feb 2009 20:24:47 +0100
> Subject: [PATCH] kernel/irq: fix sparse warning: make symbol static
>
> While being at it make every occurrence of 'do_irq_select_affinity'
> have the same signature in terms of signedness of the first argument.
>
> Fix this sparse warning:
>  kernel/irq/manage.c:112:5: warning: symbol 'do_irq_select_affinity' was not declared. Should it be static?
>
> Also rename do_irq_select_affinity() to setup_affinity() - shorter name
> and clearer naming.
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Matthew Wilcox <matthew@wil.cx>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/irq/manage.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 291f036..38008b8 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -109,7 +109,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
>  /*
>  * Generic version of the affinity autoselector.
>  */
> -int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
> +static int setup_affinity(unsigned int irq, struct irq_desc *desc)
>  {
>        if (!irq_can_set_affinity(irq))
>                return 0;
> @@ -133,7 +133,7 @@ set_affinity:
>        return 0;
>  }
>  #else
> -static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *d)
> +static inline int setup_affinity(unsigned int irq, struct irq_desc *d)

using the following would even be more homogenous:

-static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *d)
+static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)


>  {
>        return irq_select_affinity(irq);
>  }
> @@ -149,14 +149,14 @@ int irq_select_affinity_usr(unsigned int irq)
>        int ret;
>
>        spin_lock_irqsave(&desc->lock, flags);
> -       ret = do_irq_select_affinity(irq, desc);
> +       ret = setup_affinity(irq, desc);
>        spin_unlock_irqrestore(&desc->lock, flags);
>
>        return ret;
>  }
>
>  #else
> -static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
> +static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
>  {
>        return 0;
>  }
> @@ -488,7 +488,7 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
>                        desc->status |= IRQ_NO_BALANCING;
>
>                /* Set default affinity mask once everything is setup */
> -               do_irq_select_affinity(irq, desc);
> +               setup_affinity(irq, desc);
>
>        } else if ((new->flags & IRQF_TRIGGER_MASK)
>                        && (new->flags & IRQF_TRIGGER_MASK)
>

Thank you.

-Hannes
