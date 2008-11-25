Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKYUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKYUSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKYUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:18:22 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:34198 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKYUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:18:21 -0500
Message-ID: <492C5D74.7040302@cs.columbia.edu>
Date: Tue, 25 Nov 2008 15:17:56 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add support for in-kernel process creation during
 restart
References: <1227541175-30301-1-git-send-email-major@openvz.org> <1227541175-30301-2-git-send-email-major@openvz.org> <1227541175-30301-3-git-send-email-major@openvz.org>
In-Reply-To: <1227541175-30301-3-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrey Mirkin wrote:
> All work (process tree creation and process state restore) now can be
> done in kernel.
> 
> Task structure in image file is extended with 2 fields to make in-kernel
> process creation more easy.
> 
> Signed-off-by: Andrey Mirkin <major@openvz.org>
> ---
>  checkpoint/checkpoint.c        |   17 ++++
>  checkpoint/restart.c           |    4 +-
>  checkpoint/rstr_process.c      |  201 +++++++++++++++++++++++++++++++++++++++-
>  include/linux/checkpoint.h     |    2 +
>  include/linux/checkpoint_hdr.h |    2 +
>  5 files changed, 223 insertions(+), 3 deletions(-)
> 
> diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
> index 04b0c4a..ae3326e 100644
> --- a/checkpoint/checkpoint.c
> +++ b/checkpoint/checkpoint.c
> @@ -173,6 +173,21 @@ static int cr_write_tail(struct cr_ctx *ctx)
>  	return ret;
>  }
>  
> +static int cr_count_children(struct cr_ctx *ctx, struct task_struct *tsk)
> +{
> +	int num = 0;
> +	struct task_struct *child;
> +
> +	read_lock(&tasklist_lock);
> +	list_for_each_entry(child, &tsk->children, sibling) {
> +		if (child->parent != tsk)
> +			continue;
> +		num++;
> +	}
> +	read_unlock(&tasklist_lock);
> +	return num;
> +}
> +

This information (and the pids of children) is already available in
the ctx->pids_arr.

