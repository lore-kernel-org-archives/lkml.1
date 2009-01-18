Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZARIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZARIl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZARIlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:41:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZARIlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:41:46 -0500
Date: Sun, 18 Jan 2009 09:41:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] x86-64: Remove the PDA
Message-ID: <20090118084134.GC21940@elte.hu>
References: <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com> <1232115396-26367-13-git-send-email-brgerst@gmail.com> <1232115396-26367-14-git-send-email-brgerst@gmail.com> <1232115396-26367-15-git-send-email-brgerst@gmail.com> <1232115396-26367-16-git-send-email-brgerst@gmail.com> <4972B5A1.9090708@kernel.org> <73c1f2160901172346k3d6170eeqd733724e3af84e95@mail.gmail.com> <4972E4AC.9080000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4972E4AC.9080000@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Brian.
> 
> Brian Gerst wrote:
> >> How about something like the following?
> >>
> >> #define CANARY_OFFSET   40
> >> #define CANARY_SIZE     8
> >>
> >> DECLARE_PER_CPU(unsigned long, stack_canary);
> >>
> >> and in linker script,
> >>
> >> PERCPU_VADDR_PREALLOC(0, :percpu, CANARY_OFFSET + CANARY_SIZE)
> >> per_cpu__stack_canary = __per_cpu_start + CANARY_OFFSET;
> >>
> > 
> > The thing I don't like about the prealloc method is that it puts the
> > page-aligned variables at the end.  This leaves a gap which is
> > unavailable for dynamic allocations.  Stealing 48 bytes from the
> > bottom of the irqstack (which is 16k) keeps the page-aligned section
> > at the start.  It's really no different than how the thread_info
> > structure sits at the bottom of the process stack.
> > 
> > How about something like:
> > union irq_stack_union {
> > 	char irq_stack[IRQSTACKSIZE];
> > 	struct {
> > 		char pad[40];
> > 		unsigned long stack_canary;
> > 	}
> > };
> > 
> > That documents the overlay better, and avoids having to touch the
> > linker script.
> 
> I have no objection as long as it's sufficiently documented.

There is another advantage from Brian's trick of reusing the IRQ stack 
bottom: if we ever overflow the IRQ stack the kernel will likely stomp on 
the canary and overwrite it, and then (if the user runs on a 
stackprotector kernel) we will get an instantaneous assert and backtrace, 
exactly where the overflow happened.

Small overflows are otherwise rather hard to catch right on the spot so 
this is a bonus.

	Ingo
