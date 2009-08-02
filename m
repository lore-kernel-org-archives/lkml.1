Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZHBWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZHBWnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZHBWnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:43:45 -0400
Received: from mail.open.by ([193.232.92.17]:58076 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZHBWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:43:44 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9223 [Aug 2 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Mon, 3 Aug 2009 01:46:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802224633.GA3200@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
 <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
 <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/02/09 14:33), Linus Torvalds wrote:
> > And another related point which I'm don't know is why we don't change
> > console_fops to hung_up_tty_fops in do_tty_hangup() in the below.
>=20
> Yup, you're right. Because console_fops has=20
>=20
>         .write          =3D redirected_tty_write,
>=20
> we won't actually hang up the console due to that test for "write !=3D=20
> tty_write".
[...]
> So exactly what _does_ happen if we get rid of that hack?
>=20
This solution looks like the right one. There is no trace
on shutdown.
I'll compile and test non-SMP kernel (and of course yet more testing for SM=
P).

	Sergey


>  drivers/char/tty_io.c |   19 +------------------
>  1 files changed, 1 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index a3afa0c..80540ec 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -496,10 +496,8 @@ static void do_tty_hangup(struct work_struct *work)
>  {
>  	struct tty_struct *tty =3D
>  		container_of(work, struct tty_struct, hangup_work);
> -	struct file *cons_filp =3D NULL;
>  	struct file *filp, *f =3D NULL;
>  	struct task_struct *p;
> -	int    closecount =3D 0, n;
>  	unsigned long flags;
>  	int refs =3D 0;
> =20
> @@ -520,11 +518,6 @@ static void do_tty_hangup(struct work_struct *work)
>  	file_list_lock();
>  	/* This breaks for file handles being sent over AF_UNIX sockets ? */
>  	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
> -		if (filp->f_op->write =3D=3D redirected_tty_write)
> -			cons_filp =3D filp;
> -		if (filp->f_op->write !=3D tty_write)
> -			continue;
> -		closecount++;
>  		tty_fasync(-1, filp, 0);	/* can't block */
>  		filp->f_op =3D &hung_up_tty_fops;
>  	}
> @@ -574,17 +567,7 @@ static void do_tty_hangup(struct work_struct *work)
>  	while (refs--)
>  		tty_kref_put(tty);
> =20
> -	/*
> -	 * If one of the devices matches a console pointer, we
> -	 * cannot just call hangup() because that will cause
> -	 * tty->count and state->count to go out of sync.
> -	 * So we just call close() the right number of times.
> -	 */
> -	if (cons_filp) {
> -		if (tty->ops->close)
> -			for (n =3D 0; n < closecount; n++)
> -				tty->ops->close(tty, cons_filp);
> -	} else if (tty->ops->hangup)
> +	if (tty->ops->hangup)
>  		(tty->ops->hangup)(tty);
>  	/*
>  	 * We don't want to have driver/ldisc interactions beyond
>=20

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp2F0kACgkQfKHnntdSXjRrrwQAuTvsK6DBmefeUQHJLy4ApJF9
eza4yHtK45IEr1ebgWN6yHaeJeEaWMLTdB0L51+3lZ9h8l3LB0AElgZuNQIk2Sfv
aOofeygrA51fqYqIEdSltHDXOjY294T2DklalYkOvHd+Knrjwanj07u5/Np//TJY
LUQ+W6k/NND8HLBDYFs=
=Hpio
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
