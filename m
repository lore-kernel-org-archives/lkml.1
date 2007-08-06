Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXHFTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXHFTN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763295AbXHFTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:13:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:53024 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752358AbXHFTNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:13:48 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19eO7FBUT9eeyZymWMXw7RKRNxxTdFeU+HsbTyYdz
	2QzKzJNvs7BBEo
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Mon, 6 Aug 2007 21:13:41 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200708051902.18801.toralf.foerster@gmx.de> <200708061136.50491.toralf.foerster@gmx.de> <20070806143631.GB31615@khazad-dum.debian.net>
In-Reply-To: <20070806143631.GB31615@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5656070.jWnsEK9rJc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708062113.44511.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5656070.jWnsEK9rJc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 6. August 2007 16:36 schrieb Henrique de Moraes Holschuh:
> On Mon, 06 Aug 2007, Toralf F=F6rster wrote:
> > Am Montag, 6. August 2007 00:29 schrieb Pavel Machek:
> > > Yes, I seen similar reports. Does it happen in all shutdown mode and
> > > 2.6.22? Does it happen   in platform mode in 2.6.19?
> >=20
> > I can reproduce this behaviour by doing the following with kernel 2.6.2=
0 :
> >=20
> > 1. <Fn>+<F4>   - the systems sleeps within RAM
> > 2. <Fn>             - the systems wakes up
> > 3. <Fn>+<F12> - the systems hibernates to disk
> > 4. <power>       - systems wakes up
> > 5. <Fn>+<F4>   - the systems sleeps within RAM
> >=20
> > Now pressing <Fn> doesn't wake up the system, I have to press the power=
 button
> > for that instead.
>=20
> The resume path for suspend to disk is very different (for the firmware, =
at
> least) than the resume path from sleep-to-RAM.  One of them goes through a
> system shutdown and cold boot (S5) or whatever-boot (S4 - who knows if it=
 is
> the same as a cold boot in a given thinkpad model? It doesn't have to be!=
).
>=20
> The firmware *knows* when you press Fn+F4/FN+F12, and recalls that. That's
> why you can't get multiple hot key presses from pressing Fn+F4 or FN+F12
> until you actually do an ACPI wake-up.
>=20
> While you are just doing S3, all that state is preserved without fuss. But
> S5 does not preserve anything, and S4 is anyone's guess.  Numerous thinkp=
ad
> BIOS fixes in the past were releated to such problems, so if you are not
> using the latest BIOS for your model, your first duty is to upgrade it and
> try again.
>=20
> IMHO, probably some ACPI state is being lost by the BIOS because of the
> sleep-to-disk.  I don't know how sleep-to-disk plays with the ACPI NV are=
as,
> and ACPI data areas from the BIOS, so I can't help much there.
>=20
> And, mind you, I am *not* sure one is supposed to be able to wake up
> thinkpads using Fn.  It might be in fact a bug that we can do it.  One has
> to at the very least verify whether it happens in Windows as well.
>=20
> However, the following events *are* to wake a thinkpad up from S3:
> 	1. ACPI wake devices
> 	2. Dock or bay eject buttons/lever being actuated
> 	3. Brief press on power button
>=20
> You can check if (2) is still working. If both Fn and (2) stop working, we
> can be sure we have a bug in Linux.  (2) is useful because it is reported
> inside the ACPI firmware mostly through the same codepaths.
>=20
> > BTW I tried to test the latest git-sources -rc2 but the <Fn> keys do no=
t work
> > anymore with the thinkpad-acpi feature (neither as module nor if compil=
ed into).
>=20
> Don't enable the input layer by default in thinkpad-acpi Kconfig.  A patch
> to change that to default to N has already been sent to Len Brown, but it
> has not been merged yet.
>=20

Because I
(1) use the latest BIOS and
(2) I'm able to wake up a suspended system via <Fn> under Windows XP (yes, =
dual
    boot system I need it at work) regardless whether I previously hibernat=
ed
    the system (under Windows XP) or not

I bisected this regression (rather of a feature than a bug, or ?) between
the 2 tags v2.6.19 and v2.6.20 (~2400 commits, I read a good book in the
meanwhile) and found :

last good commit : 7e244322cd4ea361ef9ee623b3fcb4d9f4ff841c
first bad commit: cfee47f99bc14a6d7c6b0be2284db2cef310a815

I double checked these 2 commits - here's the first commit after which <Fn>
doesn't wake up my system from suspend state after it was (at least one time
before) hibernated:

commit cfee47f99bc14a6d7c6b0be2284db2cef310a815
Merge: 7e24432... 9185cfa...
Author: Len Brown <len.brown@intel.com>
Date:   Sat Dec 16 01:01:18 2006 -0500

    Pull bugfix into test branch

    Conflicts:

        kernel/power/disk.c


=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart5656070.jWnsEK9rJc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGt3LlhyrlCH22naMRAomXAKCxcYSBJ/kgdkSsgnuPMeifDQHsjwCfc2+A
/j3K7i+CWeHptDGxodvx1RE=
=NV3x
-----END PGP SIGNATURE-----

--nextPart5656070.jWnsEK9rJc--
