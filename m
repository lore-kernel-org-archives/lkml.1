Return-Path: <linux-kernel-owner+w=401wt.eu-S1765108AbZD3Rvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765108AbZD3Rvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZD3RZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:25:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbZD3RZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:25:36 -0400
Date: Thu, 30 Apr 2009 19:23:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430172341.GA11865@elte.hu>
References: <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> > 
> > c0436275:   64 83 05 20 5f 6a c0    addl   $0x1,%fs:0xc06a5f20
> > 
> > There's no atomic instructions at all - the counters here are 
> > only accessed locally. They are local-irq-atomic, but not 
> > cacheline-atomic.
> 
> On other architectures, you need the whole "disable preemption, 
> load-locked, store-conditional, test-and-loop, enable preemption" 
> thing.
> 
> Or "disable interrupts, load, store, restore interrupts".
> 
> There really aren't very many architectures that can do almost 
> unrestricted ALU ops in a single instruction (and thus 
> automatically safe from preemption and interrupts).

Maybe then what we should do is the very first version of commit 
6dbde35308: declaredly make percpu_arith_op() non-irq-atomic (and 
non-preempt-atomic) everywhere. The commit's internal changelog 
still says:

        * made generic percpu ops atomic against preemption

So we introduced preemption-safety in the v2 version of that commit.

This non-atomicity will 1) either not matter 2) will be irq-atomic 
by virtue of being within a critical section 3) can be made atomic 
in the few remaining cases.

And maybe, at most, introduce an opt-in API: percpu_add_irqsafe().

Right?

	Ingo
