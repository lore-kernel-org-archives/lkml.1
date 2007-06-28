Return-Path: <linux-kernel-owner+w=401wt.eu-S1765614AbXF1X3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765614AbXF1X3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXF1X3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:29:47 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41298 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXF1X3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:29:46 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Fri, 29 Jun 2007 08:27:12 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Rafael Wysocki <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <20070628142532.GC5339@ucw.cz>
In-Reply-To: <20070628142532.GC5339@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart49305947.o2VMB2cWpF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706290827.13024.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart49305947.o2VMB2cWpF
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 29 June 2007 00:25:32 Pavel Machek wrote:
> Hi!
>=20
> > Hi all
> >=20
> > Here's what I have after today's work.
> >=20
> > I haven't yet been able to test on x86, but can confirm that it works o=
kay=20
on x86_64. I'm currently working towards testing it on my old Omnibook. My =
P4=20
desktop won't resume from suspend to ram at all, and hasn't produced any=20
beeps.
> >=20
> > I needed to move the BEEP invocation to after the data segment is=20
reloaded, so that the test could access the variable. That was pretty trick=
y=20
to find - no oops or anything bad prior, it just didn't beep when expected.
> >=20
> > A couple of notes:
> >=20
> > - I'd like to put the BEEP macro somewhere that can be shared by x86 32=
=20
and 64. If that's a good idea, any suggestions on where? Nothing occurs to =
me=20
straight off.
> > - I've just switched from Evo to Kmail. Please let me know if there's a=
ny=20
mangling of the patch.
> >=20
> > Regards,
> >=20
> > Nigel
> >=20
> >  arch/i386/kernel/acpi/wakeup.S   |   29 ++++++++++++++++++++++++++++-
> >  arch/x86_64/kernel/acpi/wakeup.S |   25 +++++++++++++++++++++++++
> >  include/linux/acpi.h             |    1 +
> >  kernel/power/main.c              |   23 +++++++++++++++++++++++
> >  4 files changed, 77 insertions(+), 1 deletion(-)
> > diff -ruNp 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S=20
970-str-beep.patch-new/arch/i386/kernel/acpi/wakeup.S
> > --- 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S	2007-06-19=20
12:15:25.000000000 +1000
> > +++ 970-str-beep.patch-new/arch/i386/kernel/acpi/wakeup.S	2007-06-19=20
21:14:49.000000000 +1000
> > @@ -11,7 +11,22 @@
> >  #
> >  # If physical address of wakeup_code is 0x12345, BIOS should call us w=
ith
> >  # cs =3D 0x1234, eip =3D 0x05
> > -#=20
> > +#
> > +
> > +#define BEEP \
> > +	inb	$97, %al; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$3, %al; 	\
> > +	outb	%al, $97; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$-74, %al; 	\
> > +	outb	%al, $67; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$-119, %al; 	\
> > +	outb	%al, $66; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$15, %al; 	\
> > +	outb	%al, $66;
> > =20
> >  ALIGN
> >  	.align	4096
> > @@ -31,6 +46,11 @@ wakeup_code:
> >  	movw	%cs, %ax
> >  	movw	%ax, %ds					# Make ds:0 point to wakeup_start
> >  	movw	%ax, %ss
> > +
> > +	testl   $1, beep_flags - wakeup_code
> > +	jz      1f
> > +	BEEP
> > +1:
>=20
> Can we rename/reuse existing flag variable?

Sorry, but I can't resist the opportunity to say "Send a patch!" :)

Seriously, though, I'd prefer not to. If we rename that acpi video flags=20
variable (I assume this is what you're thinking of), we only create cause f=
or=20
confusion. A variable should for debugging or for controlling quirks, not f=
or=20
both at the same time.

Regards,

Nigel
=2D-=20
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia

--nextPart49305947.o2VMB2cWpF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGhDXBN0y+n1M3mo0RAuQwAKDxDpY/bcpiLtnTVimwkQbcCKGBDwCg22sm
AcHLukFXuDkfNhsqE2Hoy50=
=a71c
-----END PGP SIGNATURE-----

--nextPart49305947.o2VMB2cWpF--
