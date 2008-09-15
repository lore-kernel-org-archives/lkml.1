Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYIOQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYIOQ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYIOQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:29:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35306 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIOQ31 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:29:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc6-mmotm0913 build error - suspect itimers-fix-itimer-many-thread-hang.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221496161_46396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Sep 2008 12:29:21 -0400
Message-ID: <48922.1221496161@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221496161_46396P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Trying to build rc6-mmotm0913 dies:

  CC      security/selinux/hooks.o
security/selinux/hooks.c: In function =E2=80=98selinux_bprm_committing_cr=
eds=E2=80=99:
security/selinux/hooks.c:2325: error: =E2=80=98struct task_struct=E2=80=
=99 has no member named =E2=80=98it_prof_expires=E2=80=99
make=5B2=5D: *** =5Bsecurity/selinux/hooks.o=5D Error 1
make=5B1=5D: *** =5Bsecurity/selinux=5D Error 2
make: *** =5Bsecurity=5D Error 2

I suspect that itimers-fix-itimer-many-thread-hang.patch has a merge issu=
e
against linux-next.patch, causing selinux_bprm_commiting_creds to be miss=
ing
an update.  The code as it appears in my tree (end of that function
in security/selinux/hooks.c):

       if (rc) =7B
                for (i =3D 0; i < RLIM_NLIMITS; i++) =7B
                        rlim =3D current->signal->rlim + i;
                        initrlim =3D init_task.signal->rlim+i;
                        rlim->rlim_cur =3D min(rlim->rlim_max, initrlim->=
rlim_cur);
                =7D

                if (current->signal->rlim=5BRLIMIT_CPU=5D.rlim_cur =21=3D=
 RLIM_INFINITY) =7B
                        /*
                         * This will cause RLIMIT_CPU calculations to be
                         * refigured.
                         */
                        current->it_prof_expires =3D jiffies_to_cputime(1=
);
                =7D
        =7D
=7D

Looks like that current->it_prof_expires should be something else, but th=
e
linux-next.patch update for hooks.c is such a train wreck that I can't
figure out what's going on or what *should* be going on?

(After the 2 build errors I reported, plus hitting the CONFIG_DEBUG_MUTEX=
ES
glitch that Kosaki Motohiro reported, I gave up - if the fix for this one=

is obvious, I'll see what *else* I can break before the next -mmotm drops=
.. ;)




--==_Exmh_1221496161_46396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIzo1hcC3lWbTT17ARAjn7AKCID0kumoaJk316WFrRGXxmJ1ccJACeOr8e
4Wce7UwwtKTIyWkURYkW2Dw=
=waHq
-----END PGP SIGNATURE-----

--==_Exmh_1221496161_46396P--
