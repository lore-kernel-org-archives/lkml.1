Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZKCUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZKCUXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZKCUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:23:20 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:44435 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZKCUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:23:19 -0500
Message-ID: <4AF090EC.5010105@web.de>
Date: Tue, 03 Nov 2009 21:22:04 +0100
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
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <4AF08B7C.8040903@web.de> <20091103201503.GA4962@nowhere>
In-Reply-To: <20091103201503.GA4962@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7CBC127E8E39F76832582730"
X-Provags-ID: V01U2FsdGVkX19cV3K+wkSxK1SMhaqmDurS7OpHGQVu0rqMV0YM
	bFujP04Ij+MGBg1tKzHw3CxZJXcBidrLaoaVC1EsQJbmbGZ5/V
	iKgEZ2boc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7CBC127E8E39F76832582730
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> On Tue, Nov 03, 2009 at 08:58:52PM +0100, Jan Kiszka wrote:
>> Frederic Weisbecker wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index fc2974a..6560129 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -42,6 +42,7 @@
>>>  #define CREATE_TRACE_POINTS
>>>  #include "trace.h"
>>> =20
>>> +#include <asm/debugreg.h>
>>>  #include <asm/uaccess.h>
>>>  #include <asm/msr.h>
>>>  #include <asm/desc.h>
>>> @@ -3643,14 +3644,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *=
vcpu, struct kvm_run *kvm_run)
>>>  	trace_kvm_entry(vcpu->vcpu_id);
>>>  	kvm_x86_ops->run(vcpu, kvm_run);
>>> =20
>>> -	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBU=
G))) {
>>> -		set_debugreg(current->thread.debugreg[0], 0);
>>> -		set_debugreg(current->thread.debugreg[1], 1);
>>> -		set_debugreg(current->thread.debugreg[2], 2);
>>> -		set_debugreg(current->thread.debugreg[3], 3);
>>> -		set_debugreg(current->thread.debugreg6, 6);
>>> -		set_debugreg(current->thread.debugreg7, 7);
>>> -	}
>>> +	/*
>>> +	 * CHECKME: is vcpu->arch.switch_db_regs sufficient to check
>>> +	 * if the guest is using breakpoints? If so we may want to do
>>> +	 * this check before.
>>> +	 */
>>> +	hw_breakpoint_restore();
>> Obviously, this variant will make KVM users very unhappy. But trying t=
o
>> reduce this performance regression via vcpu->arch.switch_db_regs will
>> make hw-breakpoint users unhappy: KVM leaves at least dr7 clobbered
>> behind, even if the guest does not use breakpoints.
>=20
>=20
> Yeah, that's why I've made unconditionally. At least it works in every
> cases, but this is temporary.
>=20
> =20
>> We really need a replacement for TIF_DEBUG (but we only need this [1])=
=2E
>>
>> Jan
>>
>> [1]http://thread.gmane.org/gmane.comp.emulators.kvm.devel/39784/focus=3D=
39827
>>
>=20
>=20
> Thinking about it, this check should cover every cases:
>=20
> if (vcpu->arch.switch_db_regs || __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_=
MASK)
>=20
> If we have __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK, it means there i=
s an
> active breakpoint and then we should restore the current state.
>=20

And what about (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK) only? Would
you be able to live with unsync'ed hardware and software states?

Jan


--------------enig7CBC127E8E39F76832582730
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrwkPAACgkQitSsb3rl5xRYzwCfc41iKAv1mSa+GoYLNzuGIykg
yuEAnjodR7rUg0f29RL2iddOWX6hffih
=IV6H
-----END PGP SIGNATURE-----

--------------enig7CBC127E8E39F76832582730--
