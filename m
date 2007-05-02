Return-Path: <linux-kernel-owner+w=401wt.eu-S1766849AbXEBRd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766849AbXEBRd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXEBRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:33:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43988 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbXEBRdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:33:21 -0400
X-Sasl-enc: U4wUsILw9Mi7y+QJsQ+xYu9BSG7b/wOdeiYYOxKHX2cN 1178127200
Message-ID: <4638CC03.7030903@imap.cc>
Date: Wed, 02 May 2007 19:36:03 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <46338AEB.2070109@imap.cc> <20070428141024.887342bd.akpm@linux-foundation.org> <4636248E.7030309@imap.cc> <20070430112130.b64321d3.akpm@linux-foundation.org> <46364346.6030407@imap.cc> <20070430124638.10611058.akpm@linux-foundation.org> <46383742.9050503@imap.cc> <20070502001000.8460fb31.akpm@linux-foundation.org> <20070502075238.GA9083@suse.de>
In-Reply-To: <20070502075238.GA9083@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA4BD98C283333DFF8A258ED5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA4BD98C283333DFF8A258ED5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.05.2007 09:52 schrieb Greg KH:
> Tilman, here's a patch, can you try this on top of your tree that dies?=


2.6.21-git3 plus that patch comes up fine.

(Except for a UDP problem I seem to remember I already saw reported
on lkml and which I'll ignore for now in order not to blur the
picture.)

Started to git-bisect mainline now, but that will take some time.
It's more than 800 patches to check and I don't get more than 2-3
iterations per day out of that machine.

HTH
T.

> ---
>  drivers/base/core.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -252,7 +252,7 @@ static ssize_t show_uevent(struct device
>  	struct kobject *top_kobj;
>  	struct kset *kset;
>  	char *envp[32];
> -	char data[PAGE_SIZE];
> +	char *data =3D NULL;
>  	char *pos;
>  	int i;
>  	size_t count =3D 0;
> @@ -276,6 +276,10 @@ static ssize_t show_uevent(struct device
>  		if (!kset->uevent_ops->filter(kset, &dev->kobj))
>  			goto out;
> =20
> +	data =3D (char *)get_zeroed_page(GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	/* let the kset specific function add its keys */
>  	pos =3D data;
>  	retval =3D kset->uevent_ops->uevent(kset, &dev->kobj,
> @@ -290,6 +294,7 @@ static ssize_t show_uevent(struct device
>  		count +=3D sprintf(pos, "%s\n", envp[i]);
>  	}
>  out:
> +	free_page((unsigned long)data);
>  	return count;
>  }
> =20

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enigA4BD98C283333DFF8A258ED5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGOMwKMdB4Whm86/kRAiQ5AJ0YnCp4w0gB4G398+BDi3kP+i/WWgCeLR8F
JeXtj4ToA9XapC68cSmc9Mg=
=ojyH
-----END PGP SIGNATURE-----

--------------enigA4BD98C283333DFF8A258ED5--
