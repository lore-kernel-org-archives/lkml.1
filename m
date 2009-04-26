Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZDZXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZDZXWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZDZXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:22:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbZDZXWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:22:08 -0400
Date: Mon, 27 Apr 2009 01:18:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jeff Dike <jdike@addtoit.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: copy_process() && ti->flags (Was: PT_DTRACE && uml)
Message-ID: <20090426231820.GB6580@redhat.com>
References: <20090416204004.GA28013@redhat.com> <20090416232430.4DAE4FC3C6@magilla.sf.frob.com> <20090420183718.GC32527@redhat.com> <20090421011354.4B19EFC3C7@magilla.sf.frob.com> <20090421214819.GA22845@redhat.com> <20090422032205.B8D39FC3C7@magilla.sf.frob.com> <20090422220400.GA22755@redhat.com> <20090422221726.GC22755@redhat.com> <20090423160229.GA9820@c2.user-mode-linux.org> <20090426220954.GA6580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426220954.GA6580@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Oleg Nesterov wrote:
>
> Do you see other problems with this patch? (uncompiled, untested).

dup_task_struct()->setup_thread_stack() copies parent's ti->flags.

Why? Which flags should be actually copied? I must have missed
something, but whats wrong with the patch below?

OK, it is wrong. On x86 we should at least copy TIF_IA32. But
why should we copy, say, TIF_DEBUG?

Actually, I don't understand why don't we use TS_IA32 instead of
TIF_IA32. Only current can change this flag, perhaps it makes sense
to move it in thread_info->status.

copy_process()->clear_tsk_thread_flag(TIF_SIGPENDING) looks unneeded
in any case...

Oleg.


--- kernel/fork.c
+++ kernel/fork.c
@@ -241,6 +241,7 @@ static struct task_struct *dup_task_stru
 		goto out;
 
 	setup_thread_stack(tsk, orig);
+	ti->flags = 0;
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
@@ -1027,7 +1028,6 @@ static struct task_struct *copy_process(
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
-	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;
@@ -1163,14 +1163,6 @@ static struct task_struct *copy_process(
 	if ((clone_flags & (CLONE_VM|CLONE_VFORK)) == CLONE_VM)
 		p->sas_ss_sp = p->sas_ss_size = 0;
 
-	/*
-	 * Syscall tracing should be turned off in the child regardless
-	 * of CLONE_PTRACE.
-	 */
-	clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
-#ifdef TIF_SYSCALL_EMU
-	clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
-#endif
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */

