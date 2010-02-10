Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0BJQa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:30:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49210 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab0BJQay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:30:54 -0500
Date: Wed, 10 Feb 2010 10:30:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, oleg@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
Message-ID: <20100210163033.GA12251@us.ibm.com>
References: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
 <201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp>
 <20100208132101.GA7129@redhat.com>
 <alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
 <20100208171643.GA19230@redhat.com>
 <201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
 <20100209140818.43bb9770.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209140818.43bb9770.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 9 Feb 2010 06:42:45 +0900
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
> > OK. I updated description.
> > 
> > As of 2.6.32 , below users are missing rcu_read_lock().
> > 
> > Users missing rcu_read_lock() when calling find_task_by_vpid():
> > 
> >   SYSCALL_DEFINE3(ioprio_set) in fs/ioprio.c
> >   SYSCALL_DEFINE2(ioprio_get) in fs/ioprio.c
> >   cap_get_target_pid() in kernel/capability.c
> 
> Actually, cap_get_target_pid() uses rcu_read_lock() and doesn't take
> tasklist_lock.

Hmm - is that in -mm?  In my copy here it takes read_lock(&tasklist_lock)

And I'll admit I'm a bit confused as to the current state of things:
do I understand correctly that we now need to take both the tasklist_lock
and rcu_read_lock?  (Presumably only for read_lock()?)

> >   audit_prepare_user_tty() in kernel/audit.c
> >   audit_receive_msg() in kernel/audit.c
> >   check_clock() in kernel/posix-cpu-timers.c
> >   posix_cpu_timer_create() in kernel/posix-cpu-timers.c
> >   SYSCALL_DEFINE3(setpriority) in kernel/sys.c
> >   SYSCALL_DEFINE2(getpriority) in kernel/sys.c
> >   SYSCALL_DEFINE2(setpgid) in kernel/sys.c
> >   SYSCALL_DEFINE1(sched_getscheduler) in kernel/sched.c
> >   SYSCALL_DEFINE2(sched_getparam) in kernel/sched.c
> >   sched_setaffinity() in kernel/sched.c
> >   sched_getaffinity() in kernel/sched.c
> >   SYSCALL_DEFINE2(sched_rr_get_interval) in kernel/sched.c
> >   tomoyo_is_select_one() in security/tomoyo/common.c
> >   tomoyo_read_pid() in security/tomoyo/common.c
> >   SYSCALL_DEFINE6(move_pages) in mm/migrate.c
> >   SYSCALL_DEFINE4(migrate_pages) in mm/mempolicy.c
> >   find_process_by_pid() in arch/mips/kernel/mips-mt-fpaff.c
> >   pfm_get_task() in arch/ia64/kernel/perfmon.c
> >   cxn_pin_by_pid() in arch/frv/mm/mmu-context.c
> > 
> > Users missing rcu_read_lock() when calling find_task_by_pid_ns():
> > 
> >   rest_init() in init/main.c
> >   getthread() in kernel/kgdb.c
> >   mconsole_stack() in arch/um/drivers/mconsole_kern.c
> > 
> > What should we do? Adding rcu_read_lock()/rcu_read_unlock() to each
> > callers? Or adding rcu_read_lock()/rcu_read_unlock() inside
> > find_task_by_pid_ns()?
> 
> Putting rcu_read_lock() in the callee isn't a complete solution. 
> Because the function would still be returning a task_struct* without
> any locking held and without taking a reference against it.  So that
> pointer is useless to the caller!
> 
> We could add a new function which looks up the task and then takes a
> reference on it, insde suitable locks.  The caller would then use the
> task_struct and then remember to call put_task_struct() to unpin it. 
> This prevents the task_struct from getting freed while it's being
> manipulated, but it doesn't prevent fields within it from being altered
> - that's up to the caller to sort out.
> 
> One fix is to go through all those callsites and add the rcu_read_lock.
> That kinda sucks.  Perhaps writing the new function which returns a
> pinned task_struct is better?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
