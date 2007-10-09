Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbXJIIRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbXJIIRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXJIIRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:17:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51609 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXJIIRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:17:03 -0400
Subject: Re: -rt more realtime scheduling issues
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071009030412.GB12915@goodmis.org>
References: <20071006021548.GE4587@monkey.ibm.com>
	 <20071008184523.GA29656@monkey.ibm.com>
	 <20071009030412.GB12915@goodmis.org>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 10:16:45 +0200
Message-Id: <1191917805.6848.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 23:04 -0400, Steven Rostedt wrote:
> On Mon, Oct 08, 2007 at 11:45:23AM -0700, Mike Kravetz wrote:
> > On Fri, Oct 05, 2007 at 07:15:48PM -0700, Mike Kravetz wrote:
> > > After applying the fix to try_to_wake_up() I was still seeing some large
> > > latencies for realtime tasks.
> > 
> > I've been looking for places in the code where reschedule IPIs should
> > be sent in the case of 'overload' to redistribute RealTime tasks based
> > on priority.  However, an even more basic question to ask might be:  Are
> > the use of reschedule IPIs reliable enough for this purpose.  In the
> > code, there is the following comment:
> > 
> > /*
> >  * this function sends a 'reschedule' IPI to another CPU.
> >  * it goes straight through and wastes no time serializing
> >  * anything. Worst case is that we lose a reschedule ...
> >  */
> > 
> > After a quick read of the code, it does appear that reschedule's can
> > be lost if the the IPI is sent at just the right time in schedule
> > processing.  Can someone confirm this is actually the case?
> > 
> > The issue I see is that the 'rt_overload' mechanism depends on reschedule
> > IPIs for RealTime scheduling semantics.  If this is not a reliable
> > mechanism then this can lead to breakdowns in RealTime scheduling semantics.
> > 
> > Are these accurate statements?  I'll start working on a reliable delivery
> > mechanism for RealTime scheduling.  But, I just want to make sure that
> > is really necessary.
> 
> For i386 I don't think so. Seems that the interrupt handler will set the
> current task to "need_resched" and on exit of the interrupt handler, the
> schedule should take place. I don't see the race (that doesn't mean
> there is one).
> 
> For x86_64 though, I don't think that we schedule. All the reschedule
> vector does is return with a comment:
> 
> /*
>  * Reschedule call back. Nothing to do,
>  * all the work is done automatically when
>  * we return from the interrupt.
>  */
> asmlinkage void smp_reschedule_interrupt(void)
> {
>         ack_APIC_irq();
> }
> 
> I'm thinking that this was the case for i386 a while back, and we fixed
> it for RT.
> 
> /me does a quick search...
> 
> http://lkml.org/lkml/2005/5/13/174
> 
> Yep!  This is a bug in x86_64. I'll fix this up tomorrow and send out a
> patch.

Hmm, my understanding is that the IPI caller needs to set
TIF_NEED_RESCHED before issuing the IPI.

So I'm inclined to not like this 'fix'.

