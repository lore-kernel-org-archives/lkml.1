Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYCYN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYCYN5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYCYN5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:57:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50940 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYCYN5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:57:06 -0400
Date: Tue, 25 Mar 2008 16:56:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1 case
Message-ID: <20080325135645.GA96@tv-sign.ru>
References: <47E87F2A.2040303@bk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E87F2A.2040303@bk.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Atsushi Tsuji wrote:
> 
> This patch avoid taking tasklist_lock in kill_something_info() when
> the pid is -1. It can convert to rcu_read_lock() for this case because
> group_send_sig_info() doesn't need tasklist_lock.
> 
> This patch is for 2.6.25-rc5-mm1.
> 
> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
> ---
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 3edbfd4..a888c58 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1089,14 +1089,16 @@ static int kill_something_info(int sig, struct 
> siginfo *info, int pid)
>  		return ret;
>  	}
> 
> -	read_lock(&tasklist_lock);
>  	if (pid != -1) {
> +		read_lock(&tasklist_lock);
>  		ret = __kill_pgrp_info(sig, info,
>  				pid ? find_vpid(-pid) : task_pgrp(current));
> +		read_unlock(&tasklist_lock);
>  	} else {
>  		int retval = 0, count = 0;
>  		struct task_struct * p;
> 
> +		rcu_read_lock();
>  		for_each_process(p) {
>  			if (p->pid > 1 && !same_thread_group(p, current)) {
>  				int err = group_send_sig_info(sig, info, p);
> @@ -1106,8 +1108,8 @@ static int kill_something_info(int sig, struct 
> siginfo *info, int pid)
>  			}
>  		}
>  		ret = count ? retval : -ESRCH;
> +		rcu_read_unlock();
>  	}
> -	read_unlock(&tasklist_lock);
> 
>  	return ret;
>  }

Hmm. Yes, group_send_sig_info() doesn't need tasklist_lock. But we
take tasklist_lock to "freeze" the tasks list, so that we can't miss
a new forked process.

Same for __kill_pgrp_info(), we take tasklist to kill the whole group
"atomically".


However. Is it really needed? copy_process() returns -ERESTARTNOINTR
if signal_pending(), and the new task is always placed at the tail
of the list. Looks like nobody can escape the signal, at least fatal
or SIGSTOP.

If the signal is blocked/ignored or has a handler, we can miss a forked
child, but this looks OK, we can pretend it was forked after we dropped
tasklist_lock.

Note also that copy_process() does list_add_tail_rcu(p->tasks) under
->siglock, this means kill_something_info() must see the new childs
after group_send_sig_info() drops ->siglock.


Except: We don't send the signal to /sbin/init. This means that (say)
kill(-1, SIGKILL) can miss the task forked by init. Note that this
task could be forked even before we start kill_something_info(), but
without tasklist there is no guarantee we will see it on the ->tasks
list.

I think this is the only problem with this change.

Eric, Roland?

(Unfortunately, attach_pid() adds the task to the head of hlist, this
 means we can't avoid tasklist for __kill_pgrp_info).

Oleg.

