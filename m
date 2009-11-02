Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZKBKX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZKBKX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZKBKX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:23:29 -0500
Received: from smtp-out113.alice.it ([85.37.17.113]:3112 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZKBKX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:23:28 -0500
Date: Mon, 2 Nov 2009 11:23:16 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>
Subject: Using statically allocated memory for platform_data.
Message-Id: <20091102112316.16163f6a.ospite@studenti.unina.it>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Nov_2009_11_23_16_+0100_kO2JqZkrfU9IVmYd"
X-OriginalArrivalTime: 02 Nov 2009 10:23:26.0232 (UTC) FILETIME=[837F0980:01CA5BA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Nov_2009_11_23_16_+0100_kO2JqZkrfU9IVmYd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I noted that in some mfd drivers (drivers/mfd/ezx-pcap.c and
drivers/mfd/da903x.c) there is code like this:

static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
                                     struct pcap_subdev *subdev)
{
        struct platform_device *pdev;

        pdev =3D platform_device_alloc(subdev->name, subdev->id);
        pdev->dev.parent =3D &pcap->spi->dev;
        pdev->dev.platform_data =3D subdev->platform_data;

        return platform_device_add(pdev);
}

Note the _direct_assignment_ of platform data; then in board init code
there are often global struct pointers passed as subdev platform data,
see arch/arm/mach-pxa/em-x270.c::em_x270_da9030_subdevs for instance.

In these cases, whenever the subdev platform device is unregistered,
the call to platform_device_release() tries to kfree the platform data,
and being it statically allocated memory this triggers a bug from SLAB:
	kernel BUG at mm/slab.c:521!
In my case this prevented proper device poweroff.

The question: should these mfd drivers use platform_device_add_data()
which allocates dynamic memory for *a copy* of platform data? Is this
simple solution acceptable even if there will be more memory used?
Or should we setup platform_data in dynamic memory from the beginning
in board init code? (which would be way less pretty IMHO).

As a side note, I've found that SLOB is more permissive in these cases
when statically allocated memory is being freed, it reports the bug but
the kernel does not hang, and in my case poweroff is still possible.

If you need more info to come up with an opinion about that, just let me
know.

Thanks,
   Antonio

P.S. I am sending this also to LKML, but I am not subscribed to it, if
you get the message from there, please CC me on reply.

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Mon__2_Nov_2009_11_23_16_+0100_kO2JqZkrfU9IVmYd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrusxQACgkQ5xr2akVTsAFp8QCePvQ48QJL+6fhc/vt8lI4JXvZ
/q0An38g7DoebsM0aePU3WmB5YFQcNLe
=kKLQ
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Nov_2009_11_23_16_+0100_kO2JqZkrfU9IVmYd--
