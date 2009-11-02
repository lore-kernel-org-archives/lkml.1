Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZKBHqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZKBHqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZKBHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:45:59 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:42096 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZKBHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:45:57 -0500
Message-ID: <4AEE8E34.8080105@web.de>
Date: Mon, 02 Nov 2009 08:45:56 +0100
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
References: <4AE55B1B.2030006@web.de> <1257109753-6464-5-git-send-email-fweisbec@gmail.com> <4AEE06FF.9080807@web.de> <20091101233659.GE5263@nowhere>
In-Reply-To: <20091101233659.GE5263@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F3D15FACC0374B3521F5A0D"
X-Provags-ID: V01U2FsdGVkX1/I4CJffkjjng/sbztKSM8JBe3UkJI5Cj/rdNWr
	LDt2OsgrrRTjdOMT7ZfPRGxbDw4iMXCgvK6MSu83t7+8O944Kv
	Fm6b7R+zU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F3D15FACC0374B3521F5A0D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> On Sun, Nov 01, 2009 at 11:09:03PM +0100, Jan Kiszka wrote:
>>> @@ -3643,14 +3644,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *v=
cpu, struct kvm_run *kvm_run)
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
>>> +	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBU=
G)))
>>> +		hw_breakpoint_restore();
>> TIF_DEBUG is only set on active ptrace hw-breakpoints, thus we miss
>> other types here, right? (Note: arch.switch_db_regs is guest-related,
>> thus does not help in this regard.)
>>
>> Jan
>>
>=20
>=20
> About this. vcpu->arch.switch_db_regs is guest related but it looks
> like the only thing I need to check.
>=20
> I'm not sure when it is activated. Is it always done once the guest
> changes its debug registers? I suspect there is a corner case.

It's set when we had to write to some debugreg[0..4], either for use by
the guest itself or for debugging it from the host. It used to be the
only condition for switching on exit as we saved the registers on entry
(under the same condition). This was reworked recently to avoid the
entry saving.

>=20
> Because since I can't anymore assume TIF_DEBUG covers every
> breakpoints uses, it means I'll need to maintain a refcount of
> breakpoints in use.
> Well, I have one already, but it is splitted into several refcounts
> (per task events, per cpu, non-pinned, etc...). And since
> vcpu_enter_guest() is a fast path, I'll need to maintain another global=

> per cpu one, without lock or further operations to know if we need
> to save the debug registers, just a simple check.
>=20

I'm not 100% sure right now if we still need "switch_db_reg" in case we
have a reliable indicator that the host requires properly set registers.
ATM I would dare to say, we don't, but I need to think about this again.

Jan


--------------enig3F3D15FACC0374B3521F5A0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrujjQACgkQitSsb3rl5xSXRACgzE5C+TnL4psnl7TcUDjlumre
XkEAnijAYW7xWY0MGtbnT3OhLyTOXc++
=AUXP
-----END PGP SIGNATURE-----

--------------enig3F3D15FACC0374B3521F5A0D--
