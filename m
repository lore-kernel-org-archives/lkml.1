Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYLBRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYLBRLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYLBRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:11:22 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:45712 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYLBRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:11:21 -0500
Date: Tue, 2 Dec 2008 12:11:11 -0500
From: "Michael B. Trausch" <mike@trausch.us>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-kernel@vger.kernel.org, pazke@ports.donpac.ru, ariveira@gmail.com
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202121111.245d2ecc@zest.spicerack.trausch.us>
In-Reply-To: <fa.98CeSgxJ/GGaLLyZ97s1oHgh7hE@ifi.uio.no>
References: <fa.IDjfwzrT2B02+NHfmYwtICnzOOA@ifi.uio.no>
	<fa.J8MFTCUT8El3sK8BuYDBvaMRaB8@ifi.uio.no>
	<fa.q/4H3AtoJGSJ+i8tlXR4X35LFFU@ifi.uio.no>
	<fa.98CeSgxJ/GGaLLyZ97s1oHgh7hE@ifi.uio.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jk/e43PCwyAMCI.acLZYGdW";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jk/e43PCwyAMCI.acLZYGdW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 15:30:35 UTC
Alistair John Strachan <alistair@devzero.co.uk> wrote:
> One thing I would point out is that your distro kernel (presumably
> 2.6.27 or older) would probably have had the NVIDIA module to hand
> and would not drop into safe mode, right? In this case, VT switching
> behaviour may be entirely different.

Ubuntu 8.10 comes with a 2.6.27 kernel as packaged by Ubuntu.

> Could you please find out what framebuffer driver your distro is
> loading (probably nvidiafb, I'd guess) before starting X, and what
> Xorg driver Ubuntu use in this "safe graphics mode" (nv, vesa)? Also,
> could you try removing the nvidia module in the older kernel and
> confirm that the same VT corruption does not occur, so Rafael can
> identify this as a regression?

The stock Ubuntu install includes vesafb support, but Alejandro's dmesg
doesn't indicate that he's using vesafb at all.  The NVIDIA kernel
module refuses to work with the nvidiafb driver (claiming a conflict)
so if the NVIDIA module loads, nvidiafb isn't present.  (In fact, the
NVIDIA kernel module linkage will refuse to build against a kernel that
was even configured for nvidiafb).

I'm using 2.6.28-rc7 successfully on Ubuntu with the NVIDIA kernel
module as packaged by Ubuntu (Ubuntu 8.10 uses DKMS to manage the
module).  A single change to the linkage's C code was necessary, and
it is also necessary to either instruct the linkage where to find
relocated kernel headers or to create some symlinks:

 $ cd /lib/modules/2.6.28-rc7/source/include/asm-x86
 $ ln -s ../../arch/x86/include/asm/* .

(This may be different for a 32-bit configuration; mine is a 64-bit
x86-64 kernel.  I don't think it is different, though.)  I have it
working both using the standard 80x25 VGA console and with the vesafb
driver providing a significantly larger console.

> (Maybe things have changed over the years, but my understanding was
> that for the majority of Xorg drivers, mode setting was still done by
> the Xorg driver, not the kernel, and the X server is responsible for
> restoring the VT correctly, not the kernel's framebuffer driver. So
> this may possibly not be a kernel bug at all.)

NVIDIA still does mode setting in X.org, by default detecting the
native resolution of the attached monitor and using that.

This doesn't affect the VGA console... however, I have run into
NVIDIA-based graphics boards that don't like mode changes very much.
Some of the really finicky cards require using vesafb in the kernel and
then telling X.org to use the kernel-provided framebuffer to get it to
work correctly.

Also, the VESA X.org driver doesn't play nicely with all NVIDIA
boards; this might explain why the system didn't switch cleanly to a VT
after starting in "safe mode" --- which is Ubuntu's way of saying,
"640x480 using the vesa X.org driver".

Alejandro, can you switch back to VTs again after rebuilding your
NVIDIA module?  Also, you seem to have mentioned that you're not using
Ubuntu's packaged NVIDIA driver... this may mean that you've
overwritten and/or moved other files that Ubuntu uses, since the NVIDIA
driver installer does this automatically.  Can you try using a stock
system, updated kernel, and let DKMS build the NVIDIA module?  You'll
need to make some alterations, but I can help with those.

	HTH,
	Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/jk/e43PCwyAMCI.acLZYGdW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1bC8ACgkQ0kE/IBnFmjDTzQCfcdxOImQcHxoKI2qo94xwBrxX
tDUAnA8RjEGsymwt/nSSL48pKPHq/niS
=PJap
-----END PGP SIGNATURE-----

--Sig_/jk/e43PCwyAMCI.acLZYGdW--
