Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZH1M3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZH1M3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZH1M3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZH1M24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:28:56 -0400
Date: Fri, 28 Aug 2009 12:28:05 GMT
From: tip-bot for Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@polymtl.ca, brueckner@linux.vnet.ibm.com,
       mingo@redhat.com, schwidefsky@de.ibm.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, jbaron@redhat.com, laijs@cn.fujitsu.com,
       hpa@zytor.com, jiayingz@google.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, lethal@linux-sh.org, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, brueckner@linux.vnet.ibm.com,
       mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
       schwidefsky@de.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, jbaron@redhat.com,
       laijs@cn.fujitsu.com, hpa@zytor.com, jiayingz@google.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, lethal@linux-sh.org,
       mingo@elte.hu, mbligh@google.com
In-Reply-To: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
References: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Don't trace kernel thread syscalls
Message-ID: <tip-cc3b13c11c567c69a6356be98d0c03ff11541d5c@git.kernel.org>
Git-Commit-ID: cc3b13c11c567c69a6356be98d0c03ff11541d5c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:28:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc3b13c11c567c69a6356be98d0c03ff11541d5c
Gitweb:     http://git.kernel.org/tip/cc3b13c11c567c69a6356be98d0c03ff11541d5c
Author:     Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Aug 2009 18:02:37 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:29:52 +0200

tracing: Don't trace kernel thread syscalls

Kernel threads don't call syscalls using the sysenter/sysexit
path. Instead they directly call the sys_* or do_* functions
that implement the syscalls inside the kernel.

The current syscall tracepoints only bind the sysenter/sysexit
path, then it has no effect to trace the kernel thread calls
to syscalls in that path.
Setting the TIF_SYSCALL_TRACEPOINT flag is then useless for these.

Actually there is only one case when a kernel thread can reach the
usual syscall exit tracing path: when we create a kernel thread, the
child comes to ret_from_fork and is the fork() return is then traced.
But this information alone is useless, then we don't want to set the
TIF flags for these threads.

Kernel threads have task_struct->mm set to NULL.
(Thanks to Heiko for that hint ;-)
The idea is then to check the mm field in syscall_regfunc() and
set the flag accordingly.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
LKML-Reference: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 kernel/tracepoint.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1a6a453..9489a0a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -597,7 +597,9 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+			/* Skip kernel threads. */
+			if (t->mm)
+				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
