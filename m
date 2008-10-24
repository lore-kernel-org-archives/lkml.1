Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYJXEPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYJXEPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYJXEOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:14:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28599 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbYJXEOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:14:51 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org, Louis.Rilling@kerlabs.com
Subject: Re: [Devel] Re: [PATCH 05/10] Introduce function to dump process
Date: Fri, 24 Oct 2008 08:15:16 +0400
User-Agent: KMail/1.8.2
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-6-git-send-email-major@openvz.org> <20081020110226.GP15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081020110226.GP15171@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240815.17229.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 15:02 Louis Rilling wrote:
> Hi,
>
> On Sat, Oct 18, 2008 at 03:11:33AM +0400, Andrey Mirkin wrote:
> > Functions to dump task struct, fpu state and registers are added.
> > All IDs are saved from the POV of process (container) namespace.
>
> Just a couple of little comments, in case this series should keep on
> living.
>
> [...]
>
> > diff --git a/checkpoint/cpt_process.c b/checkpoint/cpt_process.c
> > new file mode 100644
> > index 0000000..58f608d
> > --- /dev/null
> > +++ b/checkpoint/cpt_process.c
> > @@ -0,0 +1,236 @@
> > +/*
> > + *  Copyright (C) 2008 Parallels, Inc.
> > + *
> > + *  Author: Andrey Mirkin <major@openvz.org>
> > + *
> > + *  This program is free software; you can redistribute it and/or
> > + *  modify it under the terms of the GNU General Public License as
> > + *  published by the Free Software Foundation, version 2 of the
> > + *  License.
> > + *
> > + */
> > +
> > +#include <linux/sched.h>
> > +#include <linux/fs.h>
> > +#include <linux/file.h>
> > +#include <linux/version.h>
> > +#include <linux/nsproxy.h>
> > +
> > +#include "checkpoint.h"
> > +#include "cpt_image.h"
> > +
> > +static unsigned int encode_task_flags(unsigned int task_flags)
> > +{
> > +	unsigned int flags = 0;
> > +
> > +	if (task_flags & PF_EXITING)
> > +		flags |= (1 << CPT_PF_EXITING);
> > +	if (task_flags & PF_FORKNOEXEC)
> > +		flags |= (1 << CPT_PF_FORKNOEXEC);
> > +	if (task_flags & PF_SUPERPRIV)
> > +		flags |= (1 << CPT_PF_SUPERPRIV);
> > +	if (task_flags & PF_DUMPCORE)
> > +		flags |= (1 << CPT_PF_DUMPCORE);
> > +	if (task_flags & PF_SIGNALED)
> > +		flags |= (1 << CPT_PF_SIGNALED);
> > +	if (task_flags & PF_USED_MATH)
> > +		flags |= (1 << CPT_PF_USED_MATH);
> > +
> > +	return flags;
> > +
> > +}
> > +
> > +int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context
> > *ctx) +{
> > +	struct cpt_task_image *t;
> > +	int i;
> > +	int err;
> > +
> > +	t = kzalloc(sizeof(*t), GFP_KERNEL);
> > +	if (!t)
> > +		return -ENOMEM;
> > +
> > +	t->cpt_len = sizeof(*t);
> > +	t->cpt_type = CPT_OBJ_TASK;
> > +	t->cpt_hdrlen = sizeof(*t);
> > +	t->cpt_content = CPT_CONTENT_ARRAY;
> > +
> > +	t->cpt_state = tsk->state;
> > +	t->cpt_flags = encode_task_flags(tsk->flags);
> > +	t->cpt_exit_code = tsk->exit_code;
> > +	t->cpt_exit_signal = tsk->exit_signal;
> > +	t->cpt_pdeath_signal = tsk->pdeath_signal;
> > +	t->cpt_pid = task_pid_nr_ns(tsk, ctx->nsproxy->pid_ns);
> > +	t->cpt_tgid = task_tgid_nr_ns(tsk, ctx->nsproxy->pid_ns);
> > +	t->cpt_ppid = tsk->parent ?
> > +		task_pid_nr_ns(tsk->parent, ctx->nsproxy->pid_ns) : 0;
> > +	t->cpt_rppid = tsk->real_parent ?
> > +		task_pid_nr_ns(tsk->real_parent, ctx->nsproxy->pid_ns) : 0;
> > +	t->cpt_pgrp = task_pgrp_nr_ns(tsk, ctx->nsproxy->pid_ns);
> > +	t->cpt_session = task_session_nr_ns(tsk, ctx->nsproxy->pid_ns);
> > +	t->cpt_old_pgrp = 0;
> > +	if (tsk->signal->tty_old_pgrp)
> > +		t->cpt_old_pgrp = pid_vnr(tsk->signal->tty_old_pgrp);
> > +	t->cpt_leader = tsk->group_leader ? task_pid_vnr(tsk->group_leader) :
> > 0;
>
> Why pid_vnr() here, and task_*_nr_ns() above? According to the introducing
> comment, I'd expect something like pid_nr_ns(tsk->signal->tty_old_pgrp,
> tsk->nsproxy->pid_ns), and the same for tsk->group_leader.
>
> IIUC, pid_vnr() is correct only if ctx->nsproxy->pid_ns ==
> tsk->nsproxy->pid_ns == current->nsproxy->pid_ns, and I expect current to
> live in a different pid_ns.
>
> Comments?

