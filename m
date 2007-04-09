Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXDIImz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXDIImz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXDIImz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:42:55 -0400
Received: from mail.screens.ru ([213.234.233.54]:34354 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbXDIImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:42:54 -0400
Date: Mon, 9 Apr 2007 12:42:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, dtor@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: + add-locking-to-evdev.patch added to -mm tree
Message-ID: <20070409084234.GA92@tv-sign.ru>
References: <20070408041611.GA18559@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408041611.GA18559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Paul E. McKenney wrote:
>
> The __kill_fasync() function in turn calls send_sigio(), which
> read-acquires both the fown_struct lock and tasklist_lock, then does
> send_sigio_to_task() for each thread in the task.
> 
> The send_sigio_to_task() function invokes group_send_sig_info(), which
> calls lock_task_sighand(), which expects one of its callers to have
> done an rcu_read_lock().  But I believe that read-holding tasklist_lock
> also suffices.  Oleg, could you please either confirm or educate?  @@@
> 
> (I think this is OK, just been awhile since I dug through the signal
> code.)

I also think this is OK.

The comment above lock_task_sighand() is not very clear. Note that it is
_not_ safe in general to do

	read_lock(tasklist_lock);
	lock_task_sighand(tsk);

even if we know that tsk can't go away (say, get_task_struct()).

However, it is safe to do:

	read_lock(tasklist_lock);
	tsk = find_task_in_pids_database();
	lock_task_sighand(tsk);

"find_task_in_pids_database" means something like find_task_by_pid_type() or
do_each_pid_task() (our case). Because read_lock(tasklist_lock) protects us
from release_task()->__exit_signal() which clears ->sighand _and_ removes tsk
from kernel/pid.c:pid_hash[] "atomically" under write_lock_irq(tasklist_lock).

rcu_read_lock() is OK for both cases. It would be nice to convert send_sigio()
to use RCU, but we also need tasklist_lock for

	- SIGCONT, see sig_needs_tasklist()

	- group wide signals (PIDTYPE_PGID), see the comment in copy_process()
	  above the recalc_sigpending() call.

Oleg.

