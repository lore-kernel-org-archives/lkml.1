Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZK1M12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZK1M12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZK1M11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:27:27 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48205 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZK1M11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:27:27 -0500
X-Sasl-enc: tt3JAtmXySJqMof5xahwVif9Vw27Lz61UxH6L+U+4tVn 1259411252
Message-ID: <4B1116F2.20308@imap.cc>
Date: Sat, 28 Nov 2009 13:26:26 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       isdn@linux-pingi.de, mac@melware.de
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
References: <20091123015625.GA32088@x200.localdomain>
In-Reply-To: <20091123015625.GA32088@x200.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9C81604568BF514A62D322D1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9C81604568BF514A62D322D1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 23.11.2009 02:56 schrieb Alexey Dobriyan:
> --- a/Documentation/isdn/INTERFACE.CAPI
> +++ b/Documentation/isdn/INTERFACE.CAPI
> @@ -149,8 +149,8 @@ char *(*procinfo)(struct capi_ctr *ctrlr)
>  	pointer to a callback function returning the entry for the device in
>  	the CAPI controller info table, /proc/capi/controller
> =20
> -read_proc_t *ctr_read_proc
> -	pointer to the read_proc callback function for the device's proc file=

> +const struct file_operations *proc_fops
> +	pointers to callback functions for the device's proc file
>  	system entry, /proc/capi/controllers/<n>; will be called with a
>  	pointer to the device's capi_ctr structure as the last (data) argumen=
t
> =20

This doesn't look correct. AFACIS, most of the callback functions in proc=
_fops
don't have a last argument named data or looking as if it might lend itse=
lf to
passing a pointer to the device's capi_ctr structure. In fact, later in y=
our
patch you replace uses of that last argument by accesses to the m->privat=
e
member of the struct seq_file *m argument, like here:

> --- a/drivers/isdn/hardware/avm/b1.c
> +++ b/drivers/isdn/hardware/avm/b1.c
[...]
> @@ -634,18 +636,17 @@ irqreturn_t b1_interrupt(int interrupt, void *dev=
ptr)
>  }
> =20
>  /* ------------------------------------------------------------- */
> -int b1ctl_read_proc(char *page, char **start, off_t off,
> -        		int count, int *eof, struct capi_ctr *ctrl)
> +static int b1ctl_proc_show(struct seq_file *m, void *v)
>  {
> +	struct capi_ctr *ctrl =3D m->private;
>  	avmctrl_info *cinfo =3D (avmctrl_info *)(ctrl->driverdata);
>  	avmcard *card =3D cinfo->card;
>  	u8 flag;
[...]

So I guess the paragraph Documentation/isdn/INTERFACE.CAPI needs to be
adapted to describe correctly where the callbacks will find their
controller data structure after that change.

OTOH, the new proc_show functions sport a second argument void *v that
doesn't appear to get used anywhere. It would be nice if that could be
explained a bit somewhere.

Thanks,
Tilman


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig9C81604568BF514A62D322D1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAksRFv0ACgkQQ3+did9BuFtm0wCeMszvhdODPFbglW0YsHGxAGs0
fioAn0Qw87wMvVK5Carsj/a47epOG992
=IItB
-----END PGP SIGNATURE-----

--------------enig9C81604568BF514A62D322D1--
