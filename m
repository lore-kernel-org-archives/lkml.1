Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYIIUN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYIIUN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYIIUNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:13:47 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59433 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYIIUNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qkTA47PLRYobWc6jqxLKh1SKtAifr6hls3kMtM0lIu4v0uvna66XHjoZnJsNlEBh9j
         gH3Zi2DsD7PrIeuPhbI19o1HfwvNy2L3YoTG8iRxMGqY7f7O4JhKdmNAIZqA1PbfF/FR
         q+0k1V7uggnTOECmWKoj4uNvBb7LxkFXe5LuM=
Message-ID: <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
Date: Tue, 9 Sep 2008 13:13:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080909184615.GA7303@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 11:46 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Replace __DO_ACTION macro with io_apic_modify_irq function.
> This allow us to 'grep' definitions being hided by
> the macro, ie the following:
>
>        __unmask_IO_APIC_irq
>        __mask_IO_APIC_irq
>        __mask_and_edge_IO_APIC_irq
>        __unmask_and_level_IO_APIC_irq
>
> Also I removed R parameter which was to define offset inside
> route table but always being zero for now and I don't think
> if it ever will be other then that.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
> Please review. This modification doesn't map object file into the
> same former state 'cause of 'for(entry)' cycle form changed and
> new mask 'mask_and_not' added to be able to fill register with
> pure zeros - ie clear register completely.
>
> Any comments are quite welcome!
>
> Index: linux-2.6.git/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/io_apic.c        2008-09-09 22:27:57.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/io_apic.c     2008-09-09 22:34:03.000000000 +0400
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
> +                               int mask_and_not, int read_after_mod)
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
> +               if (mask_and)
> +                       reg &= mask_and;

if mask_and == 0, you don't need to clear it ?

> +               if (mask_or)
> +                       reg |= mask_or;
> +               if (mask_and_not)
> +                       reg &= !mask_and_not;

it seems you should use ~ instead of !

> +               io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
> +               if (read_after_mod) {
> +                       /*
> +                        * Synchronize the IO-APIC and the CPU by doing
> +                        * a dummy read from the IO-APIC
> +                        */
> +                       struct io_apic __iomem *io_apic;
> +                       io_apic = io_apic_base(entry->apic);
> +                       readl(&io_apic->data);

hope we can keep using MACRO..

YH
