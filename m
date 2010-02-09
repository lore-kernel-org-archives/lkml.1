Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0BIWIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:08:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab0BIWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:08:50 -0500
Date: Tue, 9 Feb 2010 14:08:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: oleg@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
Message-Id: <20100209140818.43bb9770.akpm@linux-foundation.org>
In-Reply-To: <201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
References: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
	<201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp>
	<20100208132101.GA7129@redhat.com>
	<alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
	<20100208171643.GA19230@redhat.com>
	<201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010 06:42:45 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> OK. I updated description.
> 
> As of 2.6.32 , below users are missing rcu_read_lock().
> 
> Users missing rcu_read_lock() when calling find_task_by_vpid():
> 
>   SYSCALL_DEFINE3(ioprio_set) in fs/ioprio.c
>   SYSCALL_DEFINE2(ioprio_get) in fs/ioprio.c
>   cap_get_target_pid() in kernel/capability.c

Actually, cap_get_target_pid() uses rcu_read_lock() and doesn't take
tasklist_lock.

>   audit_prepare_user_tty() in kernel/audit.c
>   audit_receive_msg() in kernel/audit.c
>   check_clock() in kernel/posix-cpu-timers.c
>   posix_cpu_timer_create() in kernel/posix-cpu-timers.c
>   SYSCALL_DEFINE3(setpriority) in kernel/sys.c
>   SYSCALL_DEFINE2(getpriority) in kernel/sys.c
>   SYSCALL_DEFINE2(setpgid) in kernel/sys.c
>   SYSCALL_DEFINE1(sched_getscheduler) in kernel/sched.c
>   SYSCALL_DEFINE2(sched_getparam) in kernel/sched.c
>   sched_setaffinity() in kernel/sched.c
>   sched_getaffinity() in kernel/sched.c
>   SYSCALL_DEFINE2(sched_rr_get_interval) in kernel/sched.c
>   tomoyo_is_select_one() in security/tomoyo/common.c
>   tomoyo_read_pid() in security/tomoyo/common.c
>   SYSCALL_DEFINE6(move_pages) in mm/migrate.c
>   SYSCALL_DEFINE4(migrate_pages) in mm/mempolicy.c
>   find_process_by_pid() in arch/mips/kernel/mips-mt-fpaff.c
>   pfm_get_task() in arch/ia64/kernel/perfmon.c
>   cxn_pin_by_pid() in arch/frv/mm/mmu-context.c
> 
> Users missing rcu_read_lock() when calling find_task_by_pid_ns():
> 
>   rest_init() in init/main.c
>   getthread() in kernel/kgdb.c
>   mconsole_stack() in arch/um/drivers/mconsole_kern.c
> 
> What should we do? Adding rcu_read_lock()/rcu_read_unlock() to each
> callers? Or adding rcu_read_lock()/rcu_read_unlock() inside
> find_task_by_pid_ns()?

Putting rcu_read_lock() in the callee isn't a complete solution. 
Because the function would still be returning a task_struct* without
any locking held and without taking a reference against it.  So that
pointer is useless to the caller!

We could add a new function which looks up the task and then takes a
reference on it, insde suitable locks.  The caller would then use the
task_struct and then remember to call put_task_struct() to unpin it. 
This prevents the task_struct from getting freed while it's being
manipulated, but it doesn't prevent fields within it from being altered
- that's up to the caller to sort out.

One fix is to go through all those callsites and add the rcu_read_lock.
That kinda sucks.  Perhaps writing the new function which returns a
pinned task_struct is better?

