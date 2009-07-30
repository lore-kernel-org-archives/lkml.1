Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZG3OSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZG3OSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZG3OSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:18:06 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44351 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZG3OSF (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:18:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexander Shishkin <alexander.shishckin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] List per-process file descriptor consumption when hitting file-max
In-Reply-To: Your message of "Wed, 29 Jul 2009 19:17:00 +0300."
             <71a0d6ff0907290917u1f0c0e68p8036d53c69320392@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1244461122-3303-1-git-send-email-alexander.shishckin@gmail.com>
            <71a0d6ff0907290917u1f0c0e68p8036d53c69320392@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248957636_2641P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 08:40:36 -0400
Message-ID: <28675.1248957636@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248957636_2641P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jul 2009 19:17:00 +0300, Alexander Shishkin said:
>Is there anything dramatically wrong with this one, or could someone ple=
ase review this?


> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for_each_process(p) =7B
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 files =3D get_files_struc=
t(p);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=21files)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;=

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&files->file_lo=
ck);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fdt =3D files_fdtable(fil=
es);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we have to actually *c=
ount* the fds */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (count =3D i =3D 0; i=
 < fdt->max_fds; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=
=3D =21=21fcheck_files(files, i);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO =22=3D> =
%s =5B%d=5D: %d=5Cn=22, p->comm,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 p->pid, count);

1) Splatting out 'count' without a hint of what it is isn't very user fri=
endly.
Consider something like =22=3D> %s=5B%d=5D: open=3D%d=5Cn=22 instead, or =
add a second line
to the 'VFS: file-max' printk to provide a header.

2) What context does this run in, and what locks/scheduling consideration=
s
are there? On a large system with many processes running, this could conc=
eivably
wrap the logmsg buffer before syslog has a chance to get scheduled and re=
ad
the stuff out.

3) This can be used by a miscreant to spam the logs - consider a program
that does open() until it hits the limit, then goes into a close()/open()=

loop to repeatedly bang up against the limit. Every 2 syscalls by the
abuser could get them another 5,000+ lines in the log - an incredible
amplification factor.

Now, if you fixed it to only print out the top 10 offending processes, it=
 would
make it a lot more useful to the sysadmin, and a lot of those considerati=
ons go
away, but it also makes the already N**2 behavior even more expensive...

At that point, it would be good to report some CPU numbers by running a a=
busive
program that repeatedly hit the limit, and be able to say =22Even under f=
ull
stress, it only used 15% of a CPU on a 2.4Ghz Core2=22 or similar...


--==_Exmh_1248957636_2641P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKcZTEcC3lWbTT17ARAoYiAJ4p/9PhCMOePxALdp3vOwJV9ADhoQCglE6q
e+kqzIgs1/6r26Ys1q+i2Ps=
=4kbN
-----END PGP SIGNATURE-----

--==_Exmh_1248957636_2641P--
