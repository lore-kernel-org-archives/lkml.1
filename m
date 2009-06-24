Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZFXWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZFXWCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFXWCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:02:02 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49393 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZFXWCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:02:01 -0400
Message-ID: <4A42A259.9000306@novell.com>
Date: Wed, 24 Jun 2009 18:02:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] slow-work: add (module*)work->owner to fix races
 with module clients
References: <4A427F83.8010404@novell.com> <7230.1245878582@redhat.com>
In-Reply-To: <7230.1245878582@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9728147D334CA575F82474AB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9728147D334CA575F82474AB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Howells wrote:
> Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>>   I found this while working on KVM.  I actually posted this patch wit=
h
>> a KVM
>> series yesterday and standalone earlier today, but neither seems to ha=
ve
>> made it to the lists.  I suspect there is an issue with git-mail/postf=
ix
>> on my system.
>>    =20
>
> Also, your mail client has damaged the whitespace in the patch.
>  =20

Yeah, sorry about that.  When git-mail was failing I cut-n-pasted into
thunderbird and it munged it a bit.  v2 should be better as it came out
of git directly after I fixed the postfix misconfig.

>  =20
>>  struct slow_work {
>> +    struct module          *owner;
>>    =20
>
> Can you add it to slow_work_ops instead?
>  =20

Yeah, that makes sense.
>  =20
>>      work->ops->put_ref(work);
>> +    barrier(); /* ensure that put_ref is not re-ordered with module_p=
ut =3D
>> */
>> +    module_put(work->owner);
>>    =20
>
> Ummm...  Can it be?  module_put() and put_ref() are both out of line - =
surely
> the compiler isn't allowed to reorder them?  If it's the CPU doing it t=
hen
> barrier() isn't going to save you.
>  =20

Good point.  I added that at the last minute without engaging my brain.
:) Will remove.

> Note, however, that work may not be dereferenced like this after put_re=
f() is
> called, unless you're sure that there's still a reference outstanding.
>
>  =20
Yeah, I noticed that too immediately after sending.  It should be better
in v2 (which should be in your inbox already)

>> +            if (!try_module_get(work->owner))
>> +                goto cant_get_mod;
>>    =20
>
> Note that this may result in a module getting stuck in unloading.  It m=
ay need
> to do some work to complete the unload, and this will prevent that.
>  =20

Can we set the stake in the ground that you can only call
slow_work_enqueue() from a module if you know that there is at least one
reference to the module being held?  This seems like a core requirement
anyway.

The follow up question would be: if so, should we use __module_get()
instead ot try_module_get() to annotate that (in addition to a comment,
of course).

> A better way might be to have put_ref() return, say, a pointer to a com=
pletion
> struct, and if not NULL, have the caller of put_ref() call complete() o=
n it.
> That way you don't need to touch the module count, but can have somethi=
ng in
> put_ref() keep track of when the last object is released and have its c=
aller
> invoke a completion to celebrate this fact.
>  =20

That sounds interesting, but I am not sure if we would get into a
similar conundrum or be awkward to manage.  I am in a conf-call ATM so I
can't think clear enough to tell for sure. ;) Let me give it some
thought and get back to you, though.

Thanks David!
-Greg



--------------enig9728147D334CA575F82474AB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpColkACgkQlOSOBdgZUxlymgCeJxTryZNlH6Jlc0YcyE8+QPCG
b3YAnjYvtWQ1PJcLtTC17/szOzj6jSCZ
=d41C
-----END PGP SIGNATURE-----

--------------enig9728147D334CA575F82474AB--
