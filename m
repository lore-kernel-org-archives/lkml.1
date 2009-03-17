Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbZCQKsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbZCQKsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763274AbZCQKsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:48:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763257AbZCQKsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:48:10 -0400
Date: Tue, 17 Mar 2009 11:43:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Message-ID: <20090317104330.GA13912@redhat.com>
References: <200903141750.37238.mega@retes.hu> <200903170923.56430.mega@retes.hu> <20090317092546.GA9356@redhat.com> <200903171120.36606.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903171120.36606.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Gábor Melis wrote:
>
> On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> > On 03/17, Gábor Melis wrote:
> > > On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> > > > But this doesn't look very nice. So, perhaps we can do another
> > > > change?
> > > >
> > > > 	--- arch/x86/mm/fault.c
> > > > 	+++ arch/x86/mm/fault.c
> > > > 	@@ -177,6 +177,13 @@ static void force_sig_info_fault(int si_
> > > > 	 {
> > > > 		siginfo_t info;
> > > >
> > > > 	+	current->saved_sigmask = current->blocked;
> > > > 	+	spin_lock_irq(&current->sighand->siglock);
> > > > 	+	siginitsetinv(&current->blocked, sigmask(si_signo) |
> > > > 	+			sigmask(SIGKILL) | sigmask(SIGSTOP));
> > > > 	+	spin_unlock_irq(&current->sighand->siglock);
> > > > 	+	set_restore_sigmask();
> > > > 	+
> > > > 		info.si_signo = si_signo;
> > > > 		info.si_errno = 0;
> > > > 		info.si_code = si_code;
> > > >
> > > > But this is a user-visible change, all signals will be blocked
> > > > until sigsegv_handler() returns. But with this change
> > > > sigsegv_handler() always has the "correct" rt_sigframe.
> > >
> > > As an application developer what I'd like to have is this:
> > > synchronously generated signals are delivered before asynchronously
> > > generated ones. That is, if a number of signals are generated but
> > > not yet delivered then the synchronously generated ones are
> > > delivered first. I guess, in the kernel this would mean that the
> > > private/non-private distinction is not enough.
> >
> > With the change like above, no other signal (except SIGKILL) can be
> > delivered until the signal handler returns.
>
> Surely, you don't mean the above literally:

I literally meant the above ;)

> it would violate the
> standard to prevent all other signals from being delivered until the
> sigsegv handler returns.

Yes. That is why I didn't send the patch but asked the question.

But, just in case, this will not happen if the signal was sent from
user-space via kill/tkill.

> While we are at it, an interesting case is when a synchronously
> generated signal and an asynchronously generated signal - that is also
> of the type that can be synchronously generated - are to be delivered.
> Say we have a fault and a sigsegv generated but some misguided soul
> pthread_kill()s with sigtrap. In this case the sigsegv shall be
> delivered first, and the async sigtrap later.

In this case we can do nothing. The second signal will be lost.
But this is not the problem. If sigsegv_handler() wants to play
with context, it should check SI_FROMKERNEL() first. If we lose
the SIGSEGV from the fault, it will be re-generated.

Oleg.

