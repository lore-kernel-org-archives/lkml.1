Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZCQEaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZCQEaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZCQEan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:30:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZCQEan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:30:43 -0400
Date: Tue, 17 Mar 2009 05:25:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Message-ID: <20090317042534.GA30513@redhat.com>
References: <200903141750.37238.mega@retes.hu> <200903152306.53031.mega@retes.hu> <20090316002833.GA17615@redhat.com> <200903160934.03700.mega@retes.hu> <20090316211316.GA6270@redhat.com> <49BED93B.1090700@nortel.com> <20090317041337.GA29740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317041337.GA29740@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noise, forgot to mention,

On 03/17, Oleg Nesterov wrote:
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

Of course, this change is wrong, it is just for illustration.
We shouldn't unblock si_signo if it was blocked, force_sig_info()
sets SIG_DFL in this case.

Oleg.

