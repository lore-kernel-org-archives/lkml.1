Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZDXGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZDXGcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZDXGcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:32:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbZDXGcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:32:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: Q: ptrace_signal() && PTRACE_SETSIGINFO (Was: SIGSTOP && ptrace)
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 17:16:33 +0200 <20090423151633.GA3120@redhat.com>
References: <1158166a0904230515h333a78c9uf49931824c1dfe72@mail.gmail.com>
	<20090423142627.GA31572@redhat.com>
	<20090423151633.GA3120@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090424063159.BCEDAFC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 23:31:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. PTRACE_SETSIGINFO can change *info if debugger wants something
> special. But then we do:
> 
> 	if (signr != info->si_signo) {
> 		info->si_signo = signr;
[...]
> Why? If the tracer changes ->exit_code it should know what it does.

If it uses PTRACE_SETSIGINFO it should know what it does, and update
the siginfo_t to match the signal it passes to PTRACE_CONT et al.

> Why do we reset *info?

PTRACE_SETSIGINFO did not always exist, and even now might not be used by a
simple-minded application.  If the user is sophisticated, it calls
PTRACE_SETSIGINFO and then passes the signal number to match.  If not, it
never calls PTRACE_SETSIGINFO at all, but expects the signal number it
chose to pass in PTRACE_CONT to behave "normally" in the tracee.  

We reset the siginfo_t the tracee will see to match what a kill() from the
debugger would have looked like.  Otherwise the tracee could be confused by
the siginfo_t values that don't make sense for the signal number delivered.
(The simple-minded debugger's ptrace code could even predate SA_SIGINFO
handlers and tracees that could see the siginfo_t.)

> But the real question, how can PTRACE_SETSIGINFO change ->si_signo
> (for example, for do_signal_stop(si_signo)) if this in fact is not
> allowed?

It's allowed.  You just have to pass the same value you set in si_signo as
the argument to PTRACE_CONT after you do PTRACE_SETSIGINFO.


Thanks,
Roland
