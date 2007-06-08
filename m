Return-Path: <linux-kernel-owner+w=401wt.eu-S967284AbXFHC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967284AbXFHC3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763753AbXFHC3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:29:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbXFHC3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:29:11 -0400
Date: Thu, 7 Jun 2007 19:28:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] enable interrupts in user path of page fault.
In-Reply-To: <20070607185851.faf36f95.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706071925260.4205@woody.linux-foundation.org>
References: <1181187244.18444.45.camel@localhost.localdomain>
 <20070607185851.faf36f95.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Andrew Morton wrote:
> 
> Interrupts got disabled here because do_page_fault() is an
> interrupt-disabling trap, yes?

Yes - and it has to be: we want to disable preemption and interrupts that 
can fault on the vmalloc space, until we've at least saved away %cr2. We 
had bugs in that area before.

> The patch looks reasonable to me: a slight reduction in interrupt-off
> latency when really weird things are happening.

I applied it as obviously correct.

> The patch also breaks things, I think: if userspace is running with
> interrupts disabled and tries to access kernel memory it will presently
> whizz through the kernel without ever enabling interrupts.  With this
> change, the kernel will now enable interrupts, which is presumably not what
> the application wanted.

Well, we *do* enable interrupts for real page faults anyway, and this 
whole code just triggers for the case where we'd send a SIGSEGV. If some 
silly app really thought it could do that with interrupts disabled, it was 
wrong before too (we'd hit a reschedule point and enable them there 
anyway).

		Linus
