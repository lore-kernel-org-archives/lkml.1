Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbXGIWbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbXGIWbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbXGIWbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:31:37 -0400
Received: from waste.org ([66.93.16.53]:56771 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbXGIWbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:31:36 -0400
Date: Mon, 9 Jul 2007 17:31:02 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maps2-add-proc-pid-pagemap-interface.patch
Message-ID: <20070709223101.GW11115@waste.org>
References: <1183894381.6005.324.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183894381.6005.324.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 09:33:01PM +1000, Rusty Russell wrote:
> Hi Matt,
> 
> > +#ifdef CONFIG_PROC_PAGEMAP
> > +struct pagemapread {
> > +	struct mm_struct *mm;
> > +	unsigned long next;
> > +	unsigned long *buf;
> > +	pte_t *ptebuf;
> > +	unsigned long pos;
> > +	size_t count;
> > +	int index;
> > +	char __user *out;
> > +};
> > +
> > +static int flush_pagemap(struct pagemapread *pm)
> > +{
> > +	int n = min(pm->count, pm->index * sizeof(unsigned long));
> > +	if (copy_to_user(pm->out, pm->buf, n))
> > +		return -EFAULT;
> > +	pm->out += n;
> > +	pm->pos += n;
> > +	pm->count -= n;
> > +	pm->index = 0;
> > +	cond_resched();
> > +	return 0;
> > +}
> 
> 	This is a lot of complexity to buffer output (and the naming is
> horrible: s/pagemap/outbuf/ would help this code).  put_user() is pretty
> efficient: is this really necessary?

No, and it's also broken. It can deadlock if the user unmaps the page
in another thread.

I've got a fix using getuserpages but it's crashing on my system at
the moment (but not in lguest!).

> > +	ret = -EIO;
> > +	svpfn = src / sizeof(unsigned long) - 1;
> > +	addr = PAGE_SIZE * svpfn;
> > +	if ((svpfn + 1) * sizeof(unsigned long) != src)
> > +		goto out;
> 
> This looks like a very complicated way to test for "*ppos %
> sizeof(unsigned long) != 0".
>  
> You use ppos to count records rather than bytes, and save some
> arithmetic here but I guess that breaks your userspace.
> 
> > +	evpfn = min((src + count) / sizeof(unsigned long),
> > +		    ((~0UL) >> PAGE_SHIFT) + 1);
> 
> Why?
> 
> The mixing of byte count and record count in this function makes it
> quite hard to understand.

Agreed.

> > +	ret = -ENOMEM;
> > +	page = kzalloc(PAGE_SIZE, GFP_USER);
> > +	if (!page)
> > +		goto out;
> > +
> > +#ifdef CONFIG_HIGHPTE
> > +	pm.ptebuf = kzalloc(PAGE_SIZE, GFP_USER);
> > +	if (!pm.ptebuf)
> > +		goto out_free;
> > +#endif
> 
> I'm not sure either of these needs to be kzalloc'ed.  And the fact that
> your buffer is a page long is an arbitrary choice: it'd be better using
> a separate BUF_SIZE constant.

Well it's not really arbitrary. But these go away in my WIP code.

> > +	if (svpfn == -1) {
> > +		add_to_pagemap(pm.next, 0, &pm);
> > +		((char *)page)[0] = (ntohl(1) != 1);
> > +		((char *)page)[1] = PAGE_SHIFT;
> > +		((char *)page)[2] = sizeof(unsigned long);
> > +		((char *)page)[3] = sizeof(unsigned long);
> > +	}
> 
> I think it would simplify the code if you move this to the top of the
> function, and copy these directly to userspace and return a short read.

Done.

> And how about "cpu_to_le16(1) == 1" instead of "ntohl(1) != 1"?

Why?
 
> > +	while (pm.count > 0 && vma) {
> > +		if (!ptrace_may_attach(task)) {
> > +			ret = -EIO;
> > +			goto out_mm;
> > +		}
> 
> You already checked ptrace_may_attach() earlier in this function; do you
> need to do that again?

I think so. Consider exec(). This whole area is full of interesting
traps and it pays to be paranoid.

-- 
Mathematics is the supreme nostalgia of our time.
