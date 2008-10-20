Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYJTNZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYJTNZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYJTNZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:25:39 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:45848 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYJTNZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:25:38 -0400
Date: Mon, 20 Oct 2008 15:25:36 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 08/10] Introduce functions to restart a process
Message-ID: <20081020132536.GS15171@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-2-git-send-email-major@openvz.org> <1224285098-573-3-git-send-email-major@openvz.org> <1224285098-573-4-git-send-email-major@openvz.org> <1224285098-573-5-git-send-email-major@openvz.org> <1224285098-573-6-git-send-email-major@openvz.org> <1224285098-573-7-git-send-email-major@openvz.org> <1224285098-573-8-git-send-email-major@openvz.org> <1224285098-573-9-git-send-email-major@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-22007-1224508992-0001-2"
Content-Disposition: inline
In-Reply-To: <1224285098-573-9-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-22007-1224508992-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 18, 2008 at 03:11:36AM +0400, Andrey Mirkin wrote:
> Functions to restart process, restore its state, fpu and registers are ad=
ded.

[...]

> diff --git a/checkpoint/rst_process.c b/checkpoint/rst_process.c
> new file mode 100644
> index 0000000..b9f745e
> --- /dev/null
> +++ b/checkpoint/rst_process.c
> @@ -0,0 +1,277 @@
> +/*
> + *  Copyright (C) 2008 Parallels, Inc.
> + *
> + *  Author: Andrey Mirkin <major@openvz.org>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License as
> + *  published by the Free Software Foundation, version 2 of the
> + *  License.
> + *
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/version.h>
> +#include <linux/module.h>
> +
> +#include "checkpoint.h"
> +#include "cpt_image.h"
> +
> +#define HOOK_RESERVE	256
> +
> +struct thr_context {
> +	struct completion complete;
> +	int error;
> +	struct cpt_context *ctx;
> +	struct task_struct *tsk;
> +};
> +
> +int local_kernel_thread(int (*fn)(void *), void * arg, unsigned long fla=
gs, pid_t pid)
> +{
> +	pid_t ret;
> +
> +	if (current->fs =3D=3D NULL) {
> +		/* do_fork_pid() hates processes without fs, oopses. */
> +		eprintk("local_kernel_thread: current->fs=3D=3DNULL\n");
> +		return -EINVAL;
> +	}
> +	if (!try_module_get(THIS_MODULE))
> +		return -EBUSY;
> +	ret =3D kernel_thread(fn, arg, flags);
> +	if (ret < 0)
> +		module_put(THIS_MODULE);
> +	return ret;
> +}
> +
> +static unsigned int decode_task_flags(unsigned int task_flags)
> +{
> +	unsigned int flags =3D 0;
> +
> +	if (task_flags & (1 << CPT_PF_EXITING))
> +		flags |=3D PF_EXITING;
> +	if (task_flags & (1 << CPT_PF_FORKNOEXEC))
> +		flags |=3D PF_FORKNOEXEC;
> +	if (task_flags & (1 << CPT_PF_SUPERPRIV))
> +		flags |=3D PF_SUPERPRIV;
> +	if (task_flags & (1 << CPT_PF_DUMPCORE))
> +		flags |=3D PF_DUMPCORE;
> +	if (task_flags & (1 << CPT_PF_SIGNALED))
> +		flags |=3D PF_SIGNALED;
> +=09
> +	return flags;
> +	=09
> +}
> +
> +int rst_restore_task_struct(struct task_struct *tsk, struct cpt_task_ima=
ge *ti,
> +			    struct cpt_context *ctx)
> +{
> +	int i;
> +
> +	/* Restore only saved flags, comm and tls for now */
> +	tsk->flags =3D decode_task_flags(ti->cpt_flags);
> +	clear_tsk_thread_flag(tsk, TIF_FREEZE);
> +	memcpy(tsk->comm, ti->cpt_comm, TASK_COMM_LEN);
> +	for (i =3D 0; i < GDT_ENTRY_TLS_ENTRIES; i++) {
> +		tsk->thread.tls_array[i].a =3D ti->cpt_tls[i] & 0xFFFFFFFF;
> +		tsk->thread.tls_array[i].b =3D ti->cpt_tls[i] >> 32;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rst_restore_fpustate(struct task_struct *tsk, struct cpt_task=
_image *ti,
> +				struct cpt_context *ctx)
> +{
> +	struct cpt_obj_bits hdr;
> +	int err;
> +	char *buf;
> +
> +	clear_stopped_child_used_math(tsk);
> +
> +	err =3D rst_get_object(CPT_OBJ_BITS, &hdr, sizeof(hdr), ctx);
> +	if (err < 0)
> +		return err;
> +
> +	buf =3D kmalloc(hdr.cpt_size, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	err =3D ctx->read(buf, hdr.cpt_size, ctx);
> +	if (err)
> +		goto out;
> +
> +	if (hdr.cpt_content =3D=3D CPT_CONTENT_X86_FPUSTATE && cpu_has_fxsr) {
> +		memcpy(&tsk->thread.xstate, buf,
> +				sizeof(struct i387_fxsave_struct));
> +		if (ti->cpt_flags & CPT_PF_USED_MATH)
> +			set_stopped_child_used_math(tsk);
> +	}
> +#ifndef CONFIG_X86_64
> +	else if (hdr.cpt_content =3D=3D CPT_CONTENT_X86_FPUSTATE_OLD &&
> +			!cpu_has_fxsr) {	=09
> +		memcpy(&tsk->thread.xstate, buf,
> +				sizeof(struct i387_fsave_struct));
> +		if (ti->cpt_flags & CPT_PF_USED_MATH)
> +			set_stopped_child_used_math(tsk);
> +	}
> +#endif
> +
> +out:
> +	kfree(buf);
> +	return err;
> +}
> +
> +static u32 decode_segment(u32 segid)
> +{
> +	if (segid =3D=3D CPT_SEG_ZERO)
> +		return 0;
> +
> +	/* TLS descriptors */
> +	if (segid <=3D CPT_SEG_TLS3)
> +		return ((GDT_ENTRY_TLS_MIN + segid - CPT_SEG_TLS1) << 3) + 3;
> +
> +	/* LDT descriptor, it is just an index to LDT array */
> +	if (segid >=3D CPT_SEG_LDT)
> +		return ((segid - CPT_SEG_LDT) << 3) | 7;
> +
> +	/* Check for one of standard descriptors */
> +	if (segid =3D=3D CPT_SEG_USER32_DS)
> +		return __USER_DS;
> +	if (segid =3D=3D CPT_SEG_USER32_CS)
> +		return __USER_CS;
> +
> +	eprintk("Invalid segment reg %d\n", segid);
> +	return 0;
> +}
> +
> +static int rst_restore_registers(struct task_struct *tsk, struct cpt_con=
text *ctx)
> +{
> +	struct cpt_x86_regs ri;
> +	struct pt_regs *regs =3D task_pt_regs(tsk);
> +	extern char i386_ret_from_resume;
> +	int err;
> +
> +	err =3D rst_get_object(CPT_OBJ_X86_REGS, &ri, sizeof(ri), ctx);
> +	if (err < 0)
> +		return err;
> +
> +	tsk->thread.sp =3D (unsigned long) regs;
> +	tsk->thread.sp0 =3D (unsigned long) (regs+1);
> +	tsk->thread.ip =3D (unsigned long) &i386_ret_from_resume;
> +
> +	tsk->thread.gs =3D decode_segment(ri.cpt_gs);
> +	tsk->thread.debugreg0 =3D ri.cpt_debugreg[0];
> +	tsk->thread.debugreg1 =3D ri.cpt_debugreg[1];
> +	tsk->thread.debugreg2 =3D ri.cpt_debugreg[2];
> +	tsk->thread.debugreg3 =3D ri.cpt_debugreg[3];
> +	tsk->thread.debugreg6 =3D ri.cpt_debugreg[6];
> +	tsk->thread.debugreg7 =3D ri.cpt_debugreg[7];
> +
> +	regs->bx =3D ri.cpt_bx;
> +	regs->cx =3D ri.cpt_cx;
> +	regs->dx =3D ri.cpt_dx;
> +	regs->si =3D ri.cpt_si;
> +	regs->di =3D ri.cpt_di;
> +	regs->bp =3D ri.cpt_bp;
> +	regs->ax =3D ri.cpt_ax;
> +	regs->orig_ax =3D ri.cpt_orig_ax;
> +	regs->ip =3D ri.cpt_ip;
> +	regs->flags =3D ri.cpt_flags;
> +	regs->sp =3D ri.cpt_sp;
> +
> +	regs->cs =3D decode_segment(ri.cpt_cs);
> +	regs->ss =3D decode_segment(ri.cpt_ss);
> +	regs->ds =3D decode_segment(ri.cpt_ds);
> +	regs->es =3D decode_segment(ri.cpt_es);
> +	regs->fs =3D decode_segment(ri.cpt_fs);
> +
> +	tsk->thread.sp -=3D HOOK_RESERVE;
> +	memset((void*)tsk->thread.sp, 0, HOOK_RESERVE);
> +
> +	return 0;
> +}
> +
> +static int restart_thread(void *arg)
> +{
> +	struct thr_context *thr_ctx =3D arg;
> +	struct cpt_context *ctx;
> +	struct cpt_task_image *ti;
> +	int err;
> +
> +	current->state =3D TASK_UNINTERRUPTIBLE;
> +
> +	ctx =3D thr_ctx->ctx;
> +	ti =3D kmalloc(sizeof(*ti), GFP_KERNEL);
> +	if (!ti)
> +		return -ENOMEM;
> +
> +	err =3D rst_get_object(CPT_OBJ_TASK, ti, sizeof(*ti), ctx);
> +	if (!err)
> +		err =3D rst_restore_task_struct(current, ti, ctx);
> +	/* Restore mm here */
> +	if (!err)
> +		err =3D rst_restore_fpustate(current, ti, ctx);
> +	if (!err)
> +		err =3D rst_restore_registers(current, ctx);
> +
> +	thr_ctx->error =3D err;
> +	complete(&thr_ctx->complete);
> +
> +	if (!err && (ti->cpt_state & (EXIT_ZOMBIE|EXIT_DEAD))) {
> +		do_exit(ti->cpt_exit_code);
> +	} else {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +	}
> +
> +	kfree(ti);
> +	schedule();
> +
> +	eprintk("leaked %d/%d %p\n", task_pid_nr(current), task_pid_vnr(current=
), current->mm);
> +
> +	module_put(THIS_MODULE);

I'm sorry, I still do not understand what you are doing with this self-modu=
le
pinning stuff. AFAICS, we should not get here unless there is a bug. So the
checkpoint module ref count is never decreased, right?

Could you detail what is this self-module pinning for? As I already told yo=
u,
this looks like a bogus solution to avoid unloading the checkpoint module d=
uring
restart.

Thanks!

Louis

[...]

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-22007-1224508992-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI/IbQVKcRuvQ9Q1QRAiGBAKC4Z8k/6JoKv8ZUPiICCENVm/3WzACff24m
6BQS1z6dHnMA8QzMK7MMuk8=
=iJ08
-----END PGP SIGNATURE-----

--=_bohort-22007-1224508992-0001-2--
