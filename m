Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbXDCQ1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbXDCQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933590AbXDCQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:27:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbXDCQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:27:10 -0400
Message-ID: <46128051.9000609@redhat.com>
Date: Tue, 03 Apr 2007 09:26:57 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Jakub Jelinek <jakub@redhat.com>
Subject: missing madvise functionality
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA2E03E4CA2B42D8222962AD9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA2E03E4CA2B42D8222962AD9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

People might remember the thread about mysql not scaling and pointing
the finger quite happily at glibc.  Well, the situation is not like that.=


The problem is glibc has to work around kernel limitations.  If the
malloc implementation detects that a large chunk of previously allocated
memory is now free and unused it wants to return the memory to the
system.  What we currently have to do is this:

  to free:      mmap(PROT_NONE) over the area
  to reuse:     mprotect(PROT_READ|PROT_WRITE)

Yep, that's expensive, both operations need to get locks preventing
other threads from doing the same.

Some people were quick to suggest that we simply avoid the freeing in
many situations (that's what the patch submitted by Yanmin Zhang
basically does).  That's no solution.  One of the very good properties
of the current allocator is that it does not use much memory.

A solution for this problem is a madvise() operation with the following
property:

  - the content of the address range can be discarded

  - if an access to a page in the range happens in the future it must
    succeed.  The old page content can be provided or a new, empty page
    can be provided

That's it.  The current MADV_DONTNEED doesn't cut it because it zaps the
pages, causing *all* future reuses to create page faults.  This is what
I guess happens in the mysql test case where the pages where unused and
freed but then almost immediately reused.  The page faults erased all
the benefits of using one mprotect() call vs a pair of mmap()/mprotect()
calls.

So, if all those who were so interested in that micro benchmark could
now please direct their attention to a good madvise solution I'd be much
obliged.  It'll be put to good use right away and it should be quite
easy to provide a glibc patch to test the new kernel code.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigA2E03E4CA2B42D8222962AD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEoBR2ijCOnn/RHQRAgHIAKCROfNBeNk9mFPc5qnqHnHqfWwlfwCfT5/h
4ob2rFz/8XmRbJcb1PxXbKw=
=Mumr
-----END PGP SIGNATURE-----

--------------enigA2E03E4CA2B42D8222962AD9--
