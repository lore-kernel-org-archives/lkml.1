Return-Path: <linux-kernel-owner+w=401wt.eu-S1030495AbXDMXqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030495AbXDMXqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030899AbXDMXqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:46:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030495AbXDMXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:46:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] make kthread_stop() scalable
References: <20070413130236.GA173@tv-sign.ru>
Date: Fri, 13 Apr 2007 17:44:41 -0600
In-Reply-To: <20070413130236.GA173@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 13 Apr 2007 17:02:36 +0400")
Message-ID: <m14pnjon4m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> It's a shame kthread_stop() (may take a while!) runs with a global semaphore
> held. With this patch kthread() allocates all neccesary data (struct kthread)
> on its own stack, globals kthread_stop_xxx are deleted.

Oleg so fare you patches  have been inspiring.  However..

> HACKS:
>
> 	- re-use task_struct->set_child_tid to point to "struct kthread"

	 task_struct->vfork_done is a better cannidate.

> 	- use do_exit() directly to preserve "struct kthread" on stack

Calling do_exit directly like that is not a hack, as it appears the preferred
way to exit is to call do_exit, or complete_and_exit.

While this does improve the scalability and remove a global variable.  It
also introduces a complex special case in the form of struct kthread.

It also doesn't solve the biggest problem with the current kthread interface
in that calling kthread_stop does not cause the code to break out of
interruptible sleeps.

>  static int kthread(void *_create)
>  {
> -	struct kthread_create_info *create = _create;
> -	int (*threadfn)(void *data);
> -	void *data;
> -	int ret = -EINTR;
> +	struct kthread self = {
> +		.task = current,
> +		.err = -EINTR,
> +	};
>  
>  	/* Copy data: it's on kthread's stack */
> -	threadfn = create->threadfn;
> -	data = create->data;
> +	struct kthread_create_info *create = _create;
> +	int (*threadfn)(void *data) = create->threadfn;
> +	void *data = create->data;
> +
> +	/*
> +	 * This should be enough to assure that self is still on
> +	 * stack when we enter do_exit()
> +	 */
> +	set_kthread(&self);
> +	create->result = &self;
>  

> @@ -91,7 +105,7 @@ static void create_kthread(struct kthrea
>  
>  	/* We want our own signal handler (we take no signals by default). */
>  	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
> -	create->result = pid;
> +	create->result = ERR_PTR(pid);

Ouch.    You have a nasty race here.

If kthread runs before kernel_thread returns then setting
"create->result = ERR_PTR(pid);" could easily stomp 
"create->result = &self".


Eric

