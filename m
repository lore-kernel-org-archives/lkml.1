Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXKGSlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXKGSlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXKGSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:40:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42919 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389AbXKGSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:40:56 -0500
Date: Wed, 7 Nov 2007 10:40:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 14/23] inodes: Support generic defragmentation
In-Reply-To: <20071107101748.GC7374@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0711071035490.9857@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011229.893091119@sgi.com>
 <20071107101748.GC7374@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-998179451-1194460855=:9857"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-998179451-1194460855=:9857
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 7 Nov 2007, J=F6rn Engel wrote:

> On Tue, 6 November 2007 17:11:44 -0800, Christoph Lameter wrote:
> > =20
> > +void *get_inodes(struct kmem_cache *s, int nr, void **v)
> > +{
> > +=09int i;
> > +
> > +=09spin_lock(&inode_lock);
> > +=09for (i =3D 0; i < nr; i++) {
> > +=09=09struct inode *inode =3D v[i];
> > +
> > +=09=09if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
> > +=09=09=09v[i] =3D NULL;
> > +=09=09else
> > +=09=09=09__iget(inode);
> > +=09}
> > +=09spin_unlock(&inode_lock);
> > +=09return NULL;
> > +}
> > +EXPORT_SYMBOL(get_inodes);
>=20
> What purpose does the return type have?

The pointer is for communication between the get and kick methods. get()=20
can  modify kick() behavior by returning a pointer to a data structure or=
=20
using the pointer to set a flag. F.e. get() may discover that there is an=
=20
unreclaimable object and set a flag that causes kick to simply undo the=20
refcount increment. get() may build a map for the objects and indicate in=
=20
the map special treatment.=20

> > +void *fs_get_inodes(struct kmem_cache *s, int nr, void **v,
> > +=09=09=09=09=09=09unsigned long offset)
> > +{
> > +=09int i;
> > +
> > +=09for (i =3D 0; i < nr; i++)
> > +=09=09v[i] +=3D offset;
> > +
> > +=09return get_inodes(s, nr, v);
> > +}
> > +EXPORT_SYMBOL(fs_get_inodes);
>=20
> The fact that all pointers get changed makes me a bit uneasy:
> =09struct foo_inode v[20];
> =09...
> =09fs_get_inodes(..., v, ...);
> =09...
> =09v[0].foo_field =3D bar;
> =09
> No warning, but spectacular fireworks.

As far as I can remember: The core code always passes pointers to struct=20
inode to the filesystems. The filesystems will then recalculate the=20
pointers to point to the fs ide of an inode.


> > +void kick_inodes(struct kmem_cache *s, int nr, void **v, void *private=
)
> > +{
> > +=09struct inode *inode;
> > +=09int i;
> > +=09int abort =3D 0;
> > +=09LIST_HEAD(freeable);
> > +=09struct super_block *sb;
> > +
> > +=09for (i =3D 0; i < nr; i++) {
> > +=09=09inode =3D v[i];
> > +=09=09if (!inode)
> > +=09=09=09continue;
>=20
> NULL is legal here?  Then fs_get_inodes should check for NULL as well
> and not add the offset to NULL pointers, I guess.

The get() method may have set a pointer to NULL. The fs_get_inodes() is=20
run at a time when all pointers are valid.

> > +=09=09}
> > +
> > +=09=09/* Invalidate children and dentry */
> > +=09=09if (S_ISDIR(inode->i_mode)) {
> > +=09=09=09struct dentry *d =3D d_find_alias(inode);
> > +
> > +=09=09=09if (d) {
> > +=09=09=09=09d_invalidate(d);
> > +=09=09=09=09dput(d);
> > +=09=09=09}
> > +=09=09}
> > +
> > +=09=09if (inode->i_state & I_DIRTY)
> > +=09=09=09write_inode_now(inode, 1);
>=20
> Once more the three-bit I_DIRTY is used like a boolean value.  I don't
> hold it against you, specifically.  A general review/cleanup is
> necessary for that.

Yeah. I'd be glad if someone could take this piece off my hands.

---1700579579-998179451-1194460855=:9857--
