Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZCCJqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZCCJqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZCCJp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:45:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41160 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbZCCJp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:45:58 -0500
Date: Tue, 3 Mar 2009 10:45:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303094534.GA31983@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu> <200903021837.08635.david-b@pacbell.net> <1236072446.18955.44.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236072446.18955.44.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2009-03-02 at 18:37 -0800, David Brownell wrote:
> > No.  But I did get a non-response that didn't include any
> > explanation, and relied totally on unfounded assertions
> > combined with the presumption that someday IRQF_DISABLED
> > will be forced on in all drivers.
> 
> Enabling IRQs in hardirq context is BAD because:
> 
>  - IRQ handler nesting leads to stack overflow
>  - It gives the false impression its OK for IRQ handlers to be slow,
>    it is _NOT_, as you still generate horrible preemption latency.
> 
> Therefore IRQF_DISABLED _will_ be forced on everybody some day 
> soon, and I'll provide an IRQF_ENABLED for use by broken 
> hardware only (and make a TAINT flag for that too).

Basically the problem why !IRQF_DISABLED is bad that if there 
are enough interrupt handlers we can get nesting like this:

  <irq 20>
  <handler runs with irqs enabled>
      <irq 21>
      <handler runs with irqs enabled>
          <irq 22>
          <handler runs with irqs enabled>
              <irq 23>
              <handler runs with irqs enabled>
                  <irq 24>
                  <handler runs with irqs enabled>

Suppose each handler gets interruped while it already used up 
1000 bytes of the stack (conservative estimation - often it's 
more) - the above sequence is already 5000 bytes into the stack.

There is no protection against stack overflow there and such 
bugs can be _very_ hard to trigger and find. If there's a 
sufficient number of devices and a high enough load it can 
trigger spuriously.

Yes, in a few limited embedded environments where you dont have 
more than 3-4 IRQ sources you might decide that it's safe to do 
(or you might decide that you dont care). Also, there's a few 
legacy pieces of hardware with either very long hw access 
latencies or too short buffers. Plus there might be any number 
of other hw factors - or architecture details (such as the use 
of separate per IRQ stacks) that limit IRQ handler parallelism 
in practice.

So we'll have the quirk flag for the weird cases - but these are 
the exceptions that strengthen the general rule. The concept of 
enabling interrupts in a hardirq handler is a no-no on a general 
purpose kernel and no modern driver should make use of it.

I hope this explains why lockdep never supported this case.

	Ingo
