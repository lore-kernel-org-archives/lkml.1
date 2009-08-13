Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZHMIbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZHMIbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZHMIbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:31:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:57644 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZHMIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q6NajlsuXkBAmvZimd3mnQvYTlPgd3s/c3IMcBMrk3FkK2/VpIOsYJxwxfAP5l2gWI
         UVVnCyYMA9+ITyIBPSX95oIpU9SxQoQXZi17G2UfX3LB7ePZFOWAaXqCwzA7eeduKdqw
         PrZ2aIybIkARV+7BrWHOKYmMzHcQdWYC62DdE=
Date: Thu, 13 Aug 2009 11:34:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090813083426.GB3283@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/12/09 20:18), Len Brown wrote:
> > Kernel oopses on early boot stages (boots normally with boot_delay=3D10=
).
>=20
> > rc5-git8
>=20
> Please find which kernel this failure starts in.
> Start by testing 2.6.30.stable so we can tell  =20
> if this is a regression in the current RC.     =20
>
OK... I'll try to bisect. It'll take time.=20
I consider 7 successfull boots to mark that kernel is ok (it may be wrong).

-git8
maxcpus=3D1
+ + + + + + +

acpi_serialize=3D1
+ -

boot_delay=3D1
+ + + + + + +

boot_delay=3D0
+ + -

vga=3D791
+ + + + + + +

=20
> What is the difference between the two dmesg?
> they have the same cmdline, neither has boot_delay,
> and neither dmesg shows the oops.
>
boot params are the same. Both kernels booted successfully. There are no oo=
pses in syslog (I guess 0.21 is
too early for logd to start).

The only difference (which I find suspicious) is around 0.21 second:
[    0.205668] ACPI Error (dswload-0790): [PCFG] Namespace lookup failure, =
AE_ALREADY_EXISTS
[    0.205899] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalo=
g 20090521 psloop-227
[    0.206124] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
[    0.206417] ACPI: Marking method RBPE as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.206773] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.PCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
[    0.207070] ACPI: Marking method _STA as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.207326] ACPI Error (uteval-0256): Method execution failed [\_SB_.PCI=
0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
[    0.213503] ACPI Error: Could not map memory at 0000000000000000, size 0=
 20090521 exregion-173
[    0.213734] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [Syste=
mMemory] 20090521 evregion-424
[    0.213963] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.RBPE] (Node f7017678), AE_NO_MEMORY
[    0.214286] ACPI Error (psparse-0537): Method parse/execution failed [\_=
GPE._L01] (Node f701d198), AE_NO_MEMORY
[    0.214616] ACPI Exception: AE_NO_MEMORY, while evaluating GPE method [_=
L01] 20090521 evgpe-568


> The fact that boot_delay=3D10 makes the problem go away
> suggests some sort of race condition. =20
I think it is.

> Is 10 the smallest value of printk_time that works, or is it a random val=
ue?
>=20
No. 1 is the smallest.

> Do you still see the oops with CONFIG_PRINTK_TIME=3Dn?
>=20
Yes.

> Do you still see the oops with maxcpus=3D1?
>=20
No.

> Do you still see the oops with "acpi_serialize=3D1"?
>=20
Yes.

	Sergey
--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqD0BIACgkQfKHnntdSXjRZ0QQA5BEfZ8djejvheriyx6fOCuL5
/UZ8ba1jD6XzK5cuOH7FuMsGW3STFz9rNf23KD7AGIGCTBmHrhTSS+FJfbw1G9MW
kRGyfLTu06XBEWNg9PUgFmrZJPIhuBzyPrt2+rWmkmGu0OPSZ1ShcE1pDDCNTNAi
qkrXkVO5zfJY8Kc8Lm8=
=APL+
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
