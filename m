Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZGKRr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZGKRr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZGKRrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:47:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZGKRru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:47:50 -0400
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of
 b44/b43 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <8763dznnki.fsf@scholz.fias.uni-frankfurt.de>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	 <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	 <200907092203.10294.rjw@sisk.pl> <1247171295.1905.5.camel@johannes.local>
	 <87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
	 <1247322985.30647.108.camel@johannes.local>
	 <8763dznnki.fsf@scholz.fias.uni-frankfurt.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1KOfra4iopVe4GXK2l1w"
Date: Sat, 11 Jul 2009 19:47:44 +0200
Message-Id: <1247334464.30647.109.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1KOfra4iopVe4GXK2l1w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 19:20 +0200, Jan Scholz wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > On Sat, 2009-07-11 at 16:07 +0200, Jan Scholz wrote:
> >
> >> > Jan, can you run with console_suspend=3D0 (or whatever it is now, Ra=
fael
> >> > will correct me if I'm wrong) that should work on your platform, and=
 put
> >> > a bunch of printk calls into __ieee80211_suspend in net/mac80211/pm.=
c to
> >> > see where in there it's hanging?
> >>=20
> >> Did that, seems like it hangs in
> >>   drv_remove_interface(local, &conf);
> >
> > Ok, thanks! I was going to suggest doing the same in
> > b43_op_remove_interface in drivers/net/wireless/b43/main.c, but I think
> > the problem is just that we have an ordering problem and call drv_stop
> > before drv_remove_interface. I'll try to come up with a fix soon --
> > might not be able to today though, in the meantime I guess you can just
> > move the drv_stop call to the end of the function and tell me if that
> > works -- that would be racy but should be ok most of the time.
>=20
> I moved drv_stop to the end of the function (see patch below) and now
> suspend works fine.

Thanks, that's what I suspected -- I'll take a closer look into what is
required to make it race-free against RX.

johannes

> Jan
>=20
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 7a549f9..0ac15fb 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -58,12 +58,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>  	/* flush again, in case driver queued work */
>  	flush_workqueue(local->hw.workqueue);
> =20
> -	/* stop hardware - this must stop RX */
> -	if (local->open_count) {
> -		ieee80211_led_radio(local, false);
> -		drv_stop(local);
> -	}
> -
>  	/* remove STAs */
>  	spin_lock_irqsave(&local->sta_lock, flags);
>  	list_for_each_entry(sta, &local->sta_list, list) {
> @@ -111,6 +105,12 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>  		drv_remove_interface(local, &conf);
>  	}
> =20
> +	/* stop hardware - this must stop RX */
> +	if (local->open_count) {
> +		ieee80211_led_radio(local, false);
> +		drv_stop(local);
> +	}
> +
>  	local->suspended =3D true;
>  	local->quiescing =3D false;
>=20

--=-1KOfra4iopVe4GXK2l1w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWNA9AAoJEODzc/N7+QmaqvIP/1ZOSyhAGiJeS8bmczgysKD9
tx73CdXCONQV1mF1Ty3FM1Q2zjS5Vl1gv/pzOMixcBcgai50WZL2UoY8KZsaN//x
3FAEextpoUCoJm0v/IZjI5AzW8sAcQttuJVhp5/IMO3a296QPjX6TTS3KPtNn3lu
gW+IvFVe+ozjjo6AiL1KrcyGbDiAqCEst/KaN+h78ksQdDu6OhjzDUMpJMehKguF
LFztQBIHb4XbW1tlHoXdD4s4v/g4msuqWXyciH5lzVAQNrpF+CtfVnqsLbPWuHRI
5zn0xzjC/NX4WItiZ+If5E1wVNwhwUOqwWouL/8DOx4rjYnXxd24Plq5fV1WbaMH
wLG4zJh4QElL5xWESw8ysZX88QAYvMnE45jDj9MFOkEK4Qqf+8WG27Jilkq0SRqX
NFLsR2Adzb+SStJiOMJV4yasRw9mULys5P7l+MxWDdjLhgR8AUhUhToKWu2CZEec
MsiNtrTlk2M3pil4qCVE66gB3LUYU0PJw+7VjJ6ca2XPB+pBDN/Clkp85PiVC4vo
7TIvqNCqE+0Gw/d6O02MV4Ou7NnNk7UBv1IOxZgLNGT2Ike7xPZ4QG+9QoAVTe82
4XelpBwi6vE820Avl9aSV74STKr1MRHiB1PdtDUJ/eCj4naHM6vSdzXvTUpZkMMn
/TVavKEotqpBi4wACCDR
=oIz7
-----END PGP SIGNATURE-----

--=-1KOfra4iopVe4GXK2l1w--

