Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXJ0O4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXJ0O4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJ0Oz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:55:58 -0400
Received: from mx39.mail.ru ([194.67.23.35]:56656 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXJ0Oz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:55:56 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Sat, 27 Oct 2007 18:55:48 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>
References: <200710262024.06012.arvidjaar@mail.ru> <200710271122.49344.arvidjaar@mail.ru> <4723410E.1010208@gmail.com>
In-Reply-To: <4723410E.1010208@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13127267.zRGSiVNXa0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710271855.52866.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13127267.zRGSiVNXa0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 October 2007, Alexey Starikovskiy wrote:
> Andrey,
> Please try the attached patch. I choose to do snprintf() instead of direct
> copy, as your previous message showed empty OEM type.
>

Not quite. Now I get

OEM info:                0

while before I got empty string. If I read acpi_extract_package correctly, =
it=20
actually interpreted integer as string without any conversion. Which in thi=
s=20
case obviously gave us empty string (integer being 0). I'd prefer to remain=
=20
compatible.

also

{pts/1}% cat /sys/class/power_supply/BAT1/manufacturer
0

which is rather weird manufacturer name :)

> Thanks,
> Alex.
>
> Andrey Borzenkov wrote:
> > On Friday 26 October 2007, Alexey Starikovskiy wrote:
> >> Your cat's "Bad address" means -EFAULT, according to "man errno".
> >> Please apply this patch to see what exactly failed...
> >
> > [ 1191.471572] ACPI: element[12]->type =3D 1, expected string
> > [ 1196.640065] ACPI: element[12]->type =3D 1, expected string
> > [ 1199.479773] ACPI: element[12]->type =3D 1, expected string
> > [ 1199.745435] ACPI: element[12]->type =3D 1, expected string
> >
> > it is "OEM type". For reference here is _BIF from my DSDT:
> >
> >              Method (_BIF, 0, NotSerialized)
> >             {
> >                 Name (BUFF, Package (0x0D) {})
> >                 Store (0x00, Index (BUFF, 0x00))
> >                 Store (\_SB.MEM.BDV2, Local2)
> >                 Multiply (\_SB.MEM.BDC2, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x01))
> >                 Multiply (\_SB.MEM.BLF2, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x02))
> >                 Store (\_SB.MEM.BTC2, Index (BUFF, 0x03))
> >                 Store (\_SB.MEM.BDV2, Index (BUFF, 0x04))
> >                 Multiply (\_SB.MEM.BCW2, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x05))
> >                 Multiply (\_SB.MEM.BCL2, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x06))
> >                 Multiply (\_SB.MEM.BG12, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x07))
> >                 Multiply (\_SB.MEM.BG22, Local2, Local0)
> >                 Divide (Local0, 0x03E8, Local1, Local0)
> >                 Store (Local0, Index (BUFF, 0x08))
> >                 Store (\_SB.MEM.BMN2, Index (BUFF, 0x09))
> >                 Store (\_SB.MEM.BSN2, Index (BUFF, 0x0A))
> >                 Store (\_SB.MEM.BTP2, Index (BUFF, 0x0B))
> >                 Store (\_SB.MEM.BOI2, Index (BUFF, 0x0C))
> >                 Return (BUFF)
> >             }
> >
> > This is behaviour change. Previous battery.c used generic
> > acpi_extract_package which allowed (allows) for object of type integer
> > when string is requested:
> >
> >                 case ACPI_TYPE_INTEGER:
> >                         switch (format_string[i]) {
> >                         case 'N':
> >                                 size_required +=3D sizeof(acpi_integer);
> >                                 tail_offset +=3D sizeof(acpi_integer);
> >                                 break;
> >                         case 'S':
> >                                 size_required +=3D
> >                                     sizeof(char *) + sizeof(acpi_intege=
r)
> > + sizeof(char);
> >                                 tail_offset +=3D sizeof(char *);
> >                                 break;
> >
> > while current battery.c:extract_package fails:
> >
> >                 if (offsets[i].mode) {
> >                         if (element->type !=3D ACPI_TYPE_STRING &&
> >                             element->type !=3D ACPI_TYPE_BUFFER) {
> > printk (KERN_ERR PREFIX "element[%d]->type =3D %x, expected string\n", =
i,
> > element->type);
> >                                 return -EFAULT;
> >                         }
> >
> > well, while it could be BIOS fault this happily worked before ... This =
is
> > obviously also the reason why I do not have anything in /sys
> >
> > Fans, could you check whether you have the same issue using test patch?



--nextPart13127267.zRGSiVNXa0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI1F1R6LMutpd94wRAnbXAKCnMZwKGgROr13DlyjKiMoAKamAcQCfeG8c
rECGurTVV/6CcXk4gyaXupM=
=buEx
-----END PGP SIGNATURE-----

--nextPart13127267.zRGSiVNXa0--
