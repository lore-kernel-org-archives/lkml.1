Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXLKAkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXLKAkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXLKAkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:40:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37060 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXLKAkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:40:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
References: <20071208183802.GA9946@tv-sign.ru>
Date: Mon, 10 Dec 2007 17:38:22 -0700
In-Reply-To: <20071208183802.GA9946@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 8 Dec 2007 21:38:02 +0300")
Message-ID: <m1sl2a2hhd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> do_wait(WSTOPPED) assumes that p->state must be == TASK_STOPPED, this is not
> true if the leader is already dead. Check SIGNAL_STOP_STOPPED instead and use
> ->signal->group_exit_code.
>
> This patch is not complete if not buggy. At the very minimum it needs cleanup.

Thinking about this set of problems.  Testing SIGNAL_STOP_STOPPED
seems more correct then testing TASK_STOPPED.  It ensures we don't
have a race, and except for ptrace the only way to stop a task
triggers SIGNAL_STOP_STOPPED.

We need a similar flag for thread group exit, to mark when every task
in the thread group has exited.

With those in place we can have race free tests of our status.
/proc/<tgid>/status needs to be updated to use those the per
signal struct status bits as well.

As for the exit_code, we set tsk->exit_code = sig->group_exit_code
so that doesn't seem to be a problem either.

So to get a task group status looking at bits on the signal struct
looks like the right approach, as this ensures we can avoid races in
setting the status, and we don't need to test a dozen other fields.

There is still some value in my other approach but even it will
have small races if we continue look at per task status bits when
what we want is a per thread group status.

Eric
