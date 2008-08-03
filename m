Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYHCF6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYHCF6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYHCF60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:58:26 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:57267 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYHCF6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uTWHKRMMZX0DT41b9M+5jTQLRC+AXADaj3AUeaz6VuVELrVk5uqE3PYckOODsUOs72
         DPf4/AprVziSBumW7zZRERnu3kagvXRQojZMfOP+v+J+CP3pACdG8siYLWL02hIehVm4
         urWBcShuQtGU7pPH/a5Zi4ZUeA33t0cD4i6/k=
Message-ID: <86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com>
Date: Sat, 2 Aug 2008 22:58:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86_64: Restore the proper NR_IRQS define so larger systems work.
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m18wveacu6.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	 <m18wveacu6.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 10:26 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> As pointed out and tracked by Yinghai Lu <yhlu.kernel@gmail.com>:
>
> Dhaval Giani got:
> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
> invalid opcode: 0000 [1] SMP
> CPU 24
> ...
>
> his system (x3950) has 8 ioapic, irq > 256
>
> This was caused by:
>        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>        Author: Thomas Gleixner <tglx@linutronix.de>
>        Date:   Fri May 2 20:10:09 2008 +0200
>
>           x86: unify interrupt vector defines
>
>           The interrupt vector defines are copied 4 times around with minimal
>           differences. Move them all into asm-x86/irq_vectors.h
>
> It appears that Thomas did not notice that x86_64 does something
> completely different when he merge irq_vectors.h
>
> We can solve this for 2.6.27 by simply reintroducing the old heuristic
> for setting NR_IRQS on x86_64 to a usable value, which trivially removes
> the regression.
>
> Long term it would be nice to harmonize the handling of ioapic interrupts
> of x86_32 and x86_64 so we don't have this kind of confusion.
>
> Dhaval Giani <dhaval@linux.vnet.ibm.com> tested an earlier version of
> this patch by YH which confirms simply increasing NR_IRQS fixes the
> problem.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/asm-x86/irq_vectors.h |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
> index 90b1d1f..a13eb6c 100644
> --- a/include/asm-x86/irq_vectors.h
> +++ b/include/asm-x86/irq_vectors.h
> @@ -109,7 +109,15 @@
>  #define LAST_VM86_IRQ          15
>  #define invalid_vm86_irq(irq)  ((irq) < 3 || (irq) > 15)
>
> -#if !defined(CONFIG_X86_VOYAGER)
> +#ifdef CONFIG_X86_64
> +# if NR_CPUS < MAX_IO_APICS
> +#  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
> +# else
> +#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS ))
> +# endif
> +# define NR_IRQ_VECTORS NR_IRQS
> +
> +#elif !defined(CONFIG_X86_VOYAGER)
>
>  # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
>

what should xen pv 64 get for NR_IRQS?

YH
