Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbZIQC4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbZIQC4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbZIQC4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:56:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46373 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbZIQCz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:55:59 -0400
Date: Thu, 17 Sep 2009 12:55:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kurt Roeckx <kurt@roeckx.be>
Subject: Re: linux-next: cpufreq-current tree build warning
Message-Id: <20090917125556.1125d8ae.sfr@canb.auug.org.au>
In-Reply-To: <20090917022726.GA30706@redhat.com>
References: <20090917120651.f0cdf4c2.sfr@canb.auug.org.au>
	<20090917022726.GA30706@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_12_55_56_+1000_7rlPv5hpRuiWaIix"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_12_55_56_+1000_7rlPv5hpRuiWaIix
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 16 Sep 2009 22:27:26 -0400 Dave Jones <davej@redhat.com> wrote:
>
> On Thu, Sep 17, 2009 at 12:06:51PM +1000, Stephen Rothwell wrote:
>  >=20
>  > Today's linux-next build (x86_64 allmodconfig) produced this warning:
>  >=20
>  > arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function 'fill_powernow_=
table_fidvid':
>  > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1001: warning: passing argum=
ent 1 of 'invalidate_entry' from incompatible pointer type
>  > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:608: note: expected 'struct =
cpufreq_frequency_table *' but argument is of type 'struct powernow_k8_data=
 *'
>  >=20
>  > Introduced by commit 7fc1b26613587ab4369615445b5485040c60fef1 ("[CPUFR=
EQ]
>  > Fix NULL ptr regression in powernow-k8").
>=20
> I'm very confused. I don't see this..
>=20
> (22:22:25:davej:cpufreq)$ make arch/x86/kernel/cpu/cpufreq/powernow-k8.o
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CC [M]  arch/x86/kernel/cpu/cpufreq/powernow-k8.o
> (22:22:30:davej:cpufreq)$=20
>=20
> Also, line 1001 is ..
>=20
> 	if (data->acpi_data.state_count)

That is line 1022 in my tree.

>From line 986 (in fucntion fill_powernow_table_fidvid):

		/* verify only 1 entry from the lo frequency table */
		if (fid < HI_FID_TABLE_BOTTOM) {
			if (cntlofreq) {
				/* if both entries are the same,
				 * ignore this one ... */
				if ((freq !=3D powernow_table[cntlofreq].frequency) ||
				    (index !=3D powernow_table[cntlofreq].index)) {
					printk(KERN_ERR PFX
						"Too many lo freq table "
						"entries\n");
					return 1;
				}

				dprintk("double low frequency table entry, "
						"ignoring it.\n");
				invalidate_entry(data, i);
				continue;
			} else
				cntlofreq =3D i;
		}

> So I'm not sure what your gcc is talking about.

This is gcc 4.4.0 if that is relevant.

> Does next contain additional patches to this file from outside the cpufre=
q.git tree?

$ git log origin/master.. arch/x86/kernel/cpu/cpufreq/powernow-k8.c
commit 7fc1b26613587ab4369615445b5485040c60fef1
Author: Kurt Roeckx <kurt@roeckx.be>
Date:   Wed Sep 16 11:09:32 2009 -0400

    [CPUFREQ] Fix NULL ptr regression in powernow-k8
   =20
    Fixes bugzilla #13780
   =20
    From: Kurt Roeckx <kurt@roeckx.be>
    Signed-off-by: Dave Jones <davej@redhat.com>

so, no.
(origin/master is Linus' tree of about 2 hours ago, commit
ab86e5765d41a5eb4239a1c04d613db87bea5ed8 "Merge
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6")

Looking further, this is the cpureq-current tree I am complaining about,
in the cpufreq tree, you also have:

commit db39d5529d347de5e2eec1a72d67fcfacae6c5a2
Author: Mark Langsdorf <mark.langsdorf@amd.com>
Date:   Fri Aug 21 19:15:28 2009 -0500

    [CPUFREQ] Powernow-k8: Enable more than 2 low P-states
   =20
    Remove an obsolete check that used to prevent there being more
    than 2 low P-states.  Now that low-to-low P-states changes are
    enabled, it prevents otherwise workable configurations with
    multiple low P-states.
   =20
    Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Tested-by: Krists Krilovs <pow@pow.za.net>
    Signed-off-by: Dave Jones <davej@redhat.com>

Which removes the above code ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_12_55_56_+1000_7rlPv5hpRuiWaIix
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxpTwACgkQjjKRsyhoI8wgigCguyiYUElcGpO8rO5yx7oh3n1b
EmcAoJD3HJydpivUK8rIxDsHiBWKHlJQ
=vGML
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_12_55_56_+1000_7rlPv5hpRuiWaIix--
