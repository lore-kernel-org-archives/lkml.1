Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZHBWNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZHBWNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZHBWNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:13:11 -0400
Received: from mail.open.by ([193.232.92.17]:57340 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZHBWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:13:10 -0400
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
Date: Mon, 3 Aug 2009 01:15:56 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802221556.GA2943@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
 <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/02/09 13:20), Linus Torvalds wrote:
> On Sun, 2 Aug 2009, Sergey Senozhatsky wrote:
> >=20
> > non-SMP system 'fails' as well.
>=20
> Ahh, can you trigger this reliably? Is it 100% of the time when you shut=
=20
> down from single user mode? Or just occasionally?
>=20
Yes, 100% in both SMP and non-SMP builds.

> I take it that you can't get a trace with sysrq-T because nothing gets=20
> logged,=20
TRUE

> and you don't have a serial port console?=20
I don't have a serial port console.


I think there is no need in=20
	mutex_unlock(&tty->ldisc_mutex); // HACK
	...
	mutex_lock(&tty->ldisc_mutex); // HACK

since we have tty_ldisc.c:794
	mutex_lock(&tty->ldisc_mutex);			<<
        if (tty->ldisc) { /* Not yet closed */

Anyway, code looks like this:
//JUST FOR TEST!

if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
		/* Avoid racing set_ldisc or tty_ldisc_release */
		//mutex_lock(&tty->ldisc_mutex);		// Commented
		if (tty->ldisc) {	/* Not yet closed */
			int work =3D 0;
			/* Switch back to N_TTY */
			mutex_unlock(&tty->ldisc_mutex);        // HACK

			work =3D tty_ldisc_halt(tty);		//to be sure
			if (work) {
				WARN_ON(0 !=3D 1);
				wait_event_timeout(tty_ldisc_wait,
					   (1 =3D=3D 0), 15 * HZ);	//Just to read what is written on the screen
			}
		=09
			if (tty_ldisc_wait_idle(tty) !=3D 0) {
				WARN_ON(0 !=3D 1);
				wait_event_timeout(tty_ldisc_wait,
					   (1 =3D=3D 0), 15 * HZ);	//Just to read what is written on the screen
			}
			mutex_lock(&tty->ldisc_mutex);          // HACK
			tty_ldisc_reinit(tty);
			/* At this point we have a closed ldisc and we want to
			   reopen it. We could defer this to the next open but
			   it means auditing a lot of other paths so this is
			   a FIXME */
			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
			tty_ldisc_enable(tty);
		}
		mutex_unlock(&tty->ldisc_mutex);
		tty_reset_termios(tty);
	}

This code gave me WARNINGS:
tty_io.c:1267		//tty_reopen: WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
tty_ldisc.c:808		//tty_ldisc_wait_idle
tty_ldisc.c:209		//tty_ldisc_put


	Sergey

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp2EBwACgkQfKHnntdSXjRnagP/eqb13zSYhtfAyCl4PaUpXYFg
eZGEjA+IPR2IBDyZBfYxN9/Y89uLMuC0FFSgGfeHoNbN8HXvp7xopSPFSiIlehMk
+PqVDe/oDgfUEKQ3BwDUGiFG0OQzc62JFJW7ZoOkQ26shoxACiuMviV3SLc+Iicz
MuzKhSX0ZNcvi7FektI=
=xwig
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
