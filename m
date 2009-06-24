Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZFXG4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZFXG4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFXG4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:56:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFXG4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:56:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] arm: arch_ptrace clean-up
In-Reply-To: Russell King's message of  Friday, 19 June 2009 10:13:23 +0100 <20090619091323.GA18246@flint.arm.linux.org.uk>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
	<20090425000732.ACB87FC3C8@magilla.sf.frob.com>
	<20090619091323.GA18246@flint.arm.linux.org.uk>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20090624065600.040F24059B@magilla.sf.frob.com>
Date: Tue, 23 Jun 2009 23:55:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It also changes the semantics a bit, and I don't buy the "it doesn't
> matter" comments, especially in the PT_SINGLESTEP case.  Having
> PT_SINGLESTEP set the flag but later fail is not nice behaviour at all,
> it means that, despite the ptrace call failing, the next time that the
> task encounters a signal, it will enter single stepping mode.

The reason my comment says "before it matters" is precisely because I don't
think this scenario is possible.  (And hence that it does not change the
user-visible semantics at all.)  If I'm wrong about that, then all that's
required is to drop the comments about not error-checking and reintroduce:

			ret = -EIO;
			if (!valid_signal(data))
				break;

at the top of both cases that end in "goto common;".  That is the only
error case ptrace_request() can diagnose for those requests.

Here's why I think that my comment:

		 * It's harmless in the error case, since we will have
		 * come back through here or PTRACE_SINGLESTEP again
		 * before it matters.

is correct and thus the check above is superfluous.  

If we are in arch_ptrace() at all, it means we have already been through
ptrace_check_attach() successfully, so the child is in TASK_TRACED.  (Or
else it's simultaneously being woken up by SIGKILL and dying, which is
already required to be harmless to things arch_ptrace() might do.)  Aside
from SIGKILL, nothing else can wake the child from TASK_TRACED but ptrace.
If it's SIGKILL, then no harm done no matter what the state of the
single-step machinery--it never even tries to get back to user mode anyway.

If it's ptrace, then that's what "back through here" means in the comment:
it will be in one of these same cases in arch_ptrace() that calls either
single_step_disable() or single_step_enable().  Again, no harm done,
because the state was reset as desired before resuming in user mode.

I don't know what exactly "task encounters a signal" meant in your
description of a failure mode.  If it means "a signal is sent" (generated),
then this does not wake the task from TASK_TRACED, where we know it is
sitting in this scenario, unless it was SIGKILL.  If it means "a signal is
dequeued and processed" (delivered), then this only happens after the task
has been woken up from TASK_TRACED.  That happens by SIGKILL, in which case
user mode is never seen again (zero steps already < single step), or by
ptrace, in which case it will or won't enter single stepping mode, exactly
as directed by that (second, successful) ptrace call.

Did I misunderstand which scenario you had in mind,
or am I mistaken about how that scenario is ruled out?


Thanks,
Roland
