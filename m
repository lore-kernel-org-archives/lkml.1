Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZHFURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZHFURp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbZHFURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:17:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43797 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbZHFURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:17:42 -0400
Date: Thu, 6 Aug 2009 22:17:40 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Luotao Fu <l.fu@pengutronix.de>, socketcan-users@lists.berlios.de,
       Michael Olbrich <m.olbrich@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Socketcan-users] [PATCH] CAN: make checking in can_rcv less
	restrictive
Message-ID: <20090806201740.GA7067@pengutronix.de>
Mail-Followup-To: Oliver Hartkopp <oliver@hartkopp.net>,
	Luotao Fu <l.fu@pengutronix.de>, socketcan-users@lists.berlios.de,
	Michael Olbrich <m.olbrich@pengutronix.de>,
	linux-kernel@vger.kernel.org
References: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de> <4A7B0957.5020808@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <4A7B0957.5020808@hartkopp.net>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 22:05:29 up 1 day,  7:24,  5 users,  load average: 0.05, 0.06,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Thu, Aug 06, 2009 at 06:48:23PM +0200, Oliver Hartkopp wrote:
> Luotao Fu wrote:
> > From: Michael Olbrich <m.olbrich@pengutronix.de>
> >=20
> > Checking for can frame format in can_rcv() is too restrictive. BUG_ON i=
s way too
> > heavy for the case that the can interface probably received a can frame=
 with
> > malicious format. Further it can be used for DDOS attack since BUG_ON c=
an lead
> > to kernel panic. Hence we turn this to WARN_ON instead.
> >=20
> > Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> > Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> > ---
> >  net/can/af_can.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/net/can/af_can.c b/net/can/af_can.c
> > index e733725..e6dcf4b 100644
> > --- a/net/can/af_can.c
> > +++ b/net/can/af_can.c
> > @@ -656,7 +656,7 @@ static int can_rcv(struct sk_buff *skb, struct net_=
device *dev,
> >  		return 0;
> >  	}
> > =20
> > -	BUG_ON(skb->len !=3D sizeof(struct can_frame) || cf->can_dlc > 8);
> > +	WARN_ON(skb->len !=3D sizeof(struct can_frame) || cf->can_dlc > 8);
> > =20
> >  	/* update statistics */
> >  	can_stats.rx_frames++;
>=20
> NAK.
>=20
> The CAN applications can rely on getting proper CAN frames with this chec=
k. It
> was introduced some time ago together with several other sanity checks - =
even
> on the TX path.
>=20
> The CAN core *only* consumes skbuffs originated from a CAN netdevice
> (ARPHRD_CAN).

I don't quite get it. The problem here is a broken can message sent to
the device can bring down the kernel. Which means that we can this way
easily shoot down a system with a single can message. This might be a
serious security hole. Sanity check at this level should imho better
made in the can application. We shall not bring the systemstabity in
danger this way.

>=20
> When this BUG() triggers, someone provided a definitely broken *CAN* netw=
ork
> driver, and this needsfp to be fixed on that level.=20

In our case a sender (a FPGA) generates correct can frames carrying
wrong dlc length. This way the can driver on our side runs into the bug
though the driver itself is allright. The opposite needed to be fixed,
not our side.  Though we do suffer a system crash only because the
sender sends trash into the can network. This is imo quite bad.

cheers
Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp7OmQACgkQiruQY+UyUmEPrQCgnXjPg9u2PBd8XJOLfdt2XZ52
sTYAn0RpdKfgq1mj0/oW8DTBzr6bi3EX
=19Ke
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
