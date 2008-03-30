Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYC3R03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYC3R03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 13:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYC3R0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 13:26:20 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:57028 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYC3R0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 13:26:19 -0400
Date: Sun, 30 Mar 2008 20:26:08 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com
Subject: Re: mmiotrace bug: recursive probe hit
Message-ID: <20080330202608.054702a4@daedalus.pq.iki.fi>
In-Reply-To: <20080328222500.21863a44@daedalus.pq.iki.fi>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	<20080328222500.21863a44@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 22:25:00 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> A recursive probe hit means that kmmio_handler() is called twice without a
> a call to post_kmmio_handler() in between. This situation is explicitly
> checked for (if (ctx->active)), and the current solution is to ignore the
> fault and fall through to do_page_fault() triggering an error there.
> According to experience, this does not happen on a uniprocessor machine.
> 
> However, on an SMP machine this can occasionally occur. I have reproduced
> it on my Core 2 Duo laptop while tracing the blob. Recursive probe hit
> is very rare compared to the events logged, I can run two glxgears at the
> same time for half an hour generating at least millions of events and never
> hit it. Repeatedly start and stop a single glxgears, and I have a fairly
> good chance of hitting it. It is random, but reproducible.

It appears this happens:

          CPU 0           CPU 1
 ,--->  fault           fault
 |      disarm          disarm
 |                      single step
 |                      arm
 |      single step
 '--------'
        arm

and the both cpus are faulting on the same page. I guess one cpu is running
an nvidia interrupt service.
I see three possible solutions:

A) Like in this patch, just disarm again and hope for the best.
Seems to work ok. I also compare the fault address to the saved address
ctx->addr. If they are equal, it is a "double probe hit" and harmless.
If they are not equal, it is a real "recursive probe hit" and something
more is wrong. With these definitions, recursive probe hits are gone in
my experiments on Intel Core 2 Duo.

> Next, after discussion with Enberg and Nossum, I tried the following patch:
> 
> @@ -272,6 +272,9 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
>                 pr_emerg("kmmio: recursive probe hit on CPU %d, "
>                                         "for address 0x%08lx. Ignoring.\n",
>                                         smp_processor_id(), addr);
> +               pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
> +                                       ctx->addr);
> +               disarm_kmmio_fault_page(faultpage->page, NULL);
>                 goto no_kmmio_ctx;
>         }
>         ctx->active++;

B) Acquire a spinlock in kmmio_handler() and release it in
post_kmmio_handler(). I don't like this one since I spent some effort
making the fault path spinlockless, but at least this would be a
completely separate spinlock. Or we could use per-page spinlocks.

C) Vegard mentioned something about per-cpu page tables for kmemcheck.
This would be the ultimate solution, because it would solve two problems:
- recursive probe hits
- missed events due to another cpu disarming the page for single stepping
Would it be possible to have a single temporary per-cpu pte?

I understood kmemcheck has similar issues. Of course, one could force the
system down to a single running CPU, but that feels nasty.

Which way to go?
I choose A) as the current workaround, keeping in mind that I will loose
events on SMP. C) would be the only reliable SMP solution on tracing point
of view.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
