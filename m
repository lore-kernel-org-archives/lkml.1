Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZLRBSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZLRBSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZLRBRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:17:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZLRBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:17:44 -0500
Date: Fri, 18 Dec 2009 02:11:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: [PATCH 4/7] export __ptrace_detach() and do_notify_parent_cldstop()
Message-ID: <20091218011132.GA29555@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export __ptrace_detach() and do_notify_parent_cldstop() for
ptrace-utrace.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    1 +
 include/linux/sched.h  |    1 +
 kernel/ptrace.c        |    2 +-
 kernel/signal.c        |    2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

--- V1/include/linux/ptrace.h~4_EXPORT_2_HELPERS	2009-12-18 00:20:50.000000000 +0100
+++ V1/include/linux/ptrace.h	2009-12-18 00:53:58.000000000 +0100
@@ -85,6 +85,7 @@ extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern int ptrace_attach(struct task_struct *tsk);
+extern bool __ptrace_detach(struct task_struct *tracer, struct task_struct *tracee);
 extern int ptrace_detach(struct task_struct *, unsigned int);
 extern void ptrace_disable(struct task_struct *);
 extern int ptrace_check_attach(struct task_struct *task, int kill);
--- V1/include/linux/sched.h~4_EXPORT_2_HELPERS	2009-12-18 00:20:50.000000000 +0100
+++ V1/include/linux/sched.h	2009-12-18 00:53:58.000000000 +0100
@@ -2081,6 +2081,7 @@ extern int kill_pgrp(struct pid *pid, in
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void do_notify_parent_cldstop(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
--- V1/kernel/ptrace.c~4_EXPORT_2_HELPERS	2009-09-24 21:38:54.000000000 +0200
+++ V1/kernel/ptrace.c	2009-12-18 00:53:58.000000000 +0100
@@ -271,7 +271,7 @@ static int ignoring_children(struct sigh
  * reap it now, in that case we must also wake up sub-threads sleeping in
  * do_wait().
  */
-static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 {
 	__ptrace_unlink(p);
 
--- V1/kernel/signal.c~4_EXPORT_2_HELPERS	2009-12-18 00:48:35.000000000 +0100
+++ V1/kernel/signal.c	2009-12-18 00:53:58.000000000 +0100
@@ -1494,7 +1494,7 @@ int do_notify_parent(struct task_struct 
 	return ret;
 }
 
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
+void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
 	unsigned long flags;

