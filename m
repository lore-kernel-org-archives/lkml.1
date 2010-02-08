Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0BHVmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:42:54 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60163 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab0BHVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:42:51 -0500
To: oleg@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Update comment on find_task_by_pid_ns
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LFD.2.00.0912102214180.3089@localhost.localdomain>
	<201002082130.JDC57339.OHOVJFQtFSLFMO@I-love.SAKURA.ne.jp>
	<20100208132101.GA7129@redhat.com>
	<alpine.LFD.2.00.1002081802510.2811@localhost.localdomain>
	<20100208171643.GA19230@redhat.com>
In-Reply-To: <20100208171643.GA19230@redhat.com>
Message-Id: <201002090642.EBE48414.HLJVFOQFSOFOMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 9 Feb 2010 06:42:45 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I updated description.

As of 2.6.32 , below users are missing rcu_read_lock().

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

Users missing rcu_read_lock() when calling find_task_by_pid_ns():

  rest_init() in init/main.c
  getthread() in kernel/kgdb.c
  mconsole_stack() in arch/um/drivers/mconsole_kern.c

What should we do? Adding rcu_read_lock()/rcu_read_unlock() to each
callers? Or adding rcu_read_lock()/rcu_read_unlock() inside
find_task_by_pid_ns()?
--------------------
[PATCH] Update comment on find_task_by_pid_ns

tasklist does protect the task and its pid, it can't go away. The problem
is that find_pid_ns() itself is unsafe without rcu lock, it can race with
copy_process()->free_pid(any_pid).

Protecting copy_process()->free_pid(any_pid) with tasklist_lock would make it
possible to call find_task_by_pid_ns() under tasklist safely, but we don't do
so because we are trying to get rid of the read_lock sites of tasklist_lock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/kernel/pid.c
+++ linux-next/kernel/pid.c
@@ -376,7 +376,7 @@ struct task_struct *pid_task(struct pid 
 EXPORT_SYMBOL(pid_task);
 
 /*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
+ * Must be called under rcu_read_lock().
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
