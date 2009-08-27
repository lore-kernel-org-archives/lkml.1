Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZH0Roc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZH0Roc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZH0Roa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:44:30 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51769 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZH0Rnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O06hJzIKGBhbPFmKcfJ4X6WQibRZtaay+yaz07ZgZLFJdRu4cWoZX+vbgrwy+KykqQ
         +EM7Betd7EACAIg5+H12eDYdOJY13AjG04I2OLFtXHmrdrNK5shrN0TUd+N4AiA1No3j
         yOVqtB0lkdjjqIfZHP7Vt8nutZn+p80RqO5g4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 3/7] tracing: Don't trace kernel thread syscalls
Date: Thu, 27 Aug 2009 19:43:31 +0200
Message-Id: <1251395015-6329-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

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
-- 
1.6.2.3

