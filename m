Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbXGHLd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbXGHLd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXGHLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:33:18 -0400
Received: from ozlabs.org ([203.10.76.45]:38949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXGHLdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:33:18 -0400
Subject: maps2-add-proc-pid-pagemap-interface.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 21:33:01 +1000
Message-Id: <1183894381.6005.324.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> +#ifdef CONFIG_PROC_PAGEMAP
> +struct pagemapread {
> +	struct mm_struct *mm;
> +	unsigned long next;
> +	unsigned long *buf;
> +	pte_t *ptebuf;
> +	unsigned long pos;
> +	size_t count;
> +	int index;
> +	char __user *out;
> +};
> +
> +static int flush_pagemap(struct pagemapread *pm)
> +{
> +	int n = min(pm->count, pm->index * sizeof(unsigned long));
> +	if (copy_to_user(pm->out, pm->buf, n))
> +		return -EFAULT;
> +	pm->out += n;
> +	pm->pos += n;
> +	pm->count -= n;
> +	pm->index = 0;
> +	cond_resched();
> +	return 0;
> +}

	This is a lot of complexity to buffer output (and the naming is
horrible: s/pagemap/outbuf/ would help this code).  put_user() is pretty
efficient: is this really necessary?

	Oh, and cond_resched() is unnecessary: there's one in copy_to_user.

> +	ret = -EIO;
> +	svpfn = src / sizeof(unsigned long) - 1;
> +	addr = PAGE_SIZE * svpfn;
> +	if ((svpfn + 1) * sizeof(unsigned long) != src)
> +		goto out;

This looks like a very complicated way to test for "*ppos %
sizeof(unsigned long) != 0".
 
You use ppos to count records rather than bytes, and save some
arithmetic here but I guess that breaks your userspace.

> +	evpfn = min((src + count) / sizeof(unsigned long),
> +		    ((~0UL) >> PAGE_SHIFT) + 1);

Why?

The mixing of byte count and record count in this function makes it
quite hard to understand.

> +	ret = -ENOMEM;
> +	page = kzalloc(PAGE_SIZE, GFP_USER);
> +	if (!page)
> +		goto out;
> +
> +#ifdef CONFIG_HIGHPTE
> +	pm.ptebuf = kzalloc(PAGE_SIZE, GFP_USER);
> +	if (!pm.ptebuf)
> +		goto out_free;
> +#endif

I'm not sure either of these needs to be kzalloc'ed.  And the fact that
your buffer is a page long is an arbitrary choice: it'd be better using
a separate BUF_SIZE constant.

Oh, and while we're here, can someone clarify GFP_USER vs GFP_KERNEL?

> +	if (svpfn == -1) {
> +		add_to_pagemap(pm.next, 0, &pm);
> +		((char *)page)[0] = (ntohl(1) != 1);
> +		((char *)page)[1] = PAGE_SHIFT;
> +		((char *)page)[2] = sizeof(unsigned long);
> +		((char *)page)[3] = sizeof(unsigned long);
> +	}

I think it would simplify the code if you move this to the top of the
function, and copy these directly to userspace and return a short read.

And how about "cpu_to_le16(1) == 1" instead of "ntohl(1) != 1"?

> +	while (pm.count > 0 && vma) {
> +		if (!ptrace_may_attach(task)) {
> +			ret = -EIO;
> +			goto out_mm;
> +		}

You already checked ptrace_may_attach() earlier in this function; do you
need to do that again?

> +		vend = min(vma->vm_start - 1, end - 1) + 1;
> +		ret = pagemap_fill(&pm, vend);
> +		if (ret || !pm.count)
> +			break;
> +		vend = min(vma->vm_end - 1, end - 1) + 1;
> +		ret = walk_page_range(mm, vma->vm_start, vend,
> +				      &pagemap_walk, &pm);
> +		vma = vma->vm_next;
> +	}
> +	up_read(&mm->mmap_sem);
> +
> +	ret = pagemap_fill(&pm, end);

If the first pagemap_fill() fails, you still try again outside the
loop).  That's a minor nit: the second call should fail the same.  But
assigning the return value from walk_page_range() and then ignoring it?

This function keeps variables containing the beginning ("src") in bytes
(in both a local var and inside the struct pagemapread), the count in
bytes (also in two places), the start and end page numbers, the virtual
address of the start (two places), and the virtual address of the end.

I'm pretty sure it could be clarified significantly with a little
love...

Cheers,
Rusty.


