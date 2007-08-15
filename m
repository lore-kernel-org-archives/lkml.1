Return-Path: <linux-kernel-owner+w=401wt.eu-S1763494AbXHONMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763494AbXHONMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbXHONMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:12:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:57449 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754604AbXHONMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:12:19 -0400
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
In-Reply-To: <20070815122253.GA15268@wotan.suse.de>
References: <20070814142103.204771292@sgi.com>
	 <20070815122253.GA15268@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F7pt2T9XU8WLW2Dzj6SJ"
Date: Wed, 15 Aug 2007 15:12:06 +0200
Message-Id: <1187183526.6114.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F7pt2T9XU8WLW2Dzj6SJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 14:22 +0200, Nick Piggin wrote:
> On Tue, Aug 14, 2007 at 07:21:03AM -0700, Christoph Lameter wrote:
> > The following patchset implements recursive reclaim. Recursive reclaim
> > is necessary if we run out of memory in the writeout patch from reclaim=
.
> >=20
> > This is f.e. important for stacked filesystems or anything that does
> > complicated processing in the writeout path.
>=20
> Filesystems (most of them) that require compilcated allocations at
> writeout time suck. That said, especially with network ones, it
> seems like making them preallocate or reserve required memory isn't
> progressing very smoothly.

Mainly because we seem to go in circles :-(

>  I think these patchsets are definitely
> worth considering as an alternative.=20

Honestly, I don't. They very much do not solve the problem, they just
displace it.

Christoph's suggestion to set min_free_kbytes to 20% is ridiculous - nor
does it solve all deadlocks :-(


> No substantial comments though.=20

Please do ponder the problem and its proposed solutions, because I'm
going crazy here.

The problem with networked swap is:

TX
 - we need some memory to initiate writeout
 - writeout needs to be throttled in order to make this bounded

  (currently sort-of done by throttle_vm_writeout() - but evginey and
   daniel phillips are working on a more generic approach)

RX
 - we basically need infinite memory to receive the network reply
   to complete writeout. Consider the following scenario:

   3 machines, A, B, C;

     A: * networked swapped
        * networked service

     B: * client for networked service

     C: * server for networked swap

   C becomes unreachable/slow for a while
   B sends massive amounts of traffic A wards
   A consumes all memory with non-critical traffic from B and wedges

 - so we need a threshold of some sorts to start tossing non-critical
   network packets away. (because the consumer of these packets may be
   the one swapping and is therefore frozen)

 - we also need to ensure memory doesn't fragment too badly during the
   receiving -> tossing phase. Otherwise we might again wedge due to OOM

and then there is an TCP specific deadlock: TCP has a global limit on
the amount of skb memory that can be in socket receive queues. Once we
hit this limit with non-critical data (because the consumers are waiting
on swap) all further packets will be tossed and we'll never receive C's
completion


<> Now my solution was to have a reserve just big enough to fit:
  - TX
  - RX (large enough to overflow the IP fragment reassembly)

that way, whenever we receive a packet and find we need the reserve
to back this packet we must only use this for critical services.
(this provides the threshold previously mentioned)

we then process the packet until socket demux (where the skb gets
associated with a sk - and can therefore determine whether it is
critical or not) and toss all packets that are non-critical. This frees
up the memory to receive the next packet, and this can continue ad
infinitum - until we finally do get C's completion and get out of the
tight spot.


<> What Christoph is proposing is doing recursive reclaim and not
initiating writeout. This will only work _IFF_ there are clean pages
about. Which in the general case need not be true (memory might be
packed with anonymous pages - consider an MPI cluster doing computation
stuff). So this gets us a workload dependant solution - which IMHO is
bad!

Also his suggestion to crank up min_free_kbytes to 20% of machine memory
is not workable (again imagine this MPI cluster loosing 20% of its
collective memory, very much out of the question).

Nor does that solve the TCP deadlock, you need some additional condition
to break that.

> I've been sick all week.

Do get well.

--=-F7pt2T9XU8WLW2Dzj6SJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGwvumXA2jU0ANEf4RAt3rAJ92VQCwJjULIMg37YYLH6xpegKW/QCdERR1
Ss3uud9b3mJrMxc7XGUaMTM=
=EkTZ
-----END PGP SIGNATURE-----

--=-F7pt2T9XU8WLW2Dzj6SJ--

