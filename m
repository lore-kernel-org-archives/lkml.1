Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZHCPVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZHCPVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZHCPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:21:49 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:35374 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZHCPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:21:48 -0400
Date: Mon, 3 Aug 2009 17:21:46 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Nicholas Vinen <hb@x256.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible kernel bug with SYS_clone / CLONE_PARENT
Message-ID: <20090803152146.GJ29252@hawkmoon.kerlabs.com>
Mail-Followup-To: Nicholas Vinen <hb@x256.org>,
	linux-kernel@vger.kernel.org
References: <4A766864.40703@x256.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-26613-1249312874-0001-2"
Content-Disposition: inline
In-Reply-To: <4A766864.40703@x256.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-26613-1249312874-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03/08/09 14:32 +1000, Nicholas Vinen wrote:
> Hello,
>=20
> I have a program where process A forks process B and process B forks
> process C. I want process A to be notified if/when process C terminates.
> (Process B terminates almost immediately after forking process C and a
> number of other siblings.)
>=20
> According to the manual page for clone() I should be able to do this
> with CLONE_PARENT:
>=20
> -----------------
>     CLONE_PARENT (since Linux 2.3.12)
>     If CLONE_PARENT is set, then the parent of the new child (as
> returned by getppid(2)) will be the same as that of the calling process.
>     If CLONE_PARENT is not set, then (as with fork(2)) the child's
> parent is the calling process.
>     Note that it is the parent process, as returned by getppid(2), which
> is signaled when the child terminates, so that if CLONE_PARENT is set,
> then the parent of the calling process, rather than the calling process
> itself, will be signaled.
> -----------------
>=20
>=20
> I am using kernel 2.6.29-gentoo-r5 (not the most recent, I know, but
> relatively new), glibc 2.9_p20081201-r2 and gcc 4.3.2-r3. Here is my
> test program:
>=20
> -----------------
> #include <asm/unistd.h>
> #include <sys/syscall.h>
> #include <sched.h>
> #include <signal.h>
> #include <stdio.h>
> #include <string.h>
> #include <stdlib.h>
>=20
> int fork_but_keep_ppid() {
>   return syscall(SYS_clone, CLONE_PARENT, (void*)0);
> }

You should use CLONE_PARENT|SIGCHLD. CLONE_PARENT alone deactivates
signal notification to original parent.

Louis

>=20
> void sigchld_handler(int signum, siginfo_t* info, void* ucontext) {
>   fprintf(stderr, "SIGCHLD (PID=3D%d)\n", info->si_pid);
> }
>=20
> int main(void) {
>   struct sigaction act;
>   memset(&act, 0, sizeof(act));
>   act.sa_sigaction =3D sigchld_handler;
>   act.sa_flags =3D SA_NOCLDSTOP|SA_NOCLDWAIT|SA_SIGINFO;
>   sigaction(SIGCHLD, &act, 0);
>=20
>   fprintf(stderr, "Main PID =3D %d\n", syscall(SYS_getpid));
>=20
>   pid_t a =3D fork();
>   if( a =3D=3D 0 ) {
>     fprintf(stderr, "first fork PID =3D %d, PPID =3D %d\n",
> syscall(SYS_getpid), syscall(SYS_getppid));
>     pid_t b =3D fork_but_keep_ppid();
>     if( b =3D=3D 0 ) {
>       fprintf(stderr, "second fork PID =3D %d, PPID =3D %d\n",
> syscall(SYS_getpid), syscall(SYS_getppid));
>       exit(-2);
>     } else {
>       fprintf(stderr, "second fork returned %d\n", b);
>     }
>     exit(-1);
>   } else {
>     fprintf(stderr, "first fork returned %d\n", a);
>   }
>   sleep(1);
>   fprintf(stderr, "Creating & terminating another child to check
> SIGCHILD still works...\n");
>   pid_t c =3D fork();
>   if( c =3D=3D 0 ) {
>     fprintf(stderr, "Child's PID is %d\n", syscall(SYS_getpid));
>     exit(-3);
>   }
>   sleep(1);
>=20
>   return 0;
> }
> -----------------
>=20
> Note that I am making the syscall directly because I want fork-like
> semantics and these are not provided by the clone() call. I also don't
> want to have to provide a separate stack for the child and it seems that
> (at least according to the man page) for clone() you have to, even if
> you don't use CLONE_VM.
>=20
> The output from this program is:
>=20
> -----------------
> Main PID =3D 13125
> first fork returned 13126
> first fork PID =3D 13126, PPID =3D 13125
> second fork PID =3D 13127, PPID =3D 13125
> second fork returned 13127
> SIGCHLD (PID=3D13126)
> Creating & terminating another child to check SIGCHILD still works...
> Child's PID is 13128
> SIGCHLD (PID=3D13128)
> -----------------
>=20
>=20
> There should be a SIGCHLD for the second fork's child PID but there
> isn't. ps shows the process is a zombie with PPID=3D13125 (in this case)
> while the test program is still running, yet the "parent" does not seem
> to receive the SIGCHLD.
>=20
> I could be doing something wrong but I can't see what it might be. Any
> suggestions? Please CC me on any reply as I am not currently subscribed
> to LKML.
>=20
>=20
>=20
> Thanks,
>=20
> Nicholas.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-26613-1249312874-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp3AIoACgkQVKcRuvQ9Q1RTTACeLPsbK0M4odhaiVB3ZmisOA3s
rdEAn0nsqonYqJPxt+7qfOK/3xzdSdpU
=lPeD
-----END PGP SIGNATURE-----

--=_bohort-26613-1249312874-0001-2--
