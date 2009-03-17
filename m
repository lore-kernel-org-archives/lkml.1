Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZCQESZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZCQESZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZCQESP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:18:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZCQESO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:18:14 -0400
Date: Tue, 17 Mar 2009 05:13:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>,
       linux-kernel@vger.kernel.org
Subject: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Message-ID: <20090317041337.GA29740@redhat.com>
References: <200903141750.37238.mega@retes.hu> <200903152306.53031.mega@retes.hu> <20090316002833.GA17615@redhat.com> <200903160934.03700.mega@retes.hu> <20090316211316.GA6270@redhat.com> <49BED93B.1090700@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BED93B.1090700@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(see http://marc.info/?t=123704955800002)

First of all, perhaps I missed somethings and this is solvable without
kernel changes, but I can't see how.

To simplify, suppose that the application wants to log the faulting
instruction before exit, so it installs the handler for SIGSEGV

	void sigsegv_handler(int sig, siginfo_t *info, struct ucontext *context)
	{
		fprintf(stderr, "bug at %p\n", context->uc_mcontext->ip);
		exit(1);
	}

But this doesn't work. It is possible that, before the task dequeues SIGSEGV,
another private signal, say, SIGHUP (note that SIGHUP < SIGSEGV) is sent to
this app.

In this case the task dequeues both signals, SIGHUP and then SIGSEGV before
return to user-space. This is correct, but now uc_mcontext->ip points to
sighup_handler, not to the faulted instruction.


Can/should we change force_sig_info_fault() to help?

We can add siginfo_t->_sigfault.ip to solve this problem. This shouldn't
enlarge the size of siginfo_t. With this change sigsegv_handler() always
knows the address of the instruction which caused the fault.


But this doesn't allow to change uc_mcontext->ip to, say, skip the offending
instruction or call another function which does a fixup. Actually, ->si_ip
helps, we can do

	void sigsegv_handler(int sig, siginfo_t *info, struct ucontext *context)
	{
		if (info->si_ip != context->uc_mcontext->ip)
			/*
			 * The offending instruction will be repeated, and
			 * we will have the "same" SIGSEGV again.
			 */
			return;

		context->uc_mcontext->ip = fixup;
		...
	}

But this doesn't look very nice. So, perhaps we can do another change?

	--- arch/x86/mm/fault.c
	+++ arch/x86/mm/fault.c
	@@ -177,6 +177,13 @@ static void force_sig_info_fault(int si_
	 {
		siginfo_t info;
	 
	+	current->saved_sigmask = current->blocked;
	+	spin_lock_irq(&current->sighand->siglock);
	+	siginitsetinv(&current->blocked, sigmask(si_signo) |
	+			sigmask(SIGKILL) | sigmask(SIGSTOP));
	+	spin_unlock_irq(&current->sighand->siglock);
	+	set_restore_sigmask();
	+
		info.si_signo = si_signo;
		info.si_errno = 0;
		info.si_code = si_code;

But this is a user-visible change, all signals will be blocked until
sigsegv_handler() returns. But with this change sigsegv_handler()
always has the "correct" rt_sigframe.


Comments?

And once again, I have a nasty feeling I missed something and we don't
need to change the kernel.

Oleg.

