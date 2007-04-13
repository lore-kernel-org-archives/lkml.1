Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXDMNWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXDMNWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXDMNWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:22:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52147 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbXDMNWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:22:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] worker_thread: don't play with SIGCHLD
References: <20070413072910.GA1522@tv-sign.ru>
Date: Fri, 13 Apr 2007 07:21:49 -0600
In-Reply-To: <20070413072910.GA1522@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 13 Apr 2007 11:29:10 +0400")
Message-ID: <m1irc0pfyq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> depends on Eric's
>
> 	kthread-dont-depend-on-work-queues-take-2.patch
>
> worker_thread() inherits ignored SIGCHLD from its parent, kthreadd.
> We can remove unneeded do_sigaction().

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks good.

We could delete all of:

> 	set_user_nice(current, -5);
> 
> 	/* Block and flush all signals */
> 	sigfillset(&blocked);
> 	sigprocmask(SIG_BLOCK, &blocked, NULL);
> 	flush_signals(current);
> 
> 	/*
> 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
> 	 * Set MPOL_DEFAULT to insure node local allocations.
> 	 */
> 	numa_default_policy();
> 
> 	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
> 	sa.sa.sa_handler = SIG_IGN;
> 	sa.sa.sa_flags = 0;
> 	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
> 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);

If we wanted to, as that all comes by default from kthreadd.

Eric
