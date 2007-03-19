Return-Path: <linux-kernel-owner+w=401wt.eu-S966038AbXCSRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966038AbXCSRVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966040AbXCSRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:21:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52526 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966038AbXCSRVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:21:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
Date: Mon, 19 Mar 2007 11:20:47 -0600
In-Reply-To: <send-serie.davidel@xmailserver.org.9367.1174004536.2> (Davide
	Libenzi's message of "Thu, 15 Mar 2007 17:22:15 -0700")
Message-ID: <m1mz29xi8g.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> struct signalfd_siginfo {
> 	__u32 signo;	/* si_signo */
> 	__s32 err;	/* si_errno */
> 	__s32 code;	/* si_code */
> 	__u32 pid;	/* si_pid */
> 	__u32 uid;	/* si_uid */
> 	__s32 fd;	/* si_fd */
> 	__u32 tid;	/* si_fd */  
> 	__u32 band;	/* si_band */
> 	__u32 overrun;	/* si_overrun */
> 	__u32 trapno;	/* si_trapno */
> 	__s32 status;	/* si_status */
> 	__s32 svint;	/* si_int */
> 	__u64 svptr;	/* si_ptr */
> 	__u64 utime;	/* si_utime */
> 	__u64 stime;	/* si_stime */
> 	__u64 addr;	/* si_addr */
> };

Shouldn't we pad this to 128 bytes like we do siginfo in case there are
more fields we need to include, or we need to extend the size of some
field?

I'm tempted to suggest we have a per arch function that tests current
to see if we are in a compat process or not so we can just use
siginfo.  But that is probably overkill.

> +
> +
> +struct signalfd_ctx {
> +	struct list_head lnk;
> +	wait_queue_head_t wqh;
> +	sigset_t sigmask;
> +	struct task_struct *tsk;
> +};

I think you want to use a struct pid *pid instead of a pointer to the
task struct here.  It is slightly less efficient (one more
dereference) but it means that we won't pin the task struct in memory
indefinitely.  Pinning the task_struct like this makes for a very
interesting way to get around the limits on the number of processes a
user can have.

Eric
