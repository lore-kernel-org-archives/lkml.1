Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYDUPPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYDUPPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYDUPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:15:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632AbYDUPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:15:03 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 11:15:03 EDT
Subject: Re: [RFC 0/3] Examples for the new sparse context tracking
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <20080421145525.GB9153@linux.vnet.ibm.com>
References: <20080410134810.629048000@sipsolutions.net>
	 <20080419233338.GG20138@linux.vnet.ibm.com>
	 <1208766355.26186.37.camel@johannes.berg>
	 <20080421145525.GB9153@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CV94L+f4brYivCkDyoUt"
Date: Mon, 21 Apr 2008 17:05:33 +0200
Message-Id: <1208790333.26186.112.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CV94L+f4brYivCkDyoUt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > my_specific_rcu_get() __acquires(RCU) __acquires(specificRCU);
> >=20
> > and then annotate whatever needs the specific RCU type with
> > __requires(specificRCU)
>=20
> Cute!!!  I didn't realize you could mark a single interface with
> multiple __acquires() markings.
>=20
> So if there is at least one match, sparse is happy?

No, sparse requires all the given contexts to match. For example, say
you have

#define __requires_rcu __requires(RCU)

#define __requires_special_rcu \
	__requires(specificRCU)

#define __acquires_special_rcu \
	__acquires(RCU) __acquires(specificRCU)

=EF=BB=BF#define __acquires_regular_rcu __acquires(RCU)

Then a function marked "__acquires_special_rcu" with acquire *both*
contexts, and a function marked __requires_special_rcu will require just
the special one. And a function marked __requires_rcu just requires the
regular one. So say you have

rcu_special_lock __acquires_special_rcu
=EF=BB=BFrcu_special_unlock __releases_special_rcu
=EF=BB=BF
rcu_regular_lock __acquires_rcu
=EF=BB=BFrcu_regular_unlock __releases_rcu

rcu_do_special __requires_special_rcu
rcu_do_something __requires_rcu


Then both this will be fine:


rcu_special_lock()
rcu_do_special()
rcu_do_something()
rcu_special_unlock()


but this will result in a warning:


rcu_regular_lock()
rcu_do_special()
rcu_regular_unlock()

because the "specialRCU" context is missing.

You could mark do_special with *both* __requires(RCU) and
__requires(specialRCU) but as long as the acquires/releases parts have a
strict dependency (=EF=BB=BFspecialRCU implies RCU) that isn't necessary.

johannes

--=-CV94L+f4brYivCkDyoUt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAytPKVg1VMiehFYAQIwTQ//QS8R7E3PBq027f4tO3NkphsHGilYCofv
/4u4hq8B7DiyItML+ebNgPrl8xyozaxYOilnYMLsz36rQSJs5RYhVi6F1pAbwU8q
Cv4RHJ6L3DNlxmR1B0G1HJcEcX6D8Y5ElXPN/HyU23tTATa1omTPJYBHfnzemzX3
vz2xM+bwDEezCmsO8r7O1yOTo/GlERiOskdU2jKTgwAJkxHC/1Dbj0tTJ6pmWF9X
aJtArFtCDEkoRZ5ySYIZq+cLpYNC+Yx9D1VwWT8+XEf4ybDTiuwbCVqiSKc/lXmW
Lt35IiiPsvX1MNNl3m+BQAv2q0gLKlp2R8HR43llHSwsGfu33cHvqfjOQT+YD+KT
AkQlVwm1cUtAu4DlI5qMqGPHXzBMhakxlY8sK1W5o12ffO09CiKL2MpJo3Ww++6X
uwoUuc6i8OrDbcxkxYGCJeTf19BbWAWxA8j9YG0QRhYkqb4fqjbkiY5bMhPTRwdv
ttvugB5GEj7Agml5Ch+d9WbN58eWsh81qTicjj9FSNFX66LfmPYuU6eONmLc4lto
f804E/OtPdMLpRI4Ok5P8hk1wTXPzj1+goiF7DXAnNEiJW4kcCPPPOZR3Foi/TUV
cs4vUjXW5KEflHze6RhWMgikhQHsTprQL0hJvCV6K547yYHdNcxf3D+HEP2rza0X
0H5g9AjOsBM=
=08Yo
-----END PGP SIGNATURE-----

--=-CV94L+f4brYivCkDyoUt--

