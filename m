Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZBIBfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZBIBfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZBIBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:35:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZBIBfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:35:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace_detach: the wrong wakeup breaks the ERESTARTxxx
	logic
In-Reply-To: Oleg Nesterov's message of  Sunday, 8 February 2009 19:47:24 +0100 <20090208184724.GA27074@redhat.com>
References: <20090208184724.GA27074@redhat.com>
Emacs: because Hell was full.
Message-Id: <20090209013455.CB996FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 17:34:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is because ptrace_detach does:
> 
> 	if (!child->exit_state)
> 		wake_up_process(child);

I'm pretty sure that all these uses of wake_up_process were just blindly
copied from an original use in ptrace code (what's now ptrace_resume).
That original use just dates from the beforetime, the long long ago.
(I don't think it indicates any coherent original intent.)

It's many kinds of wrong.  It's also always been wrong in case of a
simultaneous SIGKILL that already woke the child, which has then blocked on
some mutex or semaphore or whatnot.  I don't know what the stated general
policy about spurious wakeups from schedule() is supposed to be.  Perhaps
to be pedantic, the sys_pause() code has been wrong to return without
checking signal_pending().

It's also about as wrong to use blind wake_up_process in ptrace_resume.
It ought to be wake_up_state(__TASK_TRACED|__TASK_STOPPED).

Frankly, I've always been afraid of strange cruft that might unexpectedly
turn out to rely on this "wrong" (unconditional) wake-up.  Probably the
things like that historically were all just to do with the stopped/traced
bookkeeping and would be covered by explicitly dealing with PTRACE_CONT vs
group stop et al.  But FWIW my reaction to fiddling the wake_up_process
bogons in the past has been, "Be afraid."


Thanks,
Roland
