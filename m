Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbXEHWOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbXEHWOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXEHWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:14:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41182 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753135AbXEHWOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:14:17 -0400
From: John Keller <jpk@sgi.com>
Message-Id: <200705082214.l48MEDKH065115@fcbayern.americas.sgi.com>
Subject: Re: [PATCH Resend] - SN: validate smp_affinity mask on intr
To: akpm@linux-foundation.org (Andrew Morton)
Date: Tue, 8 May 2007 17:14:12 -0500 (CDT)
Cc: tony.luck@intel.com (Luck Tony), pj@sgi.com (Paul Jackson),
       jpk@sgi.com (John Keller), linux-kernel@vger.kernel.org,
       steiner@sgi.com, linux-ia64@vger.kernel.org
In-Reply-To: <20070508133430.f5eef0c1.akpm@linux-foundation.org> from "Andrew Morton" at May 08, 2007 01:34:30 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, 8 May 2007 13:14:26 -0700
> "Luck, Tony" <tony.luck@intel.com> wrote:
> 
> > > It had a dopey little bug:
> > >
> > > -#define is_affinity_mask_valid() 1
> > > +#define is_affinity_mask_valid(val) 1
> > 
> > That would fix warnings on non-ia64 systems (which is
> > a step in the right direction).  But on ia64 I have
> > the
> > 
> > #define is_affinity_mask_valid is_affinity_mask_valid
> > 
> > in play at that point, so I have a real function call
> > which doesn't have an in-scope declaration, so I get:
> > 
> > kernel/irq/proc.c:49: warning: implicit declaration of function `is_affinity_mask_valid'
> > 
> 
> hm, I wonder if John sent the right patch.


I sure thought I had sent the right patch, but obviously not.
Thanks for setting things straight.

John


> 
> The obvious fix fixes it up for me:
> 
> --- a/include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect-fix-2
> +++ a/include/asm-ia64/irq.h
> @@ -11,6 +11,9 @@
>   * 02/29/00     D.Mosberger	moved most things into hw_irq.h
>   */
>  
> +#include <linux/types.h>
> +#include <linux/cpumask.h>
> +
>  #define NR_IRQS		256
>  #define NR_IRQ_VECTORS	NR_IRQS
>  
> @@ -29,6 +32,7 @@ extern void disable_irq (unsigned int);
>  extern void disable_irq_nosync (unsigned int);
>  extern void enable_irq (unsigned int);
>  extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
> +bool is_affinity_mask_valid(cpumask_t cpumask);
>  
>  #define is_affinity_mask_valid is_affinity_mask_valid
>  
> _
> 
> but the new includes are always a worry.
> 
> We need the cpumask.h include because we went and created a stupid typedef.
>  I think at the time we did this because cpumask_t could optionally be a
> plain old "long".  However I don't think we ended up doing that so we could
> now do:
> 
> -typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
> +typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
> 
> and then we can forward-declare `struct cpumask' in include/asm-ia64/irq.h
> rather than adding the nested include.
> 
> 
> 

