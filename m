Return-Path: <linux-kernel-owner+w=401wt.eu-S967268AbXFHCH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967268AbXFHCH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967132AbXFHCHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:07:42 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:64603 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967027AbXFHCHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:07:41 -0400
Subject: Re: [PATCH] enable interrupts in user path of page fault.
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070607185851.faf36f95.akpm@linux-foundation.org>
References: <1181187244.18444.45.camel@localhost.localdomain>
	 <20070607185851.faf36f95.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 22:06:46 -0400
Message-Id: <1181268406.10408.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 18:58 -0700, Andrew Morton wrote:
> On Wed, 06 Jun 2007 23:34:04 -0400

> Interrupts got disabled here because do_page_fault() is an
> interrupt-disabling trap, yes?

Correct.

> 
> The patch looks reasonable to me: a slight reduction in interrupt-off
> latency when really weird things are happening.
> 
> The patch also breaks things, I think: if userspace is running with
> interrupts disabled and tries to access kernel memory it will presently
> whizz through the kernel without ever enabling interrupts.  With this
> change, the kernel will now enable interrupts, which is presumably not what
> the application wanted.

I didn't realize that userspace was allowed to run with interrupts
disabled. If this becomes a problem, we can add the same check that's
above where do_page_fault does enable interrupts, but is skipped because
the faulting address was above PAGE_OFFSET.


ie. (i386)
        if (regs->eflags & (X86_EFLAGS_IF|VM_MASK))
                local_irq_enable();


> 
> However it's surely already the case that most pagefaults will go and
> enable interrupts on this process anyway, so no big loss there.  I'd expect
> the kernel to spit piles of might_sleep() warnings when all this happens, so
> maybe it just doesn't happen for some reason.

Actually it does on the RT kernel. Hence why I found it ;-)

-- Steve


