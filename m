Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYKZL6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYKZL6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYKZL6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:58:05 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32428 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYKZL6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:58:01 -0500
From: Andrey Mirkin <major@openvz.org>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH 2/2] Add support for in-kernel process creation during restart
Date: Wed, 26 Nov 2008 15:58:00 +0400
User-Agent: KMail/1.8.2
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1227541175-30301-1-git-send-email-major@openvz.org> <1227541175-30301-3-git-send-email-major@openvz.org> <492C5D74.7040302@cs.columbia.edu>
In-Reply-To: <492C5D74.7040302@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261458.01498.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 23:17 Oren Laadan wrote:
> Hi,
>
> Andrey Mirkin wrote:
> > All work (process tree creation and process state restore) now can be
> > done in kernel.
> >
> > Task structure in image file is extended with 2 fields to make in-kernel
> > process creation more easy.
> >
> > Signed-off-by: Andrey Mirkin <major@openvz.org>
> > ---
> >  checkpoint/checkpoint.c        |   17 ++++
> >  checkpoint/restart.c           |    4 +-
> >  checkpoint/rstr_process.c      |  201
> > +++++++++++++++++++++++++++++++++++++++- include/linux/checkpoint.h     |
> >    2 +
> >  include/linux/checkpoint_hdr.h |    2 +
> >  5 files changed, 223 insertions(+), 3 deletions(-)
> >
> > diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
> > index 04b0c4a..ae3326e 100644
> > --- a/checkpoint/checkpoint.c
> > +++ b/checkpoint/checkpoint.c
> > @@ -173,6 +173,21 @@ static int cr_write_tail(struct cr_ctx *ctx)
> >  	return ret;
> >  }
> >
> > +static int cr_count_children(struct cr_ctx *ctx, struct task_struct
> > *tsk) +{
> > +	int num = 0;
> > +	struct task_struct *child;
> > +
> > +	read_lock(&tasklist_lock);
> > +	list_for_each_entry(child, &tsk->children, sibling) {
> > +		if (child->parent != tsk)
> > +			continue;
> > +		num++;
> > +	}
> > +	read_unlock(&tasklist_lock);
> > +	return num;
> > +}
> > +
>
> This information (and the pids of children) is already available in
> the ctx->pids_arr.

Yes, as I said in my previous e-mail I'll rework this patch to use this data.

