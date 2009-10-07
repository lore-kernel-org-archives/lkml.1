Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbZJGMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbZJGMtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbZJGMtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:49:12 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:61222 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972AbZJGMtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=uvncv9ZypOyTSTorVjB+40ljUlq+CkQl2owj16Qb4o0+Gv2vWNExoDJtGW8kaJvJqH
         FBFUDV5xJKNcgJM7Li9lQGcTwvgNvASeAgxezNkVyGY+jacvGXZvJvdyM1mh70pHFKcg
         Lvi0bRbKrUHn6DxlNx/Z65s1IYTHoq1Q50TKA=
Message-ID: <4ACC8E19.8070706@gmail.com>
Date: Wed, 07 Oct 2009 08:48:25 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB528D.6030408@gmail.com> <4ACB6F0E.4000407@redhat.com> <4ACB7794.5040308@gmail.com> <4ACB77C8.9060007@gmail.com> <4ACB9D24.2060105@gmail.com> <4ACC4D46.1090805@redhat.com>
In-Reply-To: <4ACC4D46.1090805@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4590EAEA6DB050879284541C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4590EAEA6DB050879284541C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/06/2009 09:40 PM, Gregory Haskins wrote:
>> Thinking about this some more over lunch, I think we (Avi and I) might=

>> both be wrong (and David is right).  Avi is right that we don't need
>> rmb() or barrier() for the reasons already stated, but I think David i=
s
>> right that we need an smp_mb() to ensure the cpu doesn't do the
>> reordering.  Otherwise a different cpu could invalidate the memory if =
it
>> reuses the freed memory in the meantime, iiuc.  IOW: its not a compile=
r
>> issue but a cpu issue.
>>
>> Or am I still confused?
>>
>>   =20
>=20
> The sequence of operations is:
>=20
>     v =3D p->v;
>     f();
>     // rmb() ?
>     g(v);
>=20
> You are worried that the compiler

No

> or cpu will fetch p->v after f() has executed?

Yes.

> The compiler may not, since it can't tell whether f() might
> change p->v.

Right, you were correct to say my barrier() suggestion was wrong.

> If f() can cause another agent to write to p (by freeing
> it to a global list, for example), then it is its responsibility to
> issue the smp_rmb(), otherwise no calculation that took place before f(=
)
> and accessed p is safe.
>=20

IOW: David is right.  You need a cpu-barrier one way or the other.  We
can either allow ->release() to imply one (and probably document it that
way, like we did for slow-work), or we can be explicit.  I chose to be
explicit since it is kind of self-documenting, and there is no need to
be worried about performance since the release is slow-path.

OTOH: If you feel strongly about it, we can take it out, knowing that
most anything the properly invalidates the memory will likely include an
implicit barrier of some kind.

Kind Regards,
-Greg



--------------enig4590EAEA6DB050879284541C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrMjhoACgkQP5K2CMvXmqFZugCeKOWRLyHu4VtkBgRTkFUiauzT
D9kAn3H6V16hX7hDyK5o5AfRuNxh6Nbo
=XbVw
-----END PGP SIGNATURE-----

--------------enig4590EAEA6DB050879284541C--
