Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab0BDJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:60115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab0BDJ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:04 -0500
Date: Thu, 4 Feb 2010 09:55:07 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, compudj@krystal.dyndns.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, compudj@krystal.dyndns.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20100202214904.4694.24330.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214904.4694.24330.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Disable booster when CONFIG_PREEMPT=y
Message-ID: <tip-615d0ebbc782b67296e3226c293f520f93f93515@git.kernel.org>
Git-Commit-ID: 615d0ebbc782b67296e3226c293f520f93f93515
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:55:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  615d0ebbc782b67296e3226c293f520f93f93515
Gitweb:     http://git.kernel.org/tip/615d0ebbc782b67296e3226c293f520f93f93515
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 2 Feb 2010 16:49:04 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:36:18 +0100

kprobes: Disable booster when CONFIG_PREEMPT=y

Disable kprobe booster when CONFIG_PREEMPT=y at this time,
because it can't ensure that all kernel threads preempted on
kprobe's boosted slot run out from the slot even using
freeze_processes().

The booster on preemptive kernel will be resumed if
synchronize_tasks() or something like that is introduced.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100202214904.4694.24330.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/kernel/kprobes.c |    2 +-
 arch/x86/kernel/kprobes.c  |    2 +-
 kernel/kprobes.c           |   29 ++---------------------------
 3 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 9adac44..7026b29 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -870,7 +870,7 @@ static int __kprobes pre_kprobes_handler(struct die_args *args)
 		return 1;
 
 ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
+#if !defined(CONFIG_PREEMPT)
 	if (p->ainsn.inst_flag == INST_FLAG_BOOSTABLE && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		ia64_psr(regs)->ri = p->ainsn.slot;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 5b8c750..9453815 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -429,7 +429,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb)
 {
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
+#if !defined(CONFIG_PREEMPT)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b7df302..9907a03 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -124,30 +124,6 @@ static LIST_HEAD(kprobe_insn_pages);
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
 
-static int __kprobes check_safety(void)
-{
-	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
-	ret = freeze_processes();
-	if (ret == 0) {
-		struct task_struct *p, *q;
-		do_each_thread(p, q) {
-			if (p != current && p->state == TASK_RUNNING &&
-			    p->pid != 0) {
-				printk("Check failed: %s is running\n",p->comm);
-				ret = -1;
-				goto loop_end;
-			}
-		} while_each_thread(p, q);
-	}
-loop_end:
-	thaw_processes();
-#else
-	synchronize_sched();
-#endif
-	return ret;
-}
-
 /**
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
@@ -235,9 +211,8 @@ static int __kprobes collect_garbage_slots(void)
 {
 	struct kprobe_insn_page *kip, *next;
 
-	/* Ensure no-one is preepmted on the garbages */
-	if (check_safety())
-		return -EAGAIN;
+	/* Ensure no-one is interrupted on the garbages */
+	synchronize_sched();
 
 	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
 		int i;