> >  /* dump the task_struct of a given task */
> >  static int cr_write_task_struct(struct cr_ctx *ctx, struct task_struct
> > *t) {
> > @@ -189,6 +204,8 @@ static int cr_write_task_struct(struct cr_ctx *ctx,
> > struct task_struct *t) hh->exit_code = t->exit_code;
> >  	hh->exit_signal = t->exit_signal;
> >
> > +	hh->vpid = task_pid_nr_ns(t, ctx->root_nsproxy->pid_ns);
> > +	hh->children_nr = cr_count_children(ctx, t);
> >  	hh->task_comm_len = TASK_COMM_LEN;
>
> Same here (hmm... well, if it weren't skipped below, actually...)
>
> >  	/* FIXME: save remaining relevant task_struct fields */
> > diff --git a/checkpoint/restart.c b/checkpoint/restart.c
>
> [...]
>
> > +static int restart_thread(void *arg)
> > +{
> > +	struct thr_context *thr_ctx = arg;
> > +	struct cr_ctx *ctx;
> > +	struct cr_hdr_task *ht;
> > +	int ret;
> > +	int i;
> > +
> > +	current->state = TASK_UNINTERRUPTIBLE;
>
> Why do you not want it to be interruptible ?

To be sure that nobody will interrupt our process and it will finish all the 
work it should perform while restore.

> > +
> > +	ctx = thr_ctx->ctx;
> > +	ht = thr_ctx->ht;
> > +
> > +	if (ht->vpid == 1) {
> > +		ctx->root_task = current;
> > +		ctx->root_nsproxy = current->nsproxy;
> > +
> > +		get_task_struct(ctx->root_task);
> > +		get_nsproxy(ctx->root_nsproxy);
> > +	}
> > +
> > +	ret = cr_rstr_task_struct(ctx, ht);
> > +	cr_debug("rstr_task_struct: ret %d\n", ret);
> > +	if (ret < 0)
> > +		goto out;
> > +	ret = cr_read_mm(ctx);
> > +	cr_debug("memory: ret %d\n", ret);
> > +	if (ret < 0)
> > +		goto out;
> > +	ret = cr_read_files(ctx);
> > +	cr_debug("files: ret %d\n", ret);
> > +	if (ret < 0)
> > +		goto out;
> > +	ret = cr_read_thread(ctx);
> > +	cr_debug("thread: ret %d\n", ret);
> > +	if (ret < 0)
> > +		goto out;
> > +	ret = cr_read_cpu(ctx);
> > +	cr_debug("cpu: ret %d\n", ret);
> > +
> > +	for (i = 0; i < ht->children_nr; i++) {
> > +		ret = cr_restart_process(ctx);
> > +		if (ret < 0)
> > +			break;
> > +	}
>
> Here, eventually we'll need the pids of those processes; instead of
> keeping 'ht->children_nr', you could loop through the pids array in
> the ctx and create those who have their parent set to us.

Well, it will require a little bit more time, but in this case I can reuse 
data about process tree from dump file.
Ok, I'll rework my patch.

> > +
> > +out:
> > +	thr_ctx->error = ret;
> > +	complete(&thr_ctx->complete);
> > +
> > +	if (!ret && (ht->state & (EXIT_ZOMBIE|EXIT_DEAD))) {
> > +		do_exit(ht->exit_code);
> > +	} else {
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> > +	}
> > +	schedule();
>
> Using TASK_UNINTERRUPTIBLE, may keep a task unkill-able for potentially
> long time. Any reason not to use TASK_INTERRUPTIBLE ?

In OpenVZ we are moving tasks to uninterruptible state to be sure that they 
won't be killed. If something went wrong we move them to interruptible state 
and kill on error path. If undump is finished successfully then we move them 
to interruptible state during resume stage.

> > +
> > +	cr_debug("leaked %d/%d %p\n", task_pid_nr(current),
> > task_pid_vnr(current), current->mm); +
> > +	complete_and_exit(NULL, 0);
> > +	return ret;
> > +}
> > +
> > +static int cr_restart_process(struct cr_ctx *ctx)
> > +{
> > +	struct thr_context thr_ctx;
> > +	struct task_struct *tsk;
> > +	struct cr_hdr_task *ht = cr_hbuf_get(ctx, sizeof(*ht));
> > +	int pid, parent, ret = -EINVAL;
> > +
> > +	thr_ctx.ctx = ctx;
> > +	thr_ctx.error = 0;
> > +	init_completion(&thr_ctx.complete);
> > +
> > +	parent = cr_read_obj_type(ctx, ht, sizeof(*ht), CR_HDR_TASK);
> > +	if (parent < 0) {
> > +		ret = parent;
> > +		goto out;
> > +	} else if (parent != 0)
> > +		goto out;
> > +
> > +	thr_ctx.ht = ht;
> > +
> > +	if (ht->vpid == 1) {
> > +		/* We should also create container here */
> > +		pid = cr_kernel_thread(restart_thread, &thr_ctx,
> > +				CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> > +				CLONE_NEWUSER | CLONE_NEWPID | CLONE_NEWNET, 0);
>
> why do you want to start the container in the kernel ?
>
> instead, we can create a new containers in user space, and have the init
> task call the restart syscall from inside there.

The idea is simple - do _all_ the work in the kernel. That is why creation of 
container also done in the kernel.

> > +	} else {
> > +		/* We should fork here a child with saved pid and
> > +		   correct flags */
> > +		pid = cr_kernel_thread(restart_thread, &thr_ctx, 0, ht->vpid);
> > +	}
> > +	if (pid < 0) {
> > +		ret = pid;
> > +		goto out;
> > +	}
> > +	read_lock(&tasklist_lock);
> > +	tsk = find_task_by_vpid(pid);
> > +	if (tsk)
> > +		get_task_struct(tsk);
> > +	read_unlock(&tasklist_lock);
> > +	if (tsk == NULL) {
> > +		ret = -ESRCH;
> > +		goto out;
> > +	}
> > +
> > +	wait_for_completion(&thr_ctx.complete);
> > +	wait_task_inactive(tsk, 0);
> > +	ret = thr_ctx.error;
> > +	put_task_struct(tsk);
> > +
> > +out:
> > +	cr_hbuf_put(ctx, sizeof(*ht));
> > +	return ret;
> > +}
> > +
> >
> >  int do_restart_in_kernel(struct cr_ctx *ctx)
> >  {
> > -	return -ENOSYS;
> > +	int ret, size, parent;
> > +	struct cr_hdr_tree *hh = cr_hbuf_get(ctx, sizeof(*hh));
> > +
> > +	ret = cr_read_head(ctx);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = -EINVAL;
> > +	parent = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_TREE);
> > +	if (parent < 0) {
> > +		ret = parent;
> > +		goto out;
> > +	} else if (parent != 0)
> > +		goto out;
> > +
> > +	size = sizeof(*ctx->pids_arr) * hh->tasks_nr;
> > +	if (size < 0)
> > +		goto out;
> > +	ctx->file->f_pos += size;
>
> You can't do that - the file may be non-seekable (e.g. a socket); must read
> the data in.
> Besides, if instead of skipping this data you read it in, then you could
> use it as noted above.

Agree, I'll rework my patch that way.

Thanks,
Andrey
