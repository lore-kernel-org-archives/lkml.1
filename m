Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYCYWie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYCYWie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYCYWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:38:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYCYWiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:38:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] Discard notification signals when a tracer exits
In-Reply-To: Petr Tesarik's message of  Tuesday, 25 March 2008 15:31:53 +0100 <1206455513.17227.4.camel@elijah.suse.cz>
References: <1206455513.17227.4.camel@elijah.suse.cz>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080325223819.2E38026FA0A@magilla.localdomain>
Date: Tue, 25 Mar 2008 15:38:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that's wrong.  When the tracer dies unceremoniously, the tracee
should continue as if it had not been traced.  Your change makes it swallow
a normal signal waiting to be delivered, and then resume as if noone had
ever sent a signal.  

There is indeed a longstanding problem for tracing-induced signals
(e.g. SIGTRAP for single-step or exec).  One can be queued but not yet
delivered while the tracer detaches or dies, and then it gets delivered
to the unsuspecting process without any debugger to intercept it.
I plan to address that eventually, but there is no quick fix for it.

In the non-signal (ptrace_notify) cases, we don't have the queuing issue.
But it's still not as simple as checking current->ptrace to decide whether
to follow current->exit_code or clear it.  When PTRACE_DETACH is called
with a parting signal (nonzero data argument), the tracee will wake up to
see current->ptrace = 0 and current->exit_code = signo and it is explicitly
intended to act on signo rather than ignore it.

The particular case you mentioned could be addressed by something like this:

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1654,6 +1654,9 @@ static void ptrace_stop(int exit_code, i
 	spin_lock_irq(&current->sighand->siglock);
 	current->last_siginfo = NULL;
 
+	if (current->exit_code & ~0x7f)
+		current->exit_code = 0;
+
 	/*
 	 * Queued signals ignored us while we were stopped for tracing.
 	 * So check for any that we should take before resuming user mode.

But that only catches the PTRACE_O_TRACESYSGOOD cases, and not bare SIGTRAP.
To be clean, there is no way to distinguish a left-over SIGTRAP that ought
to be ignored from an intentional SIGTRAP placed there by the debugger for
the tracee to deliver.  (Granted passing SIGTRAP through after a syscall is
rarely or never done.  But that doesn't make a special-case kludge right.)

I do very much appreciate the concerns that motivated your change, and share
them.  But you can see that this is a small part of a large can of worms.
It has been this way for a long time.  I am working steadily towards new
ways to clean up the entire picture.  In the meantime, I don't really favor
any marginal changes like this that complicate the behavior with more
special cases that address only a tiny corner of the whole set of problems.


Thanks,
Roland
