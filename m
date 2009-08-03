Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZHCI3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZHCI3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZHCI3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:29:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZHCI3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:29:33 -0400
Date: Mon, 3 Aug 2009 10:29:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: NMI between switch_mm and switch_to
Message-ID: <20090803082922.GB12498@elte.hu>
References: <19054.33655.297932.261580@cargo.ozlabs.ibm.com> <1248767472.6987.2806.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248767472.6987.2806.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-07-28 at 14:49 +1000, Paul Mackerras wrote:
>
> > Ben H. suggested there might be a problem if we get a PMU 
> > interrupt and try to do a stack trace of userspace in the 
> > interval between when we call switch_mm() from 
> > sched.c:context_switch() and when we call switch_to().  If we 
> > get an NMI in that interval and do a stack trace of userspace, 
> > we'll see the registers of the old task but when we peek at user 
> > addresses we'll see the memory image for the new task, so the 
> > stack trace we get will be completely bogus.
> > 
> > Is this in fact also a problem on x86, or is there some subtle 
> > reason why it can't happen there?
> 
> I can't spot one, maybe Ingo can when he's back :-)
> 
> So I think this is very good spotting from Ben.

Yeah.

> We could use preempt notifiers (or put in our own hooks) to 
> disable callchains during the context switch I suppose.

I think we should only disable user call-chains i think - the 
in-kernel call-chain is still reliable.

Also, i think we dont need preempt notifiers, we can use a simple 
check like this:

	if (current->mm &&
		cpu_isset(smp_processor_id(), &current->mm->cpu_vm_mask) {

		...
	}

In the user-call-chain code. We'd only touch the user memory image 
if that bit is set. cpu_vm_mask is maintained atomically and before 
we switch the MM, so it should be race-free.

	Ingo
