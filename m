Return-Path: <linux-kernel-owner+w=401wt.eu-S1764403AbYDQM5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764403AbYDQM5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbYDQM5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:57:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50401 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbYDQM5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:57:30 -0400
Date: Thu, 17 Apr 2008 15:57:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible mem leak in copy_process()
Message-ID: <20080417115718.GC103@tv-sign.ru>
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh! I'm not sure I really understand what Coverity says, to the
point I am not sure where it thinks the bug is, but

On 04/16, Jesper Juhl wrote:
> 
> At conditional (16): "(p)->pid != 0" taking false path
> 
> 1331 		if (likely(p->pid)) {
> 1332 			add_parent(p);
> 1333 			if (unlikely(p->ptrace & PT_PTRACED))
> 1334 				__ptrace_link(p, current->parent);
> 1335 	
> 1336 			if (thread_group_leader(p)) {
> 1337 				if (clone_flags & CLONE_NEWPID)
> 1338 					p->nsproxy->pid_ns->child_reaper = p;
> 1339 	
> 1340 				p->signal->leader_pid = pid;
> 1341 				p->signal->tty = current->signal->tty;
> 1342 				set_task_pgrp(p, task_pgrp_nr(current));
> 1343 				set_task_session(p, task_session_nr(current));
> 1344 				attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
> 1345 				attach_pid(p, PIDTYPE_SID, task_session(current));
> 1346 				list_add_tail_rcu(&p->tasks, &init_task.tasks);
> 1347 				__get_cpu_var(process_counts)++;
> 1348 			}
> 1349 			attach_pid(p, PIDTYPE_PID, pid);
> 1350 			nr_threads++;
> 1351 		}
> 1352 	
> 1353 		total_forks++;
> 1354 		spin_unlock(&current->sighand->siglock);
> 1355 		write_unlock_irq(&tasklist_lock);
> 1356 		proc_fork_connector(p);
> 1357 		cgroup_post_fork(p);
> 
> Event leaked_storage: Returned without freeing storage "pid"
> Also see events: [alloc_fn][var_assign][pass_arg]

this looks like a false alarm.

p->pid == pid->numbers[0].nr. If "struct pid *pid" was allocated,
its .nr can't be 0.

IOW, !p->pid means that pid == init_struct_pid, it wasn't allocated
but was passed from the caller.

Oleg.

