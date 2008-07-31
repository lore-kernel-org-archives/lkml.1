Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYGaCYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYGaCYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYGaCYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:24:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYGaCYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:24:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wait_task_inactive: don't use the dummy version when !SMP && PREEMPT
In-Reply-To: Oleg Nesterov's message of  Wednesday, 30 July 2008 21:09:49 +0400 <20080730170949.GA18682@tv-sign.ru>
References: <20080730170949.GA18682@tv-sign.ru>
X-Zippy-Says: Is this going to involve RAW human ecstasy?
Message-Id: <20080731022253.BDD83154290@magilla.localdomain>
Date: Wed, 30 Jul 2008 19:22:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not convinced we need this at all (as per prior thread
"Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT").

Let's not get hung up on what the explanation of the function's semantics
supposedly is.  We can change the comments to match the reality.  We can
rename the function to better reflect its true guarantee, if you like.

There are two uses of wait_task_inactive.  One is kthread_bind.
We have established that a nop is fine for !SMP there.

The other uses are for tracing.  Presently that is the traditional use in
ptrace, and task_current_syscall.

I've described that the requirement of the traditional ptrace call is quite
weak.  A nop is fine for !SMP.  Preemption is not an issue because all that
matters is that no access to pt_regs/thread_struct can race with the actual
context switch (by definition has to be on another CPU to be simultaneous).

For task_current_syscall, it also doesn't matter that it's left the run
queue.  It just matters that the call before looking at pt_regs and the
call after indicate whether it stayed switched out for the duration.  As
per the prior thread on this, I think that's covered by using nivcsw+nvcsw
as I did originally rather than nvcsw alone.  So a short inline is still
fine.

The other uses I anticipate (e.g. utrace) follow the same model as
task_current_syscall (check before and after) and have only the same
requirements.


Thanks,
Roland
