Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYHDK0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYHDK0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYHDK0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:26:47 -0400
Received: from home.keithp.com ([63.227.221.253]:3078 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYHDK0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:26:46 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200808041902.23970.nickpiggin@yahoo.com.au>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
	 <1217814896.23437.420.camel@koto.keithp.com>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tn/N63ZRgtou1S6coe0f"
Date: Mon, 04 Aug 2008 03:26:30 -0700
Message-Id: <1217845590.24714.45.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tn/N63ZRgtou1S6coe0f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:

> This is how I'd suggested it work as well. I think a little bit
> more effort should be spent looking at making this work.

What I may be able to do is create a file, then hand it to my driver and
close the fd. That would avoid any ulimit or low-fd issues.

> Mapping the file into an address space might be a way to make it
> work (using get_user_pages to get the struct page). splice might
> also work. read_mapping_page or similar could also be something to
> look at. But using shmem_getpage seems wrong because it circumvents
> the vfs API.

It seems fairly ugly to map the object to user space just to get page
pointers; the expense of constructing that mapping will be entirely
wasted most of the time.

Would it be imprudent to use pagecache_write_begin/pagecache_write_end
here? For shmem, that appears to point at functions which will do what I
need. Of course, it will cause extra page-outs as each page will be
marked dirty, even if the GPU never writes them.=20

While shmem offers good semantics for graphics objects, it doesn't seem
like it is unique in any way, and it seems like it should be possible to
do this operation on any file system.

> If you genuinely have problems that can't be fit into existing
> APIs without significant modification, and that is specific just to
> your app, then we could always look at making special cases for you.
> But it would be nice if we generically solve problems you have with
> processes manipulating thousands of files.

There are some unique aspects to this operation which don't really have
parallels in other environments.

I'm doing memory management for a co-processor which uses the same pages
as the CPU. So, I need to allocate many pages that are just handed to
the GPU and never used by the CPU at all. Most rendering buffers are of
this form -- if you ever need to access them from the CPU, you've done
something terribly wrong.

Then there are textures which are constructed by the CPU (usually) and
handed over to the GPU for the entire lifetime of the application. These
are numerous enough that we need to be able to page them to disk; the
kernel driver will fault them back in when the GPU needs them again.

On the other hand, there are command and vertex buffers which are
constructed in user space and passed to the GPU for execution. These
operate just like any bulk-data transfer, and, in fact, I'm using the
pwrite API to transmit this data. For these buffers, the entire key is
to make sure you respect the various caches to keep them from getting
trashed.

--=20
keith.packard@intel.com

--=-tn/N63ZRgtou1S6coe0f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIltlKQp8BWwlsTdMRAkvEAJ4+2EuymTuAufKKfCB/wIbVzueFHACfXtmr
JrWFTcwSKroKR/w9P4l+/Rw=
=8CMB
-----END PGP SIGNATURE-----

--=-tn/N63ZRgtou1S6coe0f--

