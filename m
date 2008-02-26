Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbYBZRUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbYBZRUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYBZRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:20:10 -0500
Received: from vena.lwn.net ([206.168.112.25]:41973 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYBZRUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:20:09 -0500
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mmiotrace full patch, preview 1 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sun, 24 Feb 2008 19:03:23 +0200."
             <20080224190323.77adf683@daedalus.pq.iki.fi> 
Date: Tue, 26 Feb 2008 10:20:08 -0700
Message-ID: <1892.1204046408@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Pekka,

A couple of little things I noticed...

> +static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
> +{
> +	int ret = 0;
> +	struct kmmio_probe *probe;
> +	struct kmmio_fault_page *faultpage;
> +	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
> +
> +	if (!ctx->active)
> +		goto out;

Should that text read something like:

	if (condition != DIE_TRAP || !ctx->active)

Presumably you won't be active if something else is going wrong, but one
never knows.

> +int register_kmmio_probe(struct kmmio_probe *p)
> +{
> +	int ret = 0;
> +	unsigned long size = 0;
> +
> +	spin_lock_irq(&kmmio_lock);
> +	kmmio_count++;
> +	if (get_kmmio_probe(p->addr)) {
> +		ret = -EEXIST;
> +		goto out;
> +	}

That only checks the first page; if the probed region partially overlaps
another one found later in memory, the registration will succeed.

Maybe you want to decrement kmmio_count if you decide to return -EEXIST
(or hold off on the increment until after the test)?

In general, I worry about what happens if an interrupt handler generates
traced MMIO traffic while a fault handler is active.  It looks a lot
like the "all hell breaks loose" scenario mentioned in the comments.  Is
there some way of preventing that which I missed?  Otherwise, maybe,
should the ioremap() wrappers take an additional argument, being an IRQ
to disable while trace handlers are active?

jon
