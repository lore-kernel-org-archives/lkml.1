Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZHXImJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZHXImJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZHXImH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:42:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZHXImG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:42:06 -0400
Date: Mon, 24 Aug 2009 10:38:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
Message-ID: <20090824083826.GA475@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com> <4A923403.6010201@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A923403.6010201@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Hiroshi Shimamoto wrote:
>
> The point is that de_thread() waits until other thread calls wake_up_process().
> In __exit_signal() when sig->count == 2, the thread calls wake_up_process(),
> and then de_thread() will continue. However if another thread is during
> copy_process(), the sig->count is incremented at copy_signal(). That makes
> no wake_up_process().

Yes. Imho signal->count must die. But I never had time to kill it.

It is not needed. For example, __exit_signal() can just check
thread_group_leader() instead of atomic_dec_and_test(sig->count).

As for this bug, I'd like to think a bit more. But how about the
patch below? With this patch

	- copy_process() increments signal/live only when we know
	  we start the new thread

	- if copy_process() fails, we just check CLONE_THREAD.
	  If true - do nothing, the counters were not changed.
	  If false - just release ->signal, counters must be 1.

Oleg.

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -815,11 +815,8 @@ static int copy_signal(unsigned long clo
 {
 	struct signal_struct *sig;
 
-	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
-		atomic_inc(&current->signal->live);
+	if (clone_flags & CLONE_THREAD)
 		return 0;
-	}
 
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
@@ -877,16 +874,6 @@ void __cleanup_signal(struct signal_stru
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static void cleanup_signal(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-
-	atomic_dec(&sig->live);
-
-	if (atomic_dec_and_test(&sig->count))
-		__cleanup_signal(sig);
-}
-
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
@@ -1239,6 +1226,8 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}
@@ -1282,7 +1271,8 @@ bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
 bad_fork_cleanup_signal:
-	cleanup_signal(p);
+	if (!(clone_flags & CLONE_THREAD))
+		__cleanup_signal(p);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:

