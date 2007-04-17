Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbXDQCnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbXDQCnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXDQCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:43:18 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36817 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbXDQCnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=MFhNXaow9NMh1hqmqMvEYUjuhnnkUIaTZAhefVK6q+y08jadO576++QBqyDAxcsbkCzIEmYw9fWkOrtpGNlcN4CBcABVJfbkUgSU558285Yj+g1d2SPMgKtbVB3IK9U7goYGnRMqufmAzY17c0JLMSvCux62SDOzrq2gCMDvQtA=
Date: Mon, 16 Apr 2007 19:43:03 -0700
From: Mike Mattie <codermattie@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.21-rc7 hpt366 driver broken
Message-ID: <20070416194303.58545412@reforged>
In-Reply-To: <20070416182112.4fcbb87f@reforged>
References: <20070415224846.52a465b6@reforged>
	<20070416043822.0ea2490e@reforged>
	<20070416143613.GD10338@stusta.de>
	<20070416182112.4fcbb87f@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_yz5FbF.F9xdDKHYmqRLL_EN;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_yz5FbF.F9xdDKHYmqRLL_EN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2007 18:21:12 -0700
Mike Mattie <codermattie@gmail.com> wrote:

> On Mon, 16 Apr 2007 16:36:13 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
>=20
> > [ Cc's added, full bug report was in
> > http://lkml.org/lkml/2007/4/16/18 ]
> >=20
> > On Mon, Apr 16, 2007 at 04:38:22AM -0700, Mike Mattie wrote:
> > > On Sun, 15 Apr 2007 22:48:46 -0700
> > > Mike Mattie <codermattie@gmail.com> wrote:
> > >=20
> > > > Hello,
> > > >=20
> > > > I am testing the 2.6.21-rc7 kernel release. The IDE hpt366
> > > > driver is crashing hanging the boot. I have basically the same
> > > > config as 2.6.20.7 which works fine (except for netconsole
> > > > mentioned in a previous mail).
> > > >=20
> > > > here is the hand-copied info:
> > > >=20
> > > > * "unable to handle paging request" , null deref
> > > > * EIP @ init_chipset_hpt366
> > > >=20
> > >=20
> > > > I am running a git-bisect to see if I can resolve it to a
> > > > commit.
> > >=20
> > > This was identified as the first broken commit:
> > >=20
> > > commit 7b73ee05d0acb926923d43d78b61add776ea4bb1
> > > Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > > Date:   Wed Feb 7 18:18:16 2007 +0100
> > >=20
> > >     hpt366: init code rewrite
> > >=20
> > > Reverting is conflicted so it will be a bit longer before I
> > > pin-point any other build-breaks.
> >=20
> > Thanks for your report.
> >=20
> > Can you use a digital camera for taking a photograph of the crash?
>=20
> I can later on tonight, by about 11PM west coast. I also saw
> some hex offsets after the function pointed to by EIP, is there
> a way to decode that to a line number ? I have debugging symbols
> enabled.
>=20
> I am also doing printk breadcrumbs to pin it down to a block
> or a line.

I have narrowed the crash with breadcrumbs down to these lines:


	/*
	 * Only try the DPLL if we don't have a table for the PCI clock that
	 * we are running at for HPT370/A, always use it  for anything newer...
	 *
	 * NOTE: Using the internal DPLL results in slow reads on 33 MHz PCI.
	 * We also  don't like using  the DPLL because this causes glitches
	 * on PRST-/SRST- when the state engine gets reset...
	 */
	if (info->chip_type >=3D HPT374 || info->settings[clock] =3D=3D NULL) {
		u16 f_low, delta =3D pci_clk < 50 ? 2 : 4;
		int adjust;

		printk(KERN_INFO "inside the if\n");

		 /*
		  * Select 66 MHz DPLL clock only if UltraATA/133 mode is
		  * supported/enabled, use 50 MHz DPLL clock otherwise...
		  */
		if (info->max_mode =3D=3D 0x04) {
			dpll_clk =3D 66;
			clock =3D ATA_CLOCK_66MHZ;
		} else if (dpll_clk) {	/* HPT36x chips don't have DPLL */
			dpll_clk =3D 50;
			clock =3D ATA_CLOCK_50MHZ;
		}

		if (info->settings[clock] =3D=3D NULL) {
			printk(KERN_ERR "%s: unknown bus timing!\n", name);
			kfree(info);
			return -EIO;
		}

		printk(KERN_INFO "select DPLL clock\n");

This is right around 1171 , (skewed by the crumbs I added). The last
message I receive is "inside if" , it dies before "select DPLL clock".

Without knowing much about the structs I am not sure what to print-out.
I will narrow it further, and maybe even compare against what the old
working kernel had for variable values. That would take some time though.

>=20
> > cu
> > Adrian
> >=20
> > --
> >=20
> >        "Is there not promise of rain?" Ling Tan asked suddenly out
> >         of the darkness. There had been need of rain for many days.
> >        "Only a promise," Lao Er said.
> >                                        Pearl S. Buck - Dragon Seed
> >=20

--Sig_yz5FbF.F9xdDKHYmqRLL_EN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJDRAdfRchrkBInkRAhJSAJ0ZbTEr0Oq66zoa2UYm/ZAqXAlS6wCgkEQ7
dbBKwqG1euN6f/ubztG1O30=
=TQXk
-----END PGP SIGNATURE-----

--Sig_yz5FbF.F9xdDKHYmqRLL_EN--
