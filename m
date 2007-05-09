Return-Path: <linux-kernel-owner+w=401wt.eu-S969961AbXEIC0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969961AbXEIC0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935347AbXEIC0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:26:05 -0400
Received: from bulldog.cs.binghamton.edu ([128.226.118.10]:39062 "EHLO
	bulldog.cs.binghamton.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935247AbXEIC0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:26:03 -0400
X-Greylist: delayed 2941 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 22:26:03 EDT
Message-ID: <464125BC.109@cs.binghamton.edu>
Date: Tue, 08 May 2007 21:37:00 -0400
From: "Michael R. Hines" <mhines@cs.binghamton.edu>
Reply-To: mhines@cs.binghamton.edu
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mhines@cs.binghamton.edu
Subject: random AIO reads (do_generic_mapping_read)
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig891CB62675E7FE352899FA39"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig891CB62675E7FE352899FA39
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Howdy (please CC replies directly),

I have a very specific question regarding the behavior of
do_generic_mapping_read().

Here's my 2.6.20 setup: I have a stable block device driver that has
random-access style latencies (around 80 microseconds. zero seek-time).

=46rom userland: I have a simple AIO io_submit/io_suspend
program that repeatedly fires off *hundreds random AIO reads*

Here's what I would like to happen:

Since my driver does not seek (i.e. I/O not helped by mm/readahead.c)
I would like my AIOs to be *overlapped* when sent to my driver.
Currently, do_generic_mapping_read() will block on every read,
one-by-one. Instead I want the bio's to be fired off to my driver as
fast as possible without calling lock_page(). Rather the read should
return and allow io_submit_one to fire off more reads without waiting
for the userspace-copy - it would instead happen later in the future.

Furthermore: I *do not* want to avoid the page cache (which temporarily
solves the problem). I still want the support of the page-cache, I just
instead need those I/Os to not block or sleep while waiting for a single
I/O to complete.

Obviously if this were a disk, such a requirement would be very stupid
(and useless). But without it, my low-latency driver is under-utilized.

Is this possible right now?

--=20
/**************************************/
Michael R. Hines
Grad Student, SUNY Binghamton
http://www.cs.binghamton.edu/~mhines
/ *************************************/


--------------enig891CB62675E7FE352899FA39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQSW85CdHxppqAIYRAkUxAKCIqdpSmxcVVMxQrEjmc4El0/tUAwCeMk6D
hOZVCm+7m1foaqNZFAenXfM=
=5+xR
-----END PGP SIGNATURE-----

--------------enig891CB62675E7FE352899FA39--
