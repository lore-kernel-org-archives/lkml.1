Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXGROah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXGROah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbXGROa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:30:29 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3700 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXGROa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:30:28 -0400
Message-ID: <469E23F9.2080304@imap.cc>
Date: Wed, 18 Jul 2007 16:30:17 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [2.6.22.1] spurious (?) message "BUG: lock held at task exit time"
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig65A91AFFD62C4B7E64A2C6AE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig65A91AFFD62C4B7E64A2C6AE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

When testing the serial Gigaset driver with kernel release 2.6.22.1
I get a kernel BUG message:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ BUG: lock held at task exit time! ]
-------------------------------------
gigasetm101d/5970 is exiting with locks still held!
1 lock held by gigasetm101d/5970:
 #0:  (&cs->hw.ser->dead_mutex){--..}, at: [<c02d8bc7>] mutex_lock+0x1c/0=
x1f

which is all well and true except the process that has exited is the
grandfather process of a daemon() call, and the daemonized grandchild
process is still running happily, keeping the serial device open and
ensuring the line discipline stays loaded, and therefore legally
holding the dead_mutex:

ts@xenon:~> ps lw 5992
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMM=
AND
1     0  5992     1  16   0   1432   168 pause  S    ?          0:00 ./gi=
gaset/driver/daemon/gigasetm101d /dev/ttyS0

The structure of gigasetm101d is basically:

    if ((tty_fd =3D open(dev, O_RDWR|O_NOCTTY)) < 0) {
        fprintf(stderr, "%s: cannot open %s: %s\n", prog, dev, strerror(e=
rrno));
        exit(EXIT_FAILURE);
    }
    if (ioctl(tty_fd, TIOCSETD, &ldisc) < 0)
    {
        fprintf(stderr, "%s: cannot set line discipline: %s\n",
                prog, strerror(errno));
        exit(EXIT_FAILURE);
    }
    if (daemon (0, 0) !=3D 0)
    {
        fprintf(stderr, "%s: cannot daemonize: %s\n",
                prog, strerror(errno));
        exit(EXIT_FAILURE);
    }
    pause();
    exit(EXIT_SUCCESS);

Who is at fault here?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig65A91AFFD62C4B7E64A2C6AE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGniQCMdB4Whm86/kRAj8hAJwJWWTyx4z6QNd48yXl7vliGaHgFQCfarAz
XJfjv2NhM6hGNSbgXgAZIco=
=Ypox
-----END PGP SIGNATURE-----

--------------enig65A91AFFD62C4B7E64A2C6AE--
