Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbZFIKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbZFIKdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760819AbZFIKVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:19 -0400
Received: from kroah.org ([198.145.64.141]:55360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166AbZFIKVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:18 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:07 2009
Message-Id: <20090609094107.655778381@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 66/87] ptrace: fix possible zombie leak on PTRACE_DETACH
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 4576145c1ecdaaea9ef8976a48335206aa1ebf91 upstream.

When ptrace_detach() takes tasklist, the tracee can be SIGKILL'ed.  If it
has already passed exit_notify() we can leak a zombie, because a) ptracing
disables the auto-reaping logic, and b) ->real_parent was not notified
about the child's death.

ptrace_detach() should follow the ptrace_exit's logic, change the code
accordingly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Tested-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -94,6 +94,7 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
+extern int __ptrace_detach(struct task_struct *tracer, struct task_struct *p);
 extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -237,6 +237,8 @@ out:
 
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
+	int dead = 0;
+
 	if (!valid_signal(data))
 		return -EIO;
 
@@ -244,18 +246,21 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	/* protect against de_thread()->release_task() */
 	write_lock_irq(&tasklist_lock);
+	/* protect against de_thread()->release_task() */
 	if (child->ptrace) {
 		child->exit_code = data;
 
-		__ptrace_unlink(child);
+		dead = __ptrace_detach(current, child);
 
 		if (!child->exit_state)
 			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
+	if (unlikely(dead))
+		release_task(child);
+
 	return 0;
 }
 


