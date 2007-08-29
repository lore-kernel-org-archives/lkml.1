Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbXH2H5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbXH2H5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 03:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXH2H5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 03:57:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:14530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbXH2H5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 03:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,320,1183359600"; 
   d="asc'?scan'208";a="122833965"
Subject: Re: CFS review
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070829044614.GA13225@elte.hu>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
	 <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu>
	 <1188361749.21502.123.camel@koto.keithp.com>
	 <20070829044614.GA13225@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o5bqmlLkTFq5jqtB4uB0"
Organization: Intel Corp
Date: Wed, 29 Aug 2007 00:57:29 -0700
Message-Id: <1188374249.21502.155.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o5bqmlLkTFq5jqtB4uB0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 06:46 +0200, Ingo Molnar wrote:

> ok, i finally managed to reproduce the "artifact" myself on an older=20
> box. It goes like this: start up X with the vesa driver (or with NoDRI)=20
> to force software rendering. Then start up a couple of glxgears=20
> instances. Those glxgears instances update in a very "chunky",=20
> "stuttering" way - each glxgears instance runs/stops/runs/stops at a=20
> rate of a about once per second, and this was reported to me as a=20
> potential CPU scheduler regression.

Hmm. I can't even run two copies of glxgears on software GL code today;
it's broken in every X server I have available. Someone broke it a while
ago, but no-one noticed. However, this shouldn't be GLX related as the
software rasterizer is no different from any other rendering code.

Testing with my smart-scheduler case (many copies of 'plaid') shows that
at least with git master, things are working as designed. When GLX is
working again, I'll try that as well.

> at a quick glance this is not a CPU scheduler thing: X uses up 99% of=20
> CPU time, all the glxgears tasks (i needed 8 parallel instances to see=20
> the stallings) are using up the remaining 1% of CPU time. The ordering=20
> of the requests from the glxgears tasks is X's choice - and for a=20
> pathological overload situation like this we cannot blame X at all for=20
> not producing a completely smooth output. (although Xorg could perhaps=20
> try to schedule such requests more smoothly, in a more finegrained way?)

It does. It should switch between clients ever 20ms; that's why X spends
so much time asking the kernel for the current time.

Make sure the X server isn't running with the smart scheduler disabled;
that will cause precisely the symptoms you're seeing here. In the normal
usptream sources, you'd have to use '-dumbSched' as an X server command
line option.

The old 'scheduler' would run an entire X client's input buffer dry
before looking for requests from another client. Because glxgears
requests are small but time consuming, this can cause very long delays
between client switching.

--=20
keith.packard@intel.com

--=-o5bqmlLkTFq5jqtB4uB0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG1SbpQp8BWwlsTdMRAqc1AKC1PWggG18JqEaSv/vz/gxDi6ZCRQCfUmJ0
wdGs21J6NEU8vX8PVeVPhFo=
=YIPP
-----END PGP SIGNATURE-----

--=-o5bqmlLkTFq5jqtB4uB0--
