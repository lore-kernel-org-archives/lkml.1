Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZA3Mxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZA3Mxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZA3Mx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:53:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZA3Mx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:53:28 -0500
Date: Fri, 30 Jan 2009 13:50:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090130125058.GA26931@redhat.com>
References: <20090130123358.GA26216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130123358.GA26216@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Oleg Nesterov wrote:
>
> With this patch kthread() allocates all neccesary data (struct kthread)
> on its own stack, globals kthread_stop_xxx are deleted. ->vfork_done
> is used as a pointer into "struct kthread", this means kthread_stop()
> can easily wait for kthread's exit.

To simplify the review, please see the code with the patch applied.

Oleg.

struct kthread {
	int should_stop;
	struct completion exited;
};

#define to_kthread(tsk)	\
	container_of((tsk)->vfork_done, struct kthread, exited)

int kthread_should_stop(void)
{
	return to_kthread(current)->should_stop;
}

static int kthread(void *_create)
{
	/* Copy data: it's on kthread's stack */
	struct kthread_create_info *create = _create;
	int (*threadfn)(void *data) = create->threadfn;
	void *data = create->data;
	struct kthread self;
	int ret;

	self.should_stop = 0;
	init_completion(&self.exited);
	current->vfork_done = &self.exited;

	/* OK, tell user we're spawned, wait for stop or wakeup */
	__set_current_state(TASK_UNINTERRUPTIBLE);
	create->result = current;
	complete(&create->done);
	schedule();

	ret = -EINTR;
	if (!self.should_stop)
		ret = threadfn(data);

	/* we can't just return, we must preserve "self" on stack */
	do_exit(ret);
}

int kthread_stop(struct task_struct *k)
{
	struct kthread *kthread;
	int ret;

	trace_sched_kthread_stop(k);
	get_task_struct(k);

	kthread = to_kthread(k);
	barrier(); /* it might have exited */
	if (k->vfork_done != NULL) {
		kthread->should_stop = 1;
		wake_up_process(k);
		wait_for_completion(&kthread->exited);
	}
	ret = k->exit_code;

	put_task_struct(k);
	trace_sched_kthread_stop_ret(ret);

	return ret;
}

