Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXJ0HXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXJ0HXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXJ0HW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:22:56 -0400
Received: from mx7.mail.ru ([194.67.23.27]:31604 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbXJ0HWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:22:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Sat, 27 Oct 2007 11:22:48 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>
References: <200710262024.06012.arvidjaar@mail.ru> <200710262215.42939.arvidjaar@mail.ru> <472232D3.6000807@gmail.com>
In-Reply-To: <472232D3.6000807@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1970502.B9mSWZi2Iv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710271122.49344.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1970502.B9mSWZi2Iv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 October 2007, Alexey Starikovskiy wrote:
>
> Your cat's "Bad address" means -EFAULT, according to "man errno".
> Please apply this patch to see what exactly failed...



[ 1191.471572] ACPI: element[12]->type =3D 1, expected string
[ 1196.640065] ACPI: element[12]->type =3D 1, expected string
[ 1199.479773] ACPI: element[12]->type =3D 1, expected string
[ 1199.745435] ACPI: element[12]->type =3D 1, expected string

it is "OEM type". For reference here is _BIF from my DSDT:

             Method (_BIF, 0, NotSerialized)
            {
                Name (BUFF, Package (0x0D) {})
                Store (0x00, Index (BUFF, 0x00))
                Store (\_SB.MEM.BDV2, Local2)
                Multiply (\_SB.MEM.BDC2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x01))
                Multiply (\_SB.MEM.BLF2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x02))
                Store (\_SB.MEM.BTC2, Index (BUFF, 0x03))
                Store (\_SB.MEM.BDV2, Index (BUFF, 0x04))
                Multiply (\_SB.MEM.BCW2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x05))
                Multiply (\_SB.MEM.BCL2, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x06))
                Multiply (\_SB.MEM.BG12, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x07))
                Multiply (\_SB.MEM.BG22, Local2, Local0)
                Divide (Local0, 0x03E8, Local1, Local0)
                Store (Local0, Index (BUFF, 0x08))
                Store (\_SB.MEM.BMN2, Index (BUFF, 0x09))
                Store (\_SB.MEM.BSN2, Index (BUFF, 0x0A))
                Store (\_SB.MEM.BTP2, Index (BUFF, 0x0B))
                Store (\_SB.MEM.BOI2, Index (BUFF, 0x0C))
                Return (BUFF)
            }

This is behaviour change. Previous battery.c used generic acpi_extract_pack=
age=20
which allowed (allows) for object of type integer when string is requested:

                case ACPI_TYPE_INTEGER:
                        switch (format_string[i]) {
                        case 'N':
                                size_required +=3D sizeof(acpi_integer);
                                tail_offset +=3D sizeof(acpi_integer);
                                break;
                        case 'S':
                                size_required +=3D
                                    sizeof(char *) + sizeof(acpi_integer) +
                                    sizeof(char);
                                tail_offset +=3D sizeof(char *);
                                break;

while current battery.c:extract_package fails:

                if (offsets[i].mode) {
                        if (element->type !=3D ACPI_TYPE_STRING &&
                            element->type !=3D ACPI_TYPE_BUFFER) {
printk (KERN_ERR PREFIX "element[%d]->type =3D %x, expected string\n", i,=20
element->type);
                                return -EFAULT;
                        }

well, while it could be BIOS fault this happily worked before ... This is=20
obviously also the reason why I do not have anything in /sys

=46ans, could you check whether you have the same issue using test patch?

--nextPart1970502.B9mSWZi2Iv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIudJR6LMutpd94wRAs+qAKC04Chs8JYmvMShNAAdAfA9KIPz4QCgkdM9
v7xEP1YCbcj+sESVuHqX4Ls=
=P3uC
-----END PGP SIGNATURE-----

--nextPart1970502.B9mSWZi2Iv--
