Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYIIGpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYIIGpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYIIGp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:45:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:50316 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYIIGp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:45:26 -0400
Date: Tue, 9 Sep 2008 09:45:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Allow recursion in binfmt_script and binfmt_misc
Message-ID: <20080909064553.GB4859@localhost.localdomain>
References: <20080902110648.GA5027@localhost.localdomain> <1220713795-5313-1-git-send-email-kirill@shutemov.name> <1220713795-5313-2-git-send-email-kirill@shutemov.name> <20080908153921.94780d5c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20080908153921.94780d5c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2008 at 03:39:21PM -0700, Andrew Morton wrote:
> On Sat,  6 Sep 2008 18:09:55 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>=20
> > binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
> > using sh_bang and misc_bang. It causes problem in some cases:
> >=20
> > $ echo '#!/bin/ls' > /tmp/t0
> > $ echo '#!/tmp/t0' > /tmp/t1
> > $ echo '#!/tmp/t1' > /tmp/t2
> > $ chmod +x /tmp/t*
> > $ /tmp/t2
> > zsh: exec format error: /tmp/t2
> >=20
> > Similar problem with binfmt_misc.
> >=20
> > This patch introduces field 'recursion_depth' into struct linux_binprm
> > to track recursion level in binfmt_misc and binfmt_script. If recursion
> > level more then BINPRM_MAX_RECURSION it generates -ENOEXEC.
> >=20
> >
> > ...
> >
> > --- a/include/linux/binfmts.h
> > +++ b/include/linux/binfmts.h
> > @@ -34,8 +34,7 @@ struct linux_binprm{
> >  #endif
> >  	struct mm_struct *mm;
> >  	unsigned long p; /* current top of mem */
> > -	unsigned int sh_bang:1,
> > -		     misc_bang:1;
> > +	unsigned char recursion_depth;
> >  #ifdef __alpha__
> >  	unsigned int taso:1;
> >  #endif
>=20
> That's a strange position in which to add the new field.  It will prevent
> the compiler from using the same word for sh_bang, misc_bang and taso.
>=20
> I fixed that up while fixing linux-next rejects.

Thanks.

> > @@ -61,6 +60,7 @@ struct linux_binprm{
> >  #define BINPRM_FLAGS_EXECFD_BIT 1
> >  #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
> > =20
> > +#define BINPRM_MAX_RECURSION 4
>=20
> Why "4"?

It's enough for my goals. :)

We can increase it later if any user will need it.

> Why make linux_binprm.recursion_depth a u8?  There would be=20
> practically (or actually) zero cost to making it 32-bit.
> Admittedly a depth >256 would be a bit odd, but did we gain=20
> anything from this restriction?

No.

Should I repost patch with unsigned int recursion_depth?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjGG6EACgkQbWYnhzC5v6oBJACdGI+5k9jL7SQLVoHBLL+Qtuwr
F8UAoIH8Yw8TInDK3LYTLsZp2sopSgO2
=kZyr
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
