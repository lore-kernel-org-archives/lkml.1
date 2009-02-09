Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZBIBvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZBIBvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZBIBvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:51:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZBIBvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:51:11 -0500
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
In-Reply-To: Oleg Nesterov's message of  Sunday, 8 February 2009 19:47:30 +0100 <20090208184730.GA27086@redhat.com>
References: <20090208184730.GA27086@redhat.com>
X-Zippy-Says: Do I have a lifestyle yet?
Message-Id: <20090209015029.45AA7FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 17:50:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I believe this is correct.  It matches the flip side of the
bookkeeping where we adjust group_stop_count when going into TASK_TRACED
(ptrace_stop).  I think it warrants a comment with your change, saying that
treating group_stop_count as "we should be already stopped" is consistent
with decrementing an active group_stop_count when we enter TASK_TRACED.

> 	- if the process/thread was traced, SIGNAL_STOP_STOPPED
> 	  does not necessary means this thread group is stopped.
>
> 	- ptrace breaks the bookkeeping of ->group_stop_count.

SIGNAL_STOP_STOPPED is only set when all live threads in the group are in
either TASK_TRACED or TASK_STOPPED.  PTRACE_DETACH respects this and this
it stopped.  However, PTRACE_CONT et al (ptrace_resume) do not respect it
and can resume an individual thread regardless of SIGNAL_STOP_STOPPED.
That's what you mean here, right?

Doing that without a SIGCONT having been generated is an anomalous way for
a debugger to behave, since it's going to eat the effects of the job
control stop.  But who knows that things they do, so this could be sticky
to fix so that SIGNAL_STOP_STOPPED really means all stopped.

> (the comment above ptrace_untrace() doesn't look exactly right too).

How so?


Thanks,
Roland
