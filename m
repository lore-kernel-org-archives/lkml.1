Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZLKDZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZLKDZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZLKDZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:25:42 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53932 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZLKDZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:25:41 -0500
Message-Id: <200912110325.nBB3PCw6030361@www262.sakura.ne.jp>
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()access
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: tglx@linutronix.de
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Dec 2009 12:25:12 +0900
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210142036.GA8226@redhat.com> <200912110008.BEJ00511.FVOJLtSMOFHOQF@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 10122009 #3111939, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 11 Dec 2009, Tetsuo Handa wrote:
> > > Usually tasklist gives enough protection, but if copy_process() fails
> > > it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> > > This means, without rcu lock find_pid_ns() can't scan the hash table
> > > safely.
> > 
> > So, we need to change below comment from "or" to "and" ?
> 
> No, both functions must be called with rcu_read_lock()
> 
> tasklist_lock read-held is not protecting the rcu lists and does not
> protect against a concurrent update. It merily protects against tasks
> going away or being added while we look up the lists.

So, rcu_read_lock() is mandatory.
But I couldn't understand why tasklist_lock being held is not mandatory.

Caller of these functions will use "struct task_struct" and expect that values
and pointers retrieved by dereferencing returned pointer are valid.

If "struct task_struct" was removed from the list due to missing tasklist_lock
between returning from find_task_by_pid_ns() and dereferencing, I worry that
values and pointers retrieved by dereferencing are invalid.

rcu_read_lock() being held will prevent the returned "struct task_struct" from
being kfree()d, but I think rcu_read_lock() being held does not prevent values
and pointers of "struct task_struct" from being invalidated.



Anyway, I browsed 2.6.32 for find_task_by_vpid() / find_task_by_pid_ns() users
and found below users which lacks read_lock(&tasklist_lock) or rcu_read_lock().

Users missing read_lock(&tasklist_lock) when calling find_task_by_vpid():

  get_net_ns_by_pid() in net/core/net_namespace.c
  seq_print_userip_objs() in kernel/trace/trace_output.c
  fill_pid() in kernel/taskstats.c
  fill_tgid() in kernel/taskstats.c
  futex_find_get_task() in kernel/futex.c
  SYSCALL_DEFINE3(get_robust_list) in kernel/futex.c
  compat_sys_get_robust_list() in kernel/futex_compat.c
  ptrace_get_task_struct() in kernel/ptrace.c
  do_send_specific() in kernel/signal.c
  find_get_context() in kernel/perf_event.c
  posix_cpu_clock_get() in kernel/posix-cpu-timers.c
  good_sigevent() in kernel/posix-timers.c
  attach_task_by_pid() in kernel/cgroup.c
  SYSCALL_DEFINE1(getpgid) in kernel/sys.c
  SYSCALL_DEFINE1(getsid) in kernel/sys.c
  do_sched_setscheduler() in kernel/sched.c

Users missing rcu_read_lock() when calling find_task_by_vpid():

  SYSCALL_DEFINE3(ioprio_set) in fs/ioprio.c
  SYSCALL_DEFINE2(ioprio_get) in fs/ioprio.c
  cap_get_target_pid() in kernel/capability.c
  audit_prepare_user_tty() in kernel/audit.c
  audit_receive_msg() in kernel/audit.c
  check_clock() in kernel/posix-cpu-timers.c
  posix_cpu_timer_create() in kernel/posix-cpu-timers.c
  SYSCALL_DEFINE3(setpriority) in kernel/sys.c
  SYSCALL_DEFINE2(getpriority) in kernel/sys.c
  SYSCALL_DEFINE2(setpgid) in kernel/sys.c
  SYSCALL_DEFINE1(sched_getscheduler) in kernel/sched.c
  SYSCALL_DEFINE2(sched_getparam) in kernel/sched.c
  sched_setaffinity() in kernel/sched.c
  sched_getaffinity() in kernel/sched.c
  SYSCALL_DEFINE2(sched_rr_get_interval) in kernel/sched.c
  tomoyo_is_select_one() in security/tomoyo/common.c
  tomoyo_read_pid() in security/tomoyo/common.c
  SYSCALL_DEFINE6(move_pages) in mm/migrate.c
  SYSCALL_DEFINE4(migrate_pages) in mm/mempolicy.c
  find_process_by_pid() in arch/mips/kernel/mips-mt-fpaff.c
  pfm_get_task() in arch/ia64/kernel/perfmon.c
  cxn_pin_by_pid() in arch/frv/mm/mmu-context.c

Users missing read_lock(&tasklist_lock) when calling find_task_by_pid_ns():

  rest_init() in init/main.c
  proc_pid_lookup() in fs/proc/base.c
  proc_task_lookup() in fs/proc/base.c
  first_tid() in fs/proc/base.c
  getthread() in kernel/kgdb.c
  mconsole_stack() in arch/um/drivers/mconsole_kern.c

Users missing rcu_read_lock() when calling find_task_by_pid_ns():

  rest_init() in init/main.c
  getthread() in kernel/kgdb.c
  mconsole_stack() in arch/um/drivers/mconsole_kern.c

Regarding users which lack rcu_read_lock(), users call
read_lock(&tasklist_lock) in order to access "struct task_struct" returned
by find_task_by_pid_ns() but they do not want to be bothered by internal pid
structure. Thus, the fix would be to add rcu_read_lock() and rcu_read_unlock()
inside find_task_by_pid_ns().

But how to check users which lack read_lock(&tasklist_lock) but expecting that
it is safe to access "struct task_struct" returned by find_task_by_pid_ns() ?
