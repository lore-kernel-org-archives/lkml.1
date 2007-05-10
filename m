Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXEJFBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXEJFBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbXEJFBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:01:34 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44144 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbXEJFBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:01:34 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Use write_trylock_irqsave in ptrace_attach
Date: Thu, 10 May 2007 10:31:22 +0530
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
References: <200705091413.27344.sripathik@in.ibm.com> <20070509185003.34a45673.akpm@linux-foundation.org>
In-Reply-To: <20070509185003.34a45673.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101031.22794.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 07:20, Andrew Morton wrote:
> On Wed, 9 May 2007 14:13:27 +0530 Sripathi Kodi <sripathik@in.ibm.com> 
wrote:
> > Hi,
> >
> > This patch makes ptrace_attach use write_trylock_irqsave.
> >
> > Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
> >
> > ---
> >  kernel/ptrace.c |    7 +++----
> >  1 files changed, 3 insertions(+), 4 deletions(-)
> >
> > Index: linux-2.6.21/kernel/ptrace.c
> > ===================================================================
> > --- linux-2.6.21.orig/kernel/ptrace.c
> > +++ linux-2.6.21/kernel/ptrace.c
> > @@ -160,6 +160,7 @@ int ptrace_may_attach(struct task_struct
> >  int ptrace_attach(struct task_struct *task)
> >  {
> >  	int retval;
> > +	unsigned long flags = 0;
> >
> >  	retval = -EPERM;
> >  	if (task->pid <= 1)
> > @@ -178,9 +179,7 @@ repeat:
> >  	 * cpu's that may have task_lock).
> >  	 */
> >  	task_lock(task);
> > -	local_irq_disable();
> > -	if (!write_trylock(&tasklist_lock)) {
> > -		local_irq_enable();
> > +	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
> >  		task_unlock(task);
> >  		do {
> >  			cpu_relax();
> > @@ -208,7 +207,7 @@ repeat:
> >  	force_sig_specific(SIGSTOP, task);
> >
> >  bad:
> > -	write_unlock_irq(&tasklist_lock);
> > +	write_unlock_irqrestore(&tasklist_lock, flags);
> >  	task_unlock(task);
> >  out:
> >  	return retval;
>
> Your changelogs aren't vey logical.  The context for this change is off in
>
> a different patch.  I reproduce it here:
> > I am trying to fix the BUG I mentioned here:
> > http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to
> > solve this problem is to have a write_trylock_irqsave helper function.
> > Since we don't have this now, the code in ptrace_attach  implements it
> > using local_irq_disable and write_trylock. I wish to add
> > write_trylock_irqsave to mainline kernel and then fix the -rt specific
> > problem using this.
>
> I can't imagine why -rt's write_unlock_irq() doesn't do local_irq_enable().

-rt's write_unlock_irq() does local_irq_enable() while dealing with 'raw' 
rwlock_t. However tasklist_lock is a regular rwlock_t and hence -rt doesn't 
save/restore irqs while dealing with it. The probelm in ptrace_attach arises 
because we explicitely call local_irq_disable(), whereas write_unlock_irq() 
doesn't restore them.


>
> I have no problem adding write_trylock_irqsave() - it fills a gap in the
> API.
>
> Once we have write_trylock_irqsave() it makes sense to use it here.
>
> One the downside, we added a few bytes to the SMP kernel, which I guess we
> can live with.
>
> Whether this change is desired in -rt I don't know.  Ingo?

I will send a patch against -rt in a little while.

>
> I don't think the initialisation of `flags' there was needed?

Yes, it was not needed. I will send a patch to remove it.

Thanks,
Sripathi.
