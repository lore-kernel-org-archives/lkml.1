Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYCAPku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYCAPku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYCAPkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:40:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:45160 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753299AbYCAPkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:40:40 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/rMBViGJnr7OOgX5BilaZsQeQg3Tq/doLN2KrjyX
	WbQDnySVY1xFwj
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
From: Mirco Tischler <mt-ml@gmx.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>
In-Reply-To: <47C35661.80109@googlemail.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com>
	 <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com>
	 <47C344E5.5050205@linux.intel.com> <47C35046.8020007@googlemail.com>
	 <47C35661.80109@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-el0z2c/Fk370G/u9yvmd"
Date: Sat, 01 Mar 2008 16:40:34 +0100
Message-Id: <1204386034.7035.5.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-el0z2c/Fk370G/u9yvmd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 26.02.2008, 00:59 +0100 schrieb Gabriel C:=20
> Gabriel C wrote:
> > Arjan van de Ven wrote:
> >> Gabriel C wrote:
> >>> Arjan van de Ven wrote:
> >>>> Gabriel C wrote:
> >>>>> Laurent Riffard wrote:
> >>>>>> Le 16.02.2008 09:25, Andrew Morton a =C3=A9crit :
> >>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6=
.25-rc2/2.6.25-rc2-mm1/
> >>>>> [..]
> >>>>>
> >>>>> I'm getting that in mainline now on one of my older laptops also.
> >>>> we fixed the cause of the machine you quoted; so I suspect yours is =
different..
> >>>> Can you get me your stacktrace ? Can you try the patch from this thr=
ead to show
> >>>> what memory the offender tries to access ?
> >>> Arjan , sorry for the lag.
> >>>
> >>> With your patch from http://marc.info/?l=3Dlinux-kernel&m=3D120336371=
506283&w=3D2 I don't have a warning anymore.
> >>>
> >> that is ... odd since it's the same in theory, just with some added pr=
intk's ;-(
> >>
> >=20
> > hmm but in theory only that part of your patch only should do the same =
, no ?
> >=20
> > 	if (page_is_ram(pfn)) {
> > 		printk(..)
> > 	}
> >=20
> > I'm going to try that.
> >=20
> >=20
>=20
> With only that part I get the waring again.=20
>=20
> But I see the printk() twice so I guess this should be in general an WARN=
_ON() ?
>=20
> http://frugalware.org/~crazy/dmesg/dmesg_with_patch_2
>=20
I still get this in mainline (todays 2.6.25-rc3-git)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ac3c959..0a9a616 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -134,7 +134,11 @@ static void __iomem *__ioremap(unsigned long
phys_addr, unsigned long size,
                        return NULL;
        }

