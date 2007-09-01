Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXIALlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXIALlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 07:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXIALlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 07:41:08 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41806 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXIALlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 07:41:07 -0400
Date: Sat, 1 Sep 2007 15:41:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? fix SIGNAL_STOP_DEQUEUED vs SIGCONT race
Message-ID: <20070901114126.GA243@tv-sign.ru>
References: <20070828155433.GA1081@tv-sign.ru> <20070901082638.3C1124D04CC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901082638.3C1124D04CC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Roland McGrath wrote:
>
> > However, this changes the behaviour when the task is ptraced. If the debugger
> > doesn't clear ->exit_code, SIGSTOP always succeeds after ptrace_stop(), even
> > if SIGCONT was sent in between. I can't decide whether this change is good
> > or bad, hopefully Roland can clarify.
> 
> Hmm.  I think this is bad.  
> 
> First, considering only the single-threaded case, there are debugger vs
> SIGCONT races.  Someone does kill(pid,SIGSTOP);kill(pid,SIGCONT); while pid
> is debugged.  The mandate for end user behavior here is that pid cannot
> wind up sitting in job control stop in the end.  Say the debugger is
> e.g. strace, simply printing every signal and passing it through.
> So say it goes:
> 	T			K			D
> 	merrily running ...				blocked in wait4
> 				kill(K, SIGSTOP)
> 	dequeue SIGSTOP
> 	 -> ptrace_stop
>  							wait4 -> K,{SIGSTOP}
> 				kill(K, SIGCONT)
> 							PTRACE_CONT,K,SIGSTOP
> 	do_signal_stop(SIGSTOP)
>  							wait4 -> K,{SIGSTOP}

Thanks Roland.

Yes, that is what I was worrying about.

> It's still probably a worthwhile cleanup to have the logic only in
> get_signal_to_deliver, and to fix the problem you cited.  It will take only
> a little extra code to handle the ptrace case too, i.e.
> 	if (sig_kernel_stop(signr) &&
>  	    current->sighand->action[signr-1] == SIG_DFL &&
>  	    !(current->signal->flags & SIGNAL_GROUP_EXIT))
> 		current->signal->flags |= SIGNAL_STOP_DEQUEUED;
> 	ptrace_stop(signr, signr, info);
> 	if (sig_kernel_stop(signr) && current->exit_code == signr &&
> 	    !(current->signal->flags & SIGNAL_STOP_DEQUEUED) &&
>  	    current->sighand->action[signr-1] == SIG_DFL)
> 		current->exit_code = 0;

Yes, I also thought about something like this, but tried to avoid because
it adds some complications. OTOH, this is not the fast path.

I'll try to think a bit more about this, and update the patch according
to your comments. Looks like we don't need to check SIGNAL_GROUP_EXIT
here, we are doing this later anyway.

Thanks!

Oleg.

