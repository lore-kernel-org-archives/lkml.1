Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbXGEPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbXGEPgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbXGEPgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:36:38 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:47918 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbXGEPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:36:37 -0400
Message-ID: <468D1003.1050901@freedesktop.org>
Date: Thu, 05 Jul 2007 08:36:35 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
References: <20070705093528.GK21478@ftp.linux.org.uk>
In-Reply-To: <20070705093528.GK21478@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig303224320AC2F992AED99646"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig303224320AC2F992AED99646
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Al Viro wrote:
> 	We have a fun problem and for a change it's not sparse fault.
> It's gcc folks' one.  Basically, __attribute__((...)) behaves in
> an idiotic way and it's an intentional (and documented) behaviour.
> In declaration of form
> 	T __attribute__((foo)) **v;
> the attribute applies to v, not to **v.  IOW, in that position it
> behaves (regardless of the nature of attribute) as storage class,
> not as a qualifier.  Even if the same attribute can be used in
> 	T * __attribute__((foo)) *v;
> where it will apply to *v.  Intended way to have it apply to **v is
> 	T (__attribute__((foo)) **v);
>=20
> To put it mildly, that blows.  Note that qualifiers can *not* behave
> that way - direct declarator can not expand to (<qualifier> <something>=
).
> I.e. if you replace __attribute__((foo)) with qualifier in the
> above, you'll get invalid syntax.

Wow.  Insane.  So these all declare the same type:
__attribute__((foo)) T *v;
T __attribute__((foo)) *v;
T *__attribute__((foo)) v;
?  Specifically, they point to a foo-T, for convenient shooting?

> Now, that idiocy would be none of our concern, if not for the fact
> that noderef and address_space() are definitely supposed to imitate
> qualifiers.

context also represents a qualifier; the position of the qualifier should=

determine things like whether you want to enforce the context when you ac=
cess
a pointer or dereference a pointer.

> If anybody seriously suggests switching to syntax
> like
> 	int (__user *p);
> all over the place, well...

Definitely not an option.

> Note that gcc rules for __attribute__() (and that's the only source
> of rules we _have_ for the damn thing) clearly say that
> 	int __user *p;
> is the same thing as
> 	int *__user p;
>
> Now, we could declare gcc people responsible for that turd rejects
> of Vogon Construction Fleet and handle the damn thing sanely.
> The first part is clearly the right thing to do, but the second one...
> Can't do without breaking gccisms using __attribute__.  E.g.
> 	int (__attribute__((mode(__pointer__))) *p);
> is a gcc way to say "pointer to integer type equivalent to intptr_t" an=
d
> 	int __attribute__((mode(__pointer__))) *p;
> is exactly the same thing as
> 	int *p;
> since the damn attribute applies to the entire type here (and is obviou=
sly
> a no-op).
>
> Frankly, I would rather add a new primitive (__qualifier__) mirroring t=
he
> __attribute__, but acting like real qualifiers do.  And switched the
> noderef et.al. to it.

Something like that sounds vaguely reasonable.  It should allow the same =
set
of attributes, and just change what they apply to.  To use your example,
T __qualifier__((foo)) *v;
and
T (__attribute__((foo)) *v);
would mean the same thing.

> The only real alternative is to have __attribute__
> behaviour dependent on its guts and that's not feasible - remember that=

> there can be more than one attribute in the list insider the damn thing=
=2E
> Besides, it's bloody disgusting.

Agreed.  Not an option, even if we *could* implement it.

- Josh Triplett


--------------enig303224320AC2F992AED99646
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGjRADGJuZRtD+evsRApgLAJwLNHMByiXMUrOn+8/ecHSaCuOY7wCgncDJ
aAfhWE/bndDAY10MGdr1js0=
=VhSc
-----END PGP SIGNATURE-----

--------------enig303224320AC2F992AED99646--