Oh, you right here. I have already fixed it in my tree, but accidentally wrong 
patch were sent.

>
> > +	t->cpt_utime = tsk->utime;
> > +	t->cpt_stime = tsk->stime;
> > +	t->cpt_utimescaled = tsk->utimescaled;
> > +	t->cpt_stimescaled = tsk->stimescaled;
> > +	t->cpt_gtime = tsk->gtime;
> > +	t->cpt_prev_utime = tsk->prev_utime;
> > +	t->cpt_prev_stime = tsk->prev_stime;
> > +	t->cpt_nvcsw = tsk->nvcsw;
> > +	t->cpt_nivcsw = tsk->nivcsw;
> > +	t->cpt_start_time = cpt_timespec_export(&tsk->start_time);
> > +	t->cpt_real_start_time = cpt_timespec_export(&tsk->real_start_time);
> > +	t->cpt_min_flt = tsk->min_flt;
> > +	t->cpt_maj_flt = tsk->maj_flt;
> > +	memcpy(t->cpt_comm, tsk->comm, TASK_COMM_LEN);
> > +	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++) {
> > +		t->cpt_tls[i] = (((u64)tsk->thread.tls_array[i].b) << 32) +
> > +			tsk->thread.tls_array[i].a;
> > +	}
> > +	/* TODO: encode thread flags and status like task flags */
> > +	t->cpt_thrflags = task_thread_info(tsk)->flags & ~(1<<TIF_FREEZE);
> > +	t->cpt_thrstatus = task_thread_info(tsk)->status;
> > +	t->cpt_user = tsk->user->uid;
> > +	t->cpt_uid = tsk->uid;
> > +	t->cpt_euid = tsk->euid;
> > +	t->cpt_suid = tsk->suid;
> > +	t->cpt_fsuid = tsk->fsuid;
> > +	t->cpt_gid = tsk->gid;
> > +	t->cpt_egid = tsk->egid;
> > +	t->cpt_sgid = tsk->sgid;
> > +	t->cpt_fsgid = tsk->fsgid;
> > +
> > +	err = ctx->write(t, sizeof(*t), ctx);
> > +
> > +	kfree(t);
> > +	return err;
> > +}
> > +
> > +static int cpt_dump_fpustate(struct task_struct *tsk, struct cpt_context
> > *ctx) +{
> > +	struct cpt_obj_bits hdr;
> > +	int err;
> > +	int content;
> > +	unsigned long size;
> > +
> > +	content = CPT_CONTENT_X86_FPUSTATE;
> > +	size = sizeof(struct i387_fxsave_struct);
> > +#ifndef CONFIG_X86_64
> > +	if (!cpu_has_fxsr) {
> > +		size = sizeof(struct i387_fsave_struct);
> > +		content = CPT_CONTENT_X86_FPUSTATE_OLD;
> > +	}
> > +#endif
> > +
> > +	hdr.cpt_len = sizeof(hdr) + size;
> > +	hdr.cpt_type = CPT_OBJ_BITS;
> > +	hdr.cpt_hdrlen = sizeof(hdr);
> > +	hdr.cpt_content = content;
> > +	hdr.cpt_size = size;
> > +	err = ctx->write(&hdr, sizeof(hdr), ctx);
> > +	if (!err)
> > +		ctx->write(tsk->thread.xstate, size, ctx);
>
> Should check the error code of the line above, right?
Right, thanks!

[...]

> > +int cpt_dump_task(struct task_struct *tsk, struct cpt_context *ctx)
> > +{
> > +	int err;
> > +
> > +	err = cpt_dump_task_struct(tsk, ctx);
> > +
> > +	/* Dump task mm */
> > +
> > +	if (!err)
> > +		cpt_dump_fpustate(tsk, ctx);
>
> error checking...
>
> > +	if (!err)
> > +		cpt_dump_registers(tsk, ctx);
>
> error checking...
Thanks again, will fix it.


Andrey
