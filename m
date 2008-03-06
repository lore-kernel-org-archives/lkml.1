Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbYCFKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbYCFKvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYCFKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:51:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbYCFKv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:51:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Oleg Nesterov's message of  Monday, 3 March 2008 16:25:02 +0300 <20080303132502.GA81@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
	<20080227210038.93AFC2700FD@magilla.localdomain>
	<Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
	<20080228102649.071572700FD@magilla.localdomain>
	<20080228153043.GA11484@tv-sign.ru>
	<20080229023902.D93E12700FD@magilla.localdomain>
	<20080229120101.GA1410@tv-sign.ru>
	<20080301015956.A0D262700FE@magilla.localdomain>
	<20080301164102.GA171@tv-sign.ru>
	<20080303132502.GA81@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080306105043.8FD982700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 02:50:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, it is easy to re-use signal_struct->flags from the very beginning,
> no need to introduce the new flag temporary, see the attached patches. I also
> have a couple of simple cleanups on top of them (use cached ->signal value).

Looks like a good start.

> Perhaps, we can add the new helper which sets SIGNAL_GROUP_EXIT but preserves
> SIGNAL_CLD_MASK, but I don't think this is really needed.

Actually, I think it is.  This made think of another pedantic concern.
(Not that I'm sure we get this right now anyway.)

Say a child was previously stopped, parent had seen CLD_STOPPED and done
WSTOPPED wait.  Now we send SIGCONT followed shortly by SIGTERM (unhandled
fatal signal).  In the interval before the SIGTERM has yet been dequeued
(nor SIGKILLs sent to other threads by __group_complete_signal), the parent
does waitpid(pid, WSTOPPED|WCONTINUED|WEXITED|WNOHANG).  It should see one
of: WIFSTOPPED (still); WIFSIGNALED (dead); WIFCONTINUED.  Instead, waitpid
will return 0 (it's running, not stopped, not continued).  This says
SIGNAL_STOP_CONTINUED ought to function as normal (i.e. WCONTINUED polling)
until we're actually ready for wait to report the process as dead.

We already break this pedantic nit because flags = SIGNAL_GROUP_EXIT clears
SIGNAL_STOP_CONTINUED.  But if we clean up all flags usage, I think we
should make it preserve SIGNAL_STOP_CONTINUED.

I'll admit it's thin since a SIGKILL not yet dequeued or in the middle of
delivery brings the task to running so WNOHANG wait won't report it as
still stopped, won't report it for WCONTINUED at all, and won't report it
as dead yet.  But if we were to make wait key on SIGNAL_STOP_STOPPED, as is
probably necessary to do WSTOPPED waits for processes with a zombie
group_leader, then this too could be made consistent.  (Leave the
SIGNAL_STOP_STOPPED bit set throughout, so WSTOPPED|WNOHANG waits continues
to report it as stopped until it actually dies.)

> @@ -1761,6 +1757,19 @@ int get_signal_to_deliver(siginfo_t *inf
>  
>  relock:
>  	spin_lock_irq(&current->sighand->siglock);
> +
> +	if (unlikely(current->signal->flags & SIGNAL_CLD_MASK)) {
> +		int why = (current->signal->flags & SIGNAL_STOP_CONTINUED)

This should have a comment before the block.  Explain that it is finishing
the report set up by handle_stop_signal while we were in TASK_STOPPED in a
previous iteration here inside get_signal_to_deliver.


Thanks,
Roland
