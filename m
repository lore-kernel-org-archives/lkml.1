Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZHYQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZHYQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZHYQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:02:29 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:60476 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZHYQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:02:28 -0400
Date: Tue, 25 Aug 2009 18:02:37 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
	jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20090825141547.GE6114@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825141547.GE6114@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 04:15:49PM +0200, Frederic Weisbecker wrote:
> On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > There are at least two scenarios where syscall_get_nr() can return -1:
> > 
> > 1. For example, ptrace stores an invalid syscall number, and thus,
> >    tracing code resets it.
> >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > 
> > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> >    kernel threads.
> >    However, the ftrace selftest triggers a kernel oops when testing syscall
> >    trace points:
> >       - The kernel thread is started as ususal (do_fork()),
> >       - tracing code sets TIF_SYSCALL_FTRACE,
> >       - the ret_from_fork() function is triggered and starts
> > 	ftrace_syscall_exit() with an invalid syscall number.
> 
> 
> 
> I wonder if there is any way to identify such situation...?
For the second case, it might be an option to avoid setting the
TIF_SYSCALL_FTRACE flag for kernel threads.

Kernel threads have task_struct->mm set to NULL.
(Thanks to Heiko for that hint ;-)

The idea is then to check the mm field in syscall_regfunc() and
set the flag accordingly.

However, I think the patch is an optional add-on becase checking
the syscall number is still required for case 1).

---
 kernel/tracepoint.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -593,7 +593,9 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+			/* Skip kernel threads. */
+			if (t->mm)
+				set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}

