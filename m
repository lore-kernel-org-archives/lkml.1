Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbXEVUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbXEVUxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXEVUxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:53:16 -0400
Received: from mail1.cray.com ([136.162.0.111]:57235 "EHLO mail1.cray.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbXEVUxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:53:15 -0400
X-Greylist: delayed 3557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 16:53:15 EDT
From: Andrew Hastings <abh@cray.com>
Message-Id: <200705221953.l4MJruA6011637@topaz58.us.cray.com>
Date: Tue, 22 May 2007 14:53:56 -0500
To: linux-kernel@vger.kernel.org
Subject: [BUG] bad uc_stack passed to signal handlers
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Cray-VirusStatus: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experimenting with remapping the stack to hugepages.  I was hoping
to use the Posix getcontext, sigaltstack, and sigaction interfaces to do
this.  Unfortunately, the GNU/Linux implementations are not working as
specified by Posix.

Omitting error checks, here's what I'm doing:

    ucontext_t main_uc;

    main()
    {
	...
	getcontext(&main_uc);
	alt.ss_sp = malloc(alt.ss_size = SIGSTKSZ);
	alt.ss_flags = 0;
	sigaltstack(&alt, (stack_t *)0);
	sigemptyset(&set);
	act.sa_sigaction = handler;
	act.sa_mask = set;
	act.sa_flags = SA_ONSTACK|SA_SIGINFO;
	sigaction(SIGUSR1, &act, (struct sigaction *)0);
	raise(SIGUSR1);
    }

    void handler(int sig, siginfo_t *i, void *c)
    {
	ucontext_t *ucp = (ucontext_t *)c;
	...

According to Posix, ucp->uc_stack should "refer to the receiving
thread's context that was interrupted when the signal was delivered."

However, Linux always sets it to the sigaltstack.  (Even if SA_ONSTACK
was not specified, in which case ucp->uc_stack points to a stack that
has nothing to do with the running signal handler nor the context that
was active when the signal was received.)

FWIW, I ran on Linux 2.6.16.27-0.9-smp x86_64 and Linux
2.6.16.27-0.6-default i386, but the code is the same in linux-2.6.22-rc1
and all the architectures I inspected seem to have this same bug
in setup_rt_frame.

I was hoping to work around this with getcontext, but it appears to be 
incompletely implemented, and does not set the main_uc.uc_stack field.
There's a two-year-old bug report against glibc:
http://sources.redhat.com/bugzilla/show_bug.cgi?id=759

Reading the Posix specification, I would expect the values inside
main_uc.uc_stack and ucp->uc_stack to be identifical.  Making Linux and
glibc agree on these values would probably require turning getcontext
into a system call.

-Andrew Hastings
 Cray Inc.
