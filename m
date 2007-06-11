Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXFKRwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXFKRwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXFKRwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:52:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34524 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503AbXFKRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:52:32 -0400
Date: Mon, 11 Jun 2007 10:52:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com> 
 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com> 
 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1534404380-1181584352=:17264"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1534404380-1181584352=:17264
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jun 2007, H=E5vard Skinnemoen wrote:

> On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> > Ahhh... I see its the same phenomenon as before but triggered by
> > a different cause.
> >=20
> > If you set the align to 32 then the first kmalloc slabs of size
> >=20
> > 8
> > 16
> > 32
> >=20
> > are all of the same size which leads to duplicate files in sysfs.
>=20
> Yes, that seems to be the problem.
>=20
> > Does this patch fix it?
>=20
> Unfortunately, no. But I get a different error message; see below...

Hmmmm.. Yeah slabs with different user object sizes may coexist.

Argh!

Ok. Drop the patch and use this one instead. This one avoids the use
of smaller slabs that cause the conflict. The first slab will be sized 32
bytes instead of 8.

Note that I do not get why you would be aligning the objects to 32 bytes.=
=20
Increasing the smallest cache size wastes a lot of memory. And it is=20
usually advantageous if multiple related objects are in the same cacheline=
=20
unless you have heavy SMP contention.

---
 include/linux/slub_def.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/slub_def.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/slub_def.h=092007-06-11 10:50:09.000000000=
 -0700
+++ linux-2.6/include/linux/slub_def.h=092007-06-11 10:50:58.000000000 -070=
0
@@ -56,7 +56,8 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#define KMALLOC_SHIFT_LOW 3
+#define KMALLOC_SHIFT_LOW 5
+
=20
 /*
  * We keep the general caches in an array of slab caches that are used for
@@ -76,6 +77,9 @@ static inline int kmalloc_index(size_t s
 =09if (size > KMALLOC_MAX_SIZE)
 =09=09return -1;
=20
+=09if (size <=3D (1 << KMALLOC_SHIFT_LOW))
+=09=09return KMALLOC_SHIFT_LOW;
+
 =09if (size > 64 && size <=3D 96)
 =09=09return 1;
 =09if (size > 128 && size <=3D 192)
---1700579579-1534404380-1181584352=:17264--
