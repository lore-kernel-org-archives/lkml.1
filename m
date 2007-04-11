Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXDKEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXDKEF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXDKEF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:05:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35117 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778AbXDKEF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:05:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] reparent kernel threads to swapper
References: <20070410185222.GA107@tv-sign.ru>
Date: Tue, 10 Apr 2007 22:04:19 -0600
In-Reply-To: <20070410185222.GA107@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 22:52:22 +0400")
Message-ID: <m1slb7v9oc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> A lot of kernel threads parented to /sbin/init slow down do_wait() when
> a non-detached (user-space) process exits. Change reparent_kthread() to
> use init_task as a parent. Since init_task can't go away, we don't need
> to put the caller on init_task.children list.

Is there any downside of putting tasks on init_task.children?

If not it is probably a good idea to put processes there just for good measure.

> NOTE: pstree doesn't show kernel threads with this patch.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- 2.6.21-rc5/kernel/exit.c~3_SWAPPER	2007-04-10 21:59:41.000000000 +0400
> +++ 2.6.21-rc5/kernel/exit.c	2007-04-10 22:25:25.000000000 +0400
> @@ -255,11 +255,11 @@ static int has_stopped_jobs(struct pid *
>  }
>  
>  /**
> - * reparent_kthread - Reparent the calling kernel thread to the init task of
> the pid space that the thread belongs to.
> + * reparent_kthread - Reparent the calling kernel thread to swapper.
>   *
>   * If a kernel thread is launched as a result of a system call, or if
> - * it ever exits, it should generally reparent itself to init so that
> - * it is correctly cleaned up on exit.
> + * it ever exits, it should generally reparent itself so that it is
> + * correctly cleaned up on exit.
>   *
>   * The various task state such as scheduling policy and priority may have
>   * been inherited from a user process, so we reset them to sane values here.
> @@ -272,9 +272,8 @@ void reparent_kthread(void)
>  
>  	ptrace_unlink(current);
>  	remove_parent(current);
> -	current->parent = init_pid_ns.child_reaper;
> +	current->parent = &init_task;
>  	current->real_parent = current->parent;
> -	add_parent(current);
>  
>  	/* make the task auto-reap */
>  	current->exit_signal = -1;
