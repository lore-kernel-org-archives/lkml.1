Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYK0S1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYK0S1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYK0S1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:27:34 -0500
Received: from home.keithp.com ([63.227.221.253]:60889 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYK0S1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:27:34 -0500
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
From: Keith Packard <keithp@keithp.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <200811271531.18498.arnd@arndb.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
	 <200811271531.18498.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NOhFEtT3jwsoNNGNhPz7"
Date: Thu, 27 Nov 2008 10:27:04 -0800
Message-Id: <1227810424.4277.55.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NOhFEtT3jwsoNNGNhPz7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-27 at 15:31 +0100, Arnd Bergmann wrote:
> On Thursday 27 November 2008, Keith Packard wrote:
> > +static long serial_compat_ioctl(struct tty_struct *tty, struct file *f=
ile,
> > +                              unsigned int cmd, unsigned long arg)
> > +{
> > +       struct usb_serial_port *port =3D tty->driver_data;
> > +       long retval =3D -ENODEV;
> > +
> > +       dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
> > +
> > +       WARN_ON(!port->port.count);
> > +
> > +       /* pass on to the driver specific version of this function
> > +          if it is available */
> > +       if (port->serial->type->compat_ioctl) {
> > +               lock_kernel();
> > +               retval =3D port->serial->type->compat_ioctl(tty, file, =
cmd, arg);
> > +               unlock_kernel();=20
>=20
> By convention, compat_ioctl functions should be called without the big ke=
rnel
> lock held.

Thanks - I didn't realize these were supposed to be different.

> You should probably define compat_ioctl to return an int as well
> so that it becomes possible to use the same function for both eventually.

The existing tty layer compat_ioctl is defined to return long; is that
also wrong?

> Then again, we can also drop the file argument, which is entirely unused
> in all the usb-serial ioctls.

I'm not sure it's worth the effort; if some future usb serial ioctl
needs the argument, we'd end up changing every existing driver back. I
assume there are some serial devices for which the file is relevant
during ioctl.

> Maybe the best way for now is to make the new compat_ioctl be
> int compat_ioctl(struct tty_struct, unsigned int cmd, unsigned long arg);
> and leave the old ioctl as it is. When we get around to pushing the
> BKL down into ->ioctl, we can change the prototype at the same time
> to warn potential out-of-tree drivers.

Let's figure out what the right compat_ioctl interface is first and
worry about fixing the existing ioctl interface later.

--=20
keith.packard@intel.com

--=-NOhFEtT3jwsoNNGNhPz7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJLuZ4Qp8BWwlsTdMRAj1sAKC5FnbzTLo+W4yFtICSnjjgz789fwCePKEm
vLI5UDC1ADcCbHNHED1T6VU=
=VA1w
-----END PGP SIGNATURE-----

--=-NOhFEtT3jwsoNNGNhPz7--

