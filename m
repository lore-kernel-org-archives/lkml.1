Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbXAWTsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbXAWTsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965422AbXAWTsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:48:40 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:64068 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXAWTsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:48:39 -0500
Subject: Re: Any problem if softirq are done in a interrupt context (IRQ
	stack)?
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Zefang.Wang@nokia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070103104305.GA3100@atjola.homenet>
References: <20070103092214.GA2628@atjola.homenet>
	 <1E9D602D891FA142A769E9EF164712EC355CB0@beebe101.NOE.Nokia.com>
	 <20070103104305.GA3100@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 23 Jan 2007 14:48:32 -0500
Message-Id: <1169581712.13563.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-03 at 11:43 +0100, Björn Steinbrink wrote:
> [Re-added lkml to the CC list, please don't drop anything from CC]

yes, since I would not have replied to this ;)

> 
> On 2007.01.03 17:39:48 +0800, Zefang.Wang@nokia.com wrote:
> > Hi!
> > 
> > Thanks very much for your clear explanation !
> > 
> > I have another question about irq_exit(), hope you can help me.
> > 
> > void irq_exit(void)
> > {
> > 	account_system_vtime(current);          
> > 	trace_hardirq_exit();
> > 	sub_preempt_count(IRQ_EXIT_OFFSET);   
> >            ====================================================================
> > 		Here, IRQ_EXIT_OFFSET is defined as (HARDIRQ_OFFSET-1),
> > 		so the purpose seems that it try to avoid the current process
> > 		from being switched-out druing do_softirq()?
> > 		And,  if the preempt_count is not zero,  then softirq for 
> > 		timer interrupt can set  _TIF_NEED_RESCHED flag to current
> > 		process?
> > 		What happened if the above sentence is changed to
> > 		sub_preept_count(HARDIRQ_OFFSET)?
> > 
> > 	if (!in_interrupt() && local_softirq_pending())
> > 		invoke_softirq();
> > 	preempt_enable_no_resched();
> >              ==============================================
> > 	 The remaining 1 is decremented here.
> > }
> 
> I can't really help you with that one. I'd assume that you need to make
> sure that the current process context is kept while the softirq is
> running. Could be, that otherwise the process gets preempted and the
> stored process context would be assigned to the new process or
> something like that, but I'm just guessing wildly here.
> Note that IRQ_EXIT_OFFSET is defined as HARDIRQ_OFFSET if preemption is
> disabled, so that's probably key here, I just don't know what kind of
> havoc preempting would cause here ;)

It would delay the processing of the softirqs for a full tick or more.

Note that changing to sub_preempt_count(HARDIRQ_OFFSET) is not enough,
you would then need to add a preempt_disable() right afterwards, which
would just be an extra subtraction that is avoided in the current
implementation.

But the big thing is that the softirqs should be handled as soon as they
can be.

-- Steve


