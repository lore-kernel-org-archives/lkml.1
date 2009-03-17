Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZCQIYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZCQIYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZCQIYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:24:11 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54925 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZCQIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=b9A9IMm69ie9nYWyW/UCyvoHHCi4fjMsgbMVzeIHOgU1VtHTIdlneKVAbYw5oyFnGA
         tYUAJ/qCGVFXtVRrLXKmA4KDD6d+u6FB+8HwkRQBUTQh4EHcNbMKiBc4aFagJIEMJhmQ
         87dm5C9ybY46qx/3S61Qgy84Q+wyQNGAaB4C4=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Date: Tue, 17 Mar 2009 09:23:56 +0100
User-Agent: KMail/1.9.9
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <200903141750.37238.mega@retes.hu> <49BED93B.1090700@nortel.com> <20090317041337.GA29740@redhat.com>
In-Reply-To: <20090317041337.GA29740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903170923.56430.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> (see http://marc.info/?t=123704955800002)
>
> First of all, perhaps I missed somethings and this is solvable
> without kernel changes, but I can't see how.
>
> To simplify, suppose that the application wants to log the faulting
> instruction before exit, so it installs the handler for SIGSEGV
>
> 	void sigsegv_handler(int sig, siginfo_t *info, struct ucontext
> *context) {
> 		fprintf(stderr, "bug at %p\n", context->uc_mcontext->ip);
> 		exit(1);
> 	}
>
> But this doesn't work. It is possible that, before the task dequeues
> SIGSEGV, another private signal, say, SIGHUP (note that SIGHUP <
> SIGSEGV) is sent to this app.
>
> In this case the task dequeues both signals, SIGHUP and then SIGSEGV
> before return to user-space. This is correct, but now uc_mcontext->ip
> points to sighup_handler, not to the faulted instruction.
>
>
> Can/should we change force_sig_info_fault() to help?
>
> We can add siginfo_t->_sigfault.ip to solve this problem. This
> shouldn't enlarge the size of siginfo_t. With this change
> sigsegv_handler() always knows the address of the instruction which
> caused the fault.
>
>
> But this doesn't allow to change uc_mcontext->ip to, say, skip the
> offending instruction or call another function which does a fixup.
> Actually, ->si_ip helps, we can do
>
> 	void sigsegv_handler(int sig, siginfo_t *info, struct ucontext
> *context) {
> 		if (info->si_ip != context->uc_mcontext->ip)
> 			/*
> 			 * The offending instruction will be repeated, and
> 			 * we will have the "same" SIGSEGV again.
> 			 */
> 			return;
>
> 		context->uc_mcontext->ip = fixup;
> 		...
> 	}
>
> But this doesn't look very nice. So, perhaps we can do another
> change?
>
> 	--- arch/x86/mm/fault.c
> 	+++ arch/x86/mm/fault.c
> 	@@ -177,6 +177,13 @@ static void force_sig_info_fault(int si_
> 	 {
> 		siginfo_t info;
>
> 	+	current->saved_sigmask = current->blocked;
> 	+	spin_lock_irq(&current->sighand->siglock);
> 	+	siginitsetinv(&current->blocked, sigmask(si_signo) |
> 	+			sigmask(SIGKILL) | sigmask(SIGSTOP));
> 	+	spin_unlock_irq(&current->sighand->siglock);
> 	+	set_restore_sigmask();
> 	+
> 		info.si_signo = si_signo;
> 		info.si_errno = 0;
> 		info.si_code = si_code;
>
> But this is a user-visible change, all signals will be blocked until
> sigsegv_handler() returns. But with this change sigsegv_handler()
> always has the "correct" rt_sigframe.
>
>
> Comments?
>
> And once again, I have a nasty feeling I missed something and we
> don't need to change the kernel.
>
> Oleg.

As an application developer what I'd like to have is this: synchronously 
generated signals are delivered before asynchronously generated ones. 
That is, if a number of signals are generated but not yet delivered 
then the synchronously generated ones are delivered first. I guess, in 
the kernel this would mean that the private/non-private distinction is 
not enough.

I think Chris is right in that standard allows the current behaviour. I 
would have quoted it already if I had thought otherwise ... He's also 
right about quality of implementation. The standard doesn't say much 
about synchronously and asynchronously generated signals and it even 
goes further:

"The order in which multiple, simultaneously pending signals outside the 
range SIGRTMIN to SIGRTMAX are delivered to or accepted by a process is 
unspecified."

Bleh. It also says that the context argument represents the context at 
the time of delivery. For a handler for sigsegv, sigtrap (to name just 
the most likely suspects) the context -  in order for it to be useful 
at all - must be from the time of generation. There is an obvious 
contradiction here and the only way I see to resolve this is to deliver 
syncrhronously generated signals while the two contexts are the same 
which is exactly what allowing other signals to 'overtake' violates. Of 
course, if sigsegv is blocked then this is impossible to do, but that's 
fine.

For the application I'm working on this whole issue is kind of moot 
since kernels with the current behaviour will be around for ages to 
come and I have the workaround of not pthread_kill()ing with a signal 
whose signum is lower than the signum of any of the syncrhonously 
generated signals. In practice, it only means that I'll use SIGUSR2 
instead of SIGUSR1 because that's greater than SIGSEGV and pay 
attention not to pthread_kill() with SIGINT. The only thing that 
worries me is this remark from Oleg 
(http://marc.info/?l=linux-kernel&m=123711058421913&w=2):

"But please note that it is still possible to hit is_signal_blocked()
even with test_with_kill(), but the probability is very low."

I still can't see how that's possible, but if it is, then it defeats the 
workaround and I have even bigger problems than I thought. Not only me, 
I guess, most applications with a sigtrap, sigsegv handler that use the 
context will be broken by a C-c.

Gabor
