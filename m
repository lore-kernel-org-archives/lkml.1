Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZIKWJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZIKWJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbZIKWJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:09:45 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:51916 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZIKWJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:09:44 -0400
Message-ID: <4AAACAA4.2030707@web.de>
Date: Sat, 12 Sep 2009 00:09:40 +0200
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
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
 on top of perf counters
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1252571367-25876-4-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0A703AE4E77CD1205CE3488"
X-Provags-ID: V01U2FsdGVkX19ON6uJARJoenjYR3kf2liHbrgkhTK+2cHX61Wv
	fZi0fvVRYnOArfrWsR1bndPTVlGBcV0l31aF85gNa7YzLvYOx1
	EDX9fpLr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0A703AE4E77CD1205CE3488
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> This patch rebase the implementation of the breakpoints API on top of
> perf counters instances.
>=20
> The core breakpoint API has changed a bit:
>=20
> - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
>   now it doesn't support all cpu wide breakpoints but this may be
>   implemented soon.
>=20
> - unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint()=

>   have been unified in a single unregister_hw_breakpoint()
>=20
> Each breakpoints now match a perf counter which now handles the
> register scheduling, thread/cpu attachment, etc..
>=20
> The new layering is now made as follows:
>=20
>        ptrace       kgdb      ftrace   perf syscall
>           \          |          /         /
>            \         |         /         /

kgdb doesn't fit here as it requires nmi-safe services.

I don't think you want to make the whole stack nmi-safe but rather
provide a separate interface that allows kgdb to announce to the kernel
when it uses some slot. Those slots should simply be excluded from
hardware updates. That's roughly the logic we use in KVM for guest
debugging: when the host starts to use debug registers for that purpose,
the guest's setting will not effect the real hardware anymore.

>                                         /
>             Core breakpoint API        /
>                                       /
>                      |               /
>                      |              /
>=20
>               Breakpoints perf counters
>=20
>                      |
>                      |
>=20
>                Breakpoints PMU ---- Debug Register constraints handling=

>                                     (Part of core breakpoint API)
>                      |
>                      |
>=20
>              Hardware debug registers
>=20
> Reasons of this rewrite:
>=20
> - Use the centralized/optimized pmu registers scheduling,
>   implying an easier arch integration
> - More powerful register handling: perf attributes (pinned/flexible
>   events, exclusive/non-exclusive, tunable period, etc...)
>=20
> Impact:
>=20
> - New perf ABI: the hardware breakpoints counters
> - Ptrace breakpoints setting remains tricky and still needs some per
>   thread breakpoints references.
>=20
> Todo (in the order):
>=20
> - Drop struct hw_breakpoint and store generic breakpoints fields inside=

>   struct perf_counter_attr to have a common way to set breakpoints
>   parameters.
> - Support breakpoints perf counter events for perf tools (ie: implement=

>   perf_bpcounter_event())
> - Support from perf tools

Still on my wishlist for KVM is a cheap & easy way to obtain the current
register content or to refresh it in hardware. It's not yet clear to me
where to hook this in the given design. It looks like this information
can be scattered over the current thread and some perf counters.

Jan


--------------enigD0A703AE4E77CD1205CE3488
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkqqyqkACgkQniDOoMHTA+kfKACfU8WL+22jJK7CHKisI4Mgl3/L
O78An1F6Ku5ToSCo71KIrxIZlSz4JgMY
=nW5l
-----END PGP SIGNATURE-----

--------------enigD0A703AE4E77CD1205CE3488--
