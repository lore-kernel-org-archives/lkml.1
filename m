Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZBAKwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZBAKwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZBAKwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:52:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59042 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZBAKv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:51:59 -0500
Date: Sun, 1 Feb 2009 11:49:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@lst.de, ebiederm@xmission.com, mingo@elte.hu, xemul@openvz.org,
       rusty@rustcorp.com.au, vgusev@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090201104919.GC5728@redhat.com>
References: <20090130123358.GA26216@redhat.com> <20090130134736.ce5910aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130134736.ce5910aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Andrew Morton wrote:
>
> On Fri, 30 Jan 2009 13:33:58 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> >  int kthread_stop(struct task_struct *k)
> >  {
> > +	struct kthread *kthread;
> >  	int ret;
> >  
> > -	mutex_lock(&kthread_stop_lock);
> > -
> > -	/* It could exit after stop_info.k set, but before wake_up_process. */
> > -	get_task_struct(k);
> > -
> >  	trace_sched_kthread_stop(k);
> > +	get_task_struct(k);
> >  
> > -	/* Must init completion *before* thread sees kthread_stop_info.k */
> > -	init_completion(&kthread_stop_info.done);
> > -	smp_wmb();
> > +	kthread = to_kthread(k);
> > +	barrier(); /* it might have exited */
> 
> Why the change from smp_wmb() to plain old barrier()?

These 2 barriers have nothing to do with each other.

Before this patch, smp_wmb() was needed to make sure kthread sees the
initialized &kthread_stop_info.done if it sees kthread_should_stop().

After the patch, this barrier() tells the compiler it must not move
"kthread = to_kthread(k)" down, under the "if (k->vfork_done)" check.
Because k->vfork_done is "volatile", it can be changed under us.

But, once we got the k->vfork_done != NULL we can use it safely, even
if the task exits in parallel. Because we have a reference to task_struct,
and thus to tsk->stack.

Oleg.

