Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZGKTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZGKTOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZGKTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 15:14:08 -0400
Received: from mail.open.by ([193.232.92.17]:56631 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbZGKTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 15:14:07 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9001 [Jul 11 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sat, 11 Jul 2009 22:15:56 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: possible regression with pty.c commit
Message-ID: <20090711191556.GA3845@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
commit d945cb9cce20ac7143c2de8d88b187f62db99bdc ("pty: Rework the pty layer=
 to use the normal buffering logic")
seems to brake kdesu.

(quote: "Because some su implementations (i.e. the one from Red Hat=D0=92=
=C2=AE) don't want to=20
read the password from stdin, KDE su creates a pty/tty pair and=20
executes su with it's standard filedescriptors connected to the tty.")

Revert "pty: Rework the pty layer to use the normal buffering logic"
(commit d945cb9cce20ac7143c2de8d88b187f62db99bdc) makes kdesu work again.

strace /usr/bin/kdesu -u root -c top:
//tons of kde stuff were cut

execve("/usr/bin/kdesu", ["/usr/bin/kdesu", "-u", "root", "-c", "top"], [/*=
 36 vars */]) =3D 0
brk(0)                                  =3D 0x9268000
=2E..
sigreturn()                             =3D ? (mask now [])
access("/bin/su", X_OK)                 =3D 0
open("/dev/ptmx", O_RDWR)               =3D 10
ioctl(10, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...=
}) =3D 0
ioctl(10, TIOCGPTN, [10])               =3D 0
stat64("/dev/pts/10", {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 10), =
=2E..}) =3D 0
ioctl(10, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...=
}) =3D 0
ioctl(10, TIOCGPTN, [10])               =3D 0
stat64("/dev/pts/10", {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 10), =
=2E..}) =3D 0
statfs("/dev/pts/10", {f_type=3D"DEVPTS_SUPER_MAGIC", f_bsize=3D4096, f_blo=
cks=3D0, f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{0, =
0}, f_namelen=3D255, f_frsize=3D4096}) =3D 0
ioctl(10, TIOCSPTLCK, [0])              =3D 0
open("/dev/pts/10", O_RDWR)             =3D 11
clone(child_stack=3D0, flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGC=
HLD, child_tidptr=3D0xb68c5718) =3D 4072
close(11)                               =3D 0
fcntl64(10, F_GETFL)                    =3D 0x2 (flags O_RDWR)
read(10, "Password: ", 255)             =3D 10
select(11, [10], NULL, NULL, {0, 100000}) =3D 0 (Timeout)
kill(4072, SIG_0)                       =3D 0
open("/dev/pts/10", O_RDWR)             =3D 11
kill(4072, SIG_0)                       =3D 0
ioctl(11, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost isig icanon -echo .=
=2E.}) =3D 0
close(11)                               =3D 0
kill(4072, SIG_0)                       =3D 0
write(10, "**~WRITE_PASSWORD~**", 11)	=3D 11
write(10, "\n", 1)                      =3D 1
fcntl64(10, F_GETFL)                    =3D 0x2 (flags O_RDWR)
read(10, "\n", 255)                     =3D 1
fcntl64(10, F_GETFL)                    =3D 0x2 (flags O_RDWR)
read(10, "kdesu_stub\n", 255)           =3D 11
open("/dev/pts/10", O_RDWR)             =3D 11
ioctl(11, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost isig icanon echo ..=
=2E}) =3D 0
ioctl(11, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost isig icanon echo ..=
=2E}) =3D 0
ioctl(11, SNDCTL_TMR_START or TCSETS, {B38400 -opost isig icanon -echo ...}=
) =3D 0
ioctl(11, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost isig icanon -echo .=
=2E.}) =3D 0
close(11)                               =3D 0
write(10, "stop", 4)                    =3D 4
write(10, "\n", 1)                      =3D 1
fcntl64(10, F_GETFL)                    =3D 0x2 (flags O_RDWR)
read(10, 0xbf840858, 255)               =3D -1 EIO (Input/output error)		<<=
<<<<<<<
--- SIGCHLD (Child exited) @ 0 (0) ---
write(5, "\0", 1)                       =3D 1
sigreturn()                             =3D ? (mask now [])
=2E....


As for "bug 13522: BUG: scheduling while atomic" - I'll test it.


	Sergey
--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpY5OwACgkQfKHnntdSXjRJVQP/Ue/mqsBVvCiEQogd9ZPFOkzx
2JM2dmrj9KynAAhxM4wZzehLjOc6XifZKfZxxMlBet4Xt8h82EDbvs187SwwEMqL
EVImfinMmsakhM4ZkjxxkEk5CnXUfob3XoAEAJTsny08fnTT7+eZwZEzwyZn0+fK
vT/1jqHU7/VI8LPejnY=
=02Ja
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
