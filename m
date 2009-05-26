Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZEZUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZEZUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZEZUtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:49:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZEZUtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:49:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/X] ptrace: introduce the empty "struct ptrace_task"
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 02:00:01 +0200 <20090525000001.GA2218@redhat.com>
References: <20090525000001.GA2218@redhat.com>
Emacs: a compelling argument for pencil and paper.
Message-Id: <20090526204846.898CCFC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 13:48:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
> + * tracehook_init_task - initialize the new child
> + * @child:		new child task

s/child/task/

> + * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
> + * @trace:		return value from tracehook_prepare_clone()
> + *
> + * This is called immediately after dup_task_struct().

    * It must clear/reset any tracing state so that tracehook_free_task()
    * will work safely if the task creation fails.  If the task creation 
    * succeeds, a tracehook_finish_clone() call will follow with locks
    * held, before @task starts or is accessible to anyone else.

> +int alloc_ptrace_task(struct task_struct *tsk)

This deserves a short comment about the context it's called from,
and when it is or isn't called at all.

> +	if (cmpxchg(&tsk->ptrace_task, NULL, ptrace_task) != NULL)
> +		kfree(ptrace_task);

I don't see cmpxchg() used very often at all in generic kernel code.  I
wonder how good a choice it is across every arch.  Is there a reason not to
use e.g. task_lock() to mediate installing a new ->ptrace_task pointer?
That seems like a more conservative route.


Thanks,
Roland
