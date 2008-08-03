Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYHCRwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYHCRwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHCRwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:52:30 -0400
Received: from home.keithp.com ([63.227.221.253]:1865 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYHCRwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:52:30 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: John Stoffel <john@stoffel.org>
Cc: keithp@keithp.com, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <18581.43362.460694.60862@stoffel.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
	 <1217631718.23437.290.camel@koto.keithp.com>
	 <18581.43362.460694.60862@stoffel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VIOzSuaqLMN3hfg7+KAl"
Date: Sun, 03 Aug 2008 10:52:23 -0700
Message-Id: <1217785943.23437.330.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VIOzSuaqLMN3hfg7+KAl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 08:49 -0400, John Stoffel wrote:

> Why?  If you need thousands of files, won't the overhead of managing
> them dynamically start to be a big load as well? =20

We're not having any trouble with upwards of 40000 shmem file objects at
this point. Most of these are around 4 pages in size, although they
range up to around 16MB. A typical 3D game will use around 100MB or so
of this kind of data at one time.

> I assume (sorry for not looking at the code in depth) that you're
> trying to setup specific regions of memory with various attributes for
> the DRI/DRM/GEM/TTF access to Video cards? =20

Not really; these are objects used in the rendering process, vertices,
command buffers, constant buffers, textures, programs, rendering
surfaces and various other state buffers.  Lots of these are write-once
(from the CPU) and read-many (from the GPU), like textures, programs and
vertices. Some of these are effectively streamed from the CPU to the
GPU.

Each sequence of rendering commands requires that a set of these objects
be pinned to physical memory and bound to the graphics translation table
within the GPU.

Oh, and I allocate enough that I need to make them pageable as well;
under memory pressure, I can pull objects back out of the GTT binding
table and unpin the pages, letting shmem write them to disk.

> Just seeing your statement that you wanted to add ioctls made me
> shudder and try to visuallize a better way to do this. =20

I could use fds if the kernel supported applications needing many
thousand of them, and also some way to keep these FDs from polluting the
fd space used by select(2) (yeah, I know, don't use select).

> I realize you're trying to make the drivers generic so that the *BSD
> port is simple too, but... thousands of files (per X server?  per
> xclient) just seems like the wrong level.

I'm not worried about BSD; I want to build the right API for Linux at
this point.

And, yes, thousands of objects per 3D application. Each X pixmap will
end up in one of these objects as well, and so something like Firefox
will likely allocate several hundred. To keep the rendering engine busy,
we'll have a couple hundred command buffers allocated as well, of 16KB
apiece.

> Maybe you just need to open the *entire* card with one FD and then
> have your own VFS like abstraction in there, which doesn't require
> lots of filehandles? =20

That's what I'm doing at present; the card is opened with a single fd
and then these shmem objects are allocated within an ioctl from there.
What I don't want to do is use a single linear address space for these
objects; it's just useless overhead.

> Dunno... just trying to figure out what you're try to mediate here
> with ioctl() and how it could be improved/simplified.

Suggestions welcome; I just need a few thousand multi-page allocations,
which the kernel deals with quite easily these days.

--=20
keith.packard@intel.com

--=-VIOzSuaqLMN3hfg7+KAl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIlfBXQp8BWwlsTdMRAj/hAJ9aDQouA4TPNpdraH9pjOFCB/LtdACgrfGw
RzjYBGERNAAXHkFIKHXsOiU=
=ZQ+1
-----END PGP SIGNATURE-----

--=-VIOzSuaqLMN3hfg7+KAl--

