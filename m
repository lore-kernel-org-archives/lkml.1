Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbXCAIsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbXCAIsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXCAIsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:48:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35172 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147AbXCAIsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:48:50 -0500
Date: Thu, 1 Mar 2007 19:48:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tony@bakeyournoodle.com (Tony Breeds),
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix soft lockup with iSeries viocd driver
Message-Id: <20070301194848.29aa5884.sfr@canb.auug.org.au>
In-Reply-To: <20070301003748.5a571916.akpm@linux-foundation.org>
References: <20070301035640.GS4575@bakeyournoodle.com>
	<20070301003748.5a571916.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Mar_2007_19_48_48_+1100_kXit/s80BPD2lNhs"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2007_19_48_48_+1100_kXit/s80BPD2lNhs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 1 Mar 2007 00:37:48 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 1 Mar 2007 14:56:40 +1100 tony@bakeyournoodle.com (Tony Breeds) wrote:
>
> > From: Tony Breeds <tony@bakeyournoodle.com>
> >
> > Fix soft lockup with iSeries viocd driver, caused by eventually calling
> > end_that_request_first() with nr_bytes 0.
> >
> > The lockup is triggered by hald, interrogating the device.
> >
>
> What causes the lockup, and how does this patch fix it?

Some versions of hald do an SG_IO ioctl on the viocd device which becomes
a request with hard_nr_sectors and hard_cur_sectors set to zero.  Passing
zero as the number of sectors to end_request() (which calls
end_that_request_first()) causes an infinite loop when the bio is being
freed.  This patch makes sure that the zero is never passed. It only
requires some number larger the the request size the terminate the loop.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Mar_2007_19_48_48_+1100_kXit/s80BPD2lNhs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF5pN1FdBgD/zoJvwRArjCAJ9GvrM+Pl+s5JLE2LAE6RD+fsHQwwCdEwkh
yRT0XKCk1BuQCuizCZtolrs=
=vXgg
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2007_19_48_48_+1100_kXit/s80BPD2lNhs--
