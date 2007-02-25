Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXBYTK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXBYTK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXBYTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:10:28 -0500
Received: from mailfront2.netatonce.net ([217.10.96.66]:54121 "EHLO
	mailfront2.citynet.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXBYTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:10:27 -0500
X-Greylist: delayed 1931 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 14:10:26 EST
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
From: Martin Josefsson <gandalf@wlug.westbo.se>
To: Patrick McHardy <kaber@trash.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45E1C7E0.9070102@trash.net>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
	 <45E04468.7020001@trash.net> <45E06546.504@redhat.com>
	 <45E1C7E0.9070102@trash.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N1rREts8Rj+1DcGD7fDt"
Date: Sun, 25 Feb 2007 19:38:13 +0100
Message-Id: <1172428694.4485.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-Spam-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N1rREts8Rj+1DcGD7fDt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-02-25 at 18:31 +0100, Patrick McHardy wrote:

> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
>=20
> {nf,ip}_ct_iterate_cleanup iterate over the unconfirmed list for cleaning
> up conntrack entries, which is wrong for multiple reasons:
>=20
> - unconfirmed entries can not be killed manually, which means we might
>   iterate forever without making forward progress.
>=20
>   This can happen in combination with the conntrack event cache, which
>   holds a reference to the conntrack entry, which is only released when
>   the packet makes it all the way through the stack or a different
>   packet is handled.
>
> - taking references to an unconfirmed entry and using it outside the
>   locked section doesn't work, the list entries are not refcounted and
>   another CPU might already be waiting to destroy the entry
>=20
> Split ip_ct_iterate_cleanup in ip_ct_iterate, which iterates over both
> confirmed and unconfirmed entries, but doesn't attempt to kill them,
> and ip_ct_cleanup, which makes sure no unconfirmed entries exist by
> calling synchronize_net() prior to walking the conntrack hash.

What about this case:

1. Conntrack entry is created and placed on the unconfirmed list
2. The event cache bumps the refcount of the conntrack entry
3. module removal of ip_conntrack unregisters all hooks
4. packet is dropped by an iptables rule
5. packet is freed but we still have a refcount on the conntrack entry

Now there's no way to get that refcount to decrease as that only happens
when the event cache receives another packet or the current packet makes
it through the stack as you wrote above. And neither of this will happen
since we unregistered the hooks providing the packets and dropped the
packet.

I ran into this case a while ago during stresstesting and rewrote the
event cache to not increase the refcount, but this has the drawback that
events caused by dropped packets won't be reported. This may not be a
good thing...

Old patch can be found here:
http://performance.netfilter.org/patches/nf_conntrack_ecache-fix

--=20
/Martin

--=-N1rREts8Rj+1DcGD7fDt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF4deVWm2vlfa207ERAhZOAJ4wwLtE4BJ7He5HfPoDYWuhO4xEBACfTa0v
koSHK6ziYbPehHuf6mJG65Q=
=yYBJ
-----END PGP SIGNATURE-----

--=-N1rREts8Rj+1DcGD7fDt--

