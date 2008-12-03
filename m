Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYLCQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYLCQ1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYLCQ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:26:50 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:56670 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLCQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:26:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CAS+i4UUqgjdjQnpIpJ6Sv5nPe+bzOfhxGyMgNSXjO2VwZPMliiPklncBLEmRs7gXu
         E5vzPWLfZ1O/jQk1PYARliHSKuwd+JeHKvLwW6fP0Lyp4cjOHgqmaBAxNQi558xwQ81C
         QL4S+u/ODSm6/A7Ll+4pAckMsK/6awthh2mJc=
Message-ID: <c62985530812030826g47e2c81ere1c02942f8e8b1a4@mail.gmail.com>
Date: Wed, 3 Dec 2008 17:26:47 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] ftrace: fix race in function graph during fork
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081203160547.722050069@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203160448.972919719@goodmis.org>
	 <20081203160547.722050069@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: fix
>
> There is a nasy race in startup of a new process running the
> function graph tracer. In fork.c:
>
>        total_forks++;
>        spin_unlock(&current->sighand->siglock);
>        write_unlock_irq(&tasklist_lock);
>        ftrace_graph_init_task(p);
>        proc_fork_connector(p);
>        cgroup_post_fork(p);
>        return p;
>
> The new task is free to run as soon as the tasklist_lock is released.
> This is before the ftrace_graph_init_task. If the task does run
> it will be using the same ret_stack and curr_ret_stack as the parent.
> This will cause horrible crashes that are nasty to debug.
>
> This patch moves the ftrace_graph_init_task to just after the alloc_pid
> code. This fixes the above race.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/fork.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index afb376d..91cca76 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1142,6 +1142,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                }
>        }
>
> +       ftrace_graph_init_task(p);
> +
>        p->pid = pid_nr(pid);
>        p->tgid = p->pid;
>        if (clone_flags & CLONE_THREAD)
> @@ -1150,7 +1152,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>        if (current->nsproxy != p->nsproxy) {
>                retval = ns_cgroup_clone(p, pid);
>                if (retval)
> -                       goto bad_fork_free_pid;
> +                       goto bad_fork_free_graph;
>        }
>
>        p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
> @@ -1243,7 +1245,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                spin_unlock(&current->sighand->siglock);
>                write_unlock_irq(&tasklist_lock);
>                retval = -ERESTARTNOINTR;
> -               goto bad_fork_free_pid;
> +               goto bad_fork_free_graph;
>        }
>
>        if (clone_flags & CLONE_THREAD) {
> @@ -1276,11 +1278,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>        total_forks++;
>        spin_unlock(&current->sighand->siglock);
>        write_unlock_irq(&tasklist_lock);
> -       ftrace_graph_init_task(p);
>        proc_fork_connector(p);
>        cgroup_post_fork(p);
>        return p;
>
> +bad_fork_free_graph:
> +       ftrace_graph_exit_task(p);
>  bad_fork_free_pid:
>        if (pid != &init_struct_pid)
>                free_pid(pid);


Very nice catch! Thanks.
