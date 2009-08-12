Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZHLNlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZHLNlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZHLNlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:41:39 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:35599 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZHLNli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=O33Yq9vsumIx/EpmZRZujc3IfxZK9U18JmXx9xGnIGh7xlEpqLXzRU+D3/JwlvOZYg
         oeOk/Fz/lJgxcD1MC2mn9VXCHUJeFRngN14ELeF5j7O56NU+IR6+5+Vd/K/ouQHH9ebj
         vReO3uqkkypW6W8n58T+qp2FWcq4xeYYIhyFY=
Message-ID: <4A82C68F.8070306@gmail.com>
Date: Wed, 12 Aug 2009 09:41:35 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCHv2 2/2] vhost_net: a kernel-level virtio server
References: <cover.1249992497.git.mst@redhat.com> <20090811212802.GC26309@redhat.com> <4A82076A.1060805@gmail.com> <20090812090219.GB26847@redhat.com> <4A82BD2F.7080405@gmail.com> <20090812132539.GD29200@redhat.com>
In-Reply-To: <20090812132539.GD29200@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3EF8735E064856490BFD866C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3EF8735E064856490BFD866C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 09:01:35AM -0400, Gregory Haskins wrote:
>> I think I understand what your comment above meant:  You don't need to=

>> do synchronize_rcu() because you can flush the workqueue instead to
>> ensure that all readers have completed.
>=20
> Yes.
>=20
>>  But if thats true, to me, the
>> rcu_dereference itself is gratuitous,
>=20
> Here's a thesis on what rcu_dereference does (besides documentation):
>=20
> reader does this
>=20
> 	A: sock =3D n->sock
> 	B: use *sock
>=20
> Say writer does this:
>=20
> 	C: newsock =3D allocate socket
> 	D: initialize(newsock)
> 	E: n->sock =3D newsock
> 	F: flush
>=20
>=20
> On Alpha, reads could be reordered.  So, on smp, command A could get
> data from point F, and command B - from point D (uninitialized, from
> cache).  IOW, you get fresh pointer but stale data.
> So we need to stick a barrier in there.

Yes, that is understood.  Perhaps you should just use a normal barrier,
however.  (Or at least a comment that says "I am just using this for its
barrier").

>=20
>> and that pointer is *not* actually
>> RCU protected (nor does it need to be).
>=20
> Heh, if readers are lockless and writer does init/update/sync,
> this to me spells rcu.

More correctly: it "smells like" RCU, but its not. ;)  It's rcu-like,
but you are not really using the rcu facilities.  I think anyone that
knows RCU and reads your code will likely be scratching their heads as we=
ll.

Its probably not a big deal, as I understand your code now.  Just a
suggestion to help clarify it.

Regards,
-Greg


--------------enig3EF8735E064856490BFD866C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqCxo8ACgkQP5K2CMvXmqGHNwCfeSOj6XEoQldiuqHUKtcJi8K9
NTQAniNqfbw8pAtN7bgG/hfXO+Ab81ZP
=G+NZ
-----END PGP SIGNATURE-----

--------------enig3EF8735E064856490BFD866C--
