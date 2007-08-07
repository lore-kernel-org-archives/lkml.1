Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbXHGNVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbXHGNVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbXHGNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:21:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:43799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759285AbXHGNVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:21:37 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/vgEwLim7vNNLq45oF9LvM0S0YP+ZAI2ekh9ws6E
	3aXk7F1ELyaLkH
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Tue, 7 Aug 2007 15:21:31 +0200
User-Agent: KMail/1.9.5
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708062113.44511.toralf.foerster@gmx.de> <20070807002116.GD27640@khazad-dum.debian.net>
In-Reply-To: <20070807002116.GD27640@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1986656.b6GxPS1XDe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708071521.33679.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1986656.b6GxPS1XDe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 7. August 2007 02:21 schrieb Henrique de Moraes Holschuh:
> On Mon, 06 Aug 2007, Toralf F=F6rster wrote:
> > Because I
> > (1) use the latest BIOS and
> > (2) I'm able to wake up a suspended system via <Fn> under Windows XP (y=
es, dual
> >     boot system I need it at work) regardless whether I previously hibe=
rnated
> >     the system (under Windows XP) or not
> >=20
> > I bisected this regression (rather of a feature than a bug, or ?) betwe=
en
> > the 2 tags v2.6.19 and v2.6.20 (~2400 commits, I read a good book in the
> > meanwhile) and found :
> >=20
> > last good commit : 7e244322cd4ea361ef9ee623b3fcb4d9f4ff841c
> > first bad commit: cfee47f99bc14a6d7c6b0be2284db2cef310a815
> >=20
> > I double checked these 2 commits - here's the first commit after which =
<Fn>
> > doesn't wake up my system from suspend state after it was (at least one=
 time
> > before) hibernated:
> >=20
> > commit cfee47f99bc14a6d7c6b0be2284db2cef310a815
> > Merge: 7e24432... 9185cfa...
> > Author: Len Brown <len.brown@intel.com>
> > Date:   Sat Dec 16 01:01:18 2006 -0500
> >=20
> >     Pull bugfix into test branch
> >=20
> >     Conflicts:
> >=20
> >         kernel/power/disk.c
>=20
> There is a *very* interesting patch that was merged by the above commit (=
git
> log 9185cfa ^7e24432 shows them):
>=20
> 9185cfa92507d07ac787bc73d06c42222eec7239 ACPI: S4: Use "platform" rather
> than "shutdown" mode by default
>=20
> So, please configure the kernel/s2ram/whatever you use to suspend-to-disk=
 to
> use "shutdown" as the default mode for suspend-to-disk, and check if that
> doesn't solve things.
>=20
> You might want to also try platform mode, but with commit
> 9185cfa92507d07ac787bc73d06c42222eec7239 reverted, since it does change
> slightly the platform suspend code path (not in any way I think it should
> matter, but hey, since I am not sure, I might as well say it).
>=20
> This might not be the *root* of the problem even if it fixes your
> regression, S4 *is* supposed to be the right way to suspend-to-disk, even=
 on
> some weird thinkpads.  Is there any way to find out what S-mode Windows u=
se
> to suspend-to-disk? =20
>=20
> Anyway, root-cause or not, it will be a damn good hint of what is really
> wrong if switching to S5 for sleep-to-disk fixes the issue (if it is not
> broken firmware).  And one can always document this in thinkwiki.org and
> some other places, and add all thinkpads with your BIOS type (blacklist a=
ll
> thinkpads with BIOS 1RET*) to a blacklist in s2ram/whatever.
>=20
> Note that this should affect a HUGE number of thinkpads, at the very least
> all of ThinkPad R50/p, R51 (1829, 1830, 1831, 1836), T40/p, T41/p, and T4=
2/p
> (all have BIOS 1RET*), which should cover a massive chunk of the thinkpads
> currently running Linux.  Apparently, it is not very common for Linux
> thinkpad users to wake it up using something other than the lid switch and
> power button :-)
>=20
> BTW, BIOS 1R was updated about one month ago, to 1RETDRWW (3.23).
>=20

I went to the first bad commit and applied the following patch manually:

diff --git a/kernel/power/main.c b/kernel/power/main.c
index ff3a618..500eb87 100644
=2D-- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -29,7 +29,7 @@
 DEFINE_MUTEX(pm_mutex);

 struct pm_ops *pm_ops;
=2Dsuspend_disk_method_t pm_disk_mode =3D PM_DISK_PLATFORM;
+suspend_disk_method_t pm_disk_mode =3D PM_DISK_SHUTDOWN;

 /**
  *     pm_set_ops - Set the global power method table.


After that the regression was solved - I was able to wake a suspended system
with <Fn> althought it was hibernated (and waked up) before.

I use the latest installed BIOS (currently 3.23/3.04) from the ThinkWiki.

Hope this helps you to track down the root cause :-)

> So, please configure the kernel/s2ram/whatever you use to suspend-to-disk=
 to
> use "shutdown" as the default mode for suspend-to-disk, and check if that
> doesn't solve things.
I use "echo -n mem > /sys/power/state" resp.and "echo -n disk > /sys/power/=
state"
within the script /etc/acpi/default.sh.

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart1986656.b6GxPS1XDe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGuHHbhyrlCH22naMRAmoXAJoDBuDHkHtvep4ZZVBB+dePTCbscgCgkq9u
PSuJy/UcG+JSQxUEV2aq1M0=
=8Wnl
-----END PGP SIGNATURE-----

--nextPart1986656.b6GxPS1XDe--
