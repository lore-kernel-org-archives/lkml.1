Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYB0LJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYB0LJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYB0LJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:09:47 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:53084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYB0LJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:09:46 -0500
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after
	2.6.25-rc1 (bisected, powerpc related?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Christoph Hellwig <hch@lst.de>,
       xfs-masters@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       xfs@oss.sgi.com,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20080226114419.GA5353@soziologie.ch>
References: <20080225112310.GA5516@soziologie.ch>
	 <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de>
	 <200802260113.57875.rjw@sisk.pl>  <20080226114419.GA5353@soziologie.ch>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yI9qwftfuYKSxlwkj6lz"
Date: Tue, 26 Feb 2008 19:11:32 +0100
Message-Id: <1204049492.13162.265.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yI9qwftfuYKSxlwkj6lz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> I debuged this a bit further by testing the 4 changed functions
> individually. The problem only occurs with the new version of
> xfs_lowbit64.=20

Eh, uh, of course. Now that I look at that code it becomes obvious.

find_first_bit() works on unsigned longs, not 64-bit quantities, so
find_first_bit((unsigned long *)&t, 64) isn't equivalent to finding the
lowest bit set in a 64-bit quantity.

Think of the memory layout of a 64-bit word:

LE:	low 32 bits | high 32 bits
BE:	high 32 bits | low 32 bits

Take a look at the start of include/asm-powerpc/bitops.h, and note how
bitops don't define the memory layout at all :)

So find_first_bit(&t, 64) on BE will give you the number of the first
bit of the 32-bit rotated quantity, ie. of ((t<<32) | (t>>32)).

The problem doesn't happen with highbit64 because fls64 was specifically
coded for this purpose.

You really need to keep xfs_lowbit64 defined as it was before, or, maybe
even better, define ffs64 in parallel to fls64.

johannes

--=-yI9qwftfuYKSxlwkj6lz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8RWU6Vg1VMiehFYAQK9aBAAsTDlaL2HWlkcmHyYc0NfH7i5R8uX9nRt
i6iqjbLXc69s1+Zr9BaUD/PYqtlstzh6LNbVazlzfjUAUCMW9p+NI+zwyAPFcuyJ
Jw6KqAj8SodXqA2gIj3Sf9+3sXZ8IVrKrEXLeMR58rB8CtmZBAotXU+rRkLfQZDP
Z1LWw8SPdbTZittKsoFwmn4q0lhmGDzcIrFhve0JMT50N6WVJrDhf380tpEGmhbA
kXwnhEylR6mmCaamOpzyuT1n5CWjhnCUTAl81clmh48ZBiBc3AdCm1OXmVL4ZWqt
YyoO+56BPHhnuCf10xF7Sd2eX1Dybn5sgarO9wj6RADhNqViKh1QQRq0OMNXj/eu
c+YZ/A/4is5EUlO0JjCXGQ3vkhr9BBNfx1CTv4I3iVqkWEIc5t+bkzCZMBjGl2tl
H4Lt/JPTYqo++WNNYn0S5G62aJf543Q+x8/n4jAHEJidxhlmF1woXJgdvLKu7gKw
Akf56E5iM3QQa5iyFWzHHw6SsEtPm2doINnq7qvbZhOnJdWen5u0QAb46gnARh4F
4QtK08rOEkBzoXZW09oyWQMBRf7OvXDuABJdaUdoLEGsMWmOOJ0VD2CUOYM6G1pq
HBI8Sm/nyN7xF4LtNOwq0Hn+wkhbaPV9mfCsb2N0HAl/8xhxRyWc8M7gbmxsO96V
eHR+384uLjM=
=SfPO
-----END PGP SIGNATURE-----

--=-yI9qwftfuYKSxlwkj6lz--

