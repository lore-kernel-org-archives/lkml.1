Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYDDO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYDDO3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYDDO3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:29:30 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbYDDO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:29:28 -0400
Subject: debugfs_remove() vs. anything that is dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z7QhognU0JxA8d52/Snz"
Date: Fri, 04 Apr 2008 01:56:26 +0200
Message-Id: <1207266986.19189.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z7QhognU0JxA8d52/Snz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Consider the following trivial module:

--- %< ---
#include <linux/module.h>
#include <linux/debugfs.h>

static struct dentry *f;
static u32 tmp;

int __init mod_enter(void)
{
	f =3D debugfs_create_u32("tmp-test", 0666, NULL, &tmp);

	return 0;
}

void __exit mod_leave(void)
{
	debugfs_remove(f);
}

module_init(mod_enter);
module_exit(mod_leave);
MODULE_LICENSE("GPL");
--- >% ---

How do I make that safe?


FWIW, the problem is:

thread 1			thread 2
 fd =3D open("tmp-test")

 sleep(30);			rmmod test-module

 read(fd, buf, 100);

--> accesses now invalid memory because debugfs doesn't actually stop
you from accessing "&tmp" after debugfs_remove(). [yes, I actually
tested a variation of this where I dynamically allocated the 'tmp'
variable, I got the slab poison in my test program]


Personally, I tend to think this makes debugfs rather unusable in
modules and with anything that is dynamically allocated [1]. AFAICT
sysfs avoids this by having object lifetime imposed by sysfs, but
debugfs doesn't work that way.

What am I missing?

johannes

[1] which covers many many current users, it seems at least usbmon,
ohci/ehci/uhci-dbg, pktcdvd, fault injection code, blktrace and probably
more.

--=-Z7QhognU0JxA8d52/Snz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/VuqaVg1VMiehFYAQLTFQ//ZKqrpJ53bB/4+WVpKT4SWQ9ACMoF1RCZ
G+PR/WM65GRQIHYI1Lx0163Clc70B3NSPMn2Z/mAGvqTyYzEVteSXfbo+EZH3Vse
9doqvG6M6dVaXfVvbi4N8VbKomz2JpobzTy5JTBBgf/rLetEf6EKtxroc1PgPny0
yd0E2fKJuz/4FA7d4v/4enIo+JsRJlJgKfZOXV2gbGiua+ufUg0EC4bOIv0SqbRE
gC9S4hXgL8twVCyv9PFcOvoW0vf92zaf06DoJwjbT1RwJuo/0jWQ9KJbN66IpfCt
ZV9+sMRnKZfnnwnykBtJSiVGfRksoZCbZbs0IvmiW3A8K5LPD/owW44l6Cysu7YR
UOpW7WfVLZLoq7hOWsp10q+J3UOWewIxfPh+zmDsEHXaG4US8Oqu0KWQzL9HZrCe
y+KHGnIIlcAAwguG0yhWiH9Z0oD5Q1WoWwAmSOOAVDqwm6Zct8I5Dsi7I2ALbmTq
QcUVFJlXHsJXUzDIGMXbgtUNlBN68m0KhZZMB/Tc2LkXA6N8qGq83V6Gs1c9d7xy
rtG+DUw0qqAktBYijq8FNhVqs5w5pVW+Oixt6I+CCvABEjucbiAr5niixet31DMv
THpJKkxJr8ErxzQRM/m2z2yto9/ZgTXJuGz9M17jnUtJldgZ38HkvhLo/2tVkTU1
4zq6EkLDIQw=
=pieb
-----END PGP SIGNATURE-----

--=-Z7QhognU0JxA8d52/Snz--

