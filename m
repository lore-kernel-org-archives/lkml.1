Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZHCKdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZHCKdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZHCKdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:33:01 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:41797 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbZHCKdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:33:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19062.48341.397129.599184@cargo.ozlabs.ibm.com>
Date: Mon, 3 Aug 2009 20:32:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NMI between switch_mm and switch_to
In-Reply-To: <20090803082922.GB12498@elte.hu>
References: <19054.33655.297932.261580@cargo.ozlabs.ibm.com>
	<1248767472.6987.2806.camel@twins>
	<20090803082922.GB12498@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2009-07-28 at 14:49 +1000, Paul Mackerras wrote:
> >
> > > Ben H. suggested there might be a problem if we get a PMU 
> > > interrupt and try to do a stack trace of userspace in the 
> > > interval between when we call switch_mm() from 
> > > sched.c:context_switch() and when we call switch_to().  If we 
> > > get an NMI in that interval and do a stack trace of userspace, 
> > > we'll see the registers of the old task but when we peek at user 
> > > addresses we'll see the memory image for the new task, so the 
> > > stack trace we get will be completely bogus.
> > > 
> > > Is this in fact also a problem on x86, or is there some subtle 
> > > reason why it can't happen there?
> > 
> > I can't spot one, maybe Ingo can when he's back :-)
> > 
> > So I think this is very good spotting from Ben.
> 
> Yeah.
> 
> > We could use preempt notifiers (or put in our own hooks) to 
> > disable callchains during the context switch I suppose.
> 
> I think we should only disable user call-chains i think - the 
> in-kernel call-chain is still reliable.
> 
> Also, i think we dont need preempt notifiers, we can use a simple 
> check like this:
> 
> 	if (current->mm &&
> 		cpu_isset(smp_processor_id(), &current->mm->cpu_vm_mask) {

On x86, do you clear the current processor's bit in cpu_vm_mask when
you switch the MMU away from a task?  We don't on powerpc, which would
render the above test incorrect.  (But then we don't actually have the
problem on powerpc since interrupts get hard-disabled in switch_mm and
stay hard-disabled until they get soft-enabled.)

Paul.
