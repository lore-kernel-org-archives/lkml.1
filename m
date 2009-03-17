Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbZCQKVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbZCQKVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZCQKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:20:47 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:45427 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZCQKUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:20:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Y9UJNAK4WS4XWMj5FEgq6lAluW6S8cXIkbRbnD4uwJXnJFDidv63r6flMM83LhShdG
         vcVTlyzH0BVK8Z3zlolc5TxogZACSECpaesOfMaaZSWH4U8rT4vFwHJYuPGs8UxhDDgi
         e+lbDX/nTB7UVfcfvlIQ/G+90nrlLKVSQFT6w=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Date: Tue, 17 Mar 2009 11:20:36 +0100
User-Agent: KMail/1.9.9
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <200903141750.37238.mega@retes.hu> <200903170923.56430.mega@retes.hu> <20090317092546.GA9356@redhat.com>
In-Reply-To: <20090317092546.GA9356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903171120.36606.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> On 03/17, Gábor Melis wrote:
> > On Martes 17 Marzo 2009, Oleg Nesterov wrote:
> > > But this doesn't look very nice. So, perhaps we can do another
> > > change?
> > >
> > > 	--- arch/x86/mm/fault.c
> > > 	+++ arch/x86/mm/fault.c
> > > 	@@ -177,6 +177,13 @@ static void force_sig_info_fault(int si_
> > > 	 {
> > > 		siginfo_t info;
> > >
> > > 	+	current->saved_sigmask = current->blocked;
> > > 	+	spin_lock_irq(&current->sighand->siglock);
> > > 	+	siginitsetinv(&current->blocked, sigmask(si_signo) |
> > > 	+			sigmask(SIGKILL) | sigmask(SIGSTOP));
> > > 	+	spin_unlock_irq(&current->sighand->siglock);
> > > 	+	set_restore_sigmask();
> > > 	+
> > > 		info.si_signo = si_signo;
> > > 		info.si_errno = 0;
> > > 		info.si_code = si_code;
> > >
> > > But this is a user-visible change, all signals will be blocked
> > > until sigsegv_handler() returns. But with this change
> > > sigsegv_handler() always has the "correct" rt_sigframe.
> >
> > As an application developer what I'd like to have is this:
> > synchronously generated signals are delivered before asynchronously
> > generated ones. That is, if a number of signals are generated but
> > not yet delivered then the synchronously generated ones are
> > delivered first. I guess, in the kernel this would mean that the
> > private/non-private distinction is not enough.
>
> With the change like above, no other signal (except SIGKILL) can be
> delivered until the signal handler returns.

Surely, you don't mean the above literally: it would violate the 
standard to prevent all other signals from being delivered until the 
sigsegv handler returns.

> Probably it is better to just change force_sig_info(), in this case
> SIGFPE/etc will have the same behaviour.

Indeed, uniformity seems preferable to me.

While we are at it, an interesting case is when a synchronously 
generated signal and an asynchronously generated signal - that is also 
of the type that can be synchronously generated - are to be delivered. 
Say we have a fault and a sigsegv generated but some misguided soul 
pthread_kill()s with sigtrap. In this case the sigsegv shall be 
delivered first, and the async sigtrap later.

> > The only thing that
> > worries me is this remark from Oleg
> > (http://marc.info/?l=linux-kernel&m=123711058421913&w=2):
> >
> > "But please note that it is still possible to hit
> > is_signal_blocked() even with test_with_kill(), but the probability
> > is very low."
>
> Sorry for confusion. Initially I misread test_with_kill() case, and
> then forgot to remove this part. I think this is not possible.

Thanks for the clarification.

> Oleg.
