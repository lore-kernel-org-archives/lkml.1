Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbXHHKDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbXHHKDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbXHHKCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:48268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Date: Wed, 8 Aug 2007 12:00:12 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <1186546847263-git-send-email-gcosta@redhat.com> <11865468513077-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865468513077-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081200.13669.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +config PARAVIRT
> +       bool "Paravirtualization support (EXPERIMENTAL)"

This should be hidden and selected by the clients as needed
(I already did this change on i386) 

Users know nothing about paravirt, they just know about Xen, lguest
etc.

Strictly you would at least need a !X86_VSMP dependency, but
with the vsmp change i requested that will be unnecessary

Is this really synced with the latest version of the i386 code?


> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#endif


> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/efi.h>
> +#include <linux/bcd.h>
> +#include <linux/start_kernel.h>
> +
> +#include <asm/bug.h>
> +#include <asm/paravirt.h>
> +#include <asm/desc.h>
> +#include <asm/setup.h>
> +#include <asm/irq.h>
> +#include <asm/delay.h>
> +#include <asm/fixmap.h>
> +#include <asm/apic.h>
> +#include <asm/tlbflush.h>
> +#include <asm/msr.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +#include <asm/proto.h>
> +#include <asm/e820.h>
> +#include <asm/time.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/smp.h>
> +#include <asm/irqflags.h>


Are the includes really all needed?


> +	if (opfunc == NULL)
> +		/* If there's no function, patch it with a ud2a (BUG) */
> +		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);

This will actually give corrupted BUGs because you don't supply
the full inline BUG header. Perhaps another trap would be better.


> +EXPORT_SYMBOL(paravirt_ops);

Definitely _GPL at least.



> +extern struct paravirt_ops paravirt_ops;

Should be native_paravirt_ops I guess

> +
> + * This generates an indirect call based on the operation type number.

The macros here don't

> +static inline unsigned long read_msr(unsigned int msr)
> +{
> +	int __err;

No need for __ in inlines

> +/* The paravirtualized I/O functions */
> +static inline void slow_down_io(void) {

I doubt this needs to be inline and it's large

> +	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)

No __*__ in new code please

> +			     : "=a"(f)
> +			     : paravirt_type(save_fl),
> +			       paravirt_clobber(CLBR_RAX)
> +			     : "memory", "cc");
> +	return f;
> +}
> +
> +static inline void raw_local_irq_restore(unsigned long f)
> +{
> +	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
> +			     :
> +			     : "D" (f),

Have you investigated if a different input register generates better/smaller 
code? I would assume rdi to be usually used already for the caller's 
arguments so it will produce spilling

Similar for the rax return in the other functions.



-Andi
