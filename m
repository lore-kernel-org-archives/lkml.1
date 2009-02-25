Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbZBYIP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbZBYIP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZBYIPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:15:49 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:41636 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZBYIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:15:48 -0500
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and
	struct_mutex.
From: Eric Anholt <eric@anholt.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Hellstrom <thomas@shipmail.org>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1235115406.4736.4.camel@laptop>
References: <1234918786-854-1-git-send-email-eric@anholt.net>
	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org>
	 <1235082372.4612.665.camel@laptop>  <1235095484.2636.39.camel@gaiman>
	 <1235115406.4736.4.camel@laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DiHVWKGvHTxbeovPvODo"
Date: Wed, 25 Feb 2009 00:15:45 -0800
Message-Id: <1235549745.5213.4.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DiHVWKGvHTxbeovPvODo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-20 at 08:36 +0100, Peter Zijlstra wrote:
> On Thu, 2009-02-19 at 18:04 -0800, Eric Anholt wrote:
> > On Thu, 2009-02-19 at 23:26 +0100, Peter Zijlstra wrote:
> > > On Thu, 2009-02-19 at 22:02 +0100, Thomas Hellstrom wrote:
> > > > =20
> > > > It looks to me like the driver preferred locking order is
> > > >=20
> > > > object_mutex (which happens to be the device global struct_mutex)
> > > >   mmap_sem
> > > >      offset_mutex.
> > > >=20
> > > > So if one could avoid using the struct_mutex for object bookkeeping=
 (A=20
> > > > separate lock) then
> > > > vm_open() and vm_close() would adhere to that locking order as well=
,=20
> > > > simply by not taking the struct_mutex at all.
> > > >=20
> > > > So only fault() remains, in which that locking order is reversed.=20
> > > > Personally I think the trylock ->reschedule->retry method with prop=
er=20
> > > > commenting is a good solution. It will be the _only_ place where lo=
cking=20
> > > > order is reversed and it is done in a deadlock-safe manner. Note th=
at=20
> > > > fault() doesn't really fail, but requests a retry from user-space w=
ith=20
> > > > rescheduling to give the process holding the struct_mutex time to=20
> > > > release it.
> > >=20
> > > It doesn't do the reschedule -- need_resched() will check if the curr=
ent
> > > task was marked to be scheduled away, furthermore yield based locking
> > > sucks chunks.
>=20
> Imagine what would happen if your faulting task was the highest RT prio
> task in the system, you'd end up with a life-lock.
>=20
> > > What's so very difficult about pulling the copy_*_user() out from und=
er
> > > the locks?
> >=20
> > That we're expecting the data movement to occur while holding device
> > state in place.  For example, we write data through the GTT most of the
> > time so we:
> >=20
> > lock struct_mutex
> > pin the object to the GTT
> > flushing caches as needed
> > copy_from_user
> > unpin object
> > unlock struct_mutex
>=20
> So you cannot drop the lock once you've pinned the dst object?
>=20
> > If I'm to pull the copy_from_user out, that means I have to:
> >=20
> > alloc temporary storage
> > for each block of temp storage size:
> > 	copy_from_user
> > 	lock struct_mutex
> > 	pin the object to the GTT
> > 	flush caches as needed
> > 	memcpy
> > 	unpin object
> > 	unlock struct_mutex
> >=20
> > At this point of introducing our third copy of the user's data in our
> > hottest path, we should probably ditch the pwrite path entirely and go
> > to user mapping of the objects for performance.  Requiring user mapping
> > (which has significant overhead) cuts the likelihood of moving from
> > user-space object caching to kernel object caching in the future, which
> > has the potential of saving steaming piles of memory.
>=20
> Or you could get_user_pages() to fault the user pages and pin them, and
> then do pagefault_disable() and use copy_from_user_inatomic or such, and
> release the pages again.

I started poking at this today, since the get_user_pages sounded like
the solution.  Only then I noticed: when we unbind an existing object,
we have to unmap_mapping_range to clear the clients' mappings to it in
the GTT, which needs to happen while the struct lock (protecting the gtt
structure and the gtt to object mappings) is held.  So for fault we have
mmap_sem held to struct mutex taken for poking at the gtt structure, and
for unbind we have struct mutex held to mmap_sem taken to clear
mappings.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-DiHVWKGvHTxbeovPvODo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmk/i4ACgkQHUdvYGzw6vdEowCfY+RiKhv7D6ZifacSzcJoSloD
hngAnjP6VZRvvKAjc6+G99w5Fd0tyXPv
=tAwT
-----END PGP SIGNATURE-----

--=-DiHVWKGvHTxbeovPvODo--
