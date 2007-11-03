Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXKCSxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXKCSxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXKCSxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:53:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34512 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbXKCSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:53:08 -0400
Date: Sat, 3 Nov 2007 18:52:10 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2094416386-1194115930=:13845"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2094416386-1194115930=:13845
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 3 Nov 2007, Hugh Dickins wrote:
> On Sat, 3 Nov 2007, Oliv=C3=A9r Pint=C3=A9r wrote:
> > Q: It's needed auch to 2.6.22-stable?
>=20
> I guess so: though SLUB wasn't on by default in 2.6.22; and it being
> only a slow leak rather than a corruption, I was less inclined to
> agitate about it for releases further back.
>=20
> But your question makes me realize I never even looked at 2.6.23 or
> 2.6.22 hereabouts, just assumed they were the same; let alone patch
> or build or test them.  The patches reject as such because quite a
> lot has changed around (there was no struct kmem_cache_cpu in either).
>=20
> A hurried look suggests that the leakage problem was there in both,
> but let's wait to hear Christoph's expert opinion.

Okay, here's a version for 2.6.23 and 2.6.22...
Christoph, you've now Acked the 2.6.24 one, thanks:
do you agree this patch below should go to -stable?


Slub has been quite leaky under load.  Taking mm_struct as an example, in
a loop of swapping kernel builds, after the first iteration slabinfo shows:
Name        Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
mm_struct        55     840    73.7K         18/7/4    4 0  38  62 A
but Objects and Partials steadily creep up - after the 340th iteration:
mm_struct       110     840   188.4K        46/36/4    4 0  78  49 A
(example taken from 2.6.24-rc1: YMMV).

The culprit turns out to be __slab_alloc(), where it copes with the race
that another task has assigned the cpu slab while we were allocating one.
Don't rush off to load_freelist there: that assumes page->lockless_freelist
is empty, and will lose all its free slots when page->freelist is not empty=
=2E
Instead just do a local allocation from lockless_freelist when it has one.

Which fixes the leakage: Objects and Partials then remain stable.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Version of patch suitable and recommended for both 2.6.23-stable and
2.6.22-stable.  I've not run tests on either to observe the mounting
leakage; but a version of the patch below with a printk announcing
when non-empty freelist would overwrite non-empty lockless_freelist
does indeed show up in both (though notably less frequently than in
2.6.24-rc1 - something else seems to be making it more likely now).
But please wait for Christoph's Ack before committing to -stable.

 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- 2.6.23/mm/slub.c=092007-10-09 21:31:38.000000000 +0100
+++ linux/mm/slub.c=092007-11-03 18:23:07.000000000 +0000
@@ -1517,6 +1517,12 @@ new_slab:
 =09=09=09=09 */
 =09=09=09=09discard_slab(s, page);
 =09=09=09=09page =3D s->cpu_slab[cpu];
+=09=09=09=09if (page->lockless_freelist) {
+=09=09=09=09=09object =3D page->lockless_freelist;
+=09=09=09=09=09page->lockless_freelist =3D
+=09=09=09=09=09=09=09object[page->offset];
+=09=09=09=09=09return object;
+=09=09=09=09}
 =09=09=09=09slab_lock(page);
 =09=09=09=09goto load_freelist;
 =09=09=09}
--8323584-2094416386-1194115930=:13845--
