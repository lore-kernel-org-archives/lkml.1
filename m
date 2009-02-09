Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZBID7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZBID7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZBID7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:59:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZBID7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:59:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
In-Reply-To: Oleg Nesterov's message of  Monday, 9 February 2009 04:09:53 +0100 <20090209030953.GA30787@redhat.com>
References: <20090208184730.GA27086@redhat.com>
	<20090209015029.45AA7FC330@magilla.sf.frob.com>
	<20090209030953.GA30787@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090209035927.D35F1FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 19:59:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because we have another case. The group stop is in progress, and some
> thread T does do_signal_stop()->finish_stop(). It is TASK_STOPPED.
> Now we do PTRACE_ATTACH + PTRACE_DETACH. And the second sys_ptrace()
> changes T->state to TASK_TRACED.

There is no problem here.  The original TASK_STOPPED and the new
TASK_TRACED count the same as far as group-stop accounting.

> And. It it also possible that we ptrace the single sub-thread, then
> the group stop starts. The first thread which enters do_signal_stop()
> will not count the TASK_TRACED child, so it should stay stopped.

As it will, by checking for group_stop_count || SIGNAL_STOP_STOPPED.

> Perhaps this is just my misunderstanding, but
> 
> 	/*
> 	 * Turn a tracing stop into a normal stop now, since with no tracer there
> 	 * would be no way to wake it up with SIGCONT or SIGKILL.
> 
> This looks as if we always do /TRACED/STOPPED/ unconditionally.

... until you read the next sentence that describes the other case.

> 	                                                           If there was a
> 	 * signal sent that would resume the child, but didn't because it was in
> 	 * TASK_TRACED, resume it now.
> 
> No, we resume it not because it may have signals, and we don't even check
> it has pending signals.

The comment is accurate: it doesn't have anything to do with pending signals.
An ignored SIGCONT "was a signal sent that would resume the child", but is
not pending.  (Likewise a caught SIGCONT already dequeued by another thread.)
SIGNAL_STOP_STOPPED being clear is what indicates that "there was a signal
sent that would resume the child".  (It is prepare_signal() that would have
resumed the task, not any present or past state of pendingness of any signal.)

> 	 * Requires that irqs be disabled.
> 	 */
> 
> this is correct ;)

... too. ;-)

Seriously, feel free to rewrite comments so they are more unambiguous.  
But this one is not incorrect when interpreted as I do (as it was
intended), just apparently ambiguous to some eyes such as yours.
The purpose of comments is to be clear to everyone, so change may be
warranted.  But clarity of unambiguous expression is not found in
interpreting ambiguity as being unambiguously clear and wrong.


Thanks,
Roland
