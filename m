Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZAaMQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZAaMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZAaMQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:16:18 -0500
Received: from ozlabs.org ([203.10.76.45]:44935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZAaMQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:16:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Date: Sat, 31 Jan 2009 22:46:07 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com> <20090130125058.GA26931@redhat.com>
In-Reply-To: <20090130125058.GA26931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901312246.07737.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 23:20:58 Oleg Nesterov wrote:
> On 01/30, Oleg Nesterov wrote:
> >
> > With this patch kthread() allocates all neccesary data (struct kthread)
> > on its own stack, globals kthread_stop_xxx are deleted. ->vfork_done
> > is used as a pointer into "struct kthread", this means kthread_stop()
> > can easily wait for kthread's exit.
> 
> To simplify the review, please see the code with the patch applied.

Hmm, I thought about using the parent-child relationship and fairly normal
wait() semantics, but this looks simpler.

> struct kthread {
> 	int should_stop;
> 	struct completion exited;
> };

Mildly prefer bool in new code.

> #define to_kthread(tsk)	\
> 	container_of((tsk)->vfork_done, struct kthread, exited)

This needs a comment.  Especially since to_xxx(yyy) is usually simply a
container_of(yyy, xxx, member).  This one is special.

> int kthread_stop(struct task_struct *k)
> {
> 	struct kthread *kthread;
> 	int ret;
> 
> 	trace_sched_kthread_stop(k);
> 	get_task_struct(k);
> 
> 	kthread = to_kthread(k);
> 	barrier(); /* it might have exited */
> 	if (k->vfork_done != NULL) {
> 		kthread->should_stop = 1;
> 		wake_up_process(k);
> 		wait_for_completion(&kthread->exited);
> 	}
> 	ret = k->exit_code;

I don't think this works.  How does do_exit() preserve a stack var, other
than for a few cycles longer?  Sure, the vfork_done will be OK, but this code
here will not be.  I think you'd need a get_task_struct(current) before the
do_exit(ret) (the case where the kthread fn calls do_exit() is fine: you're
not allowed to call kthread stop on such threads).

In which case using vfork_done is really just a convenience pointer inside
struct task_struct to stash the struct kthread.  And that's horribly ugly, which is why I stuck with a simple global.  Changing to a linked-list of things to stop would avoid the deadlock you mentioned where a kthread stops another kthread.

Thanks,
Rusty.
