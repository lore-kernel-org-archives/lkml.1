Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0CETam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:30:42 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:58414 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab0CETal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:30:41 -0500
From: Eric Anholt <eric@anholt.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305122129.0c99adf3@lxorguk.ukuu.org.uk>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	<alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	<20100304185002.GA23532@srcf.ucam.org>
	<alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	<20100304190450.GA23807@srcf.ucam.org> <4B900AB2.1020603@garzik.org>
	<20100305122129.0c99adf3@lxorguk.ukuu.org.uk>
Date: Fri, 05 Mar 2010 11:30:36 -0800
Message-ID: <877hpq36sj.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Fri, 5 Mar 2010 12:21:29 +0000, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Serious discussion point perhaps should be: is the libdrm so close to the
> kernel it ought to be in the same git tree ? Alternatively does it need
> to be easier to have multiple Nouveau libdrms autoselected according to
> the kernel side versioning. ELF library versioning is not rocket science
> and both the old and new libraries exist and can be installed so all the
> bits are present except for the wrapper to load the right sublibrary yes ?

That *would* make versioning impossible.

To make the difficulty of improving ABI at the moment concrete, I just
got done merging the patches for execbuf2 in userland and enabling i915
texture tiling.  This was a 3% performance win in one test I was looking
at, and 1% in another -- less than hoped, but important nonetheless
(there are other cases that should see 30% or so wins hopefully).  The
patches got written back in July, and revved several times as they broke
various combinations of compatibility.  At the point that I merged eb2
to the kernel for 2.6.33, it wasn't *really* tested -- the userland side
was broken all to hell it looked like, but at least it wasn't regressing
execbuf1 any more, right?  I spent this week getting userland working,
including a new libdrm release (already obsolete because a bug in the
libdrm violated what the ABI between libdrm <-> msea was supposed to
be).  So overall, I'd say that we spent about a month of developer time
at least between jbarnes, ickle, and myself, on extending the execbuf
interface to add a flag saying "dear kernel, please don't do this bit of
work on this buffer, because I don't need it and it makes things slow."

This is not that bad for Intel folks.  We're paid to hack on it, and can
justify spending ridiculous amounts of time for small wins.  I actually
enjoy this.

Right now all the userland -- whether it's Mesa, xf86-video-intel,
libva, cairo-drm, stand-alone DRM testcases, etc., gets to move to the
new libdrm API, declare its dependency in PKG_CHECK_MODULES, and hand
that new flag to libdrm as if the kernel supported the new interface.
Inside libdrm, it looks at the kernel version and uses the new interface
or old as appropriate.  The ugly versioning stuff stays in one
easy-to-review 5kloc component, and the complicated 50kloc driver
components get to pretend they have a fancy new kernel.

But if libdrm's in the kernel, all those userland components no longer
get to rely on the version of libdrm, because distros will ship
whatever's with the kernel they're using and our userland does have to
work on (relatively recent) distros.  Each of those userland components
would have to grow a compatibility layer to work with whatever kernel
libdrm is available, passing the flag in the new API or using the old
API.  Userland would even buggier for having to replicate all that logic
everywhere, and we probably wouldn't have execbuf2 landed yet.

Well, OK.  What I'd really do instead is make the kernel libdrm be a
thin ioctl wrapper, and build a librealdrm that does what libdrm does
today.  But I don't think that's what you were suggesting.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuRW9wACgkQHUdvYGzw6vdbkACfTimehH+nB/fHiX8DfEOjeZbm
wnIAn3XgnytNRJgxaSpcyooLTzj2LU2g
=r7AA
-----END PGP SIGNATURE-----
--=-=-=--