>  /* dump the task_struct of a given task */
>  static int cr_write_task_struct(struct cr_ctx *ctx, struct task_struct *t)
>  {
> @@ -189,6 +204,8 @@ static int cr_write_task_struct(struct cr_ctx *ctx, struct task_struct *t)
>  	hh->exit_code = t->exit_code;
>  	hh->exit_signal = t->exit_signal;
>  
> +	hh->vpid = task_pid_nr_ns(t, ctx->root_nsproxy->pid_ns);
> +	hh->children_nr = cr_count_children(ctx, t);
>  	hh->task_comm_len = TASK_COMM_LEN;

Same here (hmm... well, if it weren't skipped below, actually...)

>  
>  	/* FIXME: save remaining relevant task_struct fields */
> diff --git a/checkpoint/restart.c b/checkpoint/restart.c

[...]

> +static int restart_thread(void *arg)
> +{
> +	struct thr_context *thr_ctx = arg;
> +	struct cr_ctx *ctx;
> +	struct cr_hdr_task *ht;
> +	int ret;
> +	int i;
> +
> +	current->state = TASK_UNINTERRUPTIBLE;

Why do you not want it to be interruptible ?

> +
> +	ctx = thr_ctx->ctx;
> +	ht = thr_ctx->ht;
> +
> +	if (ht->vpid == 1) {
> +		ctx->root_task = current;
> +		ctx->root_nsproxy = current->nsproxy;
> +
> +		get_task_struct(ctx->root_task);
> +		get_nsproxy(ctx->root_nsproxy);
> +	}
> +
> +	ret = cr_rstr_task_struct(ctx, ht);
> +	cr_debug("rstr_task_struct: ret %d\n", ret);
> +	if (ret < 0)
> +		goto out;
> +	ret = cr_read_mm(ctx);
> +	cr_debug("memory: ret %d\n", ret);
> +	if (ret < 0)
> +		goto out;
> +	ret = cr_read_files(ctx);
> +	cr_debug("files: ret %d\n", ret);
> +	if (ret < 0)
> +		goto out;
> +	ret = cr_read_thread(ctx);
> +	cr_debug("thread: ret %d\n", ret);
> +	if (ret < 0)
> +		goto out;
> +	ret = cr_read_cpu(ctx);
> +	cr_debug("cpu: ret %d\n", ret);
> +
> +	for (i = 0; i < ht->children_nr; i++) {
> +		ret = cr_restart_process(ctx);
> +		if (ret < 0)
> +			break;
> +	}

Here, eventually we'll need the pids of those processes; instead of
keeping 'ht->children_nr', you could loop through the pids array in
the ctx and create those who have their parent set to us.

> +
> +out:
> +	thr_ctx->error = ret;
> +	complete(&thr_ctx->complete);
> +
> +	if (!ret && (ht->state & (EXIT_ZOMBIE|EXIT_DEAD))) {
> +		do_exit(ht->exit_code);
> +	} else {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +	}
> +	schedule();

Using TASK_UNINTERRUPTIBLE, may keep a task unkill-able for potentially
long time. Any reason not to use TASK_INTERRUPTIBLE ?

> +
> +	cr_debug("leaked %d/%d %p\n", task_pid_nr(current), task_pid_vnr(current), current->mm);
> +
> +	complete_and_exit(NULL, 0);
> +	return ret;
> +}
> +
> +static int cr_restart_process(struct cr_ctx *ctx)
> +{
> +	struct thr_context thr_ctx;
> +	struct task_struct *tsk;
> +	struct cr_hdr_task *ht = cr_hbuf_get(ctx, sizeof(*ht));
> +	int pid, parent, ret = -EINVAL;
> +
> +	thr_ctx.ctx = ctx;
> +	thr_ctx.error = 0;
> +	init_completion(&thr_ctx.complete);
> +
> +	parent = cr_read_obj_type(ctx, ht, sizeof(*ht), CR_HDR_TASK);
> +	if (parent < 0) {
> +		ret = parent;
> +		goto out;
> +	} else if (parent != 0)
> +		goto out;
> +
> +	thr_ctx.ht = ht;
> +
> +	if (ht->vpid == 1) {
> +		/* We should also create container here */
> +		pid = cr_kernel_thread(restart_thread, &thr_ctx,
> +				CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> +				CLONE_NEWUSER | CLONE_NEWPID | CLONE_NEWNET, 0);

why do you want to start the container in the kernel ?

instead, we can create a new containers in user space, and have the init task
call the restart syscall from inside there.


> +	} else {
> +		/* We should fork here a child with saved pid and
> +		   correct flags */
> +		pid = cr_kernel_thread(restart_thread, &thr_ctx, 0, ht->vpid);
> +	}
> +	if (pid < 0) {
> +		ret = pid;
> +		goto out;
> +	}
> +	read_lock(&tasklist_lock);
> +	tsk = find_task_by_vpid(pid);
> +	if (tsk)
> +		get_task_struct(tsk);
> +	read_unlock(&tasklist_lock);
> +	if (tsk == NULL) {
> +		ret = -ESRCH;
> +		goto out;
> +	}
> +
> +	wait_for_completion(&thr_ctx.complete);
> +	wait_task_inactive(tsk, 0);
> +	ret = thr_ctx.error;
> +	put_task_struct(tsk);
> +
> +out:
> +	cr_hbuf_put(ctx, sizeof(*ht));
> +	return ret;
> +}
> +
>  
>  int do_restart_in_kernel(struct cr_ctx *ctx)
>  {
> -	return -ENOSYS;
> +	int ret, size, parent;
> +	struct cr_hdr_tree *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +
> +	ret = cr_read_head(ctx);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = -EINVAL;
> +	parent = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_TREE);
> +	if (parent < 0) {
> +		ret = parent;
> +		goto out;
> +	} else if (parent != 0)
> +		goto out;
> +
> +	size = sizeof(*ctx->pids_arr) * hh->tasks_nr;
> +	if (size < 0)
> +		goto out;
> +	ctx->file->f_pos += size;

You can't do that - the file may be non-seekable (e.g. a socket); must read
the data in.
Besides, if instead of skipping this data you read it in, then you could use
it as noted above.

> +
> +	ret = cr_restart_process(ctx);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = cr_read_tail(ctx);

[...]

Thanks,

Oren.

