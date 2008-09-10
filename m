Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYIJSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYIJSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYIJSkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:40:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:44969 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYIJSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jE3EAfs27l5yrL+hsMdEYxvm9B8J+vrDeL27lmNsaLXhHvtUMAweFIAvqLnhql1UKh
         h734jgV+YKqCVDNTXoOav4JPi525M6UcDJ+m68gqUFpG6u6xZcshyLVnD/vDV+zWcQUA
         vNBrtWEbMuBvl1bM5vpeSsHw2lFPx2Xm6XDjs=
Message-ID: <86802c440809101140w55602b9as94b09b4d7c3ea661@mail.gmail.com>
Date: Wed, 10 Sep 2008 11:40:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910181950.GC8067@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
	 <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
	 <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
	 <20080910093105.GA5259@elte.hu>
	 <86802c440809101030q758d2f92v470727c88654d91d@mail.gmail.com>
	 <20080910181950.GC8067@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:19 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Yinghai Lu - Wed, Sep 10, 2008 at 10:30:39AM -0700]
> | On Wed, Sep 10, 2008 at 2:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> | >
> | > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> | >
> | >> On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | >> > On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> | >> > ...
> | >> >>
> | >> >> hope we can keep using MACRO..
> | >> >>
> | >> >> YH
> | >> >>
> | >> >
> | >> > Btw, Yinghai, what does it mean? To not touch this macro at all?
> | >> > Or you mean about implementation issue (ie the design itself)?
> | >>
> | >> do not touch this macro... and may revisit after 2.6.28
> | >
> | > anything you are particularly worried about? Regressions we should be
> | > able to find pretty quickly, in a central macro like that - and the
> | > macro is quite ugly.
> | >
> |
> | ok, let remove unneeded "if", and use function pointer...
> |
> | void (*extra_action_t)(struct irq_pin_list *entry);
> |
> | +static inline void io_apic_modify_irq(unsigned int irq,
> | +                               int mask_and, int mask_or,
> | +                               int mask_and_not, extra_action_t action)
> | +{
> | +       int pin;
> | +       struct irq_cfg *cfg;
> | +       struct irq_pin_list *entry;
> | +       cfg = irq_cfg(irq);
> | +       for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
> | +               unsigned int reg;
> | +               pin = entry->pin;
> | +               reg = io_apic_read(entry->apic, 0x10 + pin * 2);
> | +               reg &= mask_and;
> | +               reg |= mask_or;
> | +               reg &= ~mask_and_not;
> | +               io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
> | +               if (action)
> | +                       action(entry);
> | +       }
> | +}
> |
> | +void extra_read(struct irq_pin_list *entry)
> | +             {
> | +                       /*
> | +                        * Synchronize the IO-APIC and the CPU by doing
> | +                        * a dummy read from the IO-APIC
> | +                        */
> | +                       struct io_apic __iomem *io_apic;
> | +                       io_apic = io_apic_base(entry->apic);
> | +                       readl(&io_apic->data);
> | +               }
> |
> |
> | YH
> |
>
> Yinghai, Ingo, what about this one?
>
>                - Cyrill -
> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: x86: io-apic - get rid of __DO_ACTION macro v3
>
> Replace __DO_ACTION macro with io_apic_modify_irq function.
> This allow us to 'grep' definitions being hided by
> __DO_ACTION macro:
>
>        __unmask_IO_APIC_irq
>        __mask_IO_APIC_irq
>        __mask_and_edge_IO_APIC_irq
>        __unmask_and_level_IO_APIC_irq
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>
> Index: linux-2.6.git/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/io_apic.c        2008-09-09 22:27:57.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/io_apic.c     2008-09-10 22:17:25.000000000 +0400
> @@ -643,65 +643,66 @@ static void __init replace_pin_at_irq(un
>                add_pin_to_irq(irq, newapic, newpin);
>  }
>
> -#define __DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)           \
> -                                                                       \
> -{                                                                      \
> -       int pin;                                                        \
> -       struct irq_cfg *cfg;                                            \
> -       struct irq_pin_list *entry;                                     \
> -                                                                       \
> -       cfg = irq_cfg(irq);                                             \
> -       entry = cfg->irq_2_pin;                                         \
> -       for (;;) {                                                      \
> -               unsigned int reg;                                       \
> -               if (!entry)                                             \
> -                       break;                                          \
> -               pin = entry->pin;                                       \
> -               reg = io_apic_read(entry->apic, 0x10 + R + pin*2);      \
> -               reg ACTION_DISABLE;                                     \
> -               reg ACTION_ENABLE;                                      \
> -               io_apic_modify(entry->apic, 0x10 + R + pin*2, reg);     \
> -               FINAL;                                                  \
> -               if (!entry->next)                                       \
> -                       break;                                          \
> -               entry = entry->next;                                    \
> -       }                                                               \
> -}
> -
> -#define DO_ACTION(name,R, ACTION_ENABLE, ACTION_DISABLE, FINAL)                \
> -                                                                       \
> -       static void name##_IO_APIC_irq (unsigned int irq)               \
> -       __DO_ACTION(R, ACTION_ENABLE, ACTION_DISABLE, FINAL)
> +static inline void io_apic_modify_irq(unsigned int irq,
> +                               int mask_and, int mask_or,
> +                               void (*final)(struct irq_pin_list *entry))
> +{
> +       int pin;
> +       struct irq_cfg *cfg;
> +       struct irq_pin_list *entry;
>
> -/* mask = 0 */
> -DO_ACTION(__unmask,    0, |= 0, &= ~IO_APIC_REDIR_MASKED, )
> +       cfg = irq_cfg(irq);
> +       for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
> +               unsigned int reg;
> +               pin = entry->pin;
> +               reg = io_apic_read(entry->apic, 0x10 + pin * 2);
> +               reg &= mask_and;
> +               reg |= mask_or;
> +               io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
> +               if (final)
> +                       final(entry);
> +       }
> +}
> +
> +static void __unmask_IO_APIC_irq(unsigned int irq)
> +{
> +       io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
> +}
>
>  #ifdef CONFIG_X86_64
> -/*
> - * Synchronize the IO-APIC and the CPU by doing
> - * a dummy read from the IO-APIC
> - */
> -static inline void io_apic_sync(unsigned int apic)
> +void io_apic_sync(struct irq_pin_list *entry)
>  {
> -       struct io_apic __iomem *io_apic = io_apic_base(apic);
> +       /*
> +        * Synchronize the IO-APIC and the CPU by doing
> +        * a dummy read from the IO-APIC
> +        */
> +       struct io_apic __iomem *io_apic;
> +       io_apic = io_apic_base(entry->apic);
>        readl(&io_apic->data);
>  }
>
> -/* mask = 1 */
> -DO_ACTION(__mask,      0, |= IO_APIC_REDIR_MASKED, &= ~0, io_apic_sync(entry->apic))
> -
> -#else
> -
> -/* mask = 1 */
> -DO_ACTION(__mask,      0, |= IO_APIC_REDIR_MASKED, &= ~0, )
> -
> -/* mask = 1, trigger = 0 */
> -DO_ACTION(__mask_and_edge, 0, |= IO_APIC_REDIR_MASKED, &= ~IO_APIC_REDIR_LEVEL_TRIGGER, )
> +static void __mask_IO_APIC_irq(unsigned int irq)
> +{
> +       io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
> +}
> +#else /* CONFIG_X86_32 */
> +static void __mask_IO_APIC_irq(unsigned int irq)
> +{
> +       io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, NULL);
> +}
>
> -/* mask = 0, trigger = 1 */
> -DO_ACTION(__unmask_and_level, 0, |= IO_APIC_REDIR_LEVEL_TRIGGER, &= ~IO_APIC_REDIR_MASKED, )
> +static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
> +{
> +       io_apic_modify_irq(irq, ~IO_APIC_REDIR_LEVEL_TRIGGER,
> +                       IO_APIC_REDIR_MASKED, NULL);
> +}
>
> -#endif
> +static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
> +{
> +       io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED,
> +                       IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
> +}
> +#endif /* CONFIG_X86_32 */
>
>  static void mask_IO_APIC_irq (unsigned int irq)
>  {
>

looks good.

YH
