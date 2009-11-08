Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZKHR1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZKHR1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZKHR1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:27:38 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:53482 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZKHR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:27:37 -0500
Message-ID: <4AF6FEDE.5030807@web.de>
Date: Sun, 08 Nov 2009 18:24:46 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf events
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1257694141-5670-6-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig68DB5B809E08F6EB46238009"
X-Provags-ID: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig68DB5B809E08F6EB46238009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fc2974a..22dee7a 100644
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
> @@ -3643,14 +3644,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu, struct kvm_run *kvm_run)
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
> +	/*
> +	 * If the guest has used debug registers, at least dr7
> +	 * will be disabled while returning to the host.
> +	 * If we don't have active breakpoints in the host, we don't
> +	 * care about the messed up debug address registers. But if
> +	 * we have some of them active, restore the old state.
> +	 */
> +	if (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)

Looks good, just a minor remark: Would be cleaner to wrap this into an
inline function, say hw_breakpoint_active(), to abstract the precise
condition away from KVM.

> +		hw_breakpoint_restore();
> =20
>  	set_bit(KVM_REQ_KICK, &vcpu->requests);
>  	local_irq_enable();

Will see that I can give your series a try the next days, probably
debugging qemu-kvm while running a guest that uses breakpoints. But I
don't expect surprises.

Jan


--------------enig68DB5B809E08F6EB46238009
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkr2/ugACgkQitSsb3rl5xRkOQCfWtX+Rss4MnQpokliQd/9pnS+
XlcAoKzEmeVXKXTvI8GojLviCUjdpy//
=caGC
-----END PGP SIGNATURE-----

--------------enig68DB5B809E08F6EB46238009--
