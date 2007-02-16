Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbXBPDP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbXBPDP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161374AbXBPDP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:15:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1899 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161339AbXBPDP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:15:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 19:15:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 09/14] syslets: x86, add move_user_context() method
In-Reply-To: <Pine.LNX.4.64.0702151058040.11064@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702151904570.11064@alien.or.mcafeemobile.com>
References: <20070215165242.GJ4285@elte.hu> <Pine.LNX.4.64.0702151058040.11064@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Davide Libenzi wrote:

> On Thu, 15 Feb 2007, Ingo Molnar wrote:
> 
> >  /*
> > + * Move user-space context from one kernel thread to another.
> > + * This includes registers and FPU state. Callers must make
> > + * sure that neither task is running user context at the moment:
> > + */
> > +void
> > +move_user_context(struct task_struct *new_task, struct task_struct *old_task)
> > +{
> > +	struct pt_regs *old_regs = task_pt_regs(old_task);
> > +	struct pt_regs *new_regs = task_pt_regs(new_task);
> > +	union i387_union *tmp;
> > +
> > +	*new_regs = *old_regs;
> > +	/*
> > +	 * Flip around the FPU state too:
> > +	 */
> > +	tmp = new_task->thread.i387;
> > +	new_task->thread.i387 = old_task->thread.i387;
> > +	old_task->thread.i387 = tmp;
> > +}
> 
> Let's say that old_task ("prev" at the incoming schedule) has TS_USEDFPU 
> set. Its context gets moved to the new_task (the one returning to 
> userspace) *before* the __unlazy_fpu() done in __switch_to(). The 
> __unlazy_fpu() at the following schedule will save the state to the old 
> new_task context, and that fine as far as the going-to-sleep task goes.
> The next fault happening in new_task (return to userspace one) will reload 
> a non up2date context (the one we got from old_task, but never hit by 
> the __unlazy_fpu() flush). Right?

Yeah. Given TS_USEDFPU set, before move_user_context():

CPU  => FPUc
NTSK => FPUn
OTSK => FPUo

After move_user_context():

CPU  => FPUc
NTSK => FPUo
OTSK => FPUn

After the incoming __unlazy_fpu() in __switch_to():

CPU  => FPUc
NTSK => FPUo
OTSK => FPUc

After the first fault in NTSK:

CPU  => FPUo
NTSK => FPUo
OTSK => FPUc

So NTSK loads a non up2date FPUo, instead of the FPUc that was the "dirty" 
context to migrate (since TS_USEDFPU was set).
I think you need an early __unlazy_fpu() in that case.




- Davide