-       WARN_ON_ONCE(page_is_ram(pfn));
+       if (page_is_ram(pfn)) {
+               printk(KERN_ERR "ioremap: trying to map RAM page at %lx
\n",
+                       pfn << PAGE_SHIFT);
+               WARN_ON_ONCE(page_is_ram(pfn));
+       }

        switch (mode) {
        case IOR_MODE_UNCACHED:

With this diagnostics patch applied, I get the following stacktrace:

[   23.223587] Allocate Port Service[0000:00:1c.3:pcie03]
[   23.232536] ioremap: trying to map RAM page at 1000
[   23.232590] ------------[ cut here ]------------
[   23.232633] WARNING: at arch/x86/mm/ioremap.c:140 __ioremap
+0x232/0x280()
[   23.232678] Modules linked in:
[   23.232744] Pid: 48, comm: kacpid Not tainted
2.6.25-rc3-current-fix.ioremap.warning #1
[   23.232801]=20
[   23.232801] Call Trace:
[   23.232881]  [<ffffffff8023b4cf>] warn_on_slowpath+0x5f/0x80
[   23.232925]  [<ffffffff8023c657>] ? printk+0x67/0x70
[   23.232970]  [<ffffffff8038c5f2>] ? acpi_ec_transaction+0x1ec/0x207
[   23.233015]  [<ffffffff802271b2>] __ioremap+0x232/0x280
[   23.233059]  [<ffffffff8022721b>] ioremap_nocache+0xb/0x10
[   23.233103]  [<ffffffff80467792>] acpi_os_map_memory+0x13/0x21
[   23.233149]  [<ffffffff8037d580>] acpi_ex_system_memory_space_handler
+0xd2/0x1c2
[   23.233204]  [<ffffffff8037d4ae>] ?
acpi_ex_system_memory_space_handler+0x0/0x1c2
[   23.233261]  [<ffffffff80376320>] acpi_ev_address_space_dispatch
+0x172/0x1c1
[   23.233307]  [<ffffffff8037a7ff>] acpi_ex_access_region+0x210/0x22d
[   23.233351]  [<ffffffff8037a90b>] acpi_ex_field_datum_io+0xef/0x183
[   23.233397]  [<ffffffff802ad1e2>] ? kmem_cache_alloc+0x82/0xc0
[   23.233441]  [<ffffffff8037aa2b>] acpi_ex_extract_from_field
+0x8c/0x1a1
[   23.233511]  [<ffffffff8037c27e>] ? acpi_ex_system_wait_mutex
+0x1f/0x51
[   23.233557]  [<ffffffff803794d9>] acpi_ex_read_data_from_field
+0x122/0x15d
[   23.233603]  [<ffffffff8037e3a0>] acpi_ex_resolve_node_to_value
+0x19c/0x250
[   23.233648]  [<ffffffff80379f7c>] acpi_ex_resolve_to_value
+0x25c/0x26c
[   23.233693]  [<ffffffff8037be64>] acpi_ex_resolve_operands
+0x25e/0x5a2
[   23.233739]  [<ffffffff8037368e>] acpi_ds_exec_end_op+0xcd/0x3db
[   23.233783]  [<ffffffff803832ed>] acpi_ps_parse_loop+0x611/0x7e0
[   23.233827]  [<ffffffff803825d2>] acpi_ps_parse_aml+0x7e/0x269
[   23.233871]  [<ffffffff80383ae9>] acpi_ps_execute_method+0x129/0x1d4
[   23.233916]  [<ffffffff80380855>] acpi_ns_evaluate+0xad/0x110
[   23.233960]  [<ffffffff803803f3>] acpi_evaluate_object+0x154/0x211
[   23.234004]  [<ffffffff802338cd>] ? hrtick_set+0xbd/0x120
[   23.234047]  [<ffffffff80371026>] ? acpi_os_execute_deferred+0x0/0x39
[   23.234092]  [<ffffffff8038c6a7>] acpi_ec_gpe_query+0x9a/0xbd
[   23.234136]  [<ffffffff80371052>] acpi_os_execute_deferred+0x2c/0x39
[   23.234181]  [<ffffffff8024e079>] run_workqueue+0x99/0x140
[   23.234225]  [<ffffffff8024ebf3>] worker_thread+0xa3/0x110
[   23.234269]  [<ffffffff80252180>] ? autoremove_wake_function+0x0/0x40
[   23.234314]  [<ffffffff8024eb50>] ? worker_thread+0x0/0x110
[   23.234358]  [<ffffffff80251d1d>] kthread+0x4d/0x80
[   23.234401]  [<ffffffff8020d668>] child_rip+0xa/0x12
[   23.234444]  [<ffffffff80251cd0>] ? kthread+0x0/0x80
[   23.234509]  [<ffffffff8020d65e>] ? child_rip+0x0/0x12
[   23.234551]=20
[   23.234594] ---[ end trace ca64fb97dc2c53b1 ]---
[   23.258458] Real Time Clock Driver v1.12ac
[   23.258671] hpet_resources: 0xfed00000 is busy



--=-el0z2c/Fk370G/u9yvmd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHyXjxz+diZ7c2xfgRAq09AKCLVcZzdxOdYW1HIpMCnoggN6Yn8gCfRtsL
iHx9FOcTun6z6kt3O9O6rAs=
=iG68
-----END PGP SIGNATURE-----

--=-el0z2c/Fk370G/u9yvmd--

