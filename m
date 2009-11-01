Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZKAWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZKAWJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZKAWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:09:05 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:52508 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZKAWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:09:04 -0500
Message-ID: <4AEE06FF.9080807@web.de>
Date: Sun, 01 Nov 2009 23:09:03 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf events
References: <4AE55B1B.2030006@web.de> <1257109753-6464-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1257109753-6464-5-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6B1708462926783FB23D0871"
X-Provags-ID: V01U2FsdGVkX193ZTwZCCw/N+rOC89kA8SGV1hAeR4DGuAVzgMm
	42TyOQ73cR7VHGo/QtU4tw3UgldvjCdfkSffpeNKu+NSSNh3jz
	51oL9t4ZM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6B1708462926783FB23D0871
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
[...]
> @@ -94,6 +87,12 @@ static inline void hw_breakpoint_disable(void)
>  	set_debugreg(0UL, 3);
>  }
>
> +#ifdef CONFIG_KVM
> +extern void hw_breakpoint_restore(void);
> +#else
> +static inline void hw_breakpoint_restore(void)	{ }
> +#endif
> +

Hmm, if this shall become a KVM-only API, why the empty wrapper?

[...]
> -void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
> +#ifdef CONFIG_KVM
> +void hw_breakpoint_restore(void)
>  {
> -	int i;
> -	struct thread_struct *thread =3D &(tsk->thread);
> -
> -	thread->debugreg7 =3D 0;
> -	for (i =3D 0; i < HBP_NUM; i++)
> -		thread->debugreg[i] =3D 0;
> +	set_debugreg(__get_cpu_var(cpu_debugreg[0]), 0);
> +	set_debugreg(__get_cpu_var(cpu_debugreg[1]), 1);
> +	set_debugreg(__get_cpu_var(cpu_debugreg[2]), 2);
> +	set_debugreg(__get_cpu_var(cpu_debugreg[3]), 3);
> +	set_debugreg(current->thread.debugreg6, 6);
> +	set_debugreg(__get_cpu_var(dr7), 7);
>  }
> +#endif

EXPORT_SYMBOL_GPL(hw_breakpoint_restore);

as KVM can be built as module.

[...]
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fc2974a..32d7bca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -42,6 +42,7 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> =20
> +#include <asm/debugreg.h>
>  #include <asm/uaccess.h>
>  #include <asm/msr.h>
>  #include <asm/desc.h>
> @@ -3643,14 +3644,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcp=
u, struct kvm_run *kvm_run)
>  	trace_kvm_entry(vcpu->vcpu_id);
>  	kvm_x86_ops->run(vcpu, kvm_run);
> =20
> -	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG)=
)) {
> -		set_debugreg(current->thread.debugreg[0], 0);
> -		set_debugreg(current->thread.debugreg[1], 1);
> -		set_debugreg(current->thread.debugreg[2], 2);
> -		set_debugreg(current->thread.debugreg[3], 3);
> -		set_debugreg(current->thread.debugreg6, 6);
> -		set_debugreg(current->thread.debugreg7, 7);
> -	}
> +	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG)=
))
> +		hw_breakpoint_restore();

TIF_DEBUG is only set on active ptrace hw-breakpoints, thus we miss
other types here, right? (Note: arch.switch_db_regs is guest-related,
thus does not help in this regard.)

Jan


--------------enig6B1708462926783FB23D0871
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkruBwMACgkQitSsb3rl5xQjDACgtiFUKWUqUA9K4rCA9bGsQxMI
+OoAoPAFfZb3tFukprl437TnA1ToOvGj
=pmUV
-----END PGP SIGNATURE-----

--------------enig6B1708462926783FB23D0871--
