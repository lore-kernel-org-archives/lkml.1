Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZBIDnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZBIDnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZBIDnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:43:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZBIDnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:43:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_untrace: use wake_up_process() instead of
	bogus signal_wake_up()
In-Reply-To: Oleg Nesterov's message of  Monday, 9 February 2009 03:42:36 +0100 <20090209024236.GB28280@redhat.com>
References: <20090208184727.GA27081@redhat.com>
	<20090209013804.C99B3FC330@magilla.sf.frob.com>
	<20090209024236.GB28280@redhat.com>
X-Zippy-Says: Somewhere in suburban Honolulu, an unemployed bellhop is whipping
    up a batch of illegal psilocybin chop suey!!
Message-Id: <20090209034255.E95A7FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 19:42:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are holding ->siglock, and task->state is TASK_TRACED. We can not do
> the "wrong" wakeup, afaics.

I guess that's true with the siglock.  But you'd be wrong to think that
this sort of detailed thinking is why wake_up_process() appears *anywhere
at all* in ptrace-related code.  I'm really quite sure that it's the
aforementioned (ancient) lack of detailed thinking about it that led to
wake_up_process() appearing originally--so any use of it reminds us of that
dubious past.

> Because it complicates the understanding of this code. I spent a lot
> of time trying to understand this signal_wake_up().
> 
> Perhaps this is just me. But when you see the code which does something,
> it is always good to understand the reason, otherwise the code at least
> looks wrong.

I had presumed most people interpret it the way I do: it does
signal_wake_up(,1), meaning "whatever it is that works right for SIGKILL or
SIGCONT", which it seems intuitive to think is right for this case too.
You don't have to think about exactly what is always exactly right for this
case, because it makes sense to think that this is like the wakeup that
SIGCONT would do.  To me, it takes much more thought to be convinced that
wake_up_process() without other considerations is correct here--because it
looks like such a scary, unconditional thing, whereas normally that is
wrapped up inside calls that handle appropriate bookkeeping--signal_wake_up()
being one of those.


Thanks,
Roland
