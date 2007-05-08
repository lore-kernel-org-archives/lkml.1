Return-Path: <linux-kernel-owner+w=401wt.eu-S966432AbXEHUel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966432AbXEHUel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966234AbXEHUeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:34:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966143AbXEHUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:34:34 -0400
Date: Tue, 8 May 2007 13:34:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>, Paul Jackson <pj@sgi.com>
Cc: "John Keller" <jpk@sgi.com>, <linux-kernel@vger.kernel.org>,
       <steiner@sgi.com>, <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH Resend] - SN: validate smp_affinity mask on intr
 redirect
Message-Id: <20070508133430.f5eef0c1.akpm@linux-foundation.org>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01719BB8@scsmsx411.amr.corp.intel.com>
References: <20070508121945.3e8d29c1.akpm@linux-foundation.org>
	<617E1C2C70743745A92448908E030B2A01719BB8@scsmsx411.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 13:14:26 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> > It had a dopey little bug:
> >
> > -#define is_affinity_mask_valid() 1
> > +#define is_affinity_mask_valid(val) 1
> 
> That would fix warnings on non-ia64 systems (which is
> a step in the right direction).  But on ia64 I have
> the
> 
> #define is_affinity_mask_valid is_affinity_mask_valid
> 
> in play at that point, so I have a real function call
> which doesn't have an in-scope declaration, so I get:
> 
> kernel/irq/proc.c:49: warning: implicit declaration of function `is_affinity_mask_valid'
> 

hm, I wonder if John sent the right patch.

The obvious fix fixes it up for me:

--- a/include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect-fix-2
+++ a/include/asm-ia64/irq.h
@@ -11,6 +11,9 @@
  * 02/29/00     D.Mosberger	moved most things into hw_irq.h
  */
 
+#include <linux/types.h>
+#include <linux/cpumask.h>
+
 #define NR_IRQS		256
 #define NR_IRQ_VECTORS	NR_IRQS
 
@@ -29,6 +32,7 @@ extern void disable_irq (unsigned int);
 extern void disable_irq_nosync (unsigned int);
 extern void enable_irq (unsigned int);
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
+bool is_affinity_mask_valid(cpumask_t cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
_

but the new includes are always a worry.

We need the cpumask.h include because we went and created a stupid typedef.
 I think at the time we did this because cpumask_t could optionally be a
plain old "long".  However I don't think we ended up doing that so we could
now do:

-typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;

and then we can forward-declare `struct cpumask' in include/asm-ia64/irq.h
rather than adding the nested include.


