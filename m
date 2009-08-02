Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZHBTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZHBTC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZHBTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:02:27 -0400
Received: from mail.open.by ([193.232.92.17]:53640 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZHBTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:02:27 -0400
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
Date: Sun, 2 Aug 2009 22:05:14 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802190514.GA3278@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/02/09 10:16), Linus Torvalds wrote:
> > Looks like we have one more bug in tty code:
> > 'shutdown -r now' in 'single' user mode gives following trace:
> >=20
> > WARNING at: drivers/char/tty_ldisc.c:209 tty_ldisc_put+0x95/0xa0
> > ---
> > warn_slowpath_common+0x78/0xa0
> > warn_slowpath_null+0x21/0x40
> > tty_ldisc_put+0x95/0xa0
> > tty_ldisc_hangup+0xfc/0x1f0
> > do_tty_hangup+0x131/0x380
> > disassociate_ctty+0x50/0x210
> > do_exit+0x6b8/0x700
> > do_group_exit+0x45/0xb0
> > get_signal_to_deliver+0x226/0x410
> > do_notify_resume+0xc1+0xa90
> > work_notifysig+0x13/0x19
> >=20
> > //There is no trace in syslog, so given one is 'copy-paste' from the pa=
per.
>=20
> We have that 'refcount' counter for the ldisc, but we don't actually use=
=20
> it for memory management like we should (ie "free the ldisc when count=20
> goes to zero"), we just decrement it and free the thing.
>=20
> And it's quite possible that another CPU is doing some tty read thing or=
=20
> other that does
>=20
> 	tty_ldisc_try(..) // increments ld->refcount
> 	...
> 	tty_ldisc_deref(..) // decrements it.
>=20
> at the same time.=20
>

non-SMP system 'fails' as well.

=20
> The ldisc refcounts are simply done wrong. They are more debugging aids=
=20
> (for the case where no races occur), than actual memory management=20
> refcounts.
>=20
tty_ldisc.c:798  tty_ldisc_hangup
	WARN_ON(tty_ldisc_wait_idle(tty) !=3D 0);

gave WARN_ON traces.

So, it seems refcount is wrong before
	tty_ldisc_halt(tty);
	tty_ldisc_wait_idle(tty);

	/* which is */
	if (wait_event_timeout(tty_ldisc_wait,=20
		tty->ldisc->refcount =3D=3D 0, 5 * HZ) =3D=3D 0)
		return -EBUSY;

	Sergey

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp142oACgkQfKHnntdSXjQ1ZwQAp+aayhQXxpYZg+fIfcr37N8J
4QGFlGI4ErOE6eHd/+c+I5pPymyeQGqBjH+jKUHMoh8/JEb2io5582xVO1Vwih3j
c0vq5aC2ZDdH/DH6ZQCqfE1JK3ih2+m8xgrzOBiIzXvX8SRzf63Zc7GJgtwx9xMv
6wP190rlI6FKtSy59eY=
=q4u3
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
