Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYGQVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYGQVtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYGQVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:49:41 -0400
Received: from xenotime.net ([66.160.160.81]:33891 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753043AbYGQVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:49:40 -0400
Date: Thu, 17 Jul 2008 14:49:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] kmemcheck: add the kmemcheck core
Message-Id: <20080717144933.8951a558.rdunlap@xenotime.net>
In-Reply-To: <20080716002329.GH12564@localhost.localdomain>
References: <20080716002329.GH12564@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 02:23:29 +0200 Vegard Nossum wrote:

> >From fcd8f514a8962ea22aafb831b9f22a2ea1a13870 Mon Sep 17 00:00:00 2001

eh?

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 4 Apr 2008 00:51:41 +0200
> Subject: [PATCH 07/13] kmemcheck: add the kmemcheck core
> 
> General description: kmemcheck is a patch to the linux kernel that
> detects use of uninitialized memory. It does this by trapping every
> read and write to memory that was allocated dynamically (e.g. using
> kmalloc()). If a memory address is read that has not previously been
> written to, a message is printed to the kernel log.
> 
> (Thanks to Andi Kleen for the set_memory_4k() solution.)
> 
> Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
> ---

> diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
> new file mode 100644
> index 0000000..843a63c
> --- /dev/null
> +++ b/Documentation/kmemcheck.txt
> @@ -0,0 +1,135 @@

Doc looks good.  Thanks.


> diff --git a/arch/x86/mm/kmemcheck/error.h b/arch/x86/mm/kmemcheck/error.h
> new file mode 100644
> index 0000000..0efc2e8
> --- /dev/null
> +++ b/arch/x86/mm/kmemcheck/error.h
> @@ -0,0 +1,15 @@
> +#ifndef ARCH__X86__MM__KMEMCHECK__ERROR_H
> +#define ARCH__X86__MM__KMEMCHECK__ERROR_H

We don't usually use double __ here.

> +
> +#include <linux/ptrace.h>
> +
> +#include "shadow.h"
> +
> +void kmemcheck_error_save(enum kmemcheck_shadow state,
> +	unsigned long address, unsigned int size, struct pt_regs *regs);
> +
> +void kmemcheck_error_save_bug(struct pt_regs *regs);
> +
> +void kmemcheck_error_recall(void);
> +
> +#endif

> diff --git a/arch/x86/mm/kmemcheck/string.c b/arch/x86/mm/kmemcheck/string.c
> new file mode 100644
> index 0000000..0d21d22
> --- /dev/null
> +++ b/arch/x86/mm/kmemcheck/string.c
> @@ -0,0 +1,91 @@
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/kmemcheck.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +#include "shadow.h"
> +#include "smp.h"
> +
> +/*
> + * A faster implementation of memset() when tracking is enabled where the
> + * whole memory area is within a single page.
> + */
> +static void memset_one_page(void *s, int c, size_t n)
> +{
> +	unsigned long addr;
> +	void *x;
> +	unsigned long flags;
> +
> +	addr = (unsigned long) s;
> +
> +	x = kmemcheck_shadow_lookup(addr);
> +	if (!x) {
> +		/* The page isn't being tracked. */
> +		__memset(s, c, n);
> +		return;
> +	}
> +
> +	/* While we are not guarding the page in question, nobody else
> +	 * should be able to change them. */
> +	local_irq_save(flags);
> +
> +	kmemcheck_pause_allbutself();
> +	kmemcheck_show_addr(addr);
> +	__memset(s, c, n);
> +	__memset(x, KMEMCHECK_SHADOW_INITIALIZED, n);
> +	if (kmemcheck_enabled)
> +		kmemcheck_hide_addr(addr);
> +	kmemcheck_resume();
> +
> +	local_irq_restore(flags);
> +}
> +
> +/*
> + * A faster implementation of memset() when tracking is enabled. We cannot
> + * assume that all pages within the range are tracked, so copying has to be
> + * split into page-sized (or smaller, for the ends) chunks.
> + */
> +void *kmemcheck_memset(void *s, int c, size_t n)
> +{
> +	unsigned long addr;
> +	unsigned long start_page, start_offset;
> +	unsigned long end_page, end_offset;
> +	unsigned long i;
> +
> +	if (!n)
> +		return s;
> +
> +	if (!slab_is_available()) {
> +		__memset(s, c, n);
> +		return s;
> +	}
> +
> +	addr = (unsigned long) s;
> +
> +	start_page = addr & PAGE_MASK;
> +	end_page = (addr + n) & PAGE_MASK;
> +
> +	if (start_page == end_page) {
> +		/* The entire area is within the same page. Good, we only
> +		 * need one memset(). */
> +		memset_one_page(s, c, n);
> +		return s;
> +	}
> +
> +	start_offset = addr & ~PAGE_MASK;
> +	end_offset = (addr + n) & ~PAGE_MASK;
> +
> +	/* Clear the head, body, and tail of the memory area. */
> +	if (start_offset < PAGE_SIZE)
> +		memset_one_page(s, c, PAGE_SIZE - start_offset);
> +	for (i = start_page + PAGE_SIZE; i < end_page; i += PAGE_SIZE)
> +		memset_one_page((void *) i, c, PAGE_SIZE);
> +	if (end_offset > 0)
> +		memset_one_page((void *) end_page, c, end_offset);
> +
> +	return s;
> +}
> +
> +EXPORT_SYMBOL(kmemcheck_memset);

We would prefer to have kernel-doc on exported functions...


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
