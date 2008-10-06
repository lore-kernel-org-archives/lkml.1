Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYJFJfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYJFJfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJFJfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:35:32 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50990 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYJFJfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:35:31 -0400
Date: Mon, 6 Oct 2008 11:35:29 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
Message-ID: <20081006093529.GA29198@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm> <1223154766-19350-2-git-send-email-heukelum@fastmail.fm> <1223154766-19350-3-git-send-email-heukelum@fastmail.fm> <1223154766-19350-4-git-send-email-heukelum@fastmail.fm> <1223154766-19350-5-git-send-email-heukelum@fastmail.fm> <1223154766-19350-6-git-send-email-heukelum@fastmail.fm> <1223154766-19350-7-git-send-email-heukelum@fastmail.fm> <1223154766-19350-8-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-5332-1223285588-0001-2"
Content-Disposition: inline
In-Reply-To: <1223154766-19350-8-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-5332-1223285588-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2008 at 11:12:46PM +0200, Alexander van Heukelum wrote:
>  - define STACKSLOTS_PER_LINE and use it
>  - define get_bp macro to hide the %%ebp/%%rbp difference
>  - i386: check task=3D=3DNULL in dump_trace, like x86_64
>  - i386: show_trace(NULL, ...) uses current automatically
>  - x86_64: use [#%d] for die_counter, like i386
>  - whitespace and comments
>=20
[...]

> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_6=
4.c
> index 6ac80f0..ddc8a38 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -16,8 +16,11 @@
> =20
>  #include <asm/stacktrace.h>
> =20
> +#define STACKSLOTS_PER_LINE 4
> +#define get_bp(bp) asm("movl %%rbp, %0" : "=3Dr" (bp) :)
                           ^^^^
Should be movq.

Louis

>  int panic_on_unrecovered_nmi;
> -int kstack_depth_to_print =3D 12;
> +int kstack_depth_to_print =3D 3 * STACKSLOTS_PER_LINE;
>  static unsigned int code_bytes =3D 64;
>  static int die_counter;
> =20
> @@ -177,7 +180,7 @@ void dump_trace(struct task_struct *task, struct pt_r=
egs *regs,
>  	if (!bp) {
>  		if (task =3D=3D current) {
>  			/* Grab bp right from our regs */
> -			asm("movq %%rbp, %0" : "=3Dr" (bp) : );
> +			get_bp(bp);
>  		} else {
>  			/* bp is the last reg pushed by switch_to */
>  			bp =3D *(unsigned long *) task->thread.sp;
> @@ -329,7 +332,7 @@ show_stack_log_lvl(struct task_struct *task, struct p=
t_regs *regs,
>  		if (((long) stack & (THREAD_SIZE-1)) =3D=3D 0)
>  			break;
>  		}
> -		if (i && ((i % 4) =3D=3D 0))
> +		if (i && ((i % STACKSLOTS_PER_LINE) =3D=3D 0))
>  			printk("\n%s", log_lvl);
>  		printk(" %016lx", *stack++);
>  		touch_nmi_watchdog();
> @@ -353,7 +356,7 @@ void dump_stack(void)
> =20
>  #ifdef CONFIG_FRAME_POINTER
>  	if (!bp)
> -		asm("movq %%rbp, %0" : "=3Dr" (bp) : );
> +		get_bp(bp);
>  #endif
> =20
>  	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
> @@ -396,7 +399,7 @@ void show_registers(struct pt_regs *regs)
> =20
>  		ip =3D (u8 *)regs->ip - code_prologue;
>  		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
> -			/* try starting at RIP */
> +			/* try starting at IP */
>  			ip =3D (u8 *)regs->ip;
>  			code_len =3D code_len - code_prologue + 1;
>  		}
> @@ -477,7 +480,7 @@ void __kprobes oops_end(unsigned long flags, struct p=
t_regs *regs, int signr)
> =20
>  int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  {
> -	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
> +	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
>  #ifdef CONFIG_PREEMPT
>  	printk("PREEMPT ");
>  #endif
> --=20
> 1.5.4.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-5332-1223285588-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI6dvhVKcRuvQ9Q1QRAie9AJwKUtAL9E8QYXIWzgMRU1tOnedSuQCdG9wo
yq9eQq5Im8JkYVHUghGAdPc=
=m11+
-----END PGP SIGNATURE-----

--=_bohort-5332-1223285588-0001-2--
