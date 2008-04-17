Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbYDQQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbYDQQ7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbYDQQ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:59:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55877 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbYDQQ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:59:20 -0400
Date: Thu, 17 Apr 2008 20:05:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: fork_idle && pid problems ?
Message-ID: <20080417160521.GA4482@tv-sign.ru>
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru> <20080417130252.GB6640@elte.hu> <20080417140246.GA257@tv-sign.ru> <480771DC.5040002@openvz.org> <20080417153644.GA69@tv-sign.ru> <48077D65.1090207@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48077D65.1090207@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Pavel Emelyanov wrote:
>
> Oleg Nesterov wrote:
> >> Well, these was some request to make tasks always have pid link
> >> point to not NULL (from Matt?) so we'll need this :)
> > 
> > For now I'd suggest the patch below. If contrary to our expectations
> > there is any usage of idle_task->pids, we will notice ;)
> > 
> > Oleg.
> > 
> > --- kernel/fork.c~	2008-03-07 18:11:27.000000000 +0300
> > +++ kernel/fork.c	2008-04-17 19:34:10.000000000 +0400
> > @@ -1420,6 +1420,9 @@ struct task_struct * __cpuinit fork_idle
> >  	if (!IS_ERR(task))
> >  		init_idle(task, cpu);
> >  
> > +	/* COMMENT */
> > +	memset(task->pids, 0, sizeof task->pids);
> > +
> 
> Hm... Looks ok, but I'd suggest such patch instead:
> 
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1348,6 +1348,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		}
>  		attach_pid(p, PIDTYPE_PID, pid);
>  		nr_threads++;
> +	} else {
> +		p->pids[PIDTYPE_PID].pid = NULL;
> +		p->pids[PIDTYPE_SID].pid = NULL;
> +		p->pids[PIDTYPE_PGID].pid = NULL;
>  	}

This penalizes the "normal" fork()...

> it will cover cases, when we (if ever) call the copy_process from
> other place. Oh, well...

We must not use init_struct_pid as an argument for copy_process(), except
in fork_idle(). Note that the result of copy_process(init_struct_pid) is
not "visible", we can't find it via find_pid() or see it on init_task.tasks.

Not that I have a strong opinion, though. In any case, I think this is
harmless. But "not good" anyway.

Oleg.

