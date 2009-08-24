Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbZHXI5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbZHXI5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZHXI5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZHXI5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:57:08 -0400
Date: Mon, 24 Aug 2009 10:53:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
Message-ID: <20090824085331.GB475@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com> <4A923403.6010201@ct.jp.nec.com> <20090824083826.GA475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824083826.GA475@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Oleg Nesterov wrote:
>
> On 08/24, Hiroshi Shimamoto wrote:
> >
> > The point is that de_thread() waits until other thread calls wake_up_process().
> > In __exit_signal() when sig->count == 2, the thread calls wake_up_process(),
> > and then de_thread() will continue. However if another thread is during
> > copy_process(), the sig->count is incremented at copy_signal(). That makes
> > no wake_up_process().
>
> Yes. Imho signal->count must die. But I never had time to kill it.
>
> It is not needed. For example, __exit_signal() can just check
> thread_group_leader() instead of atomic_dec_and_test(sig->count).
>
> As for this bug, I'd like to think a bit more. But how about the
> patch below? With this patch
>
> 	- copy_process() increments signal/live only when we know
> 	  we start the new thread
>
> 	- if copy_process() fails, we just check CLONE_THREAD.
> 	  If true - do nothing, the counters were not changed.
> 	  If false - just release ->signal, counters must be 1.

Or we can do a bit smaller patch. But in any case, copy_process()
must not use sig->count as a refcounter.

And of course, it would be nice to avoid playing ->notify_count
games in copy_process() pathes.

Oleg


--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -816,7 +816,6 @@ static int copy_signal(unsigned long clo
 	struct signal_struct *sig;
 
 	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
 		atomic_inc(&current->signal->live);
 		return 0;
 	}
@@ -881,9 +880,7 @@ static void cleanup_signal(struct task_s
 {
 	struct signal_struct *sig = tsk->signal;
 
-	atomic_dec(&sig->live);
-
-	if (atomic_dec_and_test(&sig->count))
+	if (atomic_dec_and_test(&sig->live))
 		__cleanup_signal(sig);
 }
 
@@ -1239,6 +1236,7 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->count);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}

