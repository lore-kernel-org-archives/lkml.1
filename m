Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934Ab0COAtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:49:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49978 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934529Ab0COAtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:49:01 -0400
Date: Mon, 15 Mar 2010 01:48:50 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
	commit a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <20100315004850.GB28894@pengutronix.de>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org> <m1fx43zhbd.fsf@fess.ebiederm.org> <loom.20100314T113306-436@post.gmane.org> <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org> <m1fx42yb3s.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <m1fx42yb3s.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 14, 2010 at 12:08:55PM -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>=20
> > On Sun, 14 Mar 2010, Wolfram Sang wrote:
> >>
> >> coccinelle can apply semantic patches, rough description here [1]. So =
I wrote
> >> one which checks for every c-file in the kernel-tree:
> >>
> >> - Is there a structure containing (bin_)attribute?
> >> - Does a function declare a pointer to such a structure?
> >> - Is this pointer then used for a sysfs_create(_bin)_file?
> >> - If so, has there been a call to sysfs(_bin)_attr_init before?
> >>
> >> If not -> report. As coccinelle works on an abstract level of the code=
 (not on
> >> source-code level), it can follow code-paths and such. Really nice too=
l, once
> >> you gathered the information to learn it.
>=20
> Any chance you can post the semantic patch?  If it isn't too hard it
> would be nice to have the warm fuzzy of running it myself and seeing
> that there are no more of these left in the kernel.

(Strange, I sent an introductory message to the series:

http://kerneltrap.org/mailarchive/linux-kernel-janitors/2010/3/12/6848563

But it doesn't show up in the gmane-archives? And I just learned that CCs a=
dded
while editing the introductory message will be dropped by git-send-email. T=
his
is why it isn't on lkml. I have to fix that next time.)

Sure, reviewing is very welcome. I am still new to the semantic patches, so=
 a
double check is surely helpful (also adding Julia Lawall to cc, grand maste=
r of
this topic).

Here is the patch again for the binary-attributes (I recommend coccinelle
v0.2.2. Run it with 'spatch -sp_file <name> .' form kernel-top-level-dir):

@ init @
identifier struct_name, bin;
@@

        struct struct_name {
                ...
                struct bin_attribute bin;
                ...
        };

@ main extends init @
expression E;
statement S;
identifier name, err;
@@

(
        struct struct_name *name;
|
-       struct struct_name *name =3D NULL;
+       struct struct_name *name;
)
        ...
(
        sysfs_bin_attr_init(&name->bin);
|
+       sysfs_bin_attr_init(&name->bin);
        if (sysfs_create_bin_file(E, &name->bin))
                S
|
+       sysfs_bin_attr_init(&name->bin);
        err =3D sysfs_create_bin_file(E, &name->bin);
)


Here is my patch for the non-binary-attributes:

@ init @
identifier struct_name, attr;
@@

        struct struct_name {
                ...
                struct attribute attr;
                ...
        };

@ main extends init @
expression E;
statement S;
identifier name, err;
@@

(
        struct struct_name *name;
|
-       struct struct_name *name =3D NULL;
+       struct struct_name *name;
)
        ...
(
        sysfs_attr_init(&name->attr);
|
+       sysfs_attr_init(&name->attr);
        if (sysfs_create_file(E, &name->attr))
                S
|
+       sysfs_attr_init(&name->attr);
        err =3D sysfs_create_file(E, &name->attr);
)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkudg/IACgkQD27XaX1/VRtd8gCgmjER+e4T1Y/upvKXGAU11IFD
fpEAoJRan5Z2y7fLqqbB+0tWqvUcXD+B
=skst
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
