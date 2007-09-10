Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXIJT4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXIJT4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXIJTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:55:54 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55659 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755564AbXIJTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:55:53 -0400
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0709101220001.24735@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>
	 <200709050220.53801.phillips@phunq.net>
	 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
	 <200709050916.04477.phillips@phunq.net>
	 <Pine.LNX.4.64.0709101220001.24735@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KcKGPNb8Im/xV24HK7cc"
Date: Mon, 10 Sep 2007 21:55:45 +0200
Message-Id: <1189454145.21778.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KcKGPNb8Im/xV24HK7cc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 12:25 -0700, Christoph Lameter wrote:

> Of course boundless allocations from interrupt / reclaim context will=20
> ultimately crash the system. To fix that you need to stop the networking=20
> layer from performing these.

Trouble is, I don't only need a network layer to not endlessly consume
memory, I need it to 'fully' function so that we can receive the
writeout completion.

Let us define a strict meaning for a few phrases:

 use memory - an alloc / free cycle where the free is unconditional
 consume memory - an alloc / free cycle where the free is conditional
and or might be delayed for some unspecified time.

Currently networking has two states:

  1) it receives packets and consumes memory
  2) it doesn't receive any packets and doesn't use any memory.

In order to use swap over network you need to operate the network stack
in a bounded memory model (PF_MEMALLOC). So we need a state that:

  - receives packets
  - does NOT consume memory
  - but does use memory - albeit limited.

There are two ways to do this:

  - reserve a specified amount of memory per socket
    (allegedly IRIX has this)

or

  - have a global reserve and selectively serves sockets
    (what I've been doing)

These two models can be seen as the same. There is no fundamental
difference between having various small reserves and one larger that is
carved up using strict accounting.

So, if you will, you can view my approach as a reserve per socket, where
most sockets get a reserve of 0 and a few (those serving the VM) !0.

What part are you disagreeing with or unclear on?

--=-KcKGPNb8Im/xV24HK7cc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG5aFBXA2jU0ANEf4RArm7AJ40Vp4cj7gm1cnhm0xDBD9LRFxaHwCcCGqE
FbXnb3M3tui6xv8ucWjFzaQ=
=2nRa
-----END PGP SIGNATURE-----

--=-KcKGPNb8Im/xV24HK7cc--

