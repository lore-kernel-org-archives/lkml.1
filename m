Return-Path: <linux-kernel-owner+w=401wt.eu-S1763118AbZCQJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763118AbZCQJbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZCQJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:31:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbZCQJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:31:04 -0400
Date: Tue, 17 Mar 2009 10:25:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Message-ID: <20090317092546.GA9356@redhat.com>
References: <200903141750.37238.mega@retes.hu> <49BED93B.1090700@nortel.com> <20090317041337.GA29740@redhat.com> <200903170923.56430.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903170923.56430.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Gábor Melis wrote:
>
> On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> >
> > But this doesn't look very nice. So, perhaps we can do another
> > change?
> >
> > 	--- arch/x86/mm/fault.c
> > 	+++ arch/x86/mm/fault.c
> > 	@@ -177,6 +177,13 @@ static void force_sig_info_fault(int si_
> > 	 {
> > 		siginfo_t info;
> >
> > 	+	current->saved_sigmask = current->blocked;
> > 	+	spin_lock_irq(&current->sighand->siglock);
> > 	+	siginitsetinv(&current->blocked, sigmask(si_signo) |
> > 	+			sigmask(SIGKILL) | sigmask(SIGSTOP));
> > 	+	spin_unlock_irq(&current->sighand->siglock);
> > 	+	set_restore_sigmask();
> > 	+
> > 		info.si_signo = si_signo;
> > 		info.si_errno = 0;
> > 		info.si_code = si_code;
> >
> > But this is a user-visible change, all signals will be blocked until
> > sigsegv_handler() returns. But with this change sigsegv_handler()
> > always has the "correct" rt_sigframe.
>
> As an application developer what I'd like to have is this: synchronously
> generated signals are delivered before asynchronously generated ones.
> That is, if a number of signals are generated but not yet delivered
> then the synchronously generated ones are delivered first. I guess, in
> the kernel this would mean that the private/non-private distinction is
> not enough.

With the change like above, no other signal (except SIGKILL) can be
delivered until the signal handler returns.

Probably it is better to just change force_sig_info(), in this case
SIGFPE/etc will have the same behaviour.

> The only thing that
> worries me is this remark from Oleg
> (http://marc.info/?l=linux-kernel&m=123711058421913&w=2):
>
> "But please note that it is still possible to hit is_signal_blocked()
> even with test_with_kill(), but the probability is very low."

Sorry for confusion. Initially I misread test_with_kill() case, and then
forgot to remove this part. I think this is not possible.

Oleg.

