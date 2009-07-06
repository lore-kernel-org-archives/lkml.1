Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZGFXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZGFXeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZGFXeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:34:04 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:46923 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZGFXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:34:03 -0400
Date: Mon, 6 Jul 2009 20:33:48 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       maciej.rutecki@gmail.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Input: mark serio and i8042 as suspended when
	hibernating too.
Message-ID: <20090706233346.GA32726@vespa.holoscopio.com>
References: <1246760019-4120-1-git-send-email-cascardo@holoscopio.com> <200907070040.43299.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <200907070040.43299.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 07, 2009 at 12:40:42AM +0200, Rafael J. Wysocki wrote:
> On Sunday 05 July 2009, Thadeu Lima de Souza Cascardo wrote:
> > serio ports are not being restarted any longer because resume operations
> > after hibernate do nothing, since the device has not been marked as
> > suspended. This happens because suspend is only considering the SUSPEND
> > event but not the FREEZE event.
> >=20
> > Note that this driver has still to migrate to dev_pm_ops, but this fixes
> > this particular bug now.
>=20
> Hmm, this looks like a fix for:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13643
>=20
> Any objections to merging it through the suspend tree?
>=20
> Best,
> Rafael
>=20
>=20

I even got to this bug report myself, but 1) I wasn't sure it would fix
the original problem; 2) I didn't know how to include the patch as a
solution in the report and submit it to the lists in one tackle and was
too lazy to do it through the web interface.

I found out the two references before I could find the bug report by
looking into the mailing list archives (both for linux-input and
linux-kernel). And since no one pointed out a solution, I've tried to
solve it myself. Fortunately, those references told me that was a
problem not found at 2.6.30 and that I should look for commits since
then, not since the last git after that I couldn't find the problem in,
and that hibernate was the problem. The fact is that I had hibernate
totally failing for me for that git version and hibernate was the first
thing I've tried, even before using the mouse.

Anyway, since you are the PM maintainer and had submitted messages to
the bug report and one of the messages, I've decided to copy you and I
would be very glad that the merge was done throught your tree as any
other tree. As long as this enters rc3, for sure.  :-D

My best and any tips as to get these regression fixes more noticeable,
I'll be glad.
Cascardo.

> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  drivers/input/serio/i8042.c |    7 ++++---
> >  drivers/input/serio/serio.c |    7 ++++---
> >  2 files changed, 8 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> > index f919bf5..582245c 100644
> > --- a/drivers/input/serio/i8042.c
> > +++ b/drivers/input/serio/i8042.c
> > @@ -934,10 +934,11 @@ static bool i8042_suspended;
> > =20
> >  static int i8042_suspend(struct platform_device *dev, pm_message_t sta=
te)
> >  {
> > -	if (!i8042_suspended && state.event =3D=3D PM_EVENT_SUSPEND) {
> > +	if (!i8042_suspended && state.event =3D=3D PM_EVENT_SUSPEND)
> >  		i8042_controller_reset();
> > -		i8042_suspended =3D true;
> > -	}
> > +
> > +	i8042_suspended =3D state.event =3D=3D PM_EVENT_SUSPEND ||
> > +			  state.event =3D=3D PM_EVENT_FREEZE;
> > =20
> >  	return 0;
> >  }
> > diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> > index fb17573..d66f494 100644
> > --- a/drivers/input/serio/serio.c
> > +++ b/drivers/input/serio/serio.c
> > @@ -935,10 +935,11 @@ static int serio_suspend(struct device *dev, pm_m=
essage_t state)
> >  {
> >  	struct serio *serio =3D to_serio_port(dev);
> > =20
> > -	if (!serio->suspended && state.event =3D=3D PM_EVENT_SUSPEND) {
> > +	if (!serio->suspended && state.event =3D=3D PM_EVENT_SUSPEND)
> >  		serio_cleanup(serio);
> > -		serio->suspended =3D true;
> > -	}
> > +
> > +	serio->suspended =3D state.event =3D=3D PM_EVENT_SUSPEND ||
> > +			   state.event =3D=3D PM_EVENT_FREEZE;
> > =20
> >  	return 0;
> >  }

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpSidoACgkQyTpryRcqtS0d6ACfeUFTnwX+bgOrPMG/StqKnrB+
TVgAnjRynPtLHEjmhML2NgysaBrH9ncZ
=eZWm
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
