Return-Path: <linux-kernel-owner+w=401wt.eu-S967185AbXFHCAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967185AbXFHCAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965302AbXFHB7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:59:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965033AbXFHB7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:59:53 -0400
Date: Thu, 7 Jun 2007 18:58:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] enable interrupts in user path of page fault.
Message-Id: <20070607185851.faf36f95.akpm@linux-foundation.org>
In-Reply-To: <1181187244.18444.45.camel@localhost.localdomain>
References: <1181187244.18444.45.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 23:34:04 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This is a minor fix, but what is currently there is essentially wrong.
> In do_page_fault, if the faulting address from user code happens to be
> in kernel address space (int *p = (int*)-1; p = 0xbed;)  then the
> do_page_fault handler will jump over the local_irq_enable with the
> 
>   goto bad_area_nosemaphore;
> 
> But the first line there sees this is user code and goes through the
> process of sending a signal to send SIGSEGV to the user task. This whole
> time interrupts are disabled and the task can not be preempted by a
> higher priority task.
> 
> This patch always enables interrupts in the user path of the
> bad_area_nosemaphore.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
> index 29d7d61..1ecb3e4 100644
> --- a/arch/i386/mm/fault.c
> +++ b/arch/i386/mm/fault.c
> @@ -458,6 +458,11 @@ bad_area:
>  bad_area_nosemaphore:
>  	/* User mode accesses just cause a SIGSEGV */
>  	if (error_code & 4) {
> +		/*
> +		 * It's possible to have interrupts off here.
> +		 */
> +		local_irq_enable();
> +

Interrupts got disabled here because do_page_fault() is an
interrupt-disabling trap, yes?

The patch looks reasonable to me: a slight reduction in interrupt-off
latency when really weird things are happening.

The patch also breaks things, I think: if userspace is running with
interrupts disabled and tries to access kernel memory it will presently
whizz through the kernel without ever enabling interrupts.  With this
change, the kernel will now enable interrupts, which is presumably not what
the application wanted.

However it's surely already the case that most pagefaults will go and
enable interrupts on this process anyway, so no big loss there.  I'd expect
the kernel to spit piles of might_sleep() warnings when all this happens, so
maybe it just doesn't happen for some reason.

